# HANDOFF — Kitsune one-shot combo macro

Context transfer for a fresh session. Read this fully before touching anything.

## Goal

Blox Fruits. A **Kitsune** combo that one-shots (or near enough) anyone caught
in it, driven by an AutoHotkey macro: user hovers a target in range, presses one
button, target dies.

Requirements from the user:
- **Fruit + fighting style only** if possible (no sword, no gun stats). A
  sword/gun build is acceptable only if nothing else works.
- Must state **stat distribution** (3 stats capped at 2800 each) and full build
  (accessories, loadout).
- **Human V4/V3 boosts allowed**, but the combo must one-shot *without* them.
- **Ideally inescapable** — can't be kentricked once caught. A technically
  kentrickable combo with a practically impossible reaction window is fine.
- Macros are allowed by the Blox Fruits devs. Only exploits that dig into game
  code are banned. So: **OS-level keystroke automation only.** No memory
  reading, no injection, no reading game state.

## Repo state

Branch: `claude/kitsune-oneshot-combo-xk3glg`

- `README.md` — build, moveset tables, combo, Instinct audit, alternatives
- `macro/KitsuneOneshotCombo.ahk` — AutoHotkey v2 macro
- `HANDOFF.md` — this file

## CRITICAL — sourcing, in priority order

### 1. PATCH NOTES ARE THE SOURCE OF TRUTH

`Updates/<version>` pages. **The per-ability pages and Instinct charts are STALE
— they are not updated after nerfs.** Every Instinct-break error in this project
traces to reading an ability page instead of the patch notes.

**Latest update is 31.4.** Verified: `Updates/31.5`, `31.6`, `32`, `32.1` all
return `missingtitle`.

### 2. Fandom HTML 403s, but the MediaWiki API works via curl

```bash
curl -sS -L --max-time 60 -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/125.0" \
  "https://blox-fruits.fandom.com/api.php?action=parse&page=Updates%2F31.4&prop=wikitext&format=json"
```

Search the wiki for which update changed something:

```bash
curl -sS -L -A "Mozilla/5.0 Chrome/125.0" \
  "https://blox-fruits.fandom.com/api.php?action=query&list=search&srsearch=instinct+break+rework&srlimit=15&format=json"
```

URL-encode slashes as `%2F`. Pages pulled so far: `Kitsune`, `Kitsune/Combos`,
`Godhuman`, `Godhuman/Combos`, `Sanguine Art`, `Sanguine Art/Combos`,
`Instinct`, `Instinct/Break`, `Updates/31.4`.

### 3. For Kitsune specifics, use the Kitsune page — not related pages

User instruction. `Instinct/Break` in particular is wrong about Kitsune.

### 4. Plugins are NOT loaded in-session — and the repo-config route is a DEAD END

`.claude/settings.json` on this branch declares:

```json
{
  "enabledPlugins": {
    "brightdata-plugin@knowledge-work-plugins": true,
    "tinyfish@knowledge-work-plugins": true,
    "browser-use@knowledge-work-plugins": true
  }
}
```

**Tried this in a fresh cloud session on this branch. It did not work** —
`ListPlugins` still came back empty. Root cause: `@marketplace-name` in
`enabledPlugins` is a *lookup*, not a declaration. `knowledge-work-plugins` is
an account-level plugin catalog (visible via the `SearchPlugins` tool), not a
git-sourced marketplace. A repo can only auto-register a marketplace via
`extraKnownMarketplaces` pointing at a real git repo URL — there's no way to
point that at an account-level catalog. So `enabledPlugins` referencing
`@knowledge-work-plugins` resolves to nothing in a session that doesn't already
have that marketplace registered, and cloud sessions don't show the trust
dialog that would otherwise register it.

**Do not repeat the repo-config approach — it's a confirmed dead end.**

**The actual fix**: enable `brightdata-plugin`, `tinyfish`, and `browser-use`
directly on the claude.ai account itself (account-level plugin/catalog
settings — not this repo), so they load as *synced plugins* automatically in
any future cloud session. This requires the account holder to do it outside
of this repo/session; it is not something achievable via a file committed
here. Once enabled there, a fresh session started afterward should show them
in `ListPlugins`/`ListAgents` without any repo changes.

If a future session still shows no plugins after that: check whether the
session started before or after the account-level enable (plugins install at
session start only, same caveat as everything else here), then confirm via
`ListPlugins` with no `keywords` arg on a definitely-fresh session before
concluding the account-level enable didn't take.

## UPDATE 31.4 PATCH NOTES — verbatim, current

**Kitsune was nerfed:**
- **[Z] No longer breaks Instinct; now Instinct-trickable.**
- **[X] Now channels on hit; the user cannot cast another ability before the
  animation completes.** ← hard macro constraint: X blocks your next input.
- **[C] End-lag increased by 0.3 seconds.**

**Sanguine Art was nerfed:**
- [C] Range decreased by 15%; hitbox size decreased by 10%.

**Sharkman Karate was buffed:**
- [X] No longer launches the opponent into the air; orb speed +25%.
- **[C] Now grants temporary health based on damage absorbed. No longer
  Instinct-trickable; the hold can no longer be cancelled by incoming damage;
  damage reduction while holding increased; maximum hold time is now 1.5s.**

**Death Step was buffed** (substantially — worth evaluating as the style):
- [Z] Range +50%; hitbox +50%.
- [X] Range +20%; hitbox +20%.
- [C] DoT +20%; end-lag 0.25s -> 0.1s; hitbox +15%.
- [V] Cooldown -50%; duration -50%.

**Empyrean Kitsune was nerfed** — a separate form/entity not yet investigated:
- [Z] (Tapped) No longer breaks Instinct. [Z] (Held) Damage -30%.
- [X] Now channels on hit. [C] End-lag +0.3s.

Other Instinct changes in 31.4 showing how volatile this is: Ice V2 [X] and
Dark V2 [X] *now* break Instinct; Diamond [TAP] and Yama [X] *no longer* do;
Werewolf/Blazing [F] can now be dodged with Instinct.

## READ THIS BEFORE ASSERTING ANYTHING

This task went badly wrong several times in one specific way: **treating
reachable sources as correct sources, and reasoning confidently from them.**
The user plays this game; the assistant does not. Errors made, in order:

1. **Cited a search-engine AI summary as if it were a guide.** It had blended
   Electric Claw's moveset into a Kitsune article. Could not later produce a URL
   for it because the summary had no per-sentence citations.
2. **Claimed Godhuman Z had "a built-in stun" and used it as the opener.** The
   user pointed out a lone aimed skillshot against a moving target is trivially
   dodged/kentricked, so the whole combo collapses at step one.
3. **Proposed M1s as the opener instead.** M1 range is tiny and also dodgeable.
4. **Built an entire combo around "F = dash-grab that breaks Instinct"** from a
   scraped table. Also missed that transforming disables fighting styles, and
   missed the Tails meter economy entirely.
5. **Wrote "both of us were slightly off"** to soften error #4 when the user had
   in fact been correct. Called out, correctly, as face-saving.
6. **Then over-corrected**: accepted the user's correction wholesale without
   checking, then later "re-corrected" them using wiki text about F "grabbing" —
   reversing a correct correction from the person who actually plays the game.
7. **Misread wiki flavour text as mechanics.** The wiki says Godhuman C-held
   "seizes" the target and describes Kitsune F as grabbing. **The user clarified
   this is metaphorical — descriptive language for connecting with an enemy, not
   a mechanical grab-lock. Nothing in this build disables target inputs.**

**The pattern to avoid: do not resolve a conflict between the user and a source
by siding with the source, and do not resolve it by silently siding with the
user either. Say what each says, and ask.** Do not present "the source I could
reach" as "the source that is correct."

## Verified data (Blox Fruits Wiki, via API)

### Kitsune untransformed — cooldown / energy / tails

| Key | Move | Mastery | CD | Energy | Tails |
|---|---|---|---|---|---|
| TAP | Normal Attack | — | 0.5s | — | 7.5% |
| Z | Accursed Enchantment | 1 | 9s | 20 | 10% |
| X | Tails of Burning Agony | 50 | 12s | 40 | 12.5% |
| C | Fox Fire Disruption | 100 | 15s | 80 | 15% |
| F | Wild Assault | 200 | 9s | 60 | 10% |
| V | Transformation | 300 | 3s | 20 | 30% |

Transformed CDs are shorter (Z 6.75s, X 9s, C 11.25s, V 2s, F 6.75s); tails
costs are higher (Z 15%, X 20%, C 25%, F 15%).

### Kitsune Instinct chart (untransformed) — DO NOT TRUST, kept only as a
record of what the wiki page says (it is stale, see Update 31.4 above)

- Passive / 3 Tails, TAP, X, V — chart claims below; not re-verified
- **Z — chart says "cannot break Instinct in any way."** This one happens to be
  right per 31.4 patch notes, but only by accident of timing (31.4 nerfed it TO
  this state — before 31.4 the chart would have been wrong).
- **C — chart says initial hit + flames break Instinct.** Matches user
  confirmation. This is the one move in this table actually trustworthy.
- **F — chart says "only breaks Instinct if grabbed."** User says no ("I really
  don't think it does"). **Go with the user, not the chart.**

**Use the USER-CONFIRMED table further down instead of this one.** This section
exists so a future session doesn't re-derive the chart from scratch and
mistake it for a source, not because it's usable as-is.

Other verified (moveset text, not the Instinct chart — these have held up):
X **stuns ~0.65s** (pre-31.4 combo behavior; 31.4 made X channel on hit, see
above — combo use of X is now blocked regardless). M1 at 3 tails applies 4–5s
burn DoT, up to ~10k damage with a damage accessory. V grants 1s immunity to
basic damage while transforming, and **disables fighting styles, swords and
guns**.

### Godhuman

| Key | Move | Mastery | CD | Energy |
|---|---|---|---|---|
| Z | Soaring Beast | 125 | 8s | 25 |
| X | Heaven and Earth | 250 | 11s | 35 |
| C | Sixth Realm Gun | 350 | 17s | 75 |

- **Z** — dash toward cursor, punch flurry, knockback. **Invulnerable during.**
  Breaks Instinct **only at point blank**. Follows targets who Flash Step away
  if already hit.
- **X** — tap: gust, launches target upward. Hold 4s: clap shockwave, scales
  with hold, hits above and below. **Both variants break Instinct**; tap can be
  dodged if the blast is near the player and misses the body.
- **C** — tap: fast dash-punch + knockback. Hold: much higher speed and range,
  invulnerable. Instinct chart: **"Only tap version can be dodged."**

## Current combo (updated 2026-09-02, per user request)

```
Kitsune [C] -> Sanguine [C] -> Sanguine [Z] -> Kitsune [X] -> Sanguine [X]
```

Superseded the old `Kitsune[C]->Kitsune[F]->Sanguine[C]->Sanguine[Z]->Sanguine[X]`
combo. This version puts Kitsune [X] back in (previously excluded as
"unusable mid-combo" because 31.4 made it channel on hit — that was an
overstatement; it's usable, it just needs the delay after it to cover the
full channel or the next move gets silently dropped).

**Only Kitsune [C] breaks Instinct — user-confirmed, overrides wiki claims
that Sanguine C/Z also break it.** Holds via that one break plus two confirmed
input-locks: Sanguine C's 1.2s disable and Kitsune X's stun-then-channel. See
README's "The combo" section for the full breakdown.

## THE CORE MECHANIC (verified — do not re-derive)

- **Ken-tricking** = the target pressing **[E]** to activate Instinct mid-combo
  to phase out of damage. `Instinct` page, verbatim: *"Activating Instinct during
  a move to avoid additional damage or combos is known as 'Instinct-Tricking' or
  more commonly known as 'Ken-Tricking'."*
- **It has NOTHING to do with dashing.** An earlier revision claimed Sanguine
  [C]'s dash-disable made the combo unkentrickable. Invented connection.
- **Instinct Break** *"instantly sends the players out of the Instinct state"*
  (`Instinct/Break`). It **requires a real hit** — *"only works if an AoE move's
  hitbox covers"* the target.
- Dodges: up to 8 (11 w/ Pale Scarf, Kitsune Mask, Human V2), 1 charge per hit
  vs players, ~50s recharge each. Out-draining is not viable.

### Instinct-break status — USER-CONFIRMED, overrides all wiki pages

| Move | Breaks Instinct? | Source |
|---|---|---|
| Kitsune [C] | **YES** — the only confirmed break in this build | user |
| Kitsune [Z] | **NO** | user + Updates/31.4 nerf |
| Kitsune [X] | **NO** — drains only | Kitsune page |
| Kitsune [F] | **NO** (user: "I really don't think it does") | user |
| Sanguine [C] | **NO** | user |
| Sanguine [Z] | **NO** — user confirmed 2026-09-02, overrides wiki's "breaks on direct hit" claim | user |
| Sanguine [X] | Unconfirmed — assume NO | — |

**Do not "correct" these from a wiki page. The wiki pages are what got them
wrong in the first place.** If a patch note contradicts one, raise it with the
user rather than silently changing it.

### OPEN: which fighting style actually breaks Instinct?

This is the blocking question for a genuinely unkentrickable combo. Kitsune
supplies exactly one break ([C]), which is not enough for a no-gap chain.
Sanguine does not supply one. Candidates not yet checked against patch notes:
**Death Step** (heavily buffed in 31.4), **Sharkman Karate** ([C] is "no longer
Instinct-trickable"), **Godhuman**, **Dragon Talon**, **Electric Claw**.

## Build

Melee 2800 / Fruit 2800 / Defense 2800. Sword 0, Gun 0.
Energy for the combo ~305 (Kitsune C 80 + F 60, Sanguine C 75 + Z 20 + X 30).
Race: Human V4/V3. Cyborg V3 recommended by several wiki combo entries.
Accessories: Dino Hood / Pilot Helmet. **Note Pale Scarf and Kitsune Mask raise
an opponent's dodge count to 11** — relevant to what you're fighting, not what you wear.
Mastery: user said to ignore mastery requirements for now.

## Cross-verification done 2026-09-02

User asked to "use the browser and the plugins and multiverify." Did:

1. Wiki API pulls (as before) for Sanguine Art and Kitsune full moveset text.
2. Web search surfaced a claim of a newer "Balance Patch 001" (Aug 6 2026),
   which would have superseded 31.4 as "latest" if real. Traced it to the
   actual developer source: `gamerrobot.com/blogs/news/the-balance-log`
   (Gamer Robot Inc's own Shopify blog — the real Blox Fruits dev). **User
   confirmed this is legit.** Patch content lives in an inline JS object
   (`#bf-patch-notes` mount), extracted via `javascript_tool` since the page
   renders it client-side and static fetches only grab a stub.
3. Result: Balance Patch 001's Kitsune and Sanguine Art entries match Update
   31.4 **word-for-word**. No new info for this build beyond what 31.4 already
   gave. Confirmed one new detail useful for future fights: Instinct dodge
   regen 40s -> 30s, and a Sanguine movement exploit ("Tab Boost") was patched
   (this build never used it).
4. Found a stronger Instinct-break candidate not yet integrated: **Sharkman
   Karate [C]** ("breaks Instinct no matter what") and **[X] held** (same
   claim) — see README "Sourcing note" section. Not user-confirmed, not
   swapped in, just flagged for later.

Net effect: confidence in 31.4 as current-and-only-relevant patch data went
up (independently verified via the actual dev, not just the wiki mirror), no
existing claims changed.

## Macro notes

**The maintained macro is `macro/KitsuneOneshotCombo.ps1`** (native
PowerShell + Win32 SendInput with scan codes). The `.ahk` is a superseded
reference only. `macro/combo-log.txt` collects every run's keypress log.

Hotbar: 1 style, 2 Kitsune, 3 Yama (`$slotFightStyle` / `$slotFruit` /
`$slotSword`).

Hotkeys (2026-09-04): F1 Godhuman combo, F2 Sanguine combo, F3 Sanguine alt
(all Yama combos, step lists `$Combo_*` run by `Run-Steps`); F4 old full combo
(combo v2, `Run-Combo2`); F5 old opening-only (combo v1, `Run-Combo`); F6
timing recorder; F7 swap test. `$Combo_EClaw` saved but unbound per user
("ignore eclaw but save it"). Esc/Tab abort.

- New combos spam every ability (`$ycSpamDurationMs`/`$ycSpamIntervalMs`)
  because no timings are known; slot keys pressed once (toggle risk). They
  assume the STYLE is equipped at trigger time; old combos assume Kitsune.
- Godhuman C is HELD (`$ycHoldGodCMs`, retried within `$ycHoldWindowMs`) —
  held variant is the undodgeable one. Highest-priority F1 tuning value.
- Old combos: Kitsune C is a quick TAP (user-corrected 2026-09-02; the wiki
  "charges on hold" claim was wrong). Kitsune X channels on hit (31.4) so
  the move after it can be silently dropped.
- Trigger loop is a table (`$comboTriggers`) of hotkey -> scriptblock with
  down-edge detection and a re-entry lock.
- No mouse movement, no auto-targeting — user hovers the target manually.
  Explicit user requirement (2026-09-02).
- The `.ps1` was never syntax-checked in the Linux sandbox (no pwsh
  available). If it errors on launch, the 2026-09-04 additions are the first
  suspect: `Run-Steps`, `HoldSpam-Key`, `$comboTriggers`.
