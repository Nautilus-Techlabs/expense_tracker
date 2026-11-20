# Expense Lite screen map

What each screen shows and the exact Maestro labels to use, so scripts can be written without exploring the phone again (docs/workflow.md, rule 1). Labels are given as JSON strings: `\n` is a line break inside one label. Use `(?s)…` regexes for labels with line breaks when only part of the label is known. Coordinates are phone pixels (1080×2340) as `labels` prints them.

Walked on 2026-11-05 on the Samsung M17, Play Store build 1.0.0 (5), installed 2026-11-05. **Videos are recorded on the test account ("Test User"; sign-in details in the marketing tool's `.env`).** Update this file when the app or its data changes.

## Build on the phone vs the repo

The Play Store build is older than the repo's `latest_changes` branch. Missing on the phone:

- **Repeat Monthly** switch on Add transaction, the due-bills banner on Home, and **Recurring Bills** in Profile (the whole recurring-bills feature).

Not in the app at all (features.md mentions them):

- Transactions filters have only **Specific Date** and **Category**; no type or account filter.

## Data on the test account (2026-11-05)

- **Added by Claude on 2026-11-05** (Maestro, off camera): 16 October and 7 November transactions (salary ₹85000 each month, rent, groceries, bills, food, transport, shopping, travel, freelance ₹12000). November spend ₹21779 of the ₹42000 budget (52%). 5 November is left free for the add-transaction video.
- Left by dry runs (can't be deleted): account **Kotak Savings** (₹25000), category **Pets**, a ₹500 John Doe settlement in Flatmates. The accounts-categories script now uses **Axis Savings** and **Gym**; change them again before any retake.
- Appearance: **Light**.

- **Accounts (3):** Cash Wallet (CASH) ₹1466 · HDFC (BANK) ₹499100 · SBI Savings (BANK) ₹135674. Total balance ₹636240.
- **Transactions:** Aug–Nov 2026. Sep 2026: income ₹63000, expense ₹27130.
- Newest transaction has no note, so it shows as `"Expense\nExpense\n₹500\nHDFC"`.
- **Categories** have duplicates: Food / Food & Dining, Grocery / Groceries, Health / Healthcare, Utilities / Bills & Utilities, and Transport, Rent, Salary and Freelance appear twice in the pickers.
- **Monthly budget:** ₹42000.
- **Circles:** Flatmates (ongoing, 4 members: Test User (owner), John Doe owes ₹2100, member 2 owes ₹2600, member 3 (viewer) settled; total ₹7800, ₹500 settled, ₹4700 pending). Manali Trip (one-time, 3 members, 100% settled). Circles header: `"You are owed ₹4701"`, `"You owe ₹0"`; the Flatmates card says `You owe ₹4700` for the same money.
- Second account for joining a circle: sign in with Google and pick the second Google account in the account picker. The picker shows real email addresses: off camera only.

## What can and can't be undone in the app

| Data | Undo |
|---|---|
| Transaction | Transaction detail → `"Delete"` |
| Circle | Circle settings → `"Delete Circle"` (blocked while anyone has a balance) |
| Circle expense, settlement | none |
| Account, category | none |
| Monthly budget | set it back to ₹42000 |

## Navigation

- Bottom tabs: `"Home"`, `"Transactions"`, `"Circles"`, `"Reports"`. Plain `"Home"` also matches Android's Home button: use `{ "text": "Home", "index": 0 }` or the point `"15%,89%"`.
- **Add (+) button** in the middle of the tab bar has **no label**: tap `{ "point": "50%,86%" }` (bounds [462,1944][618,2099]). It overlaps whatever scrolls behind it (e.g. Reports' `"View all categories"`).
- Profile: avatar `"TU"` on Home (top right).
- Back arrow on inner screens has no label: `{ "point": "8%,5%" }` or `pressKey: Back`.
- Opening: `launchApp` lands on Home when signed in (Splash shows briefly).

## Home

- `"Good morning,"`, `"Test"`, avatar `"TU"`.
- Balance card: `"Total balance"`, `"₹636240"`, `"Income"` / `"₹132100"`, `"Expense"` / `"₹189660"`. Card bounds about [66,400][1014,960].
- Budget card: `"November budget"`, `"₹<spent> / ₹42000"`, progress bar. Bounds about [66,980][1014,1220].
- `"Recent Transactions"`, then rows `"<note>\n<type>\n₹<amount>\n<account>"` (3 visible).

## Add transaction (+ button; bottom sheet)

- `"Add transaction"`, close ✕ (no label). Type: `"Expense"` (default) / `"Income"`.
- Amount: `"₹ "` + `"0"` at [552,710][625,896]; the keyboard isn't open: tap `"0"` then `inputText`.
- `"Category"` chips (one tap selects): first row `"Uncategorized"`, `"Food"`, `"Grocery"`; also `"Food & Dining"`, `"Groceries"`, `"Shopping"`, `"Entertainment"`, `"Bills & Utilities"`, `"Healthcare"`, `"Travel"`, `"Others"`. **Duplicate names** (`"Transport"`, `"Rent"`) need `index`.
- Below the fold (swipe up inside the sheet): `"Account"` chips `"Cash Wallet"`, `"HDFC"`, `"SBI Savings"`; date `"Today, 05 Nov"`; note `"Add a note (optional)"`.
- Save: `"Save transaction"` (fixed at the bottom, [66,1996][1014,2138]).

## Transactions tab

- `"Transactions"`; filter and search icons top right have **no labels**: filter `{ "point": "79%,10%" }`, search `{ "point": "90%,10%" }`.
- Month tabs: `"Aug 2026"`, `"Sep 2026"` (only months with data).
- Totals: `"Income"` / `"₹63000"`, `"Expense"` / `"₹127131"` (as the labels read on 2026-11-05; September's expense elsewhere is ₹27130, so check this total on the next walk).
- Day headers `"15 Sep"`, rows `"<note>\n<type>\n₹<amount>\n<account>"`.

## Filters (Transactions → filter icon; bottom sheet)

- `"Filters"`, `"Specific Date"` → `"Select Date"`, `"Category"` chips (all categories, income ones too: `"Salary"`, `"Freelance"`, `"Gifts"`), `"Clear All"`, `"Apply"`.

## Transaction detail (tap a row)

- `"Transaction detail"`, note as title, `"₹1599.0"`, `"<category> · <type> · <date>"`.
- Rows: `"Date"`, `"Account"`, `"Category"`, `"Note"`, `"Type"` with values beside them.
- `"Edit transaction"`, `"Delete"` → dialog `"Delete Transaction"`, `"Cancel"`, `"Delete"`: tap `{ "text": "Delete", "index": 0 }` (the screen's own button is hidden behind the dialog). (Edit screen not walked yet.)

## Reports tab

- `"Reports"`, month switcher `"Nov 2026"` with ‹ › arrows (no labels): previous `{ "point": "62%,10%" }`, next `{ "point": "88%,10%" }`.
- `"INCOME"`, `"EXPENSE"`, `"NET"` with amounts; `"MONTHLY TREND"` bar chart (only the selected month shows); `"SPENDING BREAKDOWN"` donut with `"₹<total>"` `"spent"`, then rows `"<category>"` / `"₹<amount> (<pct>%)"`, then `"View all categories"` (hidden behind the + button until scrolled further), then a by-account table: `"Account Name"`, `"Inflow"`, `"Outflow"`, `"Net"`.

## Spending Breakdown (Reports → View all categories)

- `"Spending Breakdown"`, `"Categories for <month>"`, `"TOTAL SPENT"` `"₹27130"`, then a card per category: `"<category>"`, `"<pct> % of total spending"`, `"₹<amount>"` with a bar.

## Circles tab

- `"Circles"`, `"You are owed ₹4701"`, `"You owe ₹0"`.
- Cards: `"(?s)ONGOING.*Flatmates.*"` [0,490][1080,1106], `"(?s).*ONE-TIME.*Manali Trip.*"`.
- `"Create a new circle"`.

## Create Circle (Circles → Create a new circle; bottom sheet)

- `"Create Circle"`, `"Ongoing"` / `"One-Time"`, `"Circle Name"` field `"e.g. Goa Trip 2026"`, `"Description (Optional)"` `"e.g. Shared expenses for summer trip"`, `"Budget (Optional)"` `"e.g. 10000"`.
- Switch `"Include settlements in personal ledger\nReflect circle settlements in your personal account balance"` (on by default), `"Settlement Account"` → `"Select account"`, save `"Create Circle"` (same text as the title: use `index: 1`).

## Circle details (tap a circle card)

- Title `"Flatmates"`, settings gear top right (no label).
- `"SUMMARY"`, `"Total spent:"` `"₹7800"`, `"₹500 settled"`, `"₹4700 pending"`.
- `"MEMBERS (4)"`, `"Add member"`; members: `"Test User (You)"` `"Settled up"` `"OWNER"`; `"John Doe"` `"Owes ₹2100 to you"` `"Remind"`; `"<member 2>"` `"Owes ₹2600 to you"` `"Remind"`; `"<member 3>"` `"VIEWER"`.
- Below: `"RECENT ACTIVITY"`, `"View all"`, rows `"<note>\nPaid by <name> • <date>\n₹<amount>"`.
- Fixed bottom buttons: `"Settle up"`, `"+ Add expense"`.

## Add Circle Expense (Circle details → + Add expense)

- `"Amount"` field `"0.00"`, `"Note / Description"` field `"e.g. Dinner at Fisherman's Wharf"`, `"Date"` `"05 Nov 2026"`, `"Paid By"` dropdown `"Test User (You)"`, `"Account"` and `"Category (Opt)"` dropdowns.
- `"SPLIT WITH (4/4)"`, `"Deselect All"`, a row per member (checked).
- **`"Account"` is required** (else a snackbar, no save): tap `{ "text": "Account", "index": 1 }`, then pick `"HDFC"` etc. from the list.
- Below the fold: `"Split Option"` `"Equal"` / `"Percentage %"` / `"Fixed ₹"`, save `"Add Expense"`.

## Settle Up (Circle details → Settle up; bottom sheet)

- `"Settle Up"`, `"Select a member to settle your balances with"`, rows `"JD\nJohn Doe\nOwes ₹2100"`, `"<initial>\n<member 2>\nOwes ₹2600"`.
- Tap a row → dialog `"Settle up with John Doe"`, `"How much did they pay you?"`, amount pre-filled `"2100"`, `"Cancel"`, `"Confirm"`. Saved: snackbar `"Settlement recorded."`.

## Profile (Home → TU)

- `"Profile"`, `"Test User"`, `"<the test account's email>"`, `"Edit profile"`, `"ACCOUNTS"` `"3"`.
- `"Appearance\nSystem"`, `"Monthly budget\n₹42000"`, `"Accounts"`, `"Categories"`, `"Export data\nCSV"`, `"Help & FAQ"`, `"Rate Expense Lite"`, `"Log out"`.

## Monthly Budget (Profile → Monthly budget; dialog)

- `"Monthly Budget"`, `"Set your spending limit for November. …"`, amount `"42000"` (pre-filled), `"Cancel"`, `"Update"`.

## Accounts (Profile → Accounts)

- Rows `"Cash Wallet\nCASH\n₹1466"`, `"HDFC\nBANK\n₹499100"`, `"SBI Savings\nBANK\n₹135674"`; `"Add Account"` (bottom right).

## Add Account

- `"Account Type"` `"Bank"` / `"Cash"`, `"Account Name"` field `"e.g. HDFC Salary, Wallet"`, `"Current Balance"` field `"0.00"`, save `"CREATE ACCOUNT"`.

## Categories (Profile → Categories)

- Rows `"<name>\n<EXPENSE|INCOME|BOTH>"`; `"Add Category"` (bottom right) → sheet `"New Category"`, `"Expense"` / `"Income"` / `"Both"`, `"Name"` field `"e.g. Groceries"`, `"Save Category"`.
