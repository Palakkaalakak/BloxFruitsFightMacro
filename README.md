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
Kitsune [C]  ->  Sanguine [C]  ->  Sanguine [Z]  ->  Sanguine [X]  ->  Kitsune [F]
 BREAKS          lands because     heals 20% HP     burst            tail damage
 INSTINCT        they're broken;   even if dodged
                 disables dash/
                 Flash Step/moves
                 ~1.2s
```

Two anchors, and only two things are actually claimed:

1. **Kitsune [C] breaks Instinct.** It is the *only* confirmed Instinct break in
   this build. It goes first, so their Instinct is down for what follows.
2. **Sanguine [C] disables dashes, Flash Step and moves for ~1.2s.** It can be
   dodged on its own — but thrown at an Instinct-broken target it lands, and
   then nothing they press does anything for 1.2s.

Everything after Sanguine [C] is dumped into that window.

### What is NOT claimed

An earlier version of this file said "every link breaks Instinct, so there is no
gap to ken-trick in." **That was false.** Corrected:

| Move | Breaks Instinct? |
|---|---|
| Kitsune [C] | **Yes** — the one reliable break in this build |
| Kitsune [Z] | **No** — changed in a recent update |
| Kitsune [X] | **No** — drains Instinct only |
| Kitsune [F] | **No** (previously claimed yes, from a stale page) |
| Sanguine [C] | **No** (previously claimed yes) |
| Sanguine [Z] / [X] | Unconfirmed — assume no |

So this combo does **not** hold via a continuous chain of Instinct breaks. It
holds via **one** break that opens the door, and a **1.2s input-disable** that
keeps it open. That is a weaker and more honest claim than the one this file
used to make.

### Ken-tricking, correctly

Ken-tricking is the target pressing **[E]** to activate Instinct mid-combo and
phase out of damage. It has **nothing to do with dashing** — an earlier revision
claimed it did, which was invented.

Instinct breaking forces them out of that state. With only one break available,
the sequencing matters: **Kitsune [C] is spent up front**, before they have a
reason to panic-[E], and Sanguine [C]'s disable covers the stretch afterward
where you'd otherwise be exposed.

---

## Moveset reference

### Kitsune — untransformed (cooldown / energy)

| Key | Move | Mastery | CD | Energy | Properties |
|---|---|---|---|---|---|
| TAP | Normal Attack | — | 0.5s | — | 5 slashes. **At 3 tails**: ticking burn 4–5s, +base damage. Up to ~10k with a damage accessory |
| Z | Accursed Enchantment | 1 | 9s | 20 | Hit: flames circle, then strike multiple times (**delayed damage**). Miss: weak AoE. **Does not break Instinct** (changed in a recent update) |
| X | Tails of Burning Agony | 50 | 12s | 40 | Zig-zag, **stuns ~0.65s**. No Instinct break but **drains a lot** |
| C | Fox Fire Disruption | 100 | 15s | 80 | **Charge on hold, fires on release. BREAKS INSTINCT** — the only confirmed break in this build |
| F | Wild Assault | 200 | 9s | 60 | Dash → claw flurry on connect. **Does not break Instinct.** Initial hit dodgeable |
| V | Transformation | 300 | 3s | 20 | Immune to basic damage 1s while transforming. **Disables fighting style / sword / gun** |

Tails cost per use: M1 7.5%, Z 10%, X 12.5%, C 15%, F 10%, V 30%.

### Sanguine Art

| Key | Move | Mastery | CD | Energy | Properties |
|---|---|---|---|---|---|
| TAP | Normal Attack | — | — | — | 4-hit string, very fast click speed, moderate range (4th hit longer) |
| Z | Bloodbane Drain | 125 | 8s | 20 | Dash to cursor, bat creatures drain. **Heals 20% of your max HP even if they dodge with Instinct.** Dodgeable on the sides |
| X | Scarlet Tear | 250 | 11s | 30 | Six claw slashes toward cursor, explode on solid surfaces. **More damage if drag + explosion both hit.** Aimed at ground = bounces distant enemies toward you |
| C | **Devourer of Worlds** | 350 | 18s | 75 | **Disables enemy Dashes, Flash Step and moves ~1.2s.** Pulls in, five energy balls. Longer stun if hit midair. **Does not break Instinct.** Projectiles/pull can be dodged |

**Energy cost of the full combo: ~305** (Kitsune C 80 + F 60, Sanguine C 75 + Z 20 + X 30). Worth watching — this is a real
constraint alongside the Tails meter.

---

## Build

**Stats — 3 caps at 2800 each:**

- **Melee 2800** — Sanguine Art
- **Fruit 2800** — Kitsune
- **Defense 2800** — survive a dropped combo

**Sword 0 / Gun 0.** Neither is used.

**Mastery:** ignored per user instruction — assume everything is unlocked.

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

## Sourcing note — read before trusting anything here

The wiki's **Instinct charts and the `Instinct/Break` page are unreliable** —
they have been wrong three separate times in building this file (Kitsune Z,
Kitsune F, Sanguine C), in some cases because the game changed and the page
didn't. **Every Instinct claim in this document has been stripped back to what
was confirmed directly by the user.**

The **moveset descriptions** on each move's own page have held up, so cooldowns,
energy, damage behaviour and the 1.2s disable are taken from those.

For anything about Kitsune, use the **Kitsune page**, not `Instinct/Break` or
other related pages.

## Honest caveats

- **Timings are estimates.** Cooldowns, energy and the 1.2s disable are
  wiki-exact; inter-move delays are not. Tune on a dummy.
- **This combo is not proven unkentrickable.** It rests on one Instinct break
  plus a 1.2s input-disable. If they pop [E] before Kitsune [C] connects, or
  after the 1.2s expires, they can still phase out.
- **Sanguine [C] can be dodged**, which is why it goes second, into an
  Instinct-broken target — not first.

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
