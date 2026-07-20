#!/usr/bin/env python3

import argparse
import fnmatch
import hashlib
import json
import os
import re
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime, timezone
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Set, Tuple

VERSION = "2.1.0"
STATE_DIR = ".slim"
STATE_FILE = "cartography.json"
CONFIG_FILE = "atlas.config.json"
CODEMAP_FILE = "codemap.md"

MAX_WORKERS = min(32, (os.cpu_count() or 4) * 2)
TEXT_READ_LIMIT = 32_000
ROOT_SECTIONS = ["Project Responsibility", "Entry Points", "Directory Map"]
FOLDER_SECTIONS = ["Responsibility", "Design", "Flow", "Integration"]
MONOREPO_MARKERS = ["pnpm-workspace.yaml", "turbo.json", "nx.json"]
DEFAULT_MONOREPO_DOMAINS = ["apps/*", "packages/*", "services/*"]

SOURCE_EXTENSIONS = {
    ".ts",
    ".tsx",
    ".js",
    ".jsx",
    ".mjs",
    ".cjs",
    ".py",
    ".go",
    ".java",
    ".rs",
    ".rb",
    ".php",
    ".cs",
    ".kt",
    ".swift",
    ".scala",
    ".sh",
}


# -------------------------
# Config & Detection
# -------------------------


def load_config(root: Path) -> dict:
    path = root / STATE_DIR / CONFIG_FILE
    if path.exists():
        try:
            return json.loads(path.read_text())
        except Exception:
            return {}
    return {}


def detect_presets(root: Path) -> List[str]:
    patterns: List[str] = []

    if (root / "package.json").exists():
        patterns.extend(["package.json", "**/*.{ts,tsx,js,jsx,mjs,cjs,json}"])
    if (root / "pyproject.toml").exists() or (root / "requirements.txt").exists():
        patterns.extend(["pyproject.toml", "requirements.txt", "**/*.py"])
    if (root / "go.mod").exists():
        patterns.extend(["go.mod", "**/*.go"])
    if (root / "pom.xml").exists() or (root / "build.gradle").exists():
        patterns.extend(["pom.xml", "build.gradle", "**/*.java"])
    if (root / "Cargo.toml").exists():
        patterns.extend(["Cargo.toml", "**/*.rs"])

    if not patterns:
        patterns = ["**/*.{ts,tsx,js,jsx,py,go,java,rs,json,toml,yaml,yml,sh}"]

    return dedupe_sorted(patterns)


def detect_monorepo(root: Path) -> bool:
    return any((root / marker).exists() for marker in MONOREPO_MARKERS)


def expand_domain_patterns(root: Path, domains: Sequence[str]) -> List[str]:
    expanded: List[str] = []

    for domain in domains:
        clean = domain.strip().strip("/")
        if not clean:
            continue

        if "*" not in clean and "?" not in clean:
            if (root / clean).exists():
                expanded.append(clean)
            continue

        prefix = clean.split("*")[0].split("?")[0].rstrip("/")
        parent = root / prefix if prefix else root
        if not parent.exists() or not parent.is_dir():
            continue

        for child in sorted(parent.iterdir(), key=lambda p: p.name):
            rel = str(child.relative_to(root)).replace("\\", "/")
            if child.is_dir() and fnmatch.fnmatch(rel, clean):
                expanded.append(rel)

    return dedupe_sorted(expanded)


def detect_domains(root: Path, config: dict) -> Tuple[bool, List[str]]:
    configured = config.get("domains") or []
    if configured:
        return detect_monorepo(root), expand_domain_patterns(root, configured)

    if not detect_monorepo(root):
        return False, []

    expanded = expand_domain_patterns(root, DEFAULT_MONOREPO_DOMAINS)
    return True, expanded


def default_excludes() -> List[str]:
    return [
        "**/*.test.*",
        "**/*.spec.*",
        "**/*_test.*",
        "tests/**",
        "__tests__/**",
        "docs/**",
        "**/*.md",
        "dist/**",
        "build/**",
        "target/**",
        "coverage/**",
        "node_modules/**",
        "venv/**",
        ".venv/**",
    ]


# -------------------------
# Pattern Matching
# -------------------------


class PatternMatcher:
    def __init__(self, patterns: List[str]):
        self.patterns = patterns or []

    def _expand_braces(self, pattern: str) -> List[str]:
        match = re.search(r"\{([^{}]+)\}", pattern)
        if not match:
            return [pattern]

        prefix = pattern[: match.start()]
        suffix = pattern[match.end() :]
        options = [
            option.strip() for option in match.group(1).split(",") if option.strip()
        ]

        expanded = []
        for option in options:
            expanded.extend(self._expand_braces(f"{prefix}{option}{suffix}"))

        return expanded or [pattern]

    def matches(self, path: str) -> bool:
        normalized = path.strip("/")

        for pattern in self.patterns:
            clean = pattern.strip()
            if not clean:
                continue

            if clean.endswith("/"):
                directory = clean.rstrip("/")
                if directory and directory in Path(normalized).parts:
                    return True
                continue

            variants = []
            for expanded in self._expand_braces(clean):
                variants.append(expanded)
                if "**/" in expanded:
                    variants.append(expanded.replace("**/", "", 1))

            for variant in variants:
                if fnmatch.fnmatch(normalized, variant):
                    return True

                if "/" not in variant and fnmatch.fnmatch(Path(normalized).name, variant):
                    return True

        return False


# -------------------------
# File Selection
# -------------------------


def load_gitignore(root: Path) -> List[str]:
    path = root / ".gitignore"
    if not path.exists():
        return []
    return [
        line.strip()
        for line in path.read_text().splitlines()
        if line.strip() and not line.startswith("#")
    ]


def select_files(
    root: Path,
    include: List[str],
    exclude: List[str],
    gitignore: List[str],
    exceptions: Optional[List[str]] = None,
    domains: Optional[List[str]] = None,
) -> List[Path]:
    inc = PatternMatcher(include)
    exc = PatternMatcher(exclude)
    git = PatternMatcher(gitignore)
    allowed = PatternMatcher(
        [f"{domain}/**" for domain in (domains or [])] + list(domains or [])
    )

    selected = []

    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if not d.startswith(".")]

        for f in filenames:
            path = Path(dirpath) / f
            rel = str(path.relative_to(root)).replace("\\", "/")

            if domains and not allowed.matches(rel):
                continue

            if git.matches(rel):
                continue

            if exc.matches(rel):
                continue

            if inc.matches(rel):
                selected.append(path)

    return sorted(selected, key=lambda p: str(p.relative_to(root)).replace("\\", "/"))


# -------------------------
# Hashing (Parallel)
# -------------------------


def compute_file_hash(path: Path) -> str:
    try:
        h = hashlib.md5()
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(8192), b""):
                h.update(chunk)
        return h.hexdigest()
    except Exception:
        return ""


hash_file = compute_file_hash


def compute_hashes(files: List[Path], root: Path) -> Dict[str, str]:
    results = {}

    with ThreadPoolExecutor(MAX_WORKERS) as executor:
        futures = {executor.submit(hash_file, f): f for f in files}

        for future in as_completed(futures):
            f = futures[future]
            rel = str(f.relative_to(root)).replace("\\", "/")
            results[rel] = future.result()

    return {key: results[key] for key in sorted(results)}


# -------------------------
# Folder Hash
# -------------------------


def compute_folder_hash(folder: str, file_hashes: Dict[str, str]) -> str:
    relevant = sorted(
        (p, h)
        for p, h in file_hashes.items()
        if p.startswith(folder + "/") or (folder == "." and "/" not in p)
    )

    if not relevant:
        return ""

    h = hashlib.md5()
    for p, v in relevant:
        h.update(f"{p}:{v}".encode())
    return h.hexdigest()


def get_folders(files: List[str]) -> Set[str]:
    folders = set()
    for f in files:
        parts = Path(f).parts[:-1]
        for i in range(len(parts)):
            folders.add("/".join(parts[: i + 1]))
    folders.add(".")
    return folders


def ancestors(folder: str) -> List[str]:
    if folder == ".":
        return ["."]
    parts = Path(folder).parts
    values = ["."]
    for i in range(len(parts)):
        values.append("/".join(parts[: i + 1]))
    return values


def top_level_module(rel_path: str, domains: Sequence[str]) -> str:
    if domains:
        for domain in domains:
            if rel_path == domain or rel_path.startswith(domain + "/"):
                return domain
    parts = Path(rel_path).parts
    if len(parts) >= 2:
        return parts[0]
    if parts:
        return "."
    return "."


# -------------------------
# State
# -------------------------


def state_path(root: Path) -> Path:
    return root / STATE_DIR / STATE_FILE


def load_state(root: Path) -> Optional[dict]:
    p = state_path(root)
    if p.exists():
        return json.loads(p.read_text())
    return None


def save_state(root: Path, state: dict):
    (root / STATE_DIR).mkdir(exist_ok=True)
    state_path(root).write_text(json.dumps(state, indent=2, sort_keys=True))


# -------------------------
# Analysis helpers
# -------------------------


def dedupe_sorted(items: Sequence[str]) -> List[str]:
    return sorted(dict.fromkeys(item for item in items if item))


def safe_read_text(path: Path) -> str:
    try:
        return path.read_text(errors="ignore")[:TEXT_READ_LIMIT]
    except Exception:
        return ""


def classify_stack(files: Sequence[str]) -> List[str]:
    extensions = {Path(path).suffix.lower() for path in files}
    names = {Path(path).name for path in files}
    stack = []

    if {".ts", ".tsx", ".js", ".jsx", ".mjs", ".cjs"} & extensions:
        stack.append("JavaScript/TypeScript")
    if ".py" in extensions:
        stack.append("Python")
    if ".go" in extensions:
        stack.append("Go")
    if ".java" in extensions:
        stack.append("Java")
    if ".rs" in extensions:
        stack.append("Rust")
    if "package.json" in names:
        stack.append("Node package metadata")
    if "pyproject.toml" in names:
        stack.append("Python project metadata")
    if "go.mod" in names:
        stack.append("Go module metadata")

    return dedupe_sorted(stack) or ["mixed source files"]


def summarize_functions_and_classes(text: str) -> Tuple[int, int]:
    function_patterns = [
        r"^\s*def\s+\w+",
        r"^\s*func\s+\w+",
        r"^\s*function\s+\w+",
        r"^\s*(?:export\s+)?(?:async\s+)?function\s+\w+",
        r"^\s*(?:export\s+)?const\s+\w+\s*=\s*(?:async\s*)?\(",
    ]
    class_patterns = [r"^\s*class\s+\w+", r"^\s*export\s+class\s+\w+"]

    functions = 0
    classes = 0
    lines = text.splitlines()
    for line in lines:
        if any(re.search(pattern, line) for pattern in function_patterns):
            functions += 1
        if any(re.search(pattern, line) for pattern in class_patterns):
            classes += 1
    return functions, classes


def extract_dependencies(text: str) -> Tuple[Set[str], Set[str]]:
    internal: Set[str] = set()
    external: Set[str] = set()

    patterns = [
        r"from\s+['\"]([^'\"]+)['\"]",
        r"import\s+['\"]([^'\"]+)['\"]",
        r"from\s+([A-Za-z0-9_\.\-/@]+)\s+import",
        r"import\s+([A-Za-z0-9_\.\-/@]+)",
        r"require\(['\"]([^'\"]+)['\"]\)",
        r"use\s+([A-Za-z0-9_:]+)",
    ]

    for pattern in patterns:
        for match in re.findall(pattern, text, flags=re.MULTILINE):
            dep = match.strip()
            if not dep or dep in {"{"}:
                continue
            if dep.startswith((".", "/")):
                internal.add(dep)
            else:
                external.add(dep)

    return internal, external


def find_entry_points(files: Sequence[str]) -> List[str]:
    priority_patterns = [
        r"(^|/)main\.(py|go|ts|tsx|js|jsx|java|rs)$",
        r"(^|/)__main__\.py$",
        r"(^|/)index\.(ts|tsx|js|jsx)$",
        r"(^|/)app\.(py|ts|tsx|js|jsx)$",
        r"(^|/)cli\.(py|ts|js|go)$",
        r"(^|/)cmd/.+\.go$",
        r"(^|/)bin/.+$",
    ]

    entries = []
    for path in sorted(files):
        if any(re.search(pattern, path) for pattern in priority_patterns):
            entries.append(path)
    return entries[:8]


def analyze_scope(
    root: Path, scope: str, files: Sequence[str], domains: Sequence[str]
) -> dict:
    relevant = [
        path for path in sorted(files) if scope == "." or path.startswith(scope + "/")
    ]
    file_infos = []
    direct_children = set()
    stacks = classify_stack(relevant)
    total_functions = 0
    total_classes = 0
    internal_deps: Set[str] = set()
    external_deps: Set[str] = set()

    for rel in relevant:
        path = root / rel
        direct_rel = rel if scope == "." else rel[len(scope) + 1 :]
        if "/" in direct_rel:
            direct_children.add(direct_rel.split("/")[0] + "/")
        else:
            direct_children.add(direct_rel)

        text = safe_read_text(path)
        functions, classes = summarize_functions_and_classes(text)
        local_internal, local_external = extract_dependencies(text)
        total_functions += functions
        total_classes += classes
        internal_deps.update(local_internal)
        external_deps.update(local_external)
        file_infos.append(
            {
                "rel": rel,
                "direct_rel": direct_rel,
                "size": path.stat().st_size if path.exists() else 0,
                "suffix": path.suffix.lower(),
                "functions": functions,
                "classes": classes,
            }
        )

    module_names = sorted(
        {top_level_module(path, domains) for path in relevant if path != "."}
    )
    return {
        "scope": scope,
        "files": relevant,
        "file_infos": file_infos,
        "direct_children": sorted(direct_children),
        "stacks": stacks,
        "functions": total_functions,
        "classes": total_classes,
        "internal_deps": sorted(internal_deps),
        "external_deps": sorted(external_deps),
        "entry_points": find_entry_points(relevant),
        "modules": module_names,
    }


def format_bullets(items: Sequence[str], empty_line: str) -> str:
    if not items:
        return empty_line
    return "\n".join(f"- {item}" for item in items)


def build_root_codemap(
    root: Path, analysis: dict, domains: Sequence[str], is_monorepo: bool
) -> str:
    stack_label = ", ".join(analysis["stacks"])
    files = analysis["files"]
    top_dirs: Dict[str, int] = {}
    for rel in files:
        parts = Path(rel).parts
        key = parts[0] if len(parts) > 1 else "."
        top_dirs[key] = top_dirs.get(key, 0) + 1

    directory_items = []
    if domains:
        for domain in domains:
            count = sum(
                1 for path in files if path == domain or path.startswith(domain + "/")
            )
            if count:
                directory_items.append(f"{domain}/ — {count} tracked files")

    for name in sorted(top_dirs):
        if name == ".":
            continue
        if any(name == domain.split("/")[0] for domain in domains):
            continue
        directory_items.append(f"{name}/ — {top_dirs[name]} tracked files")

    responsibility = [
        f"{root.name} is mapped as a {'monorepo' if is_monorepo else 'single project'} codebase.",
        f"Tracked scope covers {len(files)} files across {len(analysis['modules']) or len(top_dirs)} module group(s) using {stack_label}.",
    ]
    if domains:
        responsibility.append(f"Default domains: {', '.join(domains)}.")

    entries = analysis["entry_points"] or [
        "No conventional entry points detected; review tracked manifests and source roots instead."
    ]

    content = [f"# {root.name} Atlas", ""]
    content.extend(
        [
            "## Project Responsibility",
            "",
            format_bullets(
                responsibility, "- No repository responsibility summary available."
            ),
            "",
            "## Entry Points",
            "",
            format_bullets(entries, "- No entry points detected."),
            "",
            "## Directory Map",
            "",
            format_bullets(directory_items, "- No tracked directories detected."),
            "",
        ]
    )
    return "\n".join(content).rstrip() + "\n"


def build_folder_codemap(root: Path, scope: str, analysis: dict) -> str:
    display_name = root.name if scope == "." else scope
    files = analysis["files"]
    child_items = analysis["direct_children"][:10]
    file_items = [info["direct_rel"] for info in analysis["file_infos"][:10]]
    external = analysis["external_deps"][:8]
    internal = analysis["internal_deps"][:8]
    entries = analysis["entry_points"][:6]

    responsibility = [
        f"Scope tracks {len(files)} file(s) in {display_name}.",
        f"Primary stack: {', '.join(analysis['stacks'])}.",
    ]
    if file_items:
        responsibility.append(f"Representative files: {', '.join(file_items[:5])}.")

    design = [
        f"Direct children: {', '.join(child_items) if child_items else 'no nested tracked items'}.",
        f"Detected {analysis['functions']} function-like declaration(s) and {analysis['classes']} class declaration(s).",
    ]

    flow = []
    if entries:
        flow.append(f"Likely execution/export surfaces: {', '.join(entries)}.")
    flow.append(
        f"Tracked files are ordered deterministically from {files[0]} to {files[-1]}."
        if files
        else "No tracked files available."
    )

    integration = []
    if internal:
        integration.append(f"Internal references: {', '.join(internal)}.")
    if external:
        integration.append(f"External dependencies: {', '.join(external)}.")
    if not integration:
        integration.append(
            "No explicit imports or requires detected in the tracked scope."
        )

    content = [f"# {display_name}/", ""]
    sections = {
        "Responsibility": responsibility,
        "Design": design,
        "Flow": flow,
        "Integration": integration,
    }

    for section in FOLDER_SECTIONS:
        content.append(f"## {section}")
        content.append("")
        content.append(
            format_bullets(
                sections[section], f"- No {section.lower()} details available."
            )
        )
        content.append("")

    return "\n".join(content).rstrip() + "\n"


def write_codemap(path: Path, content: str):
    path.mkdir(parents=True, exist_ok=True)
    (path / CODEMAP_FILE).write_text(content)


def remove_stale_codemap(root: Path, folder: str):
    target = root / folder / CODEMAP_FILE
    if target.exists():
        target.unlink()


# -------------------------
# Core Pipeline
# -------------------------


def resolve_patterns(root: Path, args):
    config = load_config(root)
    include = args.include or config.get("include") or detect_presets(root)
    exclude = args.exclude or config.get("exclude") or default_excludes()
    is_monorepo, domains = detect_domains(root, config)

    return include, exclude, domains, is_monorepo


def scan(
    root: Path,
    include: List[str],
    exclude: List[str],
    domains: Optional[List[str]] = None,
):
    gitignore = load_gitignore(root)
    files = select_files(root, include, exclude, gitignore, domains=domains)
    hashes = compute_hashes(files, root)
    folders = get_folders(list(hashes.keys()))
    folder_hashes = {f: compute_folder_hash(f, hashes) for f in sorted(folders)}
    return hashes, folder_hashes


def build_state(
    include: List[str],
    exclude: List[str],
    domains: List[str],
    is_monorepo: bool,
    file_hashes: dict,
    folder_hashes: dict,
) -> dict:
    return {
        "metadata": {
            "version": VERSION,
            "last_run": datetime.now(timezone.utc).isoformat(),
            "include": include,
            "exclude": exclude,
            "domains": domains,
            "is_monorepo": is_monorepo,
        },
        "file_hashes": file_hashes,
        "folder_hashes": folder_hashes,
    }


def diff_state(
    old_hashes: Dict[str, str], current_hashes: Dict[str, str], domains: Sequence[str]
) -> dict:
    added = sorted(set(current_hashes) - set(old_hashes))
    removed = sorted(set(old_hashes) - set(current_hashes))
    modified = sorted(
        k
        for k in current_hashes
        if k in old_hashes and current_hashes[k] != old_hashes[k]
    )

    affected_folders = sorted(
        {
            ancestor
            for rel in added + removed + modified
            for ancestor in ancestors(
                str(Path(rel).parent).replace("\\", "/") if "/" in rel else "."
            )
        }
    )
    affected_modules = sorted(
        {top_level_module(rel, domains) for rel in added + removed + modified}
    )

    return {
        "added": added,
        "removed": removed,
        "modified": modified,
        "affected_folders": affected_folders,
        "affected_modules": affected_modules,
    }


def regenerate_codemaps(
    root: Path,
    file_hashes: Dict[str, str],
    domains: Sequence[str],
    is_monorepo: bool,
    folders_to_update: Optional[Set[str]] = None,
    stale_folders: Optional[Set[str]] = None,
):
    all_files = sorted(file_hashes)
    all_folders = sorted(get_folders(all_files)) if all_files else ["."]

    root_analysis = analyze_scope(root, ".", all_files, domains)
    write_codemap(root, build_root_codemap(root, root_analysis, domains, is_monorepo))

    target_folders = set(all_folders if folders_to_update is None else folders_to_update)
    target_folders.discard(".")

    for folder in sorted(target_folders):
        analysis = analyze_scope(root, folder, all_files, domains)
        if not analysis["files"]:
            remove_stale_codemap(root, folder)
            continue
        write_codemap(root / folder, build_folder_codemap(root, folder, analysis))

    for folder in sorted(stale_folders or set()):
        if folder != ".":
            remove_stale_codemap(root, folder)


def emit_result(payload: dict, as_json: bool):
    if as_json:
        print(json.dumps(payload, indent=2, sort_keys=True))
        return

    if payload.get("command") == "init":
        print(f"Initialized with {payload['tracked_files']} files")
        print(
            f"Domains: {', '.join(payload['domains']) if payload['domains'] else 'single-project scope'}"
        )
        return

    if payload.get("command") == "changes":
        print(
            f"Added: {len(payload['added'])} | Removed: {len(payload['removed'])} | Modified: {len(payload['modified'])}"
        )
        print(
            f"Affected folders: {', '.join(payload['affected_folders']) if payload['affected_folders'] else 'none'}"
        )
        print(
            f"Affected modules: {', '.join(payload['affected_modules']) if payload['affected_modules'] else 'none'}"
        )
        return

    if payload.get("command") == "update":
        print(
            f"Updated state and regenerated {payload['regenerated_folders']} folder codemap(s); stale removed: {payload['removed_stale_folders']}"
        )


# -------------------------
# Commands
# -------------------------


def cmd_init(args):
    root = Path(args.root).resolve()
    include, exclude, domains, is_monorepo = resolve_patterns(root, args)
    file_hashes, folder_hashes = scan(root, include, exclude, domains)
    regenerate_codemaps(root, file_hashes, domains, is_monorepo)
    state = build_state(
        include, exclude, domains, is_monorepo, file_hashes, folder_hashes
    )
    save_state(root, state)

    emit_result(
        {
            "command": "init",
            "tracked_files": len(file_hashes),
            "tracked_folders": len(folder_hashes),
            "domains": domains,
            "is_monorepo": is_monorepo,
        },
        args.json,
    )


def cmd_changes(args):
    root = Path(args.root).resolve()
    state = load_state(root)

    if not state:
        message = {"command": "changes", "error": "Run init first"}
        emit_result(message, True if args.json else False)
        return 1

    include, exclude, domains, _ = resolve_patterns(root, args)
    current, _ = scan(root, include, exclude, domains)
    diff = diff_state(state["file_hashes"], current, domains)
    diff["command"] = "changes"
    emit_result(diff, args.json)
    return 0


def cmd_update(args):
    root = Path(args.root).resolve()
    previous = load_state(root) or {
        "file_hashes": {},
        "folder_hashes": {},
        "metadata": {},
    }
    include, exclude, domains, is_monorepo = resolve_patterns(root, args)
    file_hashes, folder_hashes = scan(root, include, exclude, domains)
    diff = diff_state(previous.get("file_hashes", {}), file_hashes, domains)

    current_folders = get_folders(list(file_hashes.keys())) if file_hashes else {"."}
    previous_folders = set((previous.get("folder_hashes") or {}).keys()) | {"."}
    stale_folders = previous_folders - set(current_folders)
    regenerate_codemaps(
        root,
        file_hashes,
        domains,
        is_monorepo,
        folders_to_update=set(diff["affected_folders"])
        | {
            folder
            for folder in current_folders
            if folder != "." and folder not in previous_folders
        },
        stale_folders=stale_folders,
    )

    state = build_state(
        include, exclude, domains, is_monorepo, file_hashes, folder_hashes
    )
    save_state(root, state)
    emit_result(
        {
            "command": "update",
            "tracked_files": len(file_hashes),
            "regenerated_folders": len([f for f in diff["affected_folders"] if f != "."]),
            "removed_stale_folders": len([f for f in stale_folders if f != "."]),
            "affected_folders": diff["affected_folders"],
            "affected_modules": diff["affected_modules"],
        },
        args.json,
    )
    return 0


# -------------------------
# CLI
# -------------------------


def main():
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="cmd")

    for name in ["init", "changes", "update"]:
        p = sub.add_parser(name)
        p.add_argument("--root", required=True)
        p.add_argument("--include", action="append")
        p.add_argument("--exclude", action="append")
        p.add_argument("--json", action="store_true")

    args = parser.parse_args()

    if args.cmd == "init":
        return cmd_init(args)
    if args.cmd == "changes":
        return cmd_changes(args)
    if args.cmd == "update":
        return cmd_update(args)

    parser.print_help()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
