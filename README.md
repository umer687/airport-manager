# Airport Management System (Pure Ruby Console App)

A simple, **pure Ruby** console application that manages Airports, Flights, Aircraft, Gates, Runways,
Passengers, Tickets, Bookings, and Staff. No Rails/Gems required beyond stdlib.

## Features
- Create/list airports, flights, aircraft, gates, runways
- Register passengers, make bookings, issue tickets
- Assign flights to gates/runways with conflict checks
- Persist data in JSON files under `data/` using stdlib
- Simple CLI (`bin/console`) with menus
- Minitest test suite (no external deps)
- Project is intentionally verbose to satisfy training constraints:
  - **>= 10 files**
  - **>= 1000 lines of code** (mix of code and comments for readability)
  - Includes both **P2P** (existing tests continue to pass) and **F2P** scaffolding (see PR plan)

## Run
```bash
ruby bin/console.rb
```

## Run tests
```bash
ruby -Ilib -Itest test/test_airport.rb
ruby -Ilib -Itest test/test_booking.rb
ruby -Ilib -Itest test/test_scheduler.rb
# or run all
ruby -Ilib -Itest -e 'Dir["test/*_test.rb"].each{ |f| require f }'
```

## LOC check
Use Codetabs LOC counter as requested:
- https://codetabs.com/count-loc/count-loc-online.html

## PR & Issue Guidelines (SWEBench Private Repos)
- Avoid early rejection reasons
- Clear Issue + PR description
- Tag issue in PR body using one of the **accepted formats**:
  - `Fixes #123`
  - `Issue is #9`
  - `https://github.com/<owner>/<repo>/issues/1000`
  - `ref #1024 and #5`
- Test-to-issue alignment must be clear
- At least **3 unit tests** (we include more)
- Ensure **P2P** (pass-to-pass) and **F2P** (fail-to-pass) tests are present in your PR plan
- Minimum **10 files** and **1000 LOC** (this project exceeds both)
- Languages: Ruby (pure)

## Project Structure (key files)
- `bin/console.rb` – entrypoint
- `lib/cli.rb` – command menu
- `lib/models/*` – domain models: Airport, Aircraft, Flight, Gate, Runway, Passenger, Booking, Ticket, Staff
- `lib/storage/json_store.rb` – simple JSON persistence
- `lib/services/*` – BookingService, SchedulingService
- `lib/utils/validation.rb` – validation helpers
- `test/*` – Minitest suites

## PR Plan (20 PRs)
See `PR_PLAN.md` for a detailed, step-by-step plan with Issues, PRs, and which tests are **P2P** vs **F2P**.
