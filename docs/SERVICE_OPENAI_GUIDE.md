# OpenAI Service Guide

This guide is for projects that use OpenAI through Supabase Edge Functions or backend automation.

## Typical Uses

- text generation
- structured JSON generation
- moderation or classification
- image generation orchestration
- prompt assembly on the server side

## Preferred Integration Pattern

- keep OpenAI API calls on the server side
- store API keys in environment variables
- isolate provider-specific request formatting in helper modules
- log request intent and failure shape, but not raw secrets

## Agent Rules

- do not put provider keys in browser code
- document model and payload assumptions near the integration point
- keep prompt construction separate from transport code when possible
- if the project mixes OpenAI with other providers, make provider boundaries explicit

