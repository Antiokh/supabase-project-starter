# Supabase Master Guide

This file is the main orientation guide for the starter.

## Mission

This starter should let a human or agent begin a Supabase-based project with:

- a safe structure
- consistent helper patterns
- explicit runtime assumptions
- documented SQL workflows
- documented versioning and export flows

## Core Layers

Think of the starter as six layers:

1. repository structure
2. runtime helper layer
3. Supabase function patterns
4. starter templates for SQL versioning and schema export
5. cron orchestration
6. agent documentation and operating rules

## Modes

The starter must support three mental modes:

- Cloud
- local CLI
- self-hosted/offline-sensitive

Code and docs must make mode assumptions explicit.

## Service Layer

Many real projects built from this starter will also depend on external services.

Current documented service families:

- OpenAI
- Stripe
- Telegram Bot API
- fal.ai
- Supabase Storage

When a project uses one of these, the agent should read the relevant service guide in `docs/`.

## Source Of Truth

The starter also relies on a repository-level source-of-truth policy.

That policy is documented in:

- `SUPABASE_SOURCE_OF_TRUTH_GUIDE.md`

## Structure Rule

Keep starter source separate from project-owned runtime files.

Practical meaning:

- runtime helpers belong under `supabase/`
- starter templates for SQL versioning and schema export live under `docs/templates/`
- generated SQL snapshots should not share a folder with hand-maintained starter templates
