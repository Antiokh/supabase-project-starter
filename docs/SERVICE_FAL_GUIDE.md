# fal.ai Service Guide

This guide is for projects that use fal.ai for image or media generation workflows.

## Typical Uses

- generation requests
- async subscribe/resolve flows
- retries and reconciliations
- media post-processing orchestration

## Preferred Integration Pattern

- keep provider calls behind server-side functions
- explicitly model async lifecycle states
- separate request initiation from result resolution
- treat retries and worker shutdown behavior as first-class operational concerns

## Agent Rules

- do not assume async tails always finish after returning a response
- prefer durable state transitions over fire-and-forget work
- document provider callback or polling assumptions

