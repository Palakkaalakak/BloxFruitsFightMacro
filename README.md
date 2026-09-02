# Blox Fruits — Kitsune One-Shot Combo Macro

Kitsune + Godhuman, **fruit and fighting style only** (no sword, no gun), with an
AutoHotkey v2 macro that runs the combo on a hotkey.

External keystroke macro — AutoHotkey sends OS-level key/mouse events. No memory
reading, no injection, nothing touching the Roblox process. That's the line
between "macro" (allowed) and "exploit" (banned).

**All data below is from the Blox Fruits Wiki**, pulled via its MediaWiki API
(`api.php` returns 200 even though the HTML pages 403):

- [`Kitsune`](https://blox-fruits.fandom.com/wiki/Kitsune)
- [`Kitsune/Combos`](https://blox-fruits.fandom.com/wiki/Kitsune/Combos)
- [`Godhuman`](https://blox-fruits.fandom.com/wiki/Godhuman)
- [`Godhuman/Combos`](https://blox-fruits.fandom.com/wiki/Godhuman/Combos)

---

## The combo

```
Godhuman [C] HELD  ->  Kitsune [F]  ->  [X]  ->  [C]  ->  [Z]  ->  Godhuman [Z]  ->  [X]
   can't be dodged      connects,      drains    breaks             breaks         breaks
   invulnerable         breaks         Instinct  Instinct           Instinct       Instinct
                        Instinct                                    (point blank)  (both variants)
```

This is the wiki's own community combo `Godhuman [C] + Kitsune [F][X][C][Z] +
Godhuman [Z][X]` ("veryyyy easy combo for beginners", by Rip chaitanya),
with the **held** variant of Godhuman C specified as the opener — see below for
why that specific detail matters more than anything else in the sequence.

**No transformation.** The wiki's transformed combo list is almost entirely
marked *"Works well on NPCs, not for PvP"*. Transforming also costs 30% of the
Tails meter and **disables fighting styles, swords and guns** outright. The PvP
one-shots are all untransformed.

### Why the opener is Godhuman [C] held

This is the part that actually delivers "inescapable," and it's a property of
the held variant specifically:

From the Instinct chart: **"Only tap version can be dodged."** The held version
cannot. The moveset also gives it "much higher speed and range than if it were
tapped," and the user is **invulnerable** during it.

That's the entry: a long-range, very fast dash that can't be dodged and can't be
punished. Every other candidate (Kitsune F, Kitsune X, Godhuman Z) is a dash
whose *initial hit can be dodged*.

**Note on wiki wording:** the wiki says C-held "seizes" the target and describes
Kitsune F as grabbing. **This is descriptive language for connecting with an
enemy, not a mechanical grab-lock** — it does not mean the target's inputs are
disabled. The case for this opener rests only on the Instinct chart's dodge
column, not on any hold/lock mechanic.

Godhuman [C] held is also the opener in several of the wiki's other one-shot
combos, including the Gravity Blade build and the Rocket/Skull Guitar build.

### Instinct audit of each link

| Step | Breaks Instinct? | Notes |
|---|---|---|
| Godhuman [C] held | Yes — **only tap can be dodged** | User invulnerable during it |
| Kitsune [F] | Only if it connects | **Initial hit can be dodged** |
| Kitsune [X] | No | *"drains a lot of it when hit"* |
| Kitsune [C] | Yes | Initial hit + flames. Dodgeable on the edge / during explosion |
| Kitsune [Z] | **No — neither variant, ever** | Pure damage |
| Godhuman [Z] | **Only at point blank** | You are point blank here |
| Godhuman [X] | Yes, both variants | Tap can be dodged if the blast misses the body |

F's initial hit is dodgeable on its own; it's used here only after C-held has
already committed them. X's lack of an Instinct break is covered by it draining
Instinct heavily instead.

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

### Godhuman

| Key | Move | Mastery | CD | Energy | Properties |
|---|---|---|---|---|---|
| Z | Soaring Beast | 125 | 8s | 25 | Dash toward cursor, flurry of punches, knockback. **Invulnerable during.** Breaks Instinct **only at point blank**. Follows targets who Flash Step away if already hit |
| X | Heaven and Earth | 250 | 11s | 35 | Tap: gust, **launches target upward**. Hold 4s: clap shockwave, scales with hold, hits above and below. **Both break Instinct** |
| C | Sixth Realm Gun | 350 | 17s | 75 | Tap: fast dash-punch + knockback. **Hold: much higher speed/range, invulnerable, cannot be dodged** |

**Energy cost of the full combo: ~335.** Worth watching — this is a real
constraint alongside the Tails meter.

---

## Build

**Stats — 3 caps at 2800 each:**

- **Melee 2800** — Godhuman
- **Fruit 2800** — Kitsune
- **Defense 2800** — survive a dropped combo

**Sword 0 / Gun 0.** Neither is used.

**Mastery required:** Kitsune 200 (for F), Godhuman 350 (for C). Godhuman C is
the opener, so 350 Godhuman mastery is non-negotiable for this combo.

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

- **Timings are not from the wiki.** Cooldowns and energy are exact; the
  *inter-move delays* in the macro are estimates. No source publishes animation
  or recovery frames. Tune on a dummy.
- **"Inescapable" means once C-held connects.** C-held itself can't be dodged
  and the chain after it is Instinct-covered, but you still have to land the
  opener — it's a fast long-range dash toward your cursor, not a homing move.
- **Nothing here locks the target's inputs.** No move in this build is a
  mechanical grab. The combo holds because of Instinct breaks and stun, not
  because the target is held in place.
- Several wiki combos hedge with "most players can't kentrick" rather than
  "can't be kentricked." Treat that as the realistic ceiling.

---

## Files

- [`macro/KitsuneOneshotCombo.ahk`](macro/KitsuneOneshotCombo.ahk)

## Setup

1. Install [AutoHotkey v2](https://www.autohotkey.com/).
2. Edit `CONFIG` — move keys to match your binds, hotbar slots for Kitsune and
   Godhuman.
3. Run it (sits in tray).
4. In-game: target in Godhuman C range, hover them, press `F1`. `Esc` aborts.

## Tuning priority

1. **`holdTimeGodC`** — must be long enough to register as *held*, not tapped.
   Tapped C is dodgeable; held is not. Get this wrong and the whole premise of
   the combo is gone. Tune first.
2. **`delayAfterGodC`** — the charged punch must resolve before F.
3. **`chargeTimeKitC`** — Kitsune C fires on release.
4. **Slot swap delays** — if a Godhuman move comes out as a Kitsune move, raise
   `slotSwapDelay`.

## Safety

- `Esc` aborts immediately; held keys are always released.
- Re-entry lock prevents overlapping runs.
- Keystrokes and clicks only. No pixel reading, no memory reading, no
  auto-targeting — you aim and judge range.
