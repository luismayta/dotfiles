---
description: Wrapper SSD para proponer cambios usando Athena (delegates to opsx-propose)
---

Delegates the execution of `/opsx-propose` using Athena as the default agent.

# hadx-ssd-propose

## Steps

1. **Resolve agent**
   - Use `Athena` as default

2. **Delegate execution**
   - Invoke `/opsx-propose` with `{{args}}` using Athena

(End of file - total 15 lines)