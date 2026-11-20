# Expense Lite decisions

Decisions made with the user for Expense Lite only (moved here from the marketing tool on 2026-11-20). Decisions for every app are in the tool's `docs/decisions.md` ([Nautilus-Techlabs/app-marketing](https://github.com/Nautilus-Techlabs/app-marketing)).

## Expense Lite (decided 2026-11-05)

- A dedicated test account (display name "Test User"; its email and password are in the marketing tool's `.env`, never in this repo). Kept over a fresh account because it already has circles with members (Flatmates, Manali Trip). The circles' member names may appear on camera.
- Claude adds October and November demo transactions to it (off camera, by Maestro); the data stopped in September. Duplicate categories stay: the app can't delete them.
- App appearance set to **Light** on the test account.
- `recurring-bills` is **skipped**: the phone's Play Store build (1.0.0 (5)) doesn't have the feature.
- Circle expenses, settlements, accounts and categories can't be deleted in the app. Takes keep them small (₹600 split, settle ₹500 of a balance, one uniquely named account and category); the user tidies up.
- `create-join-circle` films creating a circle and its invite link only. Joining as the second account (the second Google account, signed in with Google) is never filmed: the Google account picker shows real email addresses.
- Font: Manrope (the app's own), added to the renderer.
