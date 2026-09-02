# Blox Fruits — Kitsune One-Shot Combo Macro

Kitsune + **Sanguine Art**, fruit and fighting style only (no sword, no gun),
with an AutoHotkey v2 macro that runs the combo on a hotkey.

External keystroke macro — AutoHotkey sends OS-level key/mouse events. No memory
reading, no injection, nothing touching the Roblox process. That's the line
between "macro" (allowed) and "exploit" (banned).

**All data below is from the Blox Fruits Wiki**, pulled via its MediaWiki API
(`api.php` returns 200 even though the HTML pages 403):

- [`Kitsune`](https://blox-fruits.fandom.com/wiki/Kitsune)
- [`Kitsune/Combos`](https://blox-fruits.fandom.com/wiki/Kitsune/Combos)
- [`Sanguine Art`](https://blox-fruits.fandom.com/wiki/Sanguine_Art)
- [`Sanguine Art/Combos`](https://blox-fruits.fandom.com/wiki/Sanguine_Art/Combos)
- [`Godhuman`](https://blox-fruits.fandom.com/wiki/Godhuman) (previous build, kept for reference)

---

## The combo

```
Kitsune [C] -> [X]  ->  Sanguine [C] -> [Z] -> [X]  ->  Kitsune [Z] -> [F]
 breaks      ~0.65s      DASHES/FLASH   heals   burst     delayed     finisher
 Instinct    stun        STEP/MOVES     20% HP            flames
                         OFF ~1.2s
```

Wiki community combo (`Kitsune/Combos`): `Kitsune [C][X] + Sanguine Art [C][Z][X]
+ Kitsune [Z][F]` — *"Works for fruit mains only."*

**Timing inside the lock** (macro defaults): Sanguine C at 0ms, Z at 260ms,
X at 540ms — all three land with ~660ms of margin before the lock expires.

### Why this actually can't be kentricked

**Kentricking requires a dash.** Sanguine Art [C] "Devourer of Worlds":

> "The user grabs the enemy and pulls them in, and then summons five energy
> balls to spawn around the enemy and then attack them. **This skill can disable
> the enemy's Dashes, Flash Step, and moves for ~1.2 seconds.** If the enemy is
> stunned in midair, the stun duration is increased."

That is a hard input-disable, not descriptive flavour. For ~1.2 seconds the
target cannot dash, cannot Flash Step, and cannot use moves — so they cannot
kentrick out, by mechanic rather than by reaction time. **This is the single
most important move in the build.**

### Why Sanguine [C] is not the opener

The Instinct chart says the projectiles and the pull can both be dodged, so
firing it cold at a mobile target risks whiffing your only real lock.

Instead, **Kitsune [C] and [X] go first** to break Instinct and land the ~0.65s
stun. Sanguine [C] is then thrown into an already-stunned target, where it is
very hard to miss — and *that* is what buys the 1.2s no-dash window that the
rest of the combo dumps into.

**Hit them airborne if you can** — the wiki notes the stun lasts longer when the
target is stunned in midair.

### Why this ordering over the other wiki variant

There's a near-identical community entry ordered `Sanguine [C] + Kitsune [F] +
Sanguine [Z][X]`. It's worse for a macro: Kitsune F in the middle forces **two
hotbar swaps inside the lock window**, and at ~90ms each that spends ~180ms of
your 1.2s on menu inputs and pushes the finisher to the very edge of it.

Running all three Sanguine moves back-to-back needs **zero swaps inside the
lock**. Kitsune [Z][F] then land on the tail end, where F's Instinct break
covers the expiry.

### Instinct / lock audit

| Step | Effect |
|---|---|
| Kitsune [C] | **Breaks Instinct** (hit + flames). Dodgeable on the edge / during explosion |
| Kitsune [X] | **~0.65s stun.** No Instinct break, but drains a lot of it |
| Sanguine [C] | **Disables dashes, Flash Step and moves ~1.2s.** Breaks Instinct if aimed right |
| Sanguine [Z] | Grabs by the neck, **heals you 20% max HP even if they dodge with Instinct.** Breaks Instinct on direct hit |
| Sanguine [X] | Six claw slashes + scarlet burst. Bonus damage if drag *and* explosion both connect |
| Kitsune [Z] | Delayed circling flames. Never breaks Instinct |
| Kitsune [F] | Claw flurry finisher. Breaks Instinct on connect — covers the lock expiring |

Everything after Sanguine [C] lands inside or immediately after a window in
which the target's inputs are disabled.

---

## Moveset reference

### Kitsune — untransformed (cooldown / energy)

| Key | Move | Mastery | CD | Energy | Properties |
|---|---|---|---|---|---|
| TAP | Normal Attack | — | 0.5s | — | 5 slashes. **At 3 tails**: ticking burn 4–5s, +base damage. Up to ~10k with a damage accessory |
| Z | Accursed Enchantment | 1 | 9s | 20 | Hit: flames circle, then strike multiple times (**delayed damage**). Miss: weak AoE. **Never breaks Instinct** |
| X | Tails of Burning Agony | 50 | 12s | 40 | Zig-zag, **stuns ~0.65s**. No Instinct break but **drains a lot** |
| C | Fox Fire Disruption | 100 | 15s | 80 | **Charge on hold, fires on release.** **Breaks Instinct** (hit + flames) |
| F | Wild Assault | 200 | 9s | 60 | Dash → claw flurry on connect. Breaks Instinct only if it connects. **Initial hit dodgeable** |
| V | Transformation | 300 | 3s | 20 | Immune to basic damage 1s while transforming. **Disables fighting style / sword / gun** |

Tails cost per use: M1 7.5%, Z 10%, X 12.5%, C 15%, F 10%, V 30%.

### Sanguine Art

| Key | Move | Mastery | CD | Energy | Properties |
|---|---|---|---|---|---|
| TAP | Normal Attack | — | — | — | 4-hit string, very fast click speed, moderate range (4th hit longer) |
| Z | Bloodbane Drain | 125 | 8s | 20 | Dash to cursor, grabs by neck, bat creatures drain. **Heals 20% of your max HP even if they dodge with Instinct.** Breaks Instinct on direct hit; dodgeable on the sides |
| X | Scarlet Tear | 250 | 11s | 30 | Six claw slashes toward cursor, explode on solid surfaces. **More damage if drag + explosion both hit.** Aimed at ground = bounces distant enemies toward you |
| C | **Devourer of Worlds** | 350 | 18s | 75 | **Disables enemy Dashes, Flash Step and moves ~1.2s.** Grabs and pulls in, five energy balls. Longer stun if hit midair. Projectiles/pull can be dodged |

**Energy cost of the full combo: ~305.** Worth watching — this is a real
constraint alongside the Tails meter.

---

## Build

**Stats — 3 caps at 2800 each:**

- **Melee 2800** — Sanguine Art
- **Fruit 2800** — Kitsune
- **Defense 2800** — survive a dropped combo

**Sword 0 / Gun 0.** Neither is used.

**Mastery required:** Kitsune 200 (for F), **Sanguine Art 350 (for C)**. The
1.2s input-disable *is* the combo — without Sanguine C at 350 mastery, this is
just a damage string that can be kentricked like any other.

**Race:** Human V4 (V3 min). The wiki notes **Cyborg V3** is repeatedly
recommended in combo entries "to make combo unkentrickable" — if you have it,
it's the single biggest add-on. Not required.

**Accessories:** wiki combos recommend **Dino Hood** or **Pilot Helmet** (the
Pilot Helmet note is specifically about landing Kitsune C), plus damage/fruit
boosting modifiers. Arcanist III/IV trinkets with fruit/melee modifiers are
named in one build.

---

## Alternative combos (all wiki-sourced, all fruit+style only)

If you want options that don't need 350 Godhuman mastery:

| Combo | Wiki note |
|---|---|
| `Kitsune [Z][C][X][F] + Godhuman [Z][X][C]` | "oneshot ez combo" |
| `Kitsune [C][X][Z] + Godhuman [C] + Kitsune [F] + Godhuman [Z][X]` | "Works for fruit mains only" |
| `Kitsune [Z][F][X][C] + Sanguine Art [X][Z]` | "Pretty easy combo for fruit mains." Sanguine Art replaceable with Dragon Talon [Z] |
| `Kitsune [C][X] + Sanguine Art [C][Z][X] + Kitsune [Z][F]` | "Works for fruit mains only" |
| `Any stun + Kitsune [C][X] + Sanguine Art [C] + Kitsune [F] + Sanguine Art [Z][X]` | "Very easy, very good damage, very versatile" |

The Sanguine Art variants are worth noting — Sanguine Art appears in more
one-shot entries than Godhuman does, and one entry claims its combo "can
one-shot even buddha users."

---

## Honest caveats

- **Timings are not from the wiki.** Cooldowns, energy and the 1.2s lock are
  exact; the *inter-move delays* in the macro are estimates. No source publishes
  animation or recovery frames. Tune on a dummy.
- **The 1.2s window is the budget.** Everything after Sanguine [C] has to land
  inside it (or immediately after, covered by Kitsune's Instinct breaks). If
  your delays are too generous, the lock expires and they dash out.
- **Sanguine [C] can be dodged** — that's why it goes after Kitsune [C]/[X]
  rather than opening. If the stun setup whiffs, the lock whiffs.
- **Nothing here is a grab-lock except Sanguine [C].** Wiki wording like
  "grabs"/"seizes" elsewhere (Godhuman C, Kitsune F) is descriptive, not a
  mechanical input-disable.

---

## Files

- [`macro/KitsuneOneshotCombo.ahk`](macro/KitsuneOneshotCombo.ahk)

## Setup

1. Install [AutoHotkey v2](https://www.autohotkey.com/).
2. Edit `CONFIG` — move keys to match your binds, hotbar slots for Kitsune and
   Sanguine Art.
3. Run it (sits in tray).
4. In-game: hover the target in Kitsune C range, press `F1`. `Esc` aborts.
   Hit them **airborne** if you can — the wiki notes the lock lasts longer.

## Tuning priority

1. **`delayAfterSangC`** — the lock starts the moment C connects and runs ~1.2s.
   Everything after it is racing that clock. Tighten until moves stop whiffing.
2. **`chargeTimeKitC`** — Kitsune C fires on release.
3. **`delayAfterKitX`** — the ~0.65s stun is the window Sanguine C must land in.
4. **Slot swaps** — if a Sanguine move comes out as a Kitsune move, raise
   `slotSwapDelay`.

## Safety

- `Esc` aborts immediately; held keys are always released.
- Re-entry lock prevents overlapping runs.
- Keystrokes and clicks only. No pixel reading, no memory reading, no
  auto-targeting — you aim and judge range.
