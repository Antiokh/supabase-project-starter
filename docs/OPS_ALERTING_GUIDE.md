# Ops Alerting Guide

This guide defines what should and should not be mirrored into fast operational channels such as Telegram.

## Goal

Keep alerting high-signal.

If every event goes to Telegram, Telegram stops being useful.

## Good Candidates For Telegram Alerts

- function crashes
- queue dead-letter events
- Git publication failures
- webhook validation failures
- deployment smoke-test failures
- critical storage handoff failures

## Usually Not Good Candidates

- every successful request
- normal queue progress
- verbose payload dumps on routine paths
- repeated health-check success messages

## Rule Of Thumb

Use Telegram for:

- urgent
- actionable
- human-visible

Use DB logs for:

- detailed traces
- noisy diagnostics
- full payload inspection

## Starter Pattern

The current starter pattern is:

- write structured data into `debug_events`
- use `createDbg(true)` for high-signal events that should also go to Telegram
- use `createDbg(false)` for events that should stay only in DB
