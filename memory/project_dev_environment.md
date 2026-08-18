---
name: project-dev-environment
description: Development environment — edit in katello dir, run all rake/rails commands from foreman dir with bundle exec
metadata:
  type: project
---

Katello development follows a split-directory pattern:
- **Edit files** in the Katello directory (`$GITDIR/katello` or `/home/vagrant/katello`)
- **Run commands** from the Foreman directory (`$GITDIR/foreman` or `/home/vagrant/foreman`)
- **All commands** must use `bundle exec` prefix

Key commands:
- `bundle exec foreman start` — start dev server (from foreman dir)
- `bundle exec rake db:migrate` — run migrations (from foreman dir)
- `bundle exec rake katello:reset` — wipe and reseed all data
- `bundle exec rake katello:rubocop` — Ruby linting (from foreman dir)

**Why:** Katello is a Foreman plugin, so Rails loads from Foreman's directory. Running rake/rails from the Katello directory will fail or produce wrong results.

**How to apply:** Always `cd` to the Foreman directory before running any `rake`, `rails`, or `bundle exec` command. Only `cd` to Katello for editing files, running `npm`/`npx` commands, or git operations. Related: [[project-overview]], [[project-testing]].
