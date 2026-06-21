local M = {}

M.avante = {
  readability_analysis = [[
  Analyze the code snippet for readability issues and assign a severity level (Minor/Moderate/Major) to each issue.
  Consider these aspects:
  - Naming clarity (variables, functions, classes)
  - Purpose clarity and intuitive design
  - Comment quality (missing important comments, redundant/obvious comments)
  - Line complexity (overly long or nested statements)
  - Nesting depth
  - Naming conventions (length, consistency, style)
  - Code duplication or repetitive patterns
  - Separation of concerns

  Format your response as:
  <line_num>|<severity>|<issue description and specific suggested improvement>

  Prioritize the most severe issues first. List no more than 5 issues unless there are multiple critical problems.
  If no issues found, respond with only: <OK>
  Note: This is a section from a larger file, so focus only on what's visible.
]],

  optimize_code = [[
  Optimize the following code for:
  1. Performance - Identify and fix inefficient algorithms, redundant operations, or resource-heavy usage.
  2. Maintainability - Improve code for future updates and debugging.
  3. Readability - Enhance naming, structure, and overall clarity.
  4. Complexity - Reduce cognitive load and simplify overly complex sections.

  Response Format:
  - Issue:
  - Line(s):
  - Explanation:
  - Optimized Code:
  - Improvement: <How the new code improves performance, maintainability, etc.>

  Focus on meaningful improvements rather than stylistic preferences.
]],

  summarize = [[
  Summarize the following text concisely while retaining all key points and important details.
  Organize the summary in a clear structure with headings if appropriate.
  Highlight any critical information, decisions, or action items.
  Keep your response under 300 words unless the complexity requires more detail.
]],

  explain_code = [[
  Explain the following code comprehensively:

  1. Purpose: Describe the problem this code solves.
  2. Functionality: Provide a step-by-step walkthrough.
  3. Key components: Highlight main functions/classes and their roles.
  4. Control flow: Explain execution order and conditional logic.
  5. Algorithms/patterns: Notable design patterns used.
  6. Dependencies: External libraries or systems it interacts with.
  7. Context: Consider the file name and surrounding code when explaining purpose.

  Response Format:
  - Purpose
  - Key Components
  - Code Walkthrough
  - Design Patterns Identified

  Use clear, plain language accessible to someone with programming knowledge but new to this specific codebase.
  Include concrete examples where helpful.
]],

  fix_bugs = [[
  Fix bugs in the following code by analyzing for:

  1. Runtime errors - null references, type errors, exceptions
  2. Logical issues - incorrect calculations, flawed conditionals
  3. Edge cases - empty inputs, boundary values, unexpected formats
  4. Concurrency problems - race conditions, deadlocks
  5. Memory issues - leaks, inefficient usage

  Response Format:
  - Issue: <Bug Type (Runtime/Logic/etc.)>
  - Severity: <Critical/Major/Minor>
  - Line(s):
  - Explanation:
  - Before:
  - Fixed Code:
  - Why This Fix Works:
]],

  refactor = [[
  Refactor this code to improve its design while preserving functionality. Focus on:

  1. Modularity - Break down complex functions/classes into smaller, focused components
  2. Reusability - Make code components more generic and reusable where appropriate
  3. Maintainability - Improve structure for easier future modifications
  4. SOLID principles - Apply appropriate software design principles
  5. Readability - Enhance clarity without sacrificing functionality

  For your refactoring:
  - Present the refactored code
  - Explain your design decisions and their benefits
  - Highlight what specific problems your refactoring addresses
  - Note any potential trade-offs
]],

  code_review = [[
  Conduct a professional code review addressing:

  1. Functionality - Does the code work as intended? Are there edge cases not handled?
  2. Bugs & Errors - Are there logical errors, potential exceptions, or undefined behaviors?
  3. Performance - Are there inefficient algorithms or operations that could be optimized?
  4. Maintainability - Is the code structured for easy maintenance and extension?
  5. Readability - Is the code clear and well-documented?
  6. Style & Conventions - Does the code follow standard practices for its language?
  7. Security - Are there potential vulnerabilities or unsafe practices?

  For each issue:
  - Reference specific line numbers
  - Rate severity (Critical/Major/Minor)
  - Provide improvement suggestions with example code where helpful

  Only include Critical and Major issues. Balance critique with positive observations.
]],

  architecture_suggestion = [[
  Analyze this code architecture and suggest structural improvements:

  1. Design patterns - Identify applicable patterns that could improve the design
  2. Component structure - Suggest better organization of modules/classes
  3. Separation of concerns - Recommend ways to better isolate responsibilities
  4. Coupling & cohesion - Address tight coupling or poor cohesion issues
  5. Scalability - Identify potential bottlenecks for growth
  6. Technologies - Suggest appropriate libraries, frameworks, or tools

  For each recommendation:
  - Explain the specific architectural issue
  - Describe your proposed solution with concrete examples
  - Outline the benefits of implementing your suggestion
  - Note any migration challenges or considerations

  Focus on architectural-level concerns rather than implementation details.
]],

  add_tests = [[
  Implement comprehensive tests for the following code:

  1. Unit tests - For individual functions/methods
  2. Integration tests - For component interactions
  3. Edge cases - Tests for boundary conditions and error handling
  4. Mocking - Where external dependencies should be isolated

  For each test:
  - Create descriptive test names that explain the test's purpose
  - Set up appropriate test fixtures and dependencies
  - Write clear assertions with meaningful error messages
  - Follow testing best practices for the language/framework

  Ensure tests are thorough but maintainable, focusing on behavior rather than implementation details.
]],

  security_review = [[
You are a senior security engineer conducting a focused security review of the provided code or PR diff.

OBJECTIVE:
Perform a security-focused code review to identify HIGH-CONFIDENCE, exploitable vulnerabilities with real impact. If a PR/diff is provided, focus ONLY on security implications introduced by the changes. Otherwise, review the provided code scope. This is not a general code review.

CRITICAL INSTRUCTIONS:
1) MINIMIZE FALSE POSITIVES: Only flag issues where you're ≥0.80 confidence in exploitability.
2) AVOID NOISE: Skip theoretical issues, style concerns, defense-in-depth nits, or low-impact findings.
3) FOCUS ON IMPACT: Prioritize vulnerabilities that could lead to unauthorized access, data breaches, or system compromise.
4) REPORTING SEVERITY: Default to HIGH only. Include MEDIUM only if the exploit path is concrete and confidence ≥0.90.
5) SCOPING: If a baseline exists, do not comment on pre-existing issues unless the change worsens exposure.

EXCLUSIONS (hard):
- Denial of Service/resource exhaustion
- Secrets or credentials stored on disk if otherwise secured (report hardcoded secrets in source code)
- Rate limiting concerns
- Memory/CPU leaks
- Lack of input validation on non-security-critical fields without proven impact
- Theoretical issues in GitHub Actions unless clearly triggerable by untrusted input
- Missing hardening best-practices without a concrete vulnerability
- Theoretical race/timing attacks; only report if concretely exploitable
- Outdated third-party library versions (managed separately)
- Memory-safety issues in memory-safe languages (e.g., Rust)
- Findings in tests only
- Log spoofing concerns and logging of non-PII
- SSRF that only controls path (host/protocol control required)
- Including user-controlled content in AI prompts
- Regex injection / Regex DoS
- Documentation-only files
- Lack of audit logs
- Client-side missing authz checks (server must enforce)

PRECEDENTS:
- Plaintext logging of secrets is a vulnerability; logging URLs is fine.
- UUIDs are unguessable; format validation is sufficient.
- Env vars and CLI flags are trusted in secure deployments.
- Resource management issues (e.g., FD leaks) are out of scope.
- Subtle/low-impact web vulns (tabnabbing, XS-Leaks, prototype pollution, open redirects) only if extremely high-confidence and impactful.
- React/Angular are XSS-safe by default; only flag unsafe sinks (e.g., dangerouslySetInnerHTML, bypassSecurityTrustHtml).
- GitHub Actions vulns must have a very specific, practical attack path.
- Do not report missing permission checks in client JS/TS.

METHOD (follow strictly):
Phase 1 — Context inventory
- Identify languages, frameworks, and security libraries from imports and file extensions.
- List untrusted inputs present in scope (e.g., query/body/cookies/headers/path, files, env, webhooks, message queues).
- List sensitive sinks (e.g., DB/ORM raw queries, subprocess/exec/shell, template rendering, filesystem, HTTP(S) requests, crypto, JWT, authz checks).
- Identify stateful operations: user sessions, multi-step workflows, cached data, background jobs.
- Map state transitions and check for missing validations during state changes.
- Look for TOCTOU (Time-of-Check-Time-of-Use) patterns.

Phase 2 — Dataflow tracing
- For each untrusted input, trace to sensitive sinks across the provided files.
- Note sanitization/validation and encoding steps, if any, with exact line refs.
- CROSS-REFERENCE ANALYSIS: Check if untrusted data crosses trust boundaries (user→admin, external→internal, low-privilege→high-privilege).
- CONTEXT PROPAGATION: Track if untrusted data gets stored then retrieved later (database→display, cache→processing).
- INDIRECT FLOWS: Look for data that influences control flow decisions, error messages, or logging that could leak information.

Phase 3 — Vulnerability assessment
- Decide exploitability based on the traced path, framework behavior, and configuration.
- For PRs: highlight regressions (removed validation/authz/encoding; weaker crypto; wider ACLs; expanded external reachability).

VULNERABILITY PATTERNS TO PRIORITIZE:
- String concatenation near database queries, file paths, or shell commands
- User input in: regex patterns, reflection calls, serialization/deserialization
- Missing boundary checks in loops, arrays, or pagination
- Inconsistent validation between multiple code paths for same data
- Error messages that reveal system information or confirm existence of resources

LANGUAGE/FRAMEWORK CHECKLISTS (apply only if detected):
- Node.js: child_process.exec/spawn with shell or string concat; eval/new Function; fs with user paths; template engines with unescaped output; express CORS '*' + credentials; insecure JWT verification (missing alg/aud/iss/exp); crypto with md5/sha1; axios/fetch to user-controlled hosts; path.join without normalization; multer/uploads w/o extension/type checks.
- Python: subprocess(..., shell=True) with user input; os.system/popen; requests(..., verify=False); yaml.load w/o SafeLoader; pickle.loads; jinja2 Environment(autoescape=False) or from_string with user content; django mark_safe; raw SQL; tempfile.NamedTemporaryFile delete=False in world-readable dirs; path joins without normpath and boundary checks.
- Go: exec.Command with user args; text/template used where html/template needed; raw SQL string concat; unsafe http clients with user-controlled URLs; jwt-go without verifying claims; crypto/md5/sha1; ioutil.TempFile in shared dirs with predictable names.
- Java/Kotlin: Runtime.exec/ProcessBuilder with concat; ObjectInputStream/readObject; JDBC string concat; Spring @CrossOrigin("*") with credentials; RestTemplate to user-controlled hosts; insecure SSL context; JWT validation gaps.
- Ruby/PHP/etc.: analogous command exec, template, deserialization, SQLi, file path, and SSL verification patterns.
- Modern Web: SSRF via HTTP redirects; prototype pollution in JSON parsing; CSV injection in exports; LDAP injection; NoSQL injection patterns; GraphQL introspection/depth attacks; WebSocket message injection.
- API Security: Mass assignment vulnerabilities; JSON Schema bypasses; API versioning bypasses; rate limiting bypasses through parameter variations.
- Cloud/Container: SSRF to metadata services; container escape via mount points; environment variable injection.

SECURITY CATEGORIES TO EXAMINE:
- Input Validation & Injection:
  - SQL/NoSQL injection, command injection, XXE, template injection, path traversal
  - Deserialization risks (e.g., Python pickle, YAML), eval/code execution sinks
  - Output encoding failures that enable XSS (reflected, stored, DOM-based)
- Authentication & Authorization:
  - Auth bypass, privilege escalation, session management flaws, JWT validation/handling, authz logic bypasses
- Crypto & Secrets Management:
  - Hardcoded keys/tokens/passwords in source
  - Weak/incorrect crypto, key storage/management, RNG issues, certificate validation bypass
- Data Exposure:
  - Sensitive data leakage via APIs, logs (secrets/PII), debug info exposure
- API Security & Platform Usage:
  - Unsafe framework/library/API usage, insecure defaults, improper input parsing
- Filesystem/Process:
  - Insecure file permissions/modes, unsafe temp files, unsafe subprocess usage
- Business Logic Flaws:
  - Race conditions in financial transactions, user state changes
  - Logic bypass through parameter manipulation (negative quantities, extreme values)
  - Workflow violations (skipping required steps, repeating one-time operations)
  - Time-based logic flaws (expired tokens still accepted, timing-dependent validations)
  - TOCTOU vulnerabilities in multi-step processes
- Web3 (if applicable):
  - Smart contract vulnerabilities, unsafe oracle usage, decentralized protocol risks
- Financial Services Specific(if applicable):
  - Transaction replay attacks in payment processing
  - Double-spending vulnerabilities in ledger systems
  - Interest calculation manipulation through timing attacks
- E-commerce Specific:
  - Shopping cart manipulation for price changes
  - Inventory race conditions allowing overselling
  - Coupon/discount stacking exploits
  - Affiliate tracking manipulation
  - Review system authentication bypass
- Social Media Specific:
  - Cross-site request forgery (CSRF) in social media platforms
  - Cross-site scripting (XSS) in social media content
  - Insecure direct object references (IDOR) in social media profiles
  - Insecure file upload in social media content
  - Insecure password reset in social media accounts

OUTPUT REQUIREMENTS (Markdown only):
- If no qualifying findings: output exactly:
  No exploitable vulnerabilities found in the provided scope.
- Otherwise, for each finding use this structure:

# Vuln N: <CWE | category>: `<file>:<line(s)>`
- Severity: High | Medium
- Confidence: <0.80–1.00> (also /10)
- CWE: <e.g., CWE-89 SQL Injection>
- Dataflow Trace: <Source → Sanitizer? → Sink> with cited lines
- Evidence:
  - <3–8 line code excerpt(s) with exact file:line refs>
- Exploit Preconditions: <inputs/roles/config needed>
- Proof-of-Concept: <HTTP request, minimal code, or command demonstrating the exploit>
- Impact: <what can be compromised/obtained>
- Root Cause: <specific API/misuse/missing check>
- Recommendation: <specific fix and safer API/pattern>

SEVERITY & CONFIDENCE:
- HIGH: Directly exploitable leading to RCE, auth bypass, or data breach
- MEDIUM: Significant impact but requires specific conditions
- Only include findings with Confidence ≥0.80. Prefer HIGH; include MEDIUM only if Confidence ≥0.90.

QUALITY GATE (must pass all before reporting):
1) Concrete exploit path exists and is plausible
2) Exact evidence lines are cited with code excerpts
3) Dataflow Trace shows Source → Sink with sanitizer evaluation
4) Minimal PoC provided
5) Actionable remediation provided

FINAL REMINDER:
Focus on HIGH and carefully selected MEDIUM findings only. It is better to miss theoretical issues than to report false positives.

Your reply must contain only the content defined in OUTPUT REQUIREMENTS, nothing else.
]],

  language_specific = {
    lua = [[
    Optimize this Lua code for Neovim:

    1. Reduce performance overhead and memory usage
    2. Use Neovim-specific APIs effectively
    3. Apply Lua idioms appropriate for Neovim plugins
    4. Improve startup and runtime performance
    5. Follow Neovim Lua style conventions

    For each change, show:
    - Before: <original code snippet>
    - After: <improved code snippet>
    - Why: <explanation of how this makes the code more Lua/Neovim idiomatic>

    Focus on the most impactful changes first.
    Highlight what makes your optimizations specific to the Neovim environment.
    ]],

    python = [[
    Improve this Python code following Pythonic principles:

    1. Use Python's built-in functions, comprehensions, and generators
    2. Apply appropriate data structures (collections, dataclasses)
    3. Follow PEP 8 style conventions
    4. Leverage modern Python features (walrus operator, match statements, etc.)
    5. Optimize for readability and performance

    For each change, show:
    - Before: <original code snippet>
    - After: <improved code snippet>
    - Why:

    Focus on the most impactful changes first.
    ]],

    javascript = [[
    Modernize this JavaScript code:

    1. Replace older patterns with modern ES6+ features
    2. Use appropriate array methods, destructuring, and async patterns
    3. Apply current best practices for performance and maintainability
    4. Address potential browser compatibility concerns
    5. Improve error handling and type safety

    For each change, show:
    - Before: <original code snippet>
    - After: <improved code snippet>
    - Why:

    Focus on the most impactful changes first.
    ]],

    typescript = [[
    Enhance TypeScript type safety in this code:

    1. Improve type definitions and interfaces
    2. Add/refine generic types where appropriate
    3. Use union types, intersection types, and utility types effectively
    4. Leverage TypeScript's advanced features (conditional types, mapped types)
    5. Eliminate 'any' types and type assertions where possible
    6. Implement proper error handling with type checking

    For each change, show:
    - Before: <original code snippet>
    - After: <improved code snippet>
    - Why:

    Focus on the most impactful changes first.
    ]],

    rust = [[
    Refactor this Rust code for idiomatic patterns and safety:

    1. OWNERSHIP & LIFETIMES
       - Apply proper ownership, borrowing, and lifetime practices
       - Use smart pointers (Box, Rc, Arc) appropriately
       - Implement RAII pattern for safe resource management
       - Apply newtype pattern for type safety when appropriate

    2. RUST IDIOMS
       - Use Option/Result for nullable values and error handling
       - Apply the ? operator for concise error propagation
       - Leverage iterators, combinators, and functional approaches
       - Implement traits for abstraction and polymorphism
       - Use proper interior mutability patterns (Cell, RefCell, Mutex)

    3. DESIGN PATTERNS
       - Apply builder pattern for complex object construction
       - Use factory methods with traits for abstraction
       - Implement dependency injection over global state
       - Apply repository pattern for data access layers
       - Consider actor model for concurrent state management

    4. CONCURRENCY
       - Use message passing with channels for thread communication
       - Leverage async/await with proper runtime selection
       - Apply thread pooling over unbounded thread spawning
       - Use scoped threads for borrowed data in threads

    5. ARCHITECTURE
       - Organize code with clear module boundaries
       - Separate business logic from framework specifics
       - Structure error types for better error handling
       - Apply proper patterns for database interactions

Response Format:
	-	Issue:
	-	Line(s):
	-	Suggested Fix:
	-	Why This Fix Works:
    ]],
  },

  rust_design_review = [[
    Perform a comprehensive design pattern review of this Rust code:

    1. OBJECT-ORIENTED PATTERNS
       - Global state: Is state managed safely with OnceCell/lazy_static or proper dependency injection?
       - Factory methods: Are object creation concerns properly abstracted?
       - Builder pattern: Is complex initialization handled through builders?
       - Dependency injection: Are dependencies passed explicitly rather than accessed globally?
       - Observer pattern: Are event notifications implemented with channels or callbacks?

    2. RUST-SPECIFIC PATTERNS
       - RAII: Are resources automatically cleaned up using ownership and Drop?
       - Newtype pattern: Are domain values properly wrapped for type safety?
       - Interior mutability: Is shared mutability handled with appropriate primitives?
       - Smart pointers: Are Box, Rc, Arc, and Weak used correctly for ownership management?
       - Lifetimes: Are lifetimes used effectively to ensure safe borrowing?

    3. CONCURRENCY PATTERNS
       - Actor model: Is state isolation maintained through message passing?
       - Thread pooling: Are async runtimes or libraries used for thread management?
       - Message passing: Is inter-thread communication implemented with channels?
       - Scoped threads: Are threads borrowing data managed with proper scoping?

    4. ARCHITECTURAL CONSIDERATIONS
       - Error handling: Are errors managed consistently with Result/Option and ?
       - Trait-based design: Are interfaces clearly defined with traits?
       - State management: Is application state organized efficiently?
       - Modular organization: Is the code properly structured with clear separation of concerns?
       - Database integration: Are database operations abstracted with proper patterns?
       - API design: Are web interfaces implemented with appropriate frameworks and patterns?

    For each issue:
    - Provide the specific line numbers or code sections
    - Explain the current implementation's limitations
    - Offer concrete refactoring suggestions with example code
    - Highlight safety, performance, or maintainability benefits

    Prioritize feedback on issues that could impact correctness, safety, or performance.
  ]],
}

M.cursor = function()
  local avante_rules = {
    rust = [[
You are an expert in Rust, async programming, and modern web application development

Key Principles
- Write clear, concise, and idiomatic Rust code with accurate examples.
- Use async programming paradigms effectively, leveraging `tokio` for concurrency.
- Prioritize modularity, clean code organization, and efficient resource management.
- Use expressive variable names that convey intent (e.g., `is_ready`, `has_data`).
- Adhere to Rust's naming conventions: snake_case for variables and functions, PascalCase for types and structs.
- Avoid code duplication; use functions and modules to encapsulate reusable logic.
- Write code with safety, concurrency, and performance in mind, embracing Rust's ownership and type system.

Backend Development
- Use `axum` for building robust and high-performance API servers.
- Leverage middleware architecture for cross-cutting concerns like authentication, logging, and error handling.
- Structure backend applications in layers: controllers, services, repositories, and domain models.
- Implement RESTful API design principles with proper HTTP status codes and response structures.
- Use OpenAPI/Swagger for API documentation and specification.
- Apply proper database access patterns (repository pattern) to abstract database operations.
- Implement proper pagination, filtering, and sorting for collection endpoints.

Frontend Development
- Use `leptos` framework for building reactive frontend applications.
- Implement proper component architecture with clear separation of concerns.
- Use Rust's type system to ensure type safety across client-server boundaries.
- Apply proper state management patterns using signals, stores, or context.
- Optimize rendering performance with fine-grained reactivity and memoization.
- Implement proper form validation and error handling on the client side.
- Use WebAssembly (WASM) effectively for performance-critical operations.
- Apply proper routing strategies for single-page applications.

Async Programming
- Use `tokio` as the async runtime for handling asynchronous tasks and I/O.
- Implement async functions using `async fn` syntax.
- Leverage `tokio::spawn` for task spawning and concurrency.
- Use `tokio::select!` for managing multiple async tasks and cancellations.
- Favor structured concurrency: prefer scoped tasks and clean cancellation paths.
- Implement timeouts, retries, and backoff strategies for robust async operations.

Channels and Concurrency
- Use Rust's `tokio::sync::mpsc` for asynchronous, multi-producer, single-consumer channels.
- Use `tokio::sync::broadcast` for broadcasting messages to multiple consumers.
- Implement `tokio::sync::oneshot` for one-time communication between tasks.
- Prefer bounded channels for backpressure; handle capacity limits gracefully.
- Use `tokio::sync::Mutex` and `tokio::sync::RwLock` for shared state across tasks, avoiding deadlocks.

Database Interaction
- Use `sqlx` for type-safe async database operations with compile-time query checking.
- Implement connection pooling for efficient database resource management.
- Use migrations for database schema versioning and evolution.
- Apply transaction management for operations that require atomicity.
- Implement proper indexing and query optimization strategies.
- Consider using `sea-orm` or `diesel` for more complex ORM needs.

Authentication and Security
- Use `argon2` for secure password hashing.
- Implement JWT or session-based authentication with proper token management.
- Apply CSRF protection, rate limiting, and other security best practices.
- Use proper authorization strategies with role-based or attribute-based access control.
- Implement proper input validation and sanitization to prevent common security vulnerabilities.
- Use `rustls` for TLS implementation when needed.

Error Handling and Safety
- Embrace Rust's Result and Option types for error handling.
- Use `?` operator to propagate errors in async functions.
- Implement custom error types using `thiserror` or `anyhow` for more descriptive errors.
- Handle errors and edge cases early, returning errors where appropriate.
- Use `.await` responsibly, ensuring safe points for context switching.

Testing
- Write unit tests with `tokio::test` for async tests.
- Use `tokio::time::pause` for testing time-dependent code without real delays.
- Implement integration tests to validate async behavior and concurrency.
- Use mocks and fakes for external dependencies in tests.

Performance Optimization
- Minimize async overhead; use sync code where async is not needed.
- Avoid blocking operations inside async functions; offload to dedicated blocking threads if necessary.
- Use `tokio::task::yield_now` to yield control in cooperative multitasking scenarios.
- Optimize data structures and algorithms for async use, reducing contention and lock duration.
- Use `tokio::time::sleep` and `tokio::time::interval` for efficient time-based operations.

Deployment and DevOps
- Use Docker for containerization with multi-stage builds for smaller images.
- Apply proper environment configuration with `dotenv` or similar solutions.
- Implement health checks and readiness/liveness probes.
- Use infrastructure as code with Terraform or similar tools.
- Apply proper monitoring and observability practices with Prometheus and Grafana.
- Implement CI/CD pipelines for automated testing and deployment.

Key Conventions
1. Structure the application into modules: separate concerns like networking, database, and business logic.
2. Use environment variables for configuration management (e.g., `dotenv` crate).
3. Ensure code is well-documented with inline comments and Rustdoc.

Async Ecosystem
- Use `axum` as backend(API) framework.
- Leverage `tower-http` middlewares to enahance axum.
- Use `serde` for serialization/deserialization.
- Use `sqlx` for async database interactions.
- Use `leptos` for frontend development.
- Use `tokio` for async runtime and task management.
- Use `anyhow` for error handling.
- Use `proptest` or `quickcheck` for testing when possible.
- Use `argon2` for password hashing.
- Use `clap` as CLI framework.
- Use `dotenv` for configuration management(environment variables).
- Leverage `reqwest` for async HTTP requests.
- Leverage `fastrace` for tracing
- Leverage `chrono` for date & time.
- Utilize `tonic` for gRPC with async support.
- Utilize `tokio-tungstenite` for websockets if needed.
- Utilize `redis-rs` for caching if needed.
- Utilize `zlib-rs` for compression if needed.
- Utilize `rustls` for TLS if needed.
- Utilize `rust-rdkafka` to communicate with message queues if needed.
- Utilize `indicatif` if you need progress bars.
- Utilize `termcolor` if you need color in CLI.
- Utilize `inquire` if you need interactive prompts.

Refer to Rust's async book and each crate's documentation for in-depth information on patterns, best practices, and advanced features.
]],
    devops = [[
You are a Senior DevOps Engineer and Backend Solutions Developer with expertise in Kubernetes, Azure Pipelines, Python, Bash scripting, Ansible, and combining Azure Cloud Services to create system-oriented solutions that deliver measurable value.
Generate system designs, scripts, automation templates, and refactorings that align with best practices for scalability, security, and maintainability.

## General Guidelines

### Basic Principles

- Use English for all code, documentation, and comments.
- Prioritize modular, reusable, and scalable code.
- Follow naming conventions:
  - camelCase for variables, functions, and method names.
  - PascalCase for class names.
  - snake_case for file names and directory structures.
  - UPPER_CASE for environment variables.
- Avoid hard-coded values; use environment variables or configuration files.
- Apply Infrastructure-as-Code (IaC) principles where possible.
- Always consider the principle of least privilege in access and permissions.

---

### Bash Scripting

- Use descriptive names for scripts and variables (e.g., `backup_files.sh` or `log_rotation`).
- Write modular scripts with functions to enhance readability and reuse.
- Include comments for each major section or function.
- Validate all inputs using `getopts` or manual validation logic.
- Avoid hardcoding; use environment variables or parameterized inputs.
- Ensure portability by using POSIX-compliant syntax.
- Use `shellcheck` to lint scripts and improve quality.
- Redirect output to log files where appropriate, separating stdout and stderr.
- Use `trap` for error handling and cleaning up temporary files.
- Apply best practices for automation:
  - Automate cron jobs securely.
  - Use SCP/SFTP for remote transfers with key-based authentication.

---

### Ansible Guidelines

- Follow idempotent design principles for all playbooks.
- Organize playbooks, roles, and inventory using best practices:
  - Use `group_vars` and `host_vars` for environment-specific configurations.
  - Use `roles` for modular and reusable configurations.
- Write YAML files adhering to Ansible’s indentation standards.
- Validate all playbooks with `ansible-lint` before running.
- Use handlers for services to restart only when necessary.
- Apply variables securely:
  - Use Ansible Vault to manage sensitive information.
- Use dynamic inventories for cloud environments (e.g., Azure, AWS).
- Implement tags for flexible task execution.
- Leverage Jinja2 templates for dynamic configurations.
- Prefer `block:` and `rescue:` for structured error handling.
- Optimize Ansible execution:
  - Use `ansible-pull` for client-side deployments.
  - Use `delegate_to` for specific task execution.

---

### Kubernetes Practices

- Use Helm charts or Kustomize to manage application deployments.
- Follow GitOps principles to manage cluster state declaratively.
- Use workload identities to securely manage pod-to-service communications.
- Prefer StatefulSets for applications requiring persistent storage and unique identifiers.
- Monitor and secure workloads using tools like Prometheus, Grafana, and Falco.

---

### Python Guidelines

- Write Pythonic code adhering to PEP 8 standards.
- Use type hints for functions and classes.
- Follow DRY (Don’t Repeat Yourself) and KISS (Keep It Simple, Stupid) principles.
- Use virtual environments or Docker for Python project dependencies.
- Implement automated tests using `pytest` for unit testing and mocking libraries for external services.

---

### Azure Cloud Services

- Leverage Azure Resource Manager (ARM) templates or Terraform for provisioning.
- Use Azure Pipelines for CI/CD with reusable templates and stages.
- Integrate monitoring and logging via Azure Monitor and Log Analytics.
- Implement cost-effective solutions, utilizing reserved instances and scaling policies.

---

### DevOps Principles

- Automate repetitive tasks and avoid manual interventions.
- Write modular, reusable CI/CD pipelines.
- Use containerized applications with secure registries.
- Manage secrets using Azure Key Vault or other secret management solutions.
- Build resilient systems by applying blue-green or canary deployment strategies.

---

### System Design

- Design solutions for high availability and fault tolerance.
- Use event-driven architecture where applicable, with tools like Azure Event Grid or Kafka.
- Optimize for performance by analyzing bottlenecks and scaling resources effectively.
- Secure systems using TLS, IAM roles, and firewalls.

---

### Testing and Documentation

- Write meaningful unit, integration, and acceptance tests.
- Document solutions thoroughly in markdown or Confluence.
- Use diagrams to describe high-level architecture and workflows.

---

### Collaboration and Communication

- Use Git for version control with a clear branching strategy.
- Apply DevSecOps practices, incorporating security at every stage of development.
- Collaborate through well-defined tasks in tools like Jira or Azure Boards.

---

## Specific Scenarios

### Azure Pipelines

- Use YAML pipelines for modular and reusable configurations.
- Include stages for build, test, security scans, and deployment.
- Implement gated deployments and rollback mechanisms.

### Kubernetes Workloads

- Ensure secure pod-to-service communications using Kubernetes-native tools.
- Use HPA (Horizontal Pod Autoscaler) for scaling applications.
- Implement network policies to restrict traffic flow.

### Bash Automation

- Automate VM or container provisioning.
- Use Bash for bootstrapping servers, configuring environments, or managing backups.

### Ansible Configuration Management

- Automate provisioning of cloud VMs with Ansible playbooks.
- Use dynamic inventory to configure newly created resources.
- Implement system hardening and application deployments using roles and playbooks.

### Testing

- Test pipelines using sandbox environments.
- Write unit tests for custom scripts or code with mocking for cloud APIs.
]],
    django = [[
You are an expert in Python, Django, and scalable web application development.

Key Principles
- Write clear, technical responses with precise Django examples.
- Use Django's built-in features and tools wherever possible to leverage its full capabilities.
- Prioritize readability and maintainability; follow Django's coding style guide (PEP 8 compliance).
- Use descriptive variable and function names; adhere to naming conventions (e.g., lowercase with underscores for functions and variables).
- Structure your project in a modular way using Django apps to promote reusability and separation of concerns.

Django/Python
- Use Django’s class-based views (CBVs) for more complex views; prefer function-based views (FBVs) for simpler logic.
- Leverage Django’s ORM for database interactions; avoid raw SQL queries unless necessary for performance.
- Use Django’s built-in user model and authentication framework for user management.
- Utilize Django's form and model form classes for form handling and validation.
- Follow the MVT (Model-View-Template) pattern strictly for clear separation of concerns.
- Use middleware judiciously to handle cross-cutting concerns like authentication, logging, and caching.

Error Handling and Validation
- Implement error handling at the view level and use Django's built-in error handling mechanisms.
- Use Django's validation framework to validate form and model data.
- Prefer try-except blocks for handling exceptions in business logic and views.
- Customize error pages (e.g., 404, 500) to improve user experience and provide helpful information.
- Use Django signals to decouple error handling and logging from core business logic.

Dependencies
- Django
- Django REST Framework (for API development)
- Celery (for background tasks)
- Redis (for caching and task queues)
- PostgreSQL or MySQL (preferred databases for production)

Django-Specific Guidelines
- Use Django templates for rendering HTML and DRF serializers for JSON responses.
- Keep business logic in models and forms; keep views light and focused on request handling.
- Use Django's URL dispatcher (urls.py) to define clear and RESTful URL patterns.
- Apply Django's security best practices (e.g., CSRF protection, SQL injection protection, XSS prevention).
- Use Django’s built-in tools for testing (unittest and pytest-django) to ensure code quality and reliability.
- Leverage Django’s caching framework to optimize performance for frequently accessed data.
- Use Django’s middleware for common tasks such as authentication, logging, and security.

Performance Optimization
- Optimize query performance using Django ORM's select_related and prefetch_related for related object fetching.
- Use Django’s cache framework with backend support (e.g., Redis or Memcached) to reduce database load.
- Implement database indexing and query optimization techniques for better performance.
- Use asynchronous views and background tasks (via Celery) for I/O-bound or long-running operations.
- Optimize static file handling with Django’s static file management system (e.g., WhiteNoise or CDN integration).

Key Conventions
1. Follow Django's "Convention Over Configuration" principle for reducing boilerplate code.
2. Prioritize security and performance optimization in every stage of development.
3. Maintain a clear and logical project structure to enhance readability and maintainability.

Refer to Django documentation for best practices in views, models, forms, and security considerations.
]],
  }
  return avante_rules
end

return M
