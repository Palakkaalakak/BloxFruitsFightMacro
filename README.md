# Blox Fruits — Kitsune One-Shot Combo Macro

Build notes + an AutoHotkey v2 macro that fires a Kitsune + Godhuman combo when
you hover a target in range and press a hotkey. This is an **external keystroke
macro** (AutoHotkey sends OS-level key/mouse events) — it does not read game
memory, inject code, or touch the Roblox client process, which is the line Blox
Fruits draws between "macro" (allowed) and "exploit" (banned).

## Kitsune moveset (verified)

Cross-checked across [Gamersberg](https://www.gamersberg.com/blox-fruits/wiki/fruits/kitsune),
[Pocket Tactics](https://www.pockettactics.com/blox-fruits/kitsune) and Fandom
search snippets. All three agree on move names and mastery tiers.

### Normal form

| Key | Move | Mastery | Properties |
|---|---|---|---|
| M1 | Normal Attack | — | 4-hit blue-flame slash string. At 3 tails, applies burn DoT + breaks Instinct. **Very short range.** |
| Z | **Accursed Enchantment** | 1 | **Auto-aimed** flames that surround and damage the target; leaves an AoE if it misses |
| X | **Tails of Burning Agony** | 50 | Zig-zag dash, **stuns on hit**, can strike multiple targets |
| C | **Fox Fire Disruption** | 100 | Sphere of blue flame, erupts on impact, **breaks Instinct** |
| F | **Wild Assault** | 200 | **Dash-grab** — zig-zag rush, grabs the enemy, carries them into the air, slams them down. **Breaks Instinct.** Instant slam if used airborne |
| V | Transformation | 300 | Fox-spirit form. **Requires 3 tails** to activate |

### Transformed form

| Key | Move | Properties |
|---|---|---|
| M1 | Enhanced Slash | Larger AoE, more damage |
| Z | Accursed Enchantment | Three fireballs, targets up to three enemies |
| X | Tails of Burning Agony | Zig-zag dash that **grabs and slams**; breaks Instinct |
| C | Fox Fire Disruption | Massive fireball + lingering burn — **Kitsune's single strongest damage move** |
| F | Wild Assault | Tail-based rapid-hit pressure/mobility |
| V | Revert | Back to normal form |

## Godhuman moveset (verified)

| Key | Move | Properties |
|---|---|---|
| Z | **Soaring Beast** | Dash forward, punches in all directions, final punch knocks back. Good range, **stuns**. Has i-frames |
| X | **Heaven and Earth** | Tap: gust that **launches the enemy into the air**. Hold: charged AoE whirlwind. Used to **wear off Instinct** |
| C | **Sixth Realm Gun** | Tap: dash-punch + knockback. **Hold: breaks Instinct** and hits much harder |

⚠️ **Sources conflict here.** One says all three Godhuman moves break Instinct;
another says Z and C-tap are "instinct-trickable" and only **C held** breaks it,
recommending X to wear Instinct off first. I'd trust the second (more specific,
and it matches how the community talks about instinct-baiting) — but test it.

## Stat build — fruit + fighting style only

Max level gives enough points to cap **3 stats at 2800 each**:

- **Melee 2800** — Godhuman damage
- **Fruit 2800** — Kitsune damage + DoT scaling
- **Defense 2800** — survive the trade if the combo drops

Sword and Gun stay at **0**. No sword or gun is used, so points there are wasted.

**Race:** Human V4 if you have it (V3 minimum) for the passive damage/Haki
boosts. The combo is built to kill without them; they're headroom.

**Accessories:** prioritise **% damage** and **stun-duration** modifiers. Named
accessory picks rotate with events, so check a current tier list rather than
trusting a name written here.

## The combo

```
Kitsune [F]  →  Kitsune [Z]  →  Godhuman [X]  →  Kitsune [X]  →  Kitsune [C]  →  [V]  →  transformed [C]
 Wild Assault   Accursed Ench.   Heaven & Earth   Tails of B.A.   Fox Fire Dis.  transform   biggest hit
 GRAB opener    auto-aimed       air launcher     stun on hit     breaks Instinct (3 tails)
 breaks Instinct can't be dodged  wears Instinct
```

### Why the opener is F, not Z or M1

This is the part that makes or breaks "inescapable," and it's worth being blunt
about the failure modes:

- **M1 is not an opener.** Range is tiny and it's freely dodgeable. If your entry
  is an M1, a moving target simply isn't there.
- **A skillshot is not an opener.** Godhuman Z is a good move, but against a
  strafing player who hasn't been hit yet, it's a coin flip — and if it whiffs,
  nothing downstream matters.
- **F (Wild Assault) is a grab.** It rushes in zig-zag (real closing range, not
  M1 range), and on connect it *grabs* — the target is carried up and slammed,
  not merely damaged. They aren't free to dash during that. It also **breaks
  Instinct**, so ken doesn't phase them out of it.

Once F connects, **Z is auto-aimed** — it cannot be strafed. That gives you two
guaranteed links before you ever commit a move that can miss. Godhuman X then
launches them airborne (and wears off Instinct), Kitsune X stuns, and C breaks
Instinct again — each link lands while the previous one still has them locked.

The combo damage builds your tail meter, so **V is available by the end** even
if you started at 0 tails; transformed **C** is the strongest single hit in the
kit and is your finisher.

### Honest caveat on "inescapable"

I could not verify frame data — no source I could reach publishes exact stun
durations, recovery frames, or grab-lock windows for these moves, and I could
not extract the move orders from the YouTube combo videos (the pages are
JS-rendered; WebFetch only gets the footer). Fandom's own `Kitsune/Combos` and
`Godhuman/Combos` pages both hard-blocked my fetches (HTTP 402).

So: this combo is built on **verified move properties** (grab, auto-aim,
Instinct-break, stun, launcher) rather than measured frame gaps. The sequencing
logic is sound and each link is chosen so the target is locked when the next
one starts — but whether every transition is *frame-tight* is something you'll
have to confirm in-game. Treat it as a strong, well-reasoned starting point, not
a proven zero-frame lock.

## Files

- [`macro/KitsuneOneshotCombo.ahk`](macro/KitsuneOneshotCombo.ahk) — AutoHotkey v2 script

## Setup

1. Install [AutoHotkey v2](https://www.autohotkey.com/).
2. Open the `.ahk` and edit the `CONFIG` block:
   - Set the move keys to **your actual in-game keybinds** (Blox Fruits lets you
     remap; don't assume the defaults match yours).
   - `hotkeyTrigger` (default `F1`) fires the combo. `hotkeyAbort` (default
     `Esc`) cancels mid-sequence.
3. Run the script (it sits in the tray).
4. In-game: get the target in **F range** (not M1 range — F closes the gap for
   you), mouse over them, press the trigger.

## Tuning

The delays are placeholders and **will drift with patches and your ping**. Go to
a private server / training dummy and watch whether each move fires just as the
previous animation releases. Adjust in 25–50ms steps.

The one that matters most is `delayAfterF` — the grab carries the target up and
slams them, and that animation has to *finish* before Z will connect. If Z fires
during the carry, you've wasted the guaranteed link. Tune that one first.

## Safety notes

- `Esc` aborts immediately — use it if you misjudge range.
- A re-entry lock stops the trigger from stacking overlapping sequences.
- Sends keystrokes/clicks only. No pixel reading, no memory reading, no
  auto-targeting — you still aim and judge range yourself.
