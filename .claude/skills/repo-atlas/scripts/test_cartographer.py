import hashlib
import json
import os
import sys
import tempfile
import unittest
from argparse import Namespace
from contextlib import redirect_stdout
from io import StringIO
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

from cartographer import (  # noqa: E402
    PatternMatcher,
    cmd_changes,
    cmd_init,
    cmd_update,
    compute_file_hash,
    compute_folder_hash,
    detect_domains,
    load_state,
    scan,
    select_files,
)


class TestCartographer(unittest.TestCase):
    def args(self, root: Path, json_output: bool = True):
        return Namespace(root=str(root), include=None, exclude=None, json=json_output)

    def write_fixture_repo(self, root: Path):
        (root / "pnpm-workspace.yaml").write_text(
            "packages:\n  - apps/*\n  - packages/*\n"
        )
        (root / "package.json").write_text('{"name":"fixture-repo"}\n')
        (root / "apps").mkdir()
        (root / "apps" / "web").mkdir(parents=True)
        (root / "packages").mkdir()
        (root / "packages" / "utils").mkdir(parents=True)
        (root / "docs").mkdir()

        (root / "apps" / "web" / "main.ts").write_text(
            "import { sum } from '../../packages/utils/sum'\n"
            "import express from 'express'\n\n"
            "export function bootstrap() {\n"
            "  return sum(1, 2)\n"
            "}\n"
        )
        (root / "packages" / "utils" / "sum.ts").write_text(
            "export function sum(a: number, b: number) {\n  return a + b\n}\n"
        )
        (root / "docs" / "readme.md").write_text("excluded docs\n")

    def test_pattern_matcher(self):
        patterns = ["node_modules/", "dist/", "*.log", "src/**/*.ts"]
        matcher = PatternMatcher(patterns)

        self.assertTrue(matcher.matches("node_modules/foo.js"))
        self.assertTrue(matcher.matches("vendor/node_modules/bar.js"))
        self.assertTrue(matcher.matches("dist/main.js"))
        self.assertTrue(matcher.matches("src/index.ts"))
        self.assertTrue(matcher.matches("src/utils/helper.ts"))
        self.assertFalse(matcher.matches("README.md"))

    def test_compute_file_hash(self):
        with tempfile.NamedTemporaryFile(mode="wb", delete=False) as f:
            f.write(b"test content")
            f_path = f.name

        try:
            h1 = compute_file_hash(Path(f_path))
            expected = hashlib.md5(b"test content").hexdigest()
            self.assertEqual(h1, expected)
            self.assertEqual(h1, "9473fdd0d880a43c21b7778d34872157")
        finally:
            if os.path.exists(f_path):
                os.unlink(f_path)

    def test_compute_folder_hash(self):
        file_hashes = {
            "src/a.ts": "hash-a",
            "src/b.ts": "hash-b",
            "tests/test.ts": "hash-test",
        }

        h1 = compute_folder_hash("src", file_hashes)
        h2 = compute_folder_hash("src", file_hashes)
        self.assertEqual(h1, h2)
        self.assertNotEqual(h1, compute_folder_hash("tests", file_hashes))

    def test_select_files_filters_domains_and_excludes(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            self.write_fixture_repo(root)

            includes = ["package.json", "**/*.{ts,js,json}"]
            excludes = ["docs/**"]
            selected = select_files(
                root,
                includes,
                excludes,
                [],
                domains=["apps/web", "packages/utils"],
            )

            rel_selected = [
                str(path.relative_to(root)).replace("\\", "/") for path in selected
            ]
            self.assertEqual(rel_selected, ["apps/web/main.ts", "packages/utils/sum.ts"])

    def test_detect_domains_expands_default_monorepo_domains(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            self.write_fixture_repo(root)

            is_monorepo, domains = detect_domains(root, {})
            self.assertTrue(is_monorepo)
            self.assertEqual(domains, ["apps/web", "packages/utils"])

    def test_init_generates_non_empty_contract_codemaps(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            self.write_fixture_repo(root)

            stdout = StringIO()
            with redirect_stdout(stdout):
                cmd_init(self.args(root))

            payload = json.loads(stdout.getvalue())
            self.assertTrue(payload["is_monorepo"])
            self.assertEqual(payload["domains"], ["apps/web", "packages/utils"])

            state = load_state(root)
            self.assertEqual(state["metadata"]["domains"], ["apps/web", "packages/utils"])

            root_codemap = (root / "codemap.md").read_text()
            self.assertIn("## Project Responsibility", root_codemap)
            self.assertIn("## Entry Points", root_codemap)
            self.assertIn("## Directory Map", root_codemap)
            self.assertIn("apps/web/ — 1 tracked files", root_codemap)

            folder_codemap = (root / "apps" / "web" / "codemap.md").read_text()
            for heading in [
                "## Responsibility",
                "## Design",
                "## Flow",
                "## Integration",
            ]:
                self.assertIn(heading, folder_codemap)
            self.assertIn("Primary stack:", folder_codemap)
            self.assertIn("express", folder_codemap)

    def test_changes_surfaces_affected_folders_and_modules(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            self.write_fixture_repo(root)
            with redirect_stdout(StringIO()):
                cmd_init(self.args(root))

            (root / "packages" / "utils" / "sum.ts").write_text(
                "export function sum(a: number, b: number) {\n  return a + b + 1\n}\n"
            )

            stdout = StringIO()
            with redirect_stdout(stdout):
                cmd_changes(self.args(root))

            payload = json.loads(stdout.getvalue())
            self.assertEqual(payload["modified"], ["packages/utils/sum.ts"])
            self.assertIn("packages", payload["affected_folders"])
            self.assertIn("packages/utils", payload["affected_folders"])
            self.assertEqual(payload["affected_modules"], ["packages/utils"])

    def test_update_regenerates_changed_folder_codemap_deterministically(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            self.write_fixture_repo(root)
            with redirect_stdout(StringIO()):
                cmd_init(self.args(root))

            before = (root / "packages" / "utils" / "codemap.md").read_text()
            before_root = (root / "codemap.md").read_text()

            (root / "packages" / "utils" / "sum.ts").write_text(
                "import lodash from 'lodash'\n\n"
                "export class MathBox {}\n"
                "export function sum(a: number, b: number) {\n"
                "  return a + b\n"
                "}\n"
            )

            stdout = StringIO()
            with redirect_stdout(stdout):
                cmd_update(self.args(root))

            update_payload = json.loads(stdout.getvalue())
            self.assertIn("packages/utils", update_payload["affected_folders"])

            after = (root / "packages" / "utils" / "codemap.md").read_text()
            after_root = (root / "codemap.md").read_text()
            self.assertNotEqual(before, after)
            self.assertEqual(after_root, (root / "codemap.md").read_text())
            self.assertIn("lodash", after)
            self.assertIn("1 class declaration(s)", after)

            stdout = StringIO()
            with redirect_stdout(stdout):
                cmd_update(self.args(root))
            second_payload = json.loads(stdout.getvalue())
            self.assertEqual(second_payload["affected_folders"], [])
            self.assertEqual(
                after, (root / "packages" / "utils" / "codemap.md").read_text()
            )
            self.assertEqual(after_root, (root / "codemap.md").read_text())

    def test_scan_respects_detected_domains(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            root = Path(tmpdir)
            self.write_fixture_repo(root)
            (root / "misc.py").write_text("print('ignored')\n")

            hashes, _ = scan(
                root, ["**/*.{ts,py,json}"], ["docs/**"], ["apps/web", "packages/utils"]
            )
            self.assertEqual(
                sorted(hashes), ["apps/web/main.ts", "packages/utils/sum.ts"]
            )


if __name__ == "__main__":
    unittest.main()
