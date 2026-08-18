---
name: project-architecture
description: Katello architecture — Rails engine, Dynflow async jobs, React+AngularJS UI, PostgreSQL with katello_ prefixed tables
metadata:
  type: project
---

Katello is a Rails engine loaded via `lib/katello/engine.rb`, mounted at the `/katello` namespace in Foreman.

Key architectural layers:
- **Backend:** Rails controllers (`app/controllers/katello/api/v2/`), models (`app/models/katello/`), services (`app/services/`)
- **Async jobs:** Dynflow-based actions in `app/lib/actions/katello/` — all long-running operations go through Foreman Tasks
- **Frontend:** React components in `webpack/scenes/`, legacy AngularJS in `engines/bastion_katello/`
- **API views:** RABL templates in `app/views/katello/api/v2/` — never use `render :json`
- **Database:** PostgreSQL, shared with Foreman, tables prefixed `katello_`
- **External services:** Pulp 3 (port 24816) for content, Candlepin (port 8443) for subscriptions

**Why:** Understanding these layers prevents common mistakes — e.g., putting sync logic in a controller instead of a Dynflow action, or using `render :json` instead of RABL.

**How to apply:** Match the layer to the task. API work touches controllers + RABL views + routes. Background work uses Dynflow actions. UI work goes in `webpack/scenes/`. Related: [[project-overview]], [[project-conventions]].
