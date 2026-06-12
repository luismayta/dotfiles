---
description: Push branch and create MR with title and description
---

1. Load skill: gitlab-create-mr
2. Use that skill to validate the branch, inspect `main...HEAD`, check for an existing MR, push the branch, generate the MR title and description from `.gitlab/merge_request_templates/MERGE_REQUEST_TEMPLATE.md`, create the merge request with `glab mr create`, and return the MR URL.