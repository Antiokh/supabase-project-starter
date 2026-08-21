# Telegram Debugging Guide

This guide documents Telegram as a preferred operational debug channel.

## Why Use Telegram For Debugging

For active development and operations, Telegram is often faster than opening database tables manually.

It is useful for:

- fast incident visibility
- deploy and webhook feedback
- function failure alerts
- payload snapshots during investigation

## Recommended Model

Use a dual-path approach:

1. keep structured logs available in the database
2. mirror selected events to Telegram for fast visibility

That gives both:

- speed for humans
- searchable history for deeper investigation

## Starter Pattern

The current starter pattern is:

1. write operational events into `public.debug_events`
2. use `debug-log` for normalized event ingestion
3. use `createDbg(true)` when logs should also go to Telegram
4. use `createDbg(false)` when logs should stay only in the database

This keeps Telegram useful instead of noisy.

## Good Uses

- unexpected function failures
- publication pipeline failures
- webhook errors
- queue dead-letter events
- deploy notifications

## Bad Uses

- flooding Telegram with every low-value success event
- sending secrets or raw credentials
- relying on Telegram as the only durable audit trail

## Agent Rules

- prefer Telegram for high-signal operational messages
- keep message formatting compact and readable
- redact secrets and sensitive payload fields
- if a project primarily uses Telegram for debugging, document that preference clearly
