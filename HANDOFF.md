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

## CRITICAL — how to get wiki data

Fandom **HTML pages return 403/402** to the fetcher. **The MediaWiki API works
via curl.** This is the unblock:

```bash
curl -sS -L --max-time 60 -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/125.0" \
  "https://blox-fruits.fandom.com/api.php?action=parse&page=Kitsune&prop=wikitext&format=json"
```

Pages already pulled: `Kitsune`, `Kitsune/Combos`, `Godhuman`, `Godhuman/Combos`.
URL-encode slashes as `%2F`.

**YouTube is still inaccessible** (JS-rendered; fetching returns only the page
footer). Bright Data / TinyFish plugins are installed on the account and would
fix this, but were not loaded into the original session.

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

### Kitsune Instinct chart (untransformed) — verbatim

- **Passive / 3 Tails** — requires full bar; auto-activates if grabbed by [TAP] or [F]
- **TAP** — cannot break Instinct in any way
- **Z** — both variants cannot break Instinct in any way
- **X** — doesn't break Instinct, but **drains a lot of it** when hit
- **C** — initial hit and flames break Instinct. Dodgeable during the explosion / on the edge of flames
- **F** — only breaks Instinct if grabbed. **Initial hit can be dodged**
- **V** — dodgeable on the edge while transforming; small explosion can break Instinct

Other verified: X **stuns ~0.65s**. M1 at 3 tails applies 4–5s burn DoT, up to
~10k damage with a damage accessory. V grants 1s immunity to basic damage while
transforming, and **disables fighting styles, swords and guns**.

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

## Current combo

```
Godhuman [C] HELD -> Kitsune [F] -> [X] -> [C] -> [Z] -> Godhuman [Z] -> [X]
```

Wiki community entry (`Kitsune/Combos`, by Rip chaitanya), fruit+style only,
with the **held** C variant specified as opener. Rationale for the opener is
now narrow and should stay narrow: **the Instinct chart says only the tap
version can be dodged.** Not "it grabs them."

No transformation — the wiki marks nearly every transformed combo *"works well
on NPCs, not for PvP"*, and V locks out the fighting style.

Full combo energy cost ~335.

## Build

Melee 2800 / Fruit 2800 / Defense 2800. Sword 0, Gun 0.
Mastery: Kitsune 200 (F), Godhuman 350 (C).
Race: Human V4/V3. Wiki entries repeatedly recommend **Cyborg V3** "to make
combo unkentrickable" — optional but the strongest add-on.
Accessories: Dino Hood or Pilot Helmet; damage/fruit modifiers.

## Alternative wiki combos (fruit + fighting style only)

- `Kitsune [Z][C][X][F] + Godhuman [Z][X][C]` — "oneshot ez combo"
- `Kitsune [C][X][Z] + Godhuman [C] + Kitsune [F] + Godhuman [Z][X]`
- `Kitsune [Z][F][X][C] + Sanguine Art [X][Z]` — Sanguine Art swappable for Dragon Talon [Z]
- `Kitsune [C][X] + Sanguine Art [C][Z][X] + Kitsune [Z][F]`
- `Any stun + Kitsune [C][X] + Sanguine Art [C] + Kitsune [F] + Sanguine Art [Z][X]`

**Sanguine Art appears in more one-shot entries than Godhuman.** One entry
claims its combo one-shots even Buddha users. Worth evaluating as the primary
fighting style rather than Godhuman — not yet investigated.

## OPEN QUESTIONS — ask the user, do not guess

1. **Is Godhuman C-held actually undodgeable in practice?** The whole opener
   rests on one Instinct-chart line. The user has play experience; the wiki has
   a line of text.
2. **Inter-move timings are unverified.** No source publishes animation or
   recovery frames. Only hard number: X's ~0.65s stun. Every delay in the macro
   is an estimate needing dummy testing.
3. **Should Sanguine Art replace Godhuman?** See above.
4. **Does the user actually have Godhuman 350 / Kitsune 200 mastery?** Never confirmed.

## Macro notes

AutoHotkey v2. Key mechanics:
- Z/X/C are shared between fruit and fighting style, so the macro **swaps hotbar
  slots** mid-combo (`slotFruit` / `slotFightStyle`).
- `Hold()` helper for keys needing hold-then-release: **Godhuman C (held variant
  is the undodgeable one)** and **Kitsune C (fires on release)**.
- `holdTimeGodC` is the highest-priority tuning value — if it registers as a tap
  instead of a hold, the opener becomes dodgeable and the combo's premise is gone.
- Re-entry lock prevents overlapping runs; `Esc` aborts and always releases held keys.
