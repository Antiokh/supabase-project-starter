# Supabase Runtime Guide

This guide explains the runtime differences the agent must keep in mind across:

- Supabase Cloud
- local Supabase CLI
- self-hosted Docker or offline-sensitive environments

These are not interchangeable modes.

They may run similar code, but they differ in operational guarantees, configuration boundaries, and failure modes.

## Short Mental Model

Use this rule first:

- Cloud is managed runtime
- local CLI is development runtime
- self-hosted is operations runtime

That distinction matters before you choose helper patterns, env loading strategy, dependency strategy, and debugging approach.

## Supabase Cloud

Cloud is the managed Supabase platform.

What it is good for:

- production deployment
- hosted secrets and project configuration
- platform-managed Edge Function deployment
- globally distributed Edge Functions

Agent assumptions that are usually safe in Cloud:

- project secrets are managed through the Supabase platform
- Edge Function deployment happens through the platform or CLI
- platform services are already wired together

Agent cautions in Cloud:

- do not assume cold starts never happen
- do not treat long-running background work as guaranteed after returning a response
- do not depend on undocumented runtime behavior
- do not spend Edge Function invocations on work that can be skipped by a cheap pre-check

## Cloud Cost And Limit Awareness

Supabase Cloud features are convenient, but some limits are easy to exhaust if a project calls Edge Functions too eagerly.

Practical rule:

- check whether an Edge Function call is actually needed before making it
- prefer a cheap local or DB-side precondition check over unconditional function invocation
- avoid turning every UI interaction into an Edge Function call when the answer is often "nothing to do"

Examples:

- if a thumbnail already exists, do not call a thumbnail-generation Edge Function again
- if a row is already in the target state, do not call an orchestration function just to rediscover that fact
- if a signed URL or derived artifact is still valid, do not regenerate it without a reason

## Local CLI

Local CLI is for development and testing, not for production.

This should be treated as a local, Docker-backed developer environment.

Important practical characteristics:

- local settings come from `supabase/config.toml`
- local stack behavior changes when `config.toml` changes and the stack is restarted
- the local stack should not be exposed publicly

Agent assumptions for local CLI:

- this is the best place for fast iteration
- local runtime is meant to approximate production, not become your deployment target
- local config is explicit and repo-visible

Agent cautions in local CLI:

- a local stack is still infrastructure, not just a library
- Docker, networking, port conflicts, and local machine state matter
- local parity is useful, but not identical to all Cloud behavior

## Self-Hosted

Self-hosted is a deployed runtime you operate yourself.

This is different from both Cloud and local CLI.

What usually changes here:

- you own the container and network behavior
- you own environment propagation
- you own restart and rollout behavior
- you own failure recovery for platform services

Agent assumptions for self-hosted:

- custom env vars may need explicit forwarding through Docker configuration
- function code changes may require container restart or recreation to take effect
- internal URLs and public URLs may differ

Agent cautions in self-hosted:

- never assume Cloud operational guarantees
- network egress may be unavailable or restricted
- import-time side effects are more dangerous here
- stale container state can hide bugs that do not show up in one-shot local testing

## Cloud Vs Local Vs Self-Hosted

### 1. Intended use

- Cloud: managed deployment target
- local CLI: development and testing
- self-hosted: production or controlled infrastructure operated by you

### 2. Configuration boundary

- Cloud: secrets and runtime are managed through Supabase platform primitives
- local CLI: behavior is configured through `supabase/config.toml`
- self-hosted: behavior depends on your Docker and environment configuration

### 3. Environment variables

- Cloud: usually easiest operationally, but code should still avoid fragile import-time env assumptions
- local CLI: env and service behavior are local-stack concerns
- self-hosted: env forwarding is an explicit deployment concern and can fail silently if wired wrong

### 4. Dependency strategy

- Cloud: external dependency resolution is generally easier operationally
- local CLI: normal development imports are usually acceptable
- self-hosted/offline-sensitive: prefer `npm:` dependencies first and avoid fragile external `https:` dependency chains

Important:

- the exact offline landing pattern for third-party libraries is not treated as finalized in this starter yet
- vendoring, caching, or prebundling strategy should be documented here only after it is validated in a real self-hosted project flow
- until then, treat offline library strategy as an open operational verification item, not as solved theory

### 5. Debugging

- Cloud: inspect platform logs and deployment state
- local CLI: inspect local runtime, local Docker services, and config
- self-hosted: inspect container logs, deployment config, and service recreation state

## Rules For The Agent

Before editing runtime code, decide which mode the target project is in.

If the mode is unclear:

- default to the safer helper patterns
- avoid import-time env access
- avoid assuming outbound network access
- avoid mixing runtime template files with generated SQL artifacts
- avoid unnecessary Edge Function invocations until the need for them is confirmed

If the project is self-hosted or may become self-hosted:

- prefer `npm:` imports over remote `https:` module imports
- use function-local import maps only when they improve deploy clarity
- avoid dependency trees that rely on runtime fetching from third-party CDNs
- for Telegram integrations, use native Bot API wrappers and do not introduce `grammy`
- do not assume vendoring layout or offline dependency landing is finalized unless the target project already proved it

## Operational Anti-Patterns

Treat these as red flags across all runtime modes:

- reading env or building clients at module load
- assuming a background promise will finish after returning a response
- relying on one local-only env flag to switch behavior
- building internal Edge URLs manually in each function
- editing generated SQL snapshots as if they were canonical source

These patterns may appear to work in one environment and fail in another.

## Production-Derived Signals

The starter design combines official documentation with patterns validated across production and internal project work.

Observed patterns:

- local `supabase/config.toml` is part of the repository contract
- shared helpers benefit from lazy environment access
- helper design should support local and self-hosted constraints explicitly
- Docker and infrastructure behavior are part of the runtime contract
- offline dependency handling should be validated in a real target deployment before being standardized
- Cloud-oriented projects still benefit from local CLI configuration and clear helper boundaries
- generated DB artifacts and synced SQL snapshots need explicit source-of-truth guardrails
- publication and export workflows should be explicit and documented

### Practical takeaway

If a project looks Cloud-first, do not assume it can ignore local or self-hosted constraints.

If a project looks self-hosted, do not assume it should inherit Cloud-specific operational expectations.

## Repository Design Consequence

Because runtime mode and SQL source-of-truth can vary by project:

- runtime helpers live in `supabase/`
- starter SQL modules live in `docs/templates/`
- generated SQL or synced DB snapshots should live in project-owned locations, not inside starter template folders
