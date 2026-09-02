# Blox Fruits — Kitsune One-Shot Combo Macro

Research notes + build + an AutoHotkey v2 macro that fires a Godhuman + Kitsune
combo when you hover a target and press a hotkey. This is an **external
keystroke macro** (AutoHotkey sends OS-level key/mouse events) — it does not
read game memory, inject code, or touch the Roblox client process, which is
the line Blox Fruits' rules draw between "macro" (allowed) and "exploit"
(banned).

## ⚠️ Read this first

Blox Fruits patches move/mastery numbers, accessory names, and even whole
fighting styles every update. I pulled current (Sept 2026) info from the
Fandom wiki and a few guide sites, but guide sites disagree with each other
and some are clearly AI-generated SEO junk (I caught one inventing an
"Electric Claw" moveset for Kitsune that doesn't exist). **Treat exact
numbers below as approximate and verify move keys/cooldowns in your own
keybind menu before relying on the macro in a real fight.** The delays in
the script are placeholders — you MUST tune them against your own ping and
mastery level in the training dummy room (see "Tuning" below).

## Why fruit + fighting style only (no sword/gun)

At max level you get enough stat points to max **3 stats to 2800 each**
(≈8400 total). A fighting-style-and-fruit build spends all three on:

- **Melee** 2800 — fighting-style damage/M1s
- **Fruit** 2800 — Kitsune damage, cooldowns, DoT scaling
- **Defense** 2800 — survivability so you're not one-shot back while closing distance

Sword and Gun are left at 0 — you never swing a sword or fire a gun in this
build, so those stats would be wasted points.

## Build

| Slot | Pick | Why |
|---|---|---|
| Fighting style | **Godhuman** | Highest M1 ceiling of any non-endgame style, and its **Z** has a built-in stun — the opener that starts the lock. (Sanguine Art / Dragon Talon / Death Step are later-game alternatives with similar stun-into-combo tools if you have them unlocked.) |
| Fruit | **Kitsune** | Its kit is built to break Instinct (dodge) and chain hits: **C** (Fox Fire Disruption) breaks Instinct on a huge hitbox, **X** (Tails of Burning Agony) chain-hits up to 3 targets zig-zag and, once you're past 3 tails, wraps them in a 4–5s blue-flame burn DoT that also breaks Instinct. **V** transformation adds a giant AoE finisher with your own i-frames on the transform-in. |
| Race boost | Human V3 minimum, **V4 if you have it** | Passive damage/Haki buffs make the combo hit harder and stack; the combo is designed to still one-shot squishier stat spreads without it, per your ask. |
| Accessories | Prioritize **stun-duration** and **% damage** modifiers over pure cosmetics (whatever your current top-tier set is — this rotates with events, so check the current accessory tier list rather than trusting a name here). | Extends the stun window the whole combo depends on. |

## The combo

```
Godhuman [Z]  →  Kitsune [C]  →  Kitsune [X]  →  Godhuman M1 x2–3  →  Kitsune [V]
   stun           Instinct-break        chain-hit + Instinct-break        (transform,
   (locks         AoE, big hit          hit, DoT burn wrap                 finisher /
   target)                                                                 i-frame close)
```

**Why it's (practically) inescapable:** in Blox Fruits, breaking a stun-lock
("kentric") means dash-canceling in the single frame gap between one hit's
stun ending and the next hit landing. Godhuman Z's stun chains directly into
Kitsune C's Instinct-break with no cancelable gap, and C chains into X the
same way — X's own Instinct-break plus the burn-wrap covers the tail end of
the sequence. The realistic reaction window a human has to dash-cancel
between those links is well under 100ms; a macro firing the inputs back to
back doesn't leave that window open. It's *technically* possible to escape
with frame-perfect, pre-read timing — it is not practically possible to
react to it live. If the target somehow tanks the whole chain (very high
Defense stat + shield/heal fruit active), the trailing burn DoT plus a
second M1 string usually finishes them.

## Files

- [`macro/KitsuneOneshotCombo.ahk`](macro/KitsuneOneshotCombo.ahk) — AutoHotkey v2 script.

## Setup

1. Install [AutoHotkey v2](https://www.autohotkey.com/).
2. Open `macro/KitsuneOneshotCombo.ahk` in a text editor and edit the
   `CONFIG` block at the top:
   - Set `keyGodhumanZ`, `keyKitsuneC`, `keyKitsuneX`, `keyKitsuneV` to match
     **your actual in-game keybinds** (Blox Fruits lets you remap these —
     don't assume the defaults below match yours).
   - Set `hotkeyTrigger` to whatever key/mouse button you want to fire the
     combo (default `F1`).
   - Set `hotkeyAbort` (default `Esc`) to cancel mid-sequence.
3. Double-click the `.ahk` file to run it (it sits in your system tray).
4. In-game: hover your mouse over the target (most Kitsune/Godhuman moves
   fire toward your camera/cursor direction rather than needing a hard
   lock), get in range, press the trigger key.

## Tuning

The delays between moves (`delayAfterZ`, `delayAfterC`, `delayAfterX`,
`delayBeforeV`) are guesses based on typical Blox Fruits animation lengths —
**they will drift from patch to patch and depend on your ping.** Go to a
private server or the training dummy, run the macro, and watch whether each
move fires *just as the previous one's animation/stun ends*. If a move
whiffs because it fired too early (previous animation still playing) or too
late (target already recovered), adjust that delay in 25–50ms steps and
re-test.

## Safety notes

- The abort hotkey (`Esc` by default) stops the sequence immediately —
  use it if you misjudge range or the target isn't actually there.
- The script won't re-trigger mid-sequence (a lock flag blocks re-entry),
  so mashing the trigger key can't stack overlapping macros and desync your
  inputs.
- This only sends keystrokes/clicks like a human would; it does not read
  pixels, memory, or any game state, and does not auto-target — you still
  aim and judge range yourself.
