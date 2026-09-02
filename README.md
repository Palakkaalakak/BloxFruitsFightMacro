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
Kitsune [C]  ->  Kitsune [F]  ->  Sanguine [C]  ->  Sanguine [Z]  ->  Sanguine [X]
 breaks          breaks on       breaks on        breaks on        breaks
 Instinct        first slash     grab             grab             Instinct
 (pull + flames)                 + disables       + heals 20% HP
                                 dash/moves 1.2s
```

**Every move in this chain breaks Instinct. There is no gap to ken-trick in.**

### What ken-tricking actually is

From the [`Instinct`](https://blox-fruits.fandom.com/wiki/Instinct) page:

> "Activating Instinct during a move to avoid additional damage or combos is
> known as 'Instinct-Tricking' or more commonly known as **'Ken-Tricking'**."

The Instinct toggle is **[E]**. So ken-tricking is the target hitting [E]
mid-combo to phase out of your damage. It has nothing to do with dashing.

From [`Instinct/Break`](https://blox-fruits.fandom.com/wiki/Instinct/Break):

> "Instinct breaking is the act of **forcing someone out of their Instinct
> state**... Instinct Breaking **instantly sends the players out of the Instinct
> state.** Instinct breaking is distinguished from wearing out Instinct dodges."

So the counter is direct: if the next move in your chain breaks Instinct, the
moment they hit [E] they're immediately knocked back out of it. **A combo with
no non-breaking links cannot be ken-tricked.** That — not stun, not dash
denial — is the actual design constraint.

Draining dodges is the slower alternative and not worth building around: players
have up to 8 dodges (11 with Pale Scarf / Kitsune Mask / Human V2), each hit
removes only 1 charge against players, and each recharges in ~50s.

### Why these five moves

`Instinct/Break` lists **Sanguine Art's entire moveset** as Instinct-breaking
(Z on grab, C on grab + the autotracking orb). For Kitsune it lists **Z, C, F**
untransformed — C at the initial pull and the flames after, F on the first slash.

**Kitsune [X] is deliberately excluded.** It does not break Instinct — the
Kitsune page only credits it with draining Instinct. As a mid-combo link it is
a free window for the target to hit [E] and escape. An earlier version of this
build had it at step two, which is exactly the hole this combo is supposed to
close.

**Kitsune [Z] is also excluded, because the wiki contradicts itself on it:**
`Instinct/Break` says "Z if casted directly or hit indirectly breaks Instinct";
the Kitsune page's own Instinct chart says "both variants cannot break Instinct
in any way." Unresolved — so it stays out of a combo whose whole premise is that
every link breaks.

### The 1.2s input-disable is a bonus, not the mechanism

Sanguine [C] also disables the target's Dashes, Flash Step and moves for ~1.2s.
That's real and useful — it stops them repositioning or retaliating — but it is
**not** what stops ken-tricking, and an earlier revision of this README wrongly
claimed it was. Instinct breaks are what stop ken-tricking.

### Why Sanguine [C] isn't the opener

Its projectiles and pull can both be dodged, so firing it cold at a mobile
target risks whiffing. Kitsune [C] and [F] go first to break Instinct and commit
them; [C] then lands into a target that's already caught.

**Hit them airborne if you can** — the wiki notes the stun lasts longer midair.

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

**Energy cost of the full combo: ~305** (Kitsune C 80 + F 60, Sanguine C 75 + Z 20 + X 30). Worth watching — this is a real
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

- **Timings are estimates.** Cooldowns, energy, the 1.2s disable and the
  Instinct-break table are wiki-exact; inter-move delays are not. No source
  publishes animation or recovery frames. Tune on a dummy.
- **Instinct break needs a real hit.** `Instinct/Break`: it "only works if an AoE
  move's hitbox covers" the target, and "if the opponent isn't hit directly,
  they will dodge the attack." A glancing hit doesn't break — so a sloppy link
  reopens the ken-trick window.
- **Sanguine [C] can be dodged**, which is why it isn't the opener.
- **The wiki contradicts itself on Kitsune [Z]** (see above). Excluded rather
  than guessed at.

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
