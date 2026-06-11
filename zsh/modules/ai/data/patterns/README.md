# Custom Fabric Patterns

This directory contains custom patterns for [fabric](https://github.com/danielmiessler/fabric).

## Structure

Each pattern is a directory with a `system.md` file:

```
data/patterns/
├── pattern_name/
│   ├── system.md    # Required: AI instructions
│   └── user.md      # Optional: Documentation
```

## Sync Patterns

Sync local patterns to fabric:

```bash
ai::fabric::patterns::sync
```

Or use fabric directly:

```bash
fabric --updatepatterns
```

## Create a Pattern

1. Create a directory: `mkdir -p data/patterns/my_pattern`
2. Create `system.md`:

```markdown
# IDENTITY and PURPOSE

You are an expert in...

# STEPS

- Step 1
- Step 2

# OUTPUT INSTRUCTIONS

- Output format

# INPUT

INPUT:
```

3. Sync: `ai::fabric::patterns::sync`
4. Use: `echo "text" | fabric -p my_pattern`