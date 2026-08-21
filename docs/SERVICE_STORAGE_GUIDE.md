# Supabase Storage Guide

This guide is for projects that use Supabase Storage through Edge Functions.

## Typical Uses

- uploads
- signed URL creation
- file delivery
- ownership checks
- Telegram or external-service file handoff

## Preferred Integration Pattern

- perform ownership checks before issuing signed URLs
- use service-side helpers for signed URL generation when browser trust is not enough
- document bucket assumptions and path normalization rules

## Signed Vs Public Asset Rule

Supabase-backed clients such as WeWeb can work with private or signed URLs, but that should not be the default delivery path for repeatedly requested thumbnails.

Preferred split:

- keep original or sensitive assets private when they need access control
- store cacheable thumbnails in a dedicated public bucket
- persist a stable public thumbnail URL on the source row when the thumbnail is ready

Reason:

- this reduces repeated signing work
- it reduces client-side code complexity
- it improves cacheability on the client and CDN path
- it avoids repeatedly calling an Edge Function just to re-resolve the same thumbnail URL

## Image And Thumbnail Rule

Supabase Storage has built-in image transformation support, but it should not be treated as the default thumbnail strategy for this starter.

Reason:

- built-in transform quotas are easy to hit in image-heavy flows
- repeated thumbnail requests can burn through limits faster than expected

Preferred default for thumbnail-heavy projects:

- perform a cheap existence check first
- if a thumbnail is already present, reuse it
- if it is missing, generate it through a controlled function path using an external image library
- store the generated thumbnail in a public thumbnail bucket and serve it directly afterward
- persist the resulting public thumbnail URL on the owning row for future reads

This shifts thumbnail generation from repeated platform transforms to explicit asset generation.

## Example Thumbnail Pattern

Reference flow:

1. user or job asks for a thumbnail
2. check whether the target thumbnail object already exists
3. if it exists, return it immediately
4. if it does not exist, load the source image
5. resize it with an external library inside a controlled worker or Edge Function path
6. upload the thumbnail to a dedicated public thumbnail bucket
7. persist the public thumbnail URL on the source row
8. return the stable public thumbnail URL

The important rule is not the specific library choice.

The important rule is:

- do not rely on built-in transforms as the unlimited default path
- cache the result as a stored thumbnail asset
- avoid regenerating the same thumbnail repeatedly
- avoid re-signing or re-resolving the same thumbnail on every client request

## Agent Rules

- do not expose privileged storage operations directly to the browser
- be explicit about public vs signed access
- when passing storage files to external services, verify the external service can reach the resulting URL
- for thumbnail-heavy flows, prefer stored generated thumbnails over repeated built-in transform usage
