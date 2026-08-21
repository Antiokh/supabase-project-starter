# Stripe Service Guide

This guide is for projects that use Stripe with Supabase Edge Functions.

## Typical Uses

- checkout session creation
- webhook handling
- subscription state sync
- credits or entitlements reconciliation

## Preferred Integration Pattern

- create checkout and admin actions through service-side functions
- treat webhook handlers as the source of truth for payment finalization
- keep business state reconciliation explicit in SQL or service logic

## Agent Rules

- never trust browser success redirects as final payment truth
- verify Stripe webhooks
- separate test and live secrets clearly
- document idempotency expectations for Stripe-driven writes

