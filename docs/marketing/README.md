# Expense Lite marketing

Everything needed to make Expense Lite's promo videos (Instagram Reels and
YouTube Shorts). The files here are the **sources**; the marketing tool
([Nautilus-Techlabs/app-marketing](https://github.com/Nautilus-Techlabs/app-marketing))
turns them into finished videos. The features the videos cover are listed
in [`../features.md`](../features.md): one `##` entry is one video.

| Path | What it is |
|---|---|
| `app.json` | Expense Lite's settings for the tool: name, tagline, colours, font, icon, demo names, and the reusable phone steps |
| `decisions.md` | Decisions made for Expense Lite's marketing, with dates |
| `video/screens.md` | Map of every app screen: what the tool can tap and how to reach it. Videos are scripted from this |
| `video/scripts/` | One script per video (`<feature>.json`): its text, music and phone steps |

There are no brochures or carousels for Expense Lite yet; they would go in
`print/`, as in Queuzo's repo.

## How to make them

In the marketing tool's folder, with this repo listed in its `apps.json`
(see the tool's README):

```sh
npm run promo -- status expense-lite                # every video and its next step
npm run promo -- make expense-lite add-transaction  # film and render one video (phone connected)
```

## Status (2026-11-20)

- 9 scripts approved. 8 videos made on 2026-11-05 (renderer v11), waiting
  for the final watch. `status` shows them as "video stale" only because the
  renderer is now v12 (one phone frame colour throughout a video, from the
  Queuzo work). They haven't been rendered again: rendering them in v12 is a
  decision for the final watch.
- `recurring-bills` is skipped: the Play Store build on the filming phone
  (1.0.0 (5)) doesn't have it. `features.md` still says `video: yes`, so
  `status` lists it as "new".
- `split-circle-expenses` is blocked: "Add Expense" in a circle spins forever
  and saves nothing. Waiting on the app's developer.
- Recordings run only on the test account (see `decisions.md`); the Google
  account picker is never filmed.
