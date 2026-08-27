## Context

The herdr module currently provides `hrd::internal::pane::setup_3_pane_layout` which creates a 3-pane layout in a single tab. The `hrd::project` and `hrdw::create` functions use this to set up workspaces.

The goal is to modify this function to create **2 tabs by default**, each with its own 3-pane layout, enabling multi-context workflows out of the box.

## Goals / Non-Goals

**Goals:**
- Modify `setup_3_pane_layout` to create multiple tabs
- Default to 2 tabs (breaking change from current 1-tab behavior)
- Allow configurable tab count via optional parameter
- Maintain backward compatibility for callers (function signature change only)

**Non-Goals:**
- Creating new helper functions like `hrd::dual_project`
- Changing the 3-pane layout proportions or naming
- Modifying workspace creation logic

## Decisions

### Decision 1: Modify existing function with optional num_tabs parameter

**Choice**: Add optional `num_tabs` parameter as second positional argument

**Rationale**:
- Single function encapsulates all complexity
- Backward compatible for callers (only new default behavior changes)
- Simple interface: `setup_3_pane_layout "ws_id" 2`
- No new functions to remember

**Alternatives considered**:
- Create new function `hrd::dual_project` - rejected due to code duplication
- Add `--dual` flag to `hrd::project` - rejected due to increased complexity

### Decision 2: Default to 2 tabs

**Choice**: When `num_tabs` is omitted, default to 2 tabs

**Rationale**:
- Primary use case is dual-context workflow
- Users wanting single tab can pass explicit `1`
- Aligns with user's request for "2 tabs by default"

**Alternatives considered**:
- Keep default at 1 tab - rejected per user preference
- Make default configurable via env var - rejected as over-engineering

### Decision 3: Tab creation approach

**Choice**: Create tabs sequentially using `herdr tab create` within a loop

**Rationale**:
- Reliable tab creation with proper IDs
- Each tab can be configured independently
- Matches herdr's tab management API

**Alternatives considered**:
- Batch tab creation - not supported by herdr
- Clone existing tab - not available in herdr

## Risks / Trade-offs

**Risk**: Breaking change for existing users
- **Mitigation**: Document in changelog, provide explicit `1` parameter for single-tab behavior

**Risk**: Tab creation may fail for some tabs
- **Mitigation**: Continue with remaining tabs, emit warnings, apply layout to successful tabs

**Risk**: Performance with many tabs
- **Mitigation**: Sequential creation is reliable; users unlikely to need >3 tabs
