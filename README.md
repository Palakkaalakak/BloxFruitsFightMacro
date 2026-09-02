# Blox Fruits — Kitsune One-Shot Combo Macro

Build notes + an AutoHotkey v2 macro for a Kitsune + Godhuman combo. This is an
**external keystroke macro** (AutoHotkey sends OS-level key/mouse events) — no
memory reading, no injection, no touching the Roblox process. That's the line
between "macro" (allowed) and "exploit" (banned).

Moveset below is from the Blox Fruits Wiki, supplied directly. Earlier revisions
of this file were built on scraped summaries that were wrong — see
[Corrections](#corrections).

---

## Kitsune moveset

### Human form (fighting styles / swords / guns usable)

| Key | Move | Mastery | Properties | Tails cost |
|---|---|---|---|---|
| M1 | Normal Attack | — | 5-slash string. 4th is a whirlwind; last is a ground slam (or air kick if airborne). **At 3 tails**: ticking damage + target covered in blue flames 4–5s + increased base damage | 7.5% (all 5) |
| Z | **Accursed Enchantment** | 1 | **If it hits**: flames circle the target *for some time*, then hit multiple times — **delayed damage**. If it misses: small weak AoE | 10% |
| X | **Tails of Burning Agony** | 50 | Zig-zag: corner, corner, then target. **Stuns ~0.65s** | 12.5% |
| C | **Fox Fire Disruption** | 100 | **Charge on hold, fires on release.** Huge explosion + ground flames. **Breaks Instinct.** Bonus damage on direct hit | 15% |
| F | **Wild Assault** | 200 | Dash forward; on hit, multi-slash claw flurry (TTK Wolf Fang Rush / Rengoku style). **No grab, no Instinct break** | 10% |
| V | **Transformation** | 300 | Transform. **Immune to all basic damage for 1s while transforming** | 30% |

### Transformed form (fighting styles / swords / guns **DISABLED**)

| Key | Move | Properties | Tails cost |
|---|---|---|---|
| M1 | Enhanced Slash | As 3-tail human M1 but larger AoE/hitbox/damage | 7.5% |
| Z | Accursed Enchantment | Three fireballs + dash. **If it hits**: hits 1–3 targets, **launches them backward**, fires a flame ball per target + ticking damage. If it misses: spin flurry AoE | 15% |
| X | **Tails of Burning Agony** | Zig-zag dash → **GRABS** → carries into air → **slams to ground**. **Breaks Instinct.** **Slams instantly if used airborne** | 20% |
| C | Fox Fire Disruption | Fireball, widespread damage, then flames dealing **extremely large DoT** | 25% |
| F | Wild Assault | Dash + tail swipe | 15% |
| V | Revert | Back to human form; **restores fighting style / sword / gun access** | — |

## Godhuman

| Key | Move | Properties |
|---|---|---|
| Z | **Soaring Beast** | Dash, punches all directions, final punch knocks back. Good range, **stuns**, has **i-frames** |
| X | **Heaven and Earth** | Tap: gust that **launches airborne**. Hold: charged AoE whirlwind. Used to wear off Instinct |
| C | **Sixth Realm Gun** | Tap: dash-punch + knockback. **Hold: breaks Instinct**, hits harder |

⚠️ Godhuman data is still from scraped sources and sources conflicted on its
Instinct-breaking (one said all three moves break it; another said only C-held,
and that Z/C-tap are "instinct-trickable"). Verify before trusting.

---

## Stat build — fruit + fighting style only

Max level caps **3 stats at 2800**:

- **Melee 2800** — Godhuman
- **Fruit 2800** — Kitsune damage + DoT scaling
- **Defense 2800** — survive a dropped combo

**Sword 0 / Gun 0.** Neither is used, and both are dead weight in transformed
form anyway since the fruit locks them out.

**Race:** Human V4 (V3 minimum) for passive damage/Haki. The combo is built to
kill without it.

**Accessories:** prioritise **% damage** and **stun duration**. Specific picks
rotate with events — check a current tier list.

---

## The combo

Two phases, because **transforming disables Godhuman**. All fighting-style
damage must land *before* V.

### Phase 1 — Human form

```
Godhuman [Z]      Soaring Beast    — dash opener, stuns, i-frames on entry
Kitsune  [Z]      Accursed Ench.   — flames circle, hit later (free delayed damage)
Godhuman [X] tap  Heaven and Earth — launches them airborne
Kitsune  [C] hold Fox Fire Disr.   — BREAKS INSTINCT, big explosion
Kitsune  [X]      Tails of B.Agony — ~0.65s stun, bridges into transform
Kitsune  [V]      Transformation   — 1s damage immunity covers the animation
```

### Phase 2 — Transformed

```
Kitsune [X]  Tails of B.Agony — GRAB → air carry → slam. BREAKS INSTINCT. Longest lock in the kit
Kitsune [C]  Fox Fire Disr.   — widespread hit + extremely large DoT. Finisher
```

### Why this order

- **Godhuman Z opens** because it's the longest-range engage that stuns and has
  i-frames — you're protected during the approach. It is still a dash that can
  miss (see caveat below).
- **Kitsune Z goes early on purpose.** Its flames circle before striking, so
  casting it at the start means that damage lands *during* the middle of the
  combo for free, stacked on top of everything else.
- **Godhuman X launches them airborne** — and airborne targets have far worse
  escape options. It also wears off Instinct going into C.
- **Kitsune C breaks Instinct** so ken can't phase them out of the back half.
- **Kitsune X's 0.65s stun** is the bridge that covers the V cast, and the 1s
  transform immunity means you can't be punished mid-transform.
- **Transformed X is the payoff** — a true grab that carries and slams and
  breaks Instinct. Nothing else in the kit locks a target that long.
- **Transformed C finishes** with the biggest DoT in the kit, landing while
  they're still recovering from the slam.

### Tails meter budget — read this

This is the real constraint, more than cooldowns:

```
Phase 1 spend:  Z 10% + C 15% + X 12.5%          = 37.5%
Transform:      V 30%                             = 30%
Phase 2 spend:  X 20% + C 25%                     = 45%
```

You cannot run the full sequence from a standing start on an empty meter. The
meter builds as you deal damage, and M1s at 3 tails feed it while draining
7.5% per full string. **Build tails before engaging** — the combo assumes you
enter the fight with meter banked, not at zero.

### Honest caveat on "inescapable"

The back half is genuinely hard to escape: Instinct is broken twice (C, then
transformed X), and the transformed grab is a true lock.

**The opener is the weak link and always will be.** Nothing in Kitsune's kit is
a guaranteed-hit entry — Z needs to connect for its good variant, F needs to
connect, X needs to connect. Godhuman Z is the best available engage, but a
moving target can still avoid a dash. "Inescapable once caught" is achievable
here; "unmissable entry" is not, and I'd rather say that than sell you a
combo that assumes step one always lands.

I also have **no frame data** for recovery windows — only X's ~0.65s stun. So
whether every link is frame-tight is unverified and needs dummy testing.

---

## Corrections

Logged so the bad versions don't resurface:

- **F is not a grab** in either form. An earlier revision built the entire combo
  around "F = dash-grab that breaks Instinct." That move does not exist. F is a
  dash + claw flurry (human) / tail swipe (transformed).
- **The grab is transformed X**, and it's the only grab in the kit.
- **Transforming disables fighting styles, swords and guns.** An earlier macro
  swapped hotbar slots to Godhuman *after* transforming, which cannot work.
- **Untransformed Z does not break Instinct.** Only untransformed C and
  transformed X do.
- Earlier revisions cited scraped tables (Gamersberg, search summaries) as
  "verified/cross-checked" when they disagreed with the wiki on move identity.

---

## Files

- [`macro/KitsuneOneshotCombo.ahk`](macro/KitsuneOneshotCombo.ahk)

## Setup

1. Install [AutoHotkey v2](https://www.autohotkey.com/).
2. Edit the `CONFIG` block — set move keys to **your** in-game binds and set
   your hotbar slot numbers for Kitsune and Godhuman.
3. Run the script (sits in tray).
4. In-game: bank some Tails meter, get in Godhuman Z range, hover the target,
   press the trigger (`F1` default). `Esc` aborts.

## Tuning

Delays are placeholders and drift with patch and ping. Test on a dummy. Priority
order for tuning:

1. **`chargeTimeC`** — Kitsune C fires *on release*. Too short and it fires
   underpowered; too long and the combo falls apart. Tune first.
2. **`delayAfterV`** — the transform animation must fully finish before
   transformed X registers, or you throw the grab into nothing.
3. **`delayAfterTransformedX`** — the grab carries them up and slams; C must not
   fire until the slam resolves.
4. Slot-swap delays — if a Godhuman move comes out as a Kitsune move, the swap
   didn't register in time. Raise `slotSwapDelay`.

## Safety

- `Esc` aborts immediately.
- Re-entry lock prevents stacked/overlapping sequences.
- Keystrokes and clicks only. No pixel reading, no memory reading, no
  auto-targeting — you aim and judge range yourself.
