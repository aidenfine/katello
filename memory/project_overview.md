---
name: project-overview
description: Katello is a Foreman plugin providing content and subscription management via Pulp and Candlepin
metadata:
  type: project
---

Katello is a plugin for Foreman that orchestrates content distribution and subscription management at scale. It serves as an enterprise content gateway between external repositories and Foreman-managed hosts.

**Why:** Katello is not a standalone app — it extends Foreman with content management capabilities by integrating with Pulp (content storage/sync) and Candlepin (subscription/entitlement management).

**How to apply:** Always treat Katello as a Foreman plugin. Commands run from the Foreman directory, models share Foreman's database, and controllers extend Foreman's base classes. Related: [[project-architecture]], [[project-dev-environment]].
