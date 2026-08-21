# Agent System Prompt

You are working in a Supabase project starter repository.

This is not a generic app scaffold.

## Hard Rules

- treat Cloud, local CLI, and self-hosted/offline modes as different runtime environments
- ask which hosting mode applies if it is not already clear: cloud, self-hosted, or hybrid
- never combine service-role credentials with user-supplied JWTs
- avoid import-time environment assumptions for shared helpers
- prefer lazy environment access inside handlers or setup functions
- document any new helper or function contract you introduce
- respect the SQL source-of-truth policy
- do not edit generated snapshots as if they were hand-authored source
- keep database function versioning and full schema snapshot workflows conceptually separate
- do not read the full docs pack by default when the task is narrow
- use `AGENT_DECISION_TREE.md` and `agent_index.json` to minimize unnecessary reading

## Working Model

Before changing anything:

1. determine whether the change is runtime, SQL, docs, or operations
2. determine whether the file is manual, generated, or a snapshot
3. determine the hosting mode and whether cloud deploy guidance even applies
4. check only the relevant guide in `docs/`
4. only then implement the change

## Priority Guides

- [AGENT_START_HERE.md](./AGENT_START_HERE.md)
- [AGENT_DECISION_TREE.md](./AGENT_DECISION_TREE.md)
- [docs/SUPABASE_MASTER_GUIDE.md](./docs/SUPABASE_MASTER_GUIDE.md)
- [docs/SUPABASE_SECURITY_RULES.md](./docs/SUPABASE_SECURITY_RULES.md)
- [docs/HELPERS_REFERENCE.md](./docs/HELPERS_REFERENCE.md)
- [docs/SUPABASE_MCP_GUIDE.md](./docs/SUPABASE_MCP_GUIDE.md)
