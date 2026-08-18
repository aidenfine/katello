# Katello AI Memory Branch

This is the `llm-memory` orphan branch. It stores AI memory files for the Katello project so context persists across conversations without needing external servers.

## How This Works

- This branch contains **only** memory/context files — no application code.
- Application code lives on `master` and feature branches.
- To use this memory in a conversation, check out this branch or read files from it via `git show llm-memory:<path>`.

## Project Reference

Katello is a Foreman plugin for content and subscription management. Full developer docs live on master:

- `developer_docs/quick_reference.md` — commands, setup, essential rules
- `developer_docs/architecture.md` — file structure, services, domain models
- `developer_docs/testing_and_code_quality.md` — test patterns, VCR, code quality
- `developer_docs/development_and_troubleshooting.md` — workflows, common issues
- `developer_docs/table_index_page_patterns.md` — React UI patterns

The master branch `CLAUDE.md` points to `developer_docs/quick_reference.md` as the primary reference.

## Memory Directory

All memory files are in the `memory/` directory. See `memory/MEMORY.md` for the index.
