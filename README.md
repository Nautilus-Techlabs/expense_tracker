# Expense Lite

Expense Lite is a mobile app (built with Flutter) for tracking your money — both your own personal income and spending, and expenses you share with other people through group "Circles" (roommates, trips, couples, friend groups, etc.). Your data is stored securely in the cloud, so it stays with you across devices, and the app is organized around a simple bottom navigation bar: **Home, Transactions, Add, Circles,** and **Reports**.

This document describes, in plain language, everything the app currently does — screen by screen. Where something is only partially built (a button that doesn't do anything yet, a screen that shows placeholder data), that's called out honestly rather than glossed over.

## Table of Contents

- [Sign Up, Sign In & Onboarding](#sign-up-sign-in--onboarding)
- [Personal Expense Tracking](#personal-expense-tracking)
- [Shared Expenses & Circles (Group Expense Splitting)](#shared-expenses--circles-group-expense-splitting)
- [Under the Hood: Cloud Sync, Notifications & App Experience](#under-the-hood-cloud-sync-notifications--app-experience)

---

## Sign Up, Sign In & Onboarding

### The first few seconds

When you open the app, a brief splash screen appears with the app logo while it quietly checks in the background whether you're already signed in (your login is remembered securely on your device, so most of the time you won't need to log in again). Based on that check, you're taken to one of three places:

- **Never signed in before →** the Welcome screen.
- **Signed in, but haven't set up a money account yet →** the "Add Account" setup screen.
- **Signed in and already set up →** straight to your dashboard.

If the app can't reach the internet at that moment, it plays it safe and lets you into your dashboard anyway rather than getting you stuck.

### Welcome screen

This is your first stop if you're new. It shows the app name and tagline and gives you two choices:

- **Create account** — start fresh.
- **Sign in** — if you already have an account.

A small note at the bottom reminds you that continuing means you agree to the Terms and Privacy Policy.

### Creating an account (Sign Up)

The sign-up screen asks for three things:

- **Name** — just needs to be filled in.
- **Email** — checked for a valid email format (e.g. `you@example.com`).
- **Password** — must be **exactly 6 characters**, no more and no fewer. You can tap the eye icon to reveal or hide what you've typed.

Tapping **Create Account** creates your account right away — there is currently no separate email verification or one-time-code step, so you're not asked to confirm your email address before continuing. Once your account is created, you're taken directly into the app to set up your first money account.

If something goes wrong (for example, the email is already registered, the connection drops, or the server rejects the request) you'll see a clear on-screen error message explaining what happened, and you can just try again.

You can also skip filling in the form entirely and tap **Continue with Google** to sign up using your Google account instead (see below).

If you already have an account, a "Already have an account? Sign in" link at the bottom takes you to the sign-in screen.

### Signing in

The sign-in screen asks for your **email** and **password**, with the same show/hide toggle on the password field. Tapping **Sign In** logs you straight into your dashboard if the details are correct; otherwise you'll see an on-screen error message (for example, if the password is wrong).

A **"Forgot password?"** link is shown on this screen, though at the moment tapping it doesn't yet trigger a password-reset flow — that piece of functionality isn't wired up in the current version.

As on the sign-up screen, there's also a **Continue with Google** option, and a "Don't have an account? Create one" link if you landed here by mistake.

### Signing in with Google

Both the sign-up and sign-in screens offer "Continue with Google." Tapping it opens Google's sign-in flow, and once you approve it, you're brought back into the app automatically:

- If this is the **first time** you've used this Google account with the app, it creates your profile for you automatically (using the name from your Google account) and takes you straight into setting up your first money account — no extra sign-up form to fill in.
- If you've **signed in with this Google account before**, you're taken straight to your dashboard.

If the Google sign-in doesn't complete within about 10 seconds, or something goes wrong on Google's or the app's side, you'll see an error message and can try again.

### Getting set up after signing up

Right after your very first sign-up (by email or Google), you're guided into adding your first money account (like a bank account or wallet) before you land on the main dashboard — the app needs at least one account to track expenses against. Returning users who already have an account set up skip this step and go straight to their dashboard.

### Staying signed in

Once you're signed in, the app remembers you securely on your device, so reopening the app takes you straight back to your dashboard without asking you to log in again — until you explicitly sign out, at which point your saved login is cleared and you're returned to the Welcome screen.

---

## Personal Expense Tracking

### Dashboard

When you open the app you land on a Home screen that greets you by first name ("Good morning," / "Good afternoon," / "Good evening,") based on the time of day, with your initials shown in a tappable avatar circle (tapping it opens your profile/settings).

- **Total balance card** — shows your combined balance across every account you've added, plus your all-time total income and total expenses (with up/down arrows).
- **Monthly budget card** — shows a progress bar of how much of this month's budget you've spent so far ("₹X / ₹Y"). The bar turns from the normal accent color to a warning red once you've used more than 90% of your budget. If you haven't set a budget yet, it shows a "Set a budget to track spending" prompt that takes you to the budget screen.
- **Recent transactions** — the 3 most recent transactions are listed, with a "No transactions yet." message when your history is empty, and a "See all transactions →" link that jumps to the full transaction list.
- **Quick stats** — two small cards: "Top spend" (your single largest expense, with its note and amount) and "This week" (total spent since Monday of the current week).
- **Pull to refresh** — swipe down on the dashboard to re-fetch your latest transactions, accounts, and budget from the server.

### Transactions

**Adding a transaction:** Tap the "+" button (floating in the middle of the bottom navigation bar) to open the Add Transaction sheet:
- Choose **Expense** or **Income** with a segmented toggle at the top.
- Enter an **amount** in a large, prominent numeric field.
- Pick a **category** from chips that update automatically based on whether you chose Expense or Income (categories marked "Both" show up for either).
- Pick which **account** the money moves in/out of, from a chip list of your accounts.
- Pick a **date** (defaults to today; you can go back to 2020 but not into the future).
- Optionally add a **note** (e.g. "Groceries at D-Mart").
- Tapping Save validates that you entered a positive amount and selected an account — if not, the field is outlined in red and a message pops up. If you're offline, saving is blocked with an "You are currently offline. Operations are disabled." message.

**Editing a transaction:** From a transaction's detail screen, tap "Edit transaction" to open an edit sheet where you can change the type (Expense / Income / **Withdrawal** — a third type only available here), amount, note, date, account, and category (with a "None" option for uncategorized).

**Deleting a transaction:** From the detail screen, tap "Delete" — you're asked to confirm ("This cannot be undone") before it's removed, with a success/failure message afterward.

**Viewing details:** Tapping any transaction opens a detail screen showing a large icon, the note as a headline, the amount (colored green for money in, red-ish for money out), and a summary line like "Groceries · Expense · Today." A details card lists the date, account, category, and note (or, for a transaction shared with a Circle, it instead shows how the amount was split between members). Edit/Delete buttons only appear if you're allowed to modify that transaction (you created it, or you own the Circle it belongs to).

**Browsing the full list:** The Transactions tab shows:
- A **search** toggle (magnifying glass icon) that lets you search transactions by note text.
- A **filter** icon that opens a sheet to filter by a specific date and/or a specific category, with "Clear All" and "Apply" buttons; the filter icon turns red while filters are active.
- A horizontally scrollable **month selector** showing every month that has transactions — tapping a month switches the list to that month and clears the date filter.
- A **summary card** showing total income and total expense for whatever's currently filtered/visible.
- The list itself is grouped under date headers ("Today," "Yesterday," or a date), always sorted newest-first, with an empty state message ("No transactions found.") when nothing matches.

### Accounts

Accounts represent where your money lives — a bank account or cash. From Settings you can open **Accounts** to see a list of every account with its icon, type label, and current balance, with an empty-state prompt if you have none yet.

**Adding an account:** Tap "Add Account," choose the account type (**Bank** or **Cash** — a Credit Card option exists in the code but is currently hidden/disabled), give it a name (e.g. "HDFC Salary," "Wallet"), and enter its current balance. Both name and balance are required before saving, and saving is blocked while offline.

Accounts you create show up as selectable chips whenever you add or edit a transaction, and the dashboard/reports total your balances across all of them.

### Categories

Categories classify what a transaction was for. From Settings you can open **Categories** to see all your categories (each with an icon, name, and type label); categories that have been deactivated show an "Inactive" badge.

**Adding a category:** Tap "Add Category," choose whether it applies to **Expense**, **Income**, or **Both**, and give it a name (required — a red error indicator appears if left blank). Newly created categories are currently all assigned the same default icon and green color automatically (there's no custom icon or color picker in this version). Once created, custom categories immediately become selectable when adding transactions of the matching type.

### Budgets

The app supports a single **monthly spending budget** (not a separate budget per category). You set one amount that applies to the whole month:
- If you're a brand-new user with no accounts, you're guided through adding an account and then prompted to set a budget (with a "Skip for now" option).
- You can also set or update it any time from the dashboard's budget card, or from Settings → Finance → "Monthly budget," which opens a quick dialog.
- Progress is tracked visually: the dashboard's budget bar fills up as you spend, and turns red-ish once you've used over 90% of it. There are no push notifications or alerts — it's a purely visual indicator.

### Reports

The Reports tab gives you a monthly financial overview, with left/right arrows to step to the previous or next month:
- **Top stats row** — Income, Expense, and Net for the selected month.
- **Monthly trend chart** — a simple bar chart comparing income vs. expense across recent periods, with the current month highlighted.
- **Spending breakdown** — a donut chart showing what percentage of your spending went to each category, plus a list underneath with amounts and percentages, and a "View all categories" link to a dedicated full breakdown screen (which also shows a running progress bar per category).
- **By account** — a table showing, per account, how much flowed in, how much flowed out, and the net for the month, with negative totals shown in red.
- The whole screen supports pull-to-refresh, and shows a "Retry" button if data fails to load or a "No data available" message if there's nothing for that period.

### Export

From Settings → Data → "Export data," you can export everything to a **CSV file**. The exported file contains two tables:
1. **Transactions** — date, type, category, account, note, and amount for every transaction.
2. **Account Summary** — each account's type, balance, total money in, total money out, and net, plus a grand-total row.

Once generated, the file is handed off to your device's native share sheet, so you can save it, email it, or send it to any app that accepts files. If you have no transactions yet, the app tells you "No transactions to export." instead of generating an empty file, and Settings shows a brief "Exporting…" state followed by a success or failure message.

### Settings

Reached via your profile avatar, the Settings/Profile screen includes:
- Your avatar, name, and email, with an "Edit profile" link (not yet wired up to anything).
- A quick stat showing how many accounts you have.
- **Preferences** — "Appearance," which opens a dialog to choose Light, Dark, or System-default theme.
- **Finance** — "Monthly budget" (view/edit dialog), "Accounts" (opens the accounts list), "Categories" (opens the categories list).
- **Data** — "Export data" (CSV, described above).
- **Support** — "Help & FAQ" (opens the FAQ screen) and "Rate Expense Lite" (placeholder, not yet linked to an app store).
- A **Log out** button at the very bottom that signs you out and returns you to the welcome screen.

### FAQ & Feedback

- **Help & FAQ screen** — a "Need more help?" banner with a "Contact Support" button that opens your email app pre-addressed to the support inbox, followed by six expandable questions covering: adding transactions, tracking multiple accounts, how reports are generated, creating custom categories, data security, and managing a budget.
- **Feedback screen** — headed "How can we improve?" You pick a feedback type (Bug Report, Suggestion, Feature Request, or Other) via chips, write a message in a text box (required — you're prompted if it's empty), and tap "Send Feedback." This opens your device's email app with the subject line pre-filled ("Expense Lite App – <Type>") and your message as the body, addressed to the support email. If no email app is available, you're shown the support address to email manually.

### Getting Started (Splash Screen)

When the app launches, a short (about 2-second) splash screen shows the app logo and the name "Expense Lite." Once that timer finishes and your login status is known, the app checks whether you're signed in and have any accounts set up — new users with no accounts are sent to the Add Account screen to get started, everyone else goes straight to their transactions, and signed-out users are sent to the welcome/sign-in flow.

---

## Shared Expenses & Circles (Group Expense Splitting)

The app lets you track expenses you share with other people — a trip, a household, a couple's budget, a friend group — inside a **Circle**. A Circle is a group of people who split costs together; the app keeps a running tally of who paid for what and who owes whom, similar to apps like Splitwise.

### Creating & Joining Circles

To start a new Circle, you tap **"Create a new circle"** (or the **+** button) on the Circles screen and fill in:

- **Circle name** (required — e.g. "Goa Trip 2026")
- **Description** (optional, free text)
- **Budget** (optional target amount for the circle)
- **Circle type** — Ongoing or One-Time (see below)
- **Include settlements in personal ledger** — a toggle that, when on, reflects money you pay/receive when settling up inside this circle in your own personal account balance. If you turn this on, you also pick which of your personal accounts those settlement payments should apply to.

The person who creates a circle becomes its **Owner** automatically.

**Adding members / invites:** From the Circle Details screen you tap **"Add member"**, which opens your phone's native share sheet with a pre-written invite message and a link (`https://.../invite?circleId=...`) that you can send via WhatsApp, SMS, email, etc. Whoever opens that link is taken into the app to join the circle. Members can also be assigned a **role** when added — Owner, Member, or Viewer — though the Member role is used by default.

### Circle Types

Every circle is one of two types, shown as a small colored badge on the circle card:

- **Ongoing** — for a recurring group of shared expenses with no defined end (e.g. a shared household or a couple's joint spending). The card shows what you paid and your current net balance (you're owed / you owe).
- **One-Time** — for a bounded event like a trip. In addition to what you paid and your net amount, the card shows a **settlement progress bar** (0–100%) indicating how much of the total group spend has been settled up so far.

(The app doesn't currently offer more specific sub-categories like "trip"/"home"/"couple" — those are just naming conventions you'd choose yourself; the underlying type is only Ongoing vs. One-Time.)

### Adding Shared Expenses

Tapping **"+ Add expense"** on a circle opens a form with:

- **Amount** (required)
- **Note / description** (optional, e.g. "Dinner at Fisherman's Wharf")
- **Paid by** — which member actually paid the bill (defaults to you)
- **Account** — which of your personal accounts the money came out of (required)
- **Category** (optional)
- **Split with** — a checklist of circle members to include in the split, with a Select All / Deselect All shortcut. You can leave someone out of a particular expense.
- **Split option** — Equal, Percentage, or Fixed (see below)

### Splitting Methods

Three ways to divide an expense among the selected members:

- **Equal** — the amount is divided evenly across everyone you've included in the split. No further input needed.
- **Percentage** — you type a percentage for each included member. The app requires these to add up to exactly 100% before it will let you submit (it shows the running total and blocks submission otherwise).
- **Fixed** — you type an exact rupee amount for each included member. The app requires these to add up to exactly the total expense amount before submitting.

Once submitted, the expense (and how it's split) is saved and the circle's balances, totals, and recent activity update immediately.

### Balances & Settling Up

Each circle tracks, per member, a running balance relative to you: a positive number means **they owe you**, a negative number means **you owe them**, and zero means you're settled up with that person. These per-member balances are shown on the member cards in Circle Details ("Owes ₹X to you" / "You owe ₹X to them" / "Settled up"), and a **Remind** button appears next to anyone who owes you money.

At the top of the Circles list, a summary banner totals this across *all* your circles: **"You are owed ₹X"** and **"You owe ₹Y."**

Inside a circle, the **Summary** card shows: total amount spent in the circle, how much of that has been settled, how much is still pending, and a progress bar visualizing settled vs. pending.

**Settling up:** tapping the **"Settle up"** button on a circle opens a sheet meant to let you pick a member and record a payment that clears (or reduces) the balance between the two of you — the app is built to support recording exactly who paid whom, how much, and an optional note, which then updates the balances above. In the current build, this particular screen is still a preview/placeholder (it shows sample names and a "mock" confirmation rather than your circle's real members and balances), so treat Settle Up as coming soon rather than fully live yet.

### Viewing Circle Details & All Transactions

The **Circle Details** screen shows, top to bottom: the summary card described above, the full member list (with each person's role badge and balance), and a **Recent Activity** list of the latest expenses (who paid, what for, when, how much). Tapping **"View all"** takes you to the **All Transactions** screen for that circle, which lists every expense grouped by date (Today, Yesterday, or the specific date), each showing who paid and the amount — tap any entry to see its full detail, including exactly how it was split between members. You can also add a new expense directly from this screen.

### Circle Settings & Management

Tapping the gear icon on Circle Details opens **Circle Settings**, which shows the circle's name/type and its full member list. What you can do here depends on your role:

- **Anyone (non-owner):** can **Leave Circle**.
- **Owner only:**
  - **Remove a member** — a delete icon appears next to any non-owner, non-you member in the list.
  - **Transfer Ownership** — pick another member to hand the Owner role to; you'll be asked to confirm, and once transferred you become a regular member of the circle while they become the new Owner.
  - **Delete Circle** — permanently deletes the circle. This is blocked if any member still has an outstanding balance with another, so all debts must be settled first.

### Notifications

The app defines several types of circle-related notifications that can be shown to keep members in the loop: being **invited** to a circle, a **member being removed**, a **new expense being added**, a **settlement being recorded**, **ownership being transferred**, and a **circle becoming fully settled**. Each notification links back to the relevant circle, expense, or split so tapping it can take you straight to the right screen. (See [Under the Hood](#under-the-hood-cloud-sync-notifications--app-experience) for the current status of this feature.)

---

## Under the Hood: Cloud Sync, Notifications & App Experience

### Cloud Sync & Multi-Device Access

Expense Lite stores your data in the cloud, not just on your phone. Every transaction, account, category, budget, and shared Circle is saved to a secure cloud database. This means:

- If you get a new phone or reinstall the app, signing back in restores your data.
- Money you add, edit, or delete syncs through the cloud, which is also what makes shared Circles possible — other members see the same shared expenses because everyone reads from the same cloud record.
- Sign-in is required to use the app: you create an account with email/password, or sign in with Google.

### Working Offline

The app currently needs an internet connection to function — adding transactions, viewing accounts, loading circles, and running reports all depend on live requests to the cloud. There's no local offline database that lets you keep working with no signal.

What the app does give you: a visible "No internet connection" banner appears at the top of the screen automatically whenever your device loses connectivity, so you always know why something isn't loading or saving, rather than being left to guess. As soon as the connection comes back, the banner disappears and the app resumes talking to the cloud.

### Light & Dark Mode

The app supports both a light and a dark look. By default it follows your phone's system setting (switches automatically with your device's day/night mode), and your choice is remembered on the device for next time. You can also set it explicitly from Settings → Preferences → Appearance (Light / Dark / System default).

### Navigation

The app is organized around five main areas reachable from the bottom of the screen:

- **Home** — your dashboard/overview.
- **Transactions** — full list of your income and expenses.
- **Add (center button)** — quick-add a new transaction from anywhere.
- **Circles** — shared expense groups with friends, family, or roommates.
- **Reports** — spending breakdowns and summaries.

### In-App Alerts & Notifications

The app shows small pop-up confirmation banners (snackbars) at the bottom of the screen to tell you when something succeeded (shown in green) or failed (shown in red) — for example, confirming an action worked or explaining why it didn't. These are lightweight, in-the-moment alerts, not something you review later.

There is also groundwork in the app's data model for a proper notifications inbox — things like "someone invited you to a Circle," "a member was removed," "a new transaction was added to a shared Circle," "a settlement was completed," "ownership of a Circle was transferred," or "a Circle was fully settled." However, this is not yet a working feature: there is no notifications screen, no bell icon, and nothing currently fetches or displays these alerts to the user. It exists as unfinished groundwork only.

Separately, the app does **not** currently send push or system notifications (the kind that appear outside the app, e.g. on your lock screen). That capability exists in the codebase but is fully disabled, so no reminders or push alerts will reach you today.

### Invite Links

Circles (shared expense groups) support invite links. From within a Circle, you can generate a shareable link and send it via any app on your phone (text message, WhatsApp, email, etc.) using your phone's normal share sheet. Anyone who opens the link is directed to join that specific Circle, making it easy to add roommates, partners, or friends to a shared expense group without manually searching for them.

### Reliability & Crash Reporting

The app can automatically report crashes and unexpected errors to help the developers find and fix problems and improve stability over time. This happens quietly in the background and does not require any action from you.

---

## Feature Roadmap: Spec vs. Current Build

This section tracks the current build against the internal product spec ("Finance Tracker Document") — what's done, what's partial, and what's still missing. Update this checklist as gaps get closed.

### A. Core entities and flows

| Requirement | Status |
|---|---|
| Personal profile / default "My Wallet" space for solo tracking | ✅ Implemented |
| Groups: create "Family"/"Flatmates"/"Trip", invite via link/WhatsApp, start logging shared expenses immediately **without full sign-up** | ⚠️ Partial — Circles + invite links exist, but the app requires full sign-in (email/password or Google) to use at all. The spec's frictionless, no-account join isn't there. |
| Simple "Personal ↔ Groups" switcher (workspace-style toggle) | ⚠️ Partial — a separate "Circles" tab in the bottom nav stands in for this instead of a single toggle |

### B. Personal expense tracking

| Requirement | Status |
|---|---|
| Quick add expense/income (amount, category, date, notes) | ✅ Implemented |
| Pre-configured categories with icons + custom categories | ✅ Implemented (custom categories all get the same default icon/color — no picker yet) |
| **Per-category monthly budgets** (e.g. Food ₹10,000, Transport ₹3,000) | ❌ Missing — only a single global monthly budget exists |
| Simple global monthly budget with progress bar | ✅ Implemented |
| Personal insights: daily/weekly/monthly overview, top categories, trend charts | ✅ Implemented (Reports screen) |

### C. Family/friends sharing

| Requirement | Status |
|---|---|
| Group creation in 2–3 taps, invite via link/WhatsApp/SMS | ✅ Implemented |
| **Shared group budget** with everyone seeing utilization/remaining | ⚠️ Partial — circles have an optional "Budget" field at creation, but no utilization/remaining-balance display against it |
| Expense entry: amount + category + payer + participants, equal split by default, custom split for advanced users | ✅ Implemented — exceeds spec (Equal / Percentage / Fixed, not just equal + custom) |
| Balances screen ("You owe ₹X / owed ₹Y"), simplified Splitwise-style settling | ⚠️ Partial — balances are implemented and accurate; **Settle Up itself is still mock/placeholder data**, not wired to real balances yet |
| Roles: Owner / Member / Viewer | ⚠️ Partial — roles exist in the data model, but only Owner has enforced special permissions; Viewer's read-only restriction isn't enforced |
| "Hide certain personal accounts from a group" | ❌ Missing |

### D. UX priorities

| Requirement | Status |
|---|---|
| Simple UI, one FAB "Add expense", bottom nav | ✅ Implemented |
| **Offline-friendly** (add expenses offline, sync later) | ❌ Missing — biggest gap. The app requires internet for every operation; a "no internet" banner blocks actions instead of allowing offline entry |
| India-friendly sharing: export settlement summaries as text/image for WhatsApp | ❌ Missing — a general CSV data export exists, but no settlement-specific text/image summary |
| UPI/WhatsApp as primary settlement communication channel | ❌ Missing — no UPI deep-linking; WhatsApp is only used generically via the OS share sheet for invite links |

### E. Differentiation

The "one app for personal + shared money, India-friendly, offline-capable" positioning is partially achieved: personal and shared (Circles) flows both exist and are reasonably built out, but the two things that make it *India-friendly and offline-capable* per the spec — offline support and WhatsApp/UPI-native settlement sharing — are the biggest remaining gaps.

### Remaining work, in priority order

1. **Offline support** — the app is fully online-only today
2. **Per-category budgets** — only a single global monthly budget exists
3. **Frictionless group join without full account creation**
4. **Settle Up flow** — currently mock data, not functional
5. **Settlement summary export as text/image for WhatsApp**
6. **UPI-linked settlement/payment flow**
7. **Group budget utilization display** (the budget field exists but isn't visibly tracked)
8. **Viewer role enforcement** and **hide-personal-account-from-group** option
9. Minor: unified Personal/Groups switcher UX (currently separate nav tabs — cosmetic, not functional)

Everything else in the spec (quick-add, categories, personal insights/reports, group creation + invites, expense splitting with 3 methods, per-member balances) is implemented, and a few things (3 split methods instead of 2, crash reporting, CSV export, Google sign-in) go beyond what the spec asked for.

---

## Getting Started (for developers)

```bash
flutter pub get                     # install dependencies
flutter run                         # run on a connected device/emulator
flutter build apk --release         # build a release APK
flutter build appbundle --release   # build a Play Store bundle
flutter analyze                     # static analysis
flutter test                        # run the test suite
```

This is a Flutter project. If you're new to Flutter, see the [official docs](https://docs.flutter.dev/) for setup and tutorials.
