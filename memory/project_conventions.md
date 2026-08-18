---
name: project-conventions
description: Key conventions — RABL for API, never abbreviate CVE, register permissions in lib/katello/permissions/, PatternFly UI
metadata:
  type: project
---

Critical conventions that cause real bugs when violated:

1. **Never abbreviate "content view environment" as CVE** — CVE means "Common Vulnerabilities and Exposures". Use `CVEnv` or spell it out. In Ruby: `cvenv`, `cvenv_id`. In JS: `cvEnv`, `cvEnvId`.

2. **Permission registration** — ALL controller actions requiring auth MUST be registered in `lib/katello/permissions/[resource]_permissions.rb`. Forgetting this causes 403 errors even if controller authorization is correct.

3. **RABL for API views** — use RABL templates in `app/views/katello/api/v2/`, never `render :json`.

4. **TableIndexPage for table UIs** — import from `foremanReact/components/PF4/TableIndexPage/TableIndexPage`. See `developer_docs/table_index_page_patterns.md`.

5. **PatternFly (PF4/PF5)** — UI components use the PatternFly design system.

**Why:** These are hard-to-debug mistakes. A missing permission registration silently returns 403. A CVE abbreviation confuses security tooling and reviewers. Wrong API rendering breaks consumers.

**How to apply:** When adding API endpoints, always create the RABL view and register permissions. When naming variables for content view environments, use `cvenv`/`cvEnv`. Related: [[project-architecture]], [[project-testing]].
