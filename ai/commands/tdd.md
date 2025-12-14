## Test-Driven Development Workflow (Prism)

Use this checklist every time you initiate a TDD loop so that tests remain the first “client” of our public interfaces.

1. **Locate the codebase section.**  
   - Confirm with the user where the front end or back end lives if it is not obvious.  
   - Change directory to the full absolute path (e.g., `/<project_root_full_path>/web-app` for the frontend, `/<project_root_full_path>/backend` for the backend) before running any commands.

2. **Set up the test harness.**  
   - If new, create the test file or suite structure first.  
   - Decide the granularity for execution (single file, directory, or package) so the loop stays fast.

3. **Add exactly one assertion.**  
   - Follow the order: **exceptional**, **degenerate**, **ancillary**, **happy**.  
   - This ordering is a guardrail against *Grabbing for The Gold* (Uncle Bob): avoid the “core” behavior until you’ve cleared the hedge of edge cases around it.
   - Tests should exercise the real public API of the feature; avoid contorting tests to accommodate awkward internals.

4. **Run the relevant tests.**  
   - Example (frontend TypeScript):  
     ```bash
     cd /<project_root_full_path>/web-app
     npm test -- path/to/spec.test.tsx
     ```  
   - Expect the new assertion to fail. A failing test is your permission to implement.  
   - **CRITICAL**: You must see the test FAIL with the expected failure message before implementing. If it passes or fails for the wrong reason, stop and investigate.

5. **Confirm the failure.**  
   - Read the failure output carefully. Does it fail for the right reason? (e.g., "field X undefined" when testing field X).  
   - If it fails for the wrong reason, the test may be flawed or you may have misunderstood the current state.

6. **Clean the test (while still failing).**  
   - Refactor the test *before* you make it pass so it reads like a spec.  
   - Prefer **Arrange / Act / Assert** structure, and extract helpers so the test body stays small and intention-revealing.  
   - The loop is: **Red → Clean Test → Green → Refactor**.

7. **Implement only what fixes that single failing assertion.**  
   - Keep changes focused—no shotgun coding.  
   - **One assertion = One test run = One minimal fix**. Never implement for tests you haven't written yet, even if you "know" they're coming.  
   - *Don't go for the Gold*: implement the simplest specific thing that makes the test pass; avoid premature generality. You can generalize safely in the refactor step.  
   - If the fix requires touching public interfaces, question whether the API is ergonomic; note refactor opportunities.

8. **Repeat the loop.**  
   - Extend the test suite by one more assertion, respecting the E-D-A-H ordering.  
   - Maintain the "tight loop" rhythm (write assertion → run tests → make the minimum implementation) until the user redirects, a snag appears, or you reach the happy path.  
   - When building similar features (e.g., HTTP methods, CRUD operations), systematically build parity: repeat the same assertion sequence for each variant before moving to the next concern. This keeps tests focused and catches inconsistencies early.

9. **Refactor consciously.**  
   - Always propose refactors when you notice design-pattern opportunities, but remember: a refactor must leave all existing behavior and tests unchanged.  
   - Refactor immediately when you see duplication in **production code** (Red-Green-**Refactor**). Refactoring test structure can wait until a natural pause or when tests become hard to read.  
   - If you reach the happy path and the structure feels unwieldy, pause and collaborate with the user on refactoring plans.

10. **Mind the interfaces and ergonomics.**  
   - Tests should read like real use cases. If an API is painful to test, look beyond just redesigning the public entry point: consider whether the right module or type is responsible for the behavior under test. Think about encapsulation and single responsibility—should a different component, service, or helper own this concern? Adjust the design so that responsibilities can be tested at the most natural boundary, rather than forcing awkward test code.
   - Unit tests for isolated helpers are optional; add them when they make it easier to express business rules (e.g., pure validation or math).

11. **Protect momentum.**  
   - The loop's power comes from fast cycles. Avoid adding multiple assertions or large implementation batches before re-running tests.  
   - Keep responses focused and brief: state intention → make change → confirm result → propose next step. Don't over-explain or pre-implement.  
   - When progress stalls or scope inflates, stop and ask for guidance before continuing.

