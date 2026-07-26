import type { Plugin } from "@opencode-ai/plugin"

/**
 * code-review-graph plugin for OpenCode.
 *
 * Keeps the knowledge graph up-to-date and surfaces status
 * information automatically during coding sessions.
 *
 * Installed by: code-review-graph install --platform opencode
 */

// Helper: run a shell command quietly, swallowing errors.
async function run($: any, cmd: string): Promise<string> {
  try {
    const result = await $`${cmd}`.quiet()
    return result.stdout?.toString().trim() ?? ""
  } catch {
    return ""
  }
}

export default (app: any) => {
  // 1. Auto-update graph after file edits
  app.on("file.edited", async ({ $ }: { $: any }) => {
    try {
      await $`code-review-graph update --skip-flows`.quiet()
    } catch {
      // Swallow — graph may not be built yet for this project.
    }
  })

  // 2. Show graph status when a new session starts
  app.on("session.created", async ({ $ }: { $: any }) => {
    try {
      const result = await $`code-review-graph status`.quiet()
      const output = result.stdout?.toString().trim()
      if (output) {
        console.log("[code-review-graph]", output)
      }
    } catch {
      // Swallow — not every project has a graph.
    }
  })

  // 3. Detect changes before git commit commands
  app.on("tool.execute.before", async (ctx: any) => {
    try {
      const input = ctx?.input ?? ctx?.params ?? {}
      const cmd =
        input.command ?? input.cmd ?? input.content ?? ""
      if (typeof cmd === "string" && /^git\s+commit/i.test(cmd)) {
        const result =
          await ctx.$`code-review-graph detect-changes --brief`.quiet()
        const output = result.stdout?.toString().trim()
        if (output) {
          console.log("[code-review-graph] Pre-commit analysis:\n" + output)
        }
      }
    } catch {
      // Swallow — never block a commit.
    }
  })
}
