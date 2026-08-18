---
name: project-testing
description: Testing — Minitest for Ruby (use ktest for single files), Jest for JS, VCR for external service HTTP recordings
metadata:
  type: project
---

Test stack:
- **Ruby:** Minitest — unit tests in `test/models/`, controllers in `test/controllers/`, actions in `test/actions/`
- **JavaScript:** Jest — tests colocated in `webpack/` with `__tests__/` directories
- **External services:** VCR cassettes in `test/fixtures/vcr_cassettes/` record HTTP interactions with Pulp/Candlepin

Running tests:
- `bundle exec rake test:katello` — all Ruby tests (from foreman dir)
- `ktest /path/to/test_file.rb` — single Ruby test file (from katello dir)
- `ktest /path/to/test_file.rb -n test_method_name` — single test method
- `npm test` — all JS tests (from katello dir)
- `npx jest webpack/path/to/file.test.js` — single JS test file

Test conventions:
- Never use `SecureRandom.uuid` or random values — use fixed strings like `'test-task-id-123'`
- Match surrounding test style (method names, length, comments)
- VCR recording is destructive and requires environment reset — see `developer_docs/testing_and_code_quality.md`

**Why:** The `ktest` wrapper handles the Foreman/Katello directory split for individual test files. VCR recordings are expensive and environment-specific.

**How to apply:** Use `ktest` for individual Ruby test files, `bundle exec rake test:katello` for full suite. Don't re-record VCR cassettes unless necessary. Related: [[project-dev-environment]], [[project-conventions]].
