---
description: Executes jira-start-task skill. Uses direct mode if arguments are provided, otherwise interactive mode.
---

# jira-start-task

Invoke the Jira start task skill.

## Execution

Execute the skill `jira-start-task`.

- If `{{args}}` is provided:
  - Pass it as raw input to the skill
  - The skill should continue execution without asking for additional input unless strictly required

- If `{{args}}` is NOT provided:
  - Invoke the skill without arguments
  - The skill should guide the user interactively

## Rules

- Treat `{{args}}` as opaque raw input
- Do not interpret, transform, or extract meaning from arguments
- Forward arguments exactly as received
- Do not perform any Jira-related logic
- Do not preselect issues, resolve identities, or infer intent

## Output

- Return only the final user-facing result from the skill
- Do not include reasoning, explanations, or decision process
- Do not include prefixes like "Thinking", "Analysis", or similar
- Do not add commentary or summaries
- If the skill returns structured output, preserve it exactly

## Delegation contract

The skill `jira-start-task` is solely responsible for:
- deciding execution mode (interactive vs direct)
- selecting or validating the Jira issue
- handling branch creation or reuse
- generating any prompts or outputs