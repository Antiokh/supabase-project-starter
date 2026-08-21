# Agent Start Here

This repository is a Supabase project starter.

It is intended for both humans and AI agents.

The goal is to make Supabase project work safer and more repeatable across:

- Supabase Cloud
- local Supabase CLI
- self-hosted or offline-sensitive deployments

## Read In This Order

1. [QUICKSTART_FOR_AGENT.md](./QUICKSTART_FOR_AGENT.md)
2. [AGENT_SYSTEM_PROMPT.md](./AGENT_SYSTEM_PROMPT.md)
3. [AI.md](./AI.md)
4. [AGENT_DECISION_TREE.md](./AGENT_DECISION_TREE.md)
5. [PROJECT_INIT_GUIDE.md](./PROJECT_INIT_GUIDE.md)
6. [SUPABASE_SOURCE_OF_TRUTH_GUIDE.md](./SUPABASE_SOURCE_OF_TRUTH_GUIDE.md)
7. [HELPERS_REFERENCE.md](./HELPERS_REFERENCE.md)

## Core Rule

Do not treat this as a generic TypeScript or Deno repository.

Before reading deep docs or editing:

- ask how the project will be hosted: cloud, self-hosted, or hybrid, if that is not already known
- identify the deployment mode
- identify the auth context
- identify the SQL source-of-truth policy
- identify whether a file is generated, manual, or a read-only snapshot

Then read only the task-specific docs you actually need.

For task routing, use:

- [AGENT_DECISION_TREE.md](./AGENT_DECISION_TREE.md)
- [`agent_index.json`](./agent_index.json)

## Local References

If present, also read:

- `AGENT_LOCAL_REFERENCE.md`

That file is local-only and may point to machine-specific mirrors, snippets, notes, or reference repositories.
