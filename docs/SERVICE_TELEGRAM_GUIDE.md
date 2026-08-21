# Telegram Service Guide

This guide is for projects that use Telegram Bot API for notifications, debugging, or bot workflows.

## Typical Uses

- operational alerts
- debug log mirroring
- bot webhook flows
- user-facing bot messages
- file delivery and signed-link handoff

## Why Telegram Matters In This Starter

Telegram is especially useful as a debug channel because it is faster to inspect than opening database tables during active iteration.

That makes it a practical first-class ops tool, not just a product integration.

In this starter, that is treated as a normal working convention, not as an incidental preference.

## Preferred Integration Pattern

- use Telegram for human-visible alerts and fast debug feedback
- keep structured debug logs available in DB when needed
- use service-side helpers for outbound Telegram calls
- keep bot/webhook logic separate from simple notification sends

## Preferred Transport Pattern

For this starter, the preferred default is:

- native HTTP wrappers over Telegram Bot API
- built on `fetch`
- small explicit helper surface such as `sendMessage`, `sendDocument`, `deleteMessage`, `getWebhookInfo`, `setWebhook`

Reason:

- this matches the more reliable pattern from current projects
- it avoids unnecessary SDK coupling
- it is easier to reason about in self-hosted and offline-sensitive environments

## SDK Position

Telegram SDKs such as `grammy` are not part of the recommended starter path.

Reason:

- they already caused runtime problems in current projects
- the team deliberately moved away from them
- native Bot API wrappers are easier to control and debug

## Starter Support

The starter includes:

- a `debug-log` flow that can optionally mirror selected events into Telegram
- an optional native Telegram Bot API helper for projects that need richer Telegram integration

That gives a practical default path for:

- function failure alerts
- publication pipeline alerts
- deploy and smoke-test feedback
- future bot and file-delivery flows

## Agent Rules

- do not hardcode bot tokens
- separate debug-notification flows from user-facing bot flows
- document whether a message is best-effort or must be durable
- when Telegram is the main debug channel, say so explicitly in docs and helper contracts
- do not introduce `grammy` into this starter
- use native Bot API wrappers
