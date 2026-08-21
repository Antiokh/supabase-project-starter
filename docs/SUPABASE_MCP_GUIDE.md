# Supabase MCP Guide

This guide explains when an agent should use Supabase MCP and when it should not.

## First Rule

Before using MCP or proposing deploy steps, determine how the project will be hosted:

- cloud
- self-hosted
- hybrid

If that is unclear, ask first.

## Purpose Of MCP

Supabase MCP is most useful for:

- project introspection
- schema inspection
- bucket and auth inspection
- reducing the need to read large generated DB artifacts

It should not be treated as mandatory for every project mode.

## Cloud Projects

Cloud is the main case where remote Supabase MCP is worth wiring.

Recommended agent behavior:

1. ask which Supabase Cloud project is the default deploy target
2. make sure the project is linked for CLI deploy workflows
3. use scoped, preferably read-only MCP access unless the task truly needs more

Practical rule:

- if the project deploys to Supabase Cloud, set the default project for deploy before giving deploy commands

Typical cloud workflow:

- `supabase link --project-ref <project-ref>`
- use MCP against the intended cloud project

## Self-Hosted Projects

For self-hosted projects, do not assume Supabase Cloud MCP or Cloud deploy workflows are relevant.

Default rule:

- do not require remote Supabase MCP
- do not require `supabase link` just to work on the project
- do not route the agent through Cloud deploy instructions

If a self-hosted project later proves a useful MCP path, document that proven setup separately.

## Hybrid Projects

Hybrid means some work is local or self-hosted, but deployment or managed services still touch a Supabase Cloud project.

Recommended agent behavior:

1. ask which parts are cloud-backed
2. ask which Cloud project is the default deploy target
3. use MCP only for the cloud-backed part
4. keep local or self-hosted runtime assumptions separate

## Local CLI Projects

For local-only work, MCP is optional.

Default rule:

- do not require MCP for local development
- use local files, `supabase/config.toml`, and runtime scaffold first

If local MCP is available and useful for introspection, treat it as optional convenience, not as a required dependency of the workflow.

## Token Optimization Rule

If MCP is available for the actual target environment, prefer it over reading large generated schema artifacts.

Good uses:

- inspect tables, policies, or buckets
- confirm current project state
- reduce context spent on large SQL or JSON snapshots

Bad uses:

- using MCP before the hosting mode is known
- reading broad project state when the task is narrow
- wiring MCP for local or self-hosted work that does not benefit from it

## Starter Rule

The agent should not assume that Supabase MCP must be configured in every project derived from this starter.

The default decision is:

- cloud: likely yes
- self-hosted: usually no
- hybrid: selective
- local-only: optional
