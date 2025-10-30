# PR Plan – 20 PRs with Issues (Ruby Airport Management System)

This plan gives you 20 PRs. Each PR references an Issue with an accepted format and includes
which tests are **P2P** (existing tests must still pass) and which are **F2P** (new test fails before fix, passes after).
For F2P items, create the failing test in the PR and then implement the fix/feature in the same PR so CI shows fail→pass.

> Replace `<owner>/<repo>` with your actual repo before pushing.

## Conventions
- Issue titles are concise; descriptions include reproduction steps or acceptance criteria.
- PR bodies must include one of these lines:
  - `Fixes #<n>`
  - `Issue is #<n>`
  - Full URL: `https://github.com/<owner>/<repo>/issues/<n>`
  - `ref #<n> and #<m>` (when referencing multiples)

---

### PR 1 – Initialize project skeleton (P2P)
- Issue #1: Initialize repository structure and scaffolding
- PR: `Fixes #1`
- Changes: add folders, README, baseline classes with minimal methods, tests that pass

### PR 2 – Implement JSON storage (P2P)
- Issue #2: Persist domain objects to JSON files
- PR: `Fixes #2`
- Tests: `test_airport.rb` adds cases to verify save/load

### PR 3 – Airport model validations (F2P)
- Issue #3: Invalid IATA codes should be rejected
- PR: `Fixes #3`
- Add failing test for invalid codes (F2P), then implement validation

### PR 4 – Flight scheduling (P2P)
- Issue #4: Basic scheduling without conflicts
- PR: `Fixes #4`
- Tests: `test_scheduler.rb` ensure assignment OK

### PR 5 – Gate conflict detection (F2P)
- Issue #5: Prevent overlapping gate assignments
- PR: `Fixes #5`
- Add failing test (F2P), then implement fix in `SchedulingService`

### PR 6 – Runway conflict detection (F2P)
- Issue #6: Prevent runway overlaps on same timeslot
- PR: `Fixes #6`

### PR 7 – Booking service basics (P2P)
- Issue #7: Create bookings and auto-issue tickets
- PR: `Fixes #7`

### PR 8 – Overbooking protection (F2P)
- Issue #8: Disallow bookings beyond aircraft capacity
- PR: `Fixes #8`

### PR 9 – Passenger find/search (P2P)
- Issue #9: Search passenger by name/email
- PR: `Issue is #9`

### PR 10 – Flight status transitions (P2P)
- Issue #10: Status flow (Scheduled→Boarding→Departed→Arrived)
- PR: `Fixes #10`

### PR 11 – CLI menus for CRUD (P2P)
- Issue #11: Add CLI menus for Airports/Flights/Passengers
- PR: `Fixes #11`

### PR 12 – Data import/export (P2P)
- Issue #12: Export all data to single JSON; import back
- PR: `Fixes #12`

### PR 13 – Ticket cancellation (F2P)
- Issue #13: Cancel ticket and release seat
- PR: `Fixes #13`

### PR 14 – Staff roster (P2P)
- Issue #14: Add staff assignments to flights
- PR: `Fixes #14`

### PR 15 – Duplicate passenger detection (F2P)
- Issue #15: Detect duplicate passengers by email
- PR: `Fixes #15`

### PR 16 – Timezone-safe scheduling (P2P)
- Issue #16: Ensure UTC storage and local render
- PR: `Fixes #16`

### PR 17 – Basic reporting (P2P)
- Issue #17: Report top routes and load factor
- PR: `Fixes #17`

### PR 18 – CLI search UX (P2P)
- Issue #18: Add quick search + filters
- PR: `Fixes #18`

### PR 19 – Bugfix: Booking on departed flight (F2P)
- Issue #19: Prevent booking if flight already departed
- PR: `Fixes #19`

### PR 20 – Refactor & cleanup (P2P)
- Issue #20: Code cleanup, docs, small perf wins
- PR: `ref #1 and #4`
