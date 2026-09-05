# Blox Fruits — Kitsune One-Shot Combo Macro

Kitsune + **Sanguine Art**, fruit and fighting style only (no sword, no gun),
with a **native PowerShell macro** — no AutoHotkey, no third-party runtime, no
installer of any kind. Ships as a plain `.ps1` file that runs on PowerShell,
which is already built into Windows.

External keystroke macro — uses the Win32 `SendInput` API (the same OS-level
input path a physical keyboard/mouse uses) to send key events, and
`GetAsyncKeyState` to watch for the trigger/abort hotkeys. No memory reading,
no injection, nothing touching the Roblox process. That's the line between
"macro" (allowed) and "exploit" (banned).

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
Kitsune [C]  ->  Sanguine [C]  ->  Sanguine [Z]  ->  Kitsune [X]  ->  Sanguine [X]
 BREAKS          lands because     heals 20% HP     stuns ~0.65s,    burst
 INSTINCT        they're broken;   even if dodged    then channels    finisher
                 disables dash/                       on hit (locks
                 Flash Step/moves                      your own input
                 ~1.2s                                  briefly)
```

Three things are confirmed:

1. **Kitsune [C] breaks Instinct.** The only break in this combo. Goes first,
   so their Instinct is down for what follows.
2. **Sanguine [C] disables dashes, Flash Step and moves for ~1.2s** on hit.
   Landing it against an Instinct-broken target is what opens the window
   everything else is dumped into.
3. **Kitsune [X] stuns ~0.65s**, and since Update 31.4 **channels on hit** —
   after it connects, *you* can't send another key until its own animation
   finishes. That's not a downside here: it's a second lock (on top of
   Sanguine C's) that keeps the window open long enough for Sanguine [X] to
   land as the finisher.

### Sanguine [C] and [Z] do NOT break Instinct — user-confirmed, overrides the wiki

The wiki's Instinct chart claims Sanguine [C] breaks "if aimed correctly" and
Sanguine [Z] breaks "on direct hit." **User confirmed directly: neither does.**
Per this file's own standing rule (wiki Instinct claims get less trust here,
after three prior wiki errors — Kitsune Z, Kitsune F, Sanguine C were all
wrong before), the user's word wins. Kitsune [C] is the **only** Instinct
break in this combo.

That's fine — the user supplied this combo, sequencing included. It doesn't
need to be Instinct-break-redundant to work; it holds on Kitsune C's break
plus Sanguine C's 1.2s disable plus Kitsune X's stun/channel.

| Move | Breaks Instinct? | Source |
|---|---|---|
| Kitsune [C] | **Yes** — the only break in this combo | user |
| Kitsune [Z] | No — Instinct-trickable since 31.4 | wiki (patch notes) |
| Kitsune [X] | No — drains only, but stuns ~0.65s then locks your own input on hit | wiki + user |
| Kitsune [F] | No | user |
| Sanguine [C] | **No.** Disables inputs ~1.2s regardless — that's its job here | user (overrides wiki) |
| Sanguine [Z] | **No** | user (overrides wiki) |
| Sanguine [X] | No known break claim | — |

So this combo does **not** rest on a chain of Instinct breaks. It rests on
**one confirmed break + two confirmed input-locks** — Kitsune C's break,
Sanguine C's 1.2s disable, and Kitsune X's stun-then-channel. That is the
honest claim, and it's the user's combo design, sequenced to work on exactly
that basis.

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
| X | Tails of Burning Agony | 50 | 12s | 40 | Zig-zag, **stuns ~0.65s**. No Instinct break, drains only. **31.4: now channels on hit — you cannot cast another ability until the animation finishes.** Usable mid-combo, but the move *after* it needs a delay long enough to clear that channel or it gets silently dropped |
| C | Fox Fire Disruption | 100 | 15s | 80 | **Quick TAP** (user-corrected 2026-09-02 — the "charge on hold" description belongs to the *transformed* form, not this one). **BREAKS INSTINCT** — the only confirmed break in this build. **No auto-aim / no tracking of any kind** (user, 2026-09-05) |
| F | Wild Assault | 200 | 9s | 60 | Dash → claw flurry on connect. **Does not break Instinct.** Initial hit dodgeable |
| V | Transformation | 300 | 3s | 20 | Immune to basic damage 1s while transforming. **Disables fighting style / sword / gun** |

Tails cost per use: M1 7.5%, Z 10%, X 12.5%, C 15%, F 10%, V 30%.

**Untransformed vs transformed (Empyrean) Kitsune are different movesets.**
Everything in this build is *untransformed* — V is never pressed, and
transforming would disable the fighting style anyway. The transformed form's
tapped/held Z split, shorter cooldowns and higher tails costs do **not**
apply here. Earlier revisions of this doc mixed the two (the "charge on
hold" C above was one instance); if a Kitsune move here is described with a
hold/charge variant, treat it as suspect and check the *untransformed* Kitsune
page, not the Empyrean one.

**Auto-aim / tracking (user, 2026-09-05):** Kitsune C has **none**. Some
other moves do have tracking — Godhuman C is one — but it is **weak**: miss
the target by a few studs and the move whiffs. Nothing in this build should
be treated as a lock-on; every opener still has to be aimed by hand.

**Timing is not fixed.** The gap between one move finishing and the next
becoming castable **changes from run to run** — distance to target, whether
the move connected, airborne vs grounded, ping. That is why every ability is
spammed for a window instead of pressed once at a fixed offset; a fixed
offset that works on a dummy will not work on a moving player.

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

**Use the `Updates/<version>` patch-note pages as the source of truth.** The
per-ability pages are not updated after nerfs — that is the root cause of every
Instinct error in this file's history. Latest update is **31.4** (31.5 / 32 do
not exist).

Update 31.4 nerfed Kitsune directly: **[Z] no longer breaks Instinct**, **[X] now
channels on hit so you cannot cast another ability until it finishes**, and
**[C] end-lag +0.3s**. Sanguine Art [C] lost 15% range and 10% hitbox. None of
that is reflected on the ability pages.

**Verified 2026-09-02**: a separate official source, the developer's own
"Balance Log" post (gamerrobot.com/blogs/news/the-balance-log, dated August 6
2026, "Balance Patch 001") was checked against Update 31.4 and matches it
word-for-word for both Kitsune and Sanguine Art — same Z/X/C nerfs, same
wording. It also confirms **Instinct dodge regeneration dropped from 40s to
30s** (dodges recharge 25% faster now — doesn't change a single combo, matters
if you're trading combos repeatedly in one fight), and that a **Sanguine
"Tab Boost" movement exploit** (travel much farther than intended) was patched
— this build never relied on it, so no change here.

The wiki's **Instinct charts and the `Instinct/Break` page are unreliable** —
they have been wrong three separate times in building this file (Kitsune Z,
Kitsune F, Sanguine C), in some cases because the game changed and the page
didn't. **Every Instinct claim in this document has been stripped back to what
was confirmed directly by the user** — including overriding the wiki's
Sanguine [C]/[Z] break claims, which the user confirmed are wrong.

**Also found, not yet used**: Sharkman Karate's wiki Instinct chart claims
**[C] "breaks Instinct no matter what"** and **[X] held "breaks Instinct no
matter what"** — both stronger, less conditional claims than anything Sanguine
Art offers, and 31.4/Balance Patch 001 buffed Sharkman [C] further (uncancellable
hold, more damage reduction, now grants temp HP). Not user-confirmed and not
integrated into the current combo — flagging as the strongest lead if a future
revision wants a build with more than one confirmed break.

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

- [`macro/KitsuneOneshotCombo.ps1`](macro/KitsuneOneshotCombo.ps1) — the macro.
  Plain PowerShell, native Win32 `SendInput`/`GetAsyncKeyState`. Nothing to
  install.
- `macro/KitsuneOneshotCombo.ahk` — superseded, kept only as a reference for
  the original AutoHotkey design this was ported from. Don't use it; the
  `.ps1` is the maintained version and requires no third-party software.
- `macro/combo-log.txt` — every macro run's keypress log, appended
  automatically (see `$debugLog`).

## Hotkeys (2026-09-04)

Hotbar: **1 = fighting style** (whichever is equipped), **2 = Kitsune**,
**3 = Yama**.

| Key | Combo | Start with | Note |
|---|---|---|---|
| **F1** | Godhuman C → Kit C → Yama X → Kit Z, X → Godhuman X → Kit F → Godhuman Z | Godhuman equipped | Ping / reaction-speed dependent. Godhuman C is **held** by default; **F8** toggles it to **tapped** and back |
| **F2** | Sang C → Kit C → Yama X → Kit Z, X → Sang Z → Kit F → Sang X | Sanguine equipped | Slower than the others |
| **F3** | Sang C → Kit C → Kit X → Yama X → Sang Z → Kit F → Kit Z → Sang X | Sanguine equipped | Sanguine alt |
| **F4** | Kit C → Sang C → Sang Z → Kit F → Sang X → Kit X | Kitsune equipped | The old F1 (combo v2, full). Superspeed-tuned 2026-09-04, est. ~2.4 s (was 5.1 s) |
| **F5** | Kit C → Sang C → Sang Z, stop | Kitsune equipped | The old F2 (combo v1, opening only) |
| **F6** | timing recorder toggle | — | Was F3 |
| **F7** | swap test (opening only) | — | Was F4 |
| **F8** | **toggle F1's Godhuman C: HELD ↔ TAPPED** | — | Added 2026-09-05. Starts HELD. Takes effect on the next F1. Console prints the current mode |
| *(unbound)* | E claw C → Kit C → Yama X → Kit Z, X → E claw X → Kit F → E claw Z (or E claw Z, X → Kit F) | E claw equipped | Aim dependent. Saved as `$Combo_EClaw`; set `$hotkeyEClaw` to bind |
| **Esc** / **Tab** | abort | | |

### The timing model (user, 2026-09-05) — read before changing any window

**You can swap slots the instant an ability has fired. You just can't fire the
next ability until the previous animation ends.** So the macro should: press
until it fires → swap immediately → start spamming the next key straight
away, so the first press after the previous animation ends casts with zero gap.

What that means for the numbers:

- A spam window is **not** "how long this move takes". It is "how long until
  the *previous* move's animation is over" plus a little slack.
- The **first move** of a combo has nothing animating before it, so it fires
  on press 1. Its window is now **80 ms** (`$ycGodCTapWindowMs` for tapped
  Godhuman C, `$ycOpenerWindowMs` for Sanguine C / E claw C) — one retry for
  an eaten press, then swap. It was 260, which was ~180 ms of dead time.
- Swaps cost only the 60 ms keypress, zero buffer either side, and never wait
  for an animation. `Run-Steps` already does swap → spam back-to-back; this
  model changes how windows are *sized*, not the mechanics.

### F8 — held vs tapped Godhuman C (2026-09-05; was F9 for a few hours)

The hardest part of F1 to execute is the opening Godhuman C: the held version
has to be *aimed for the whole hold*, and you're usually mid-WASD and
stretching to reach F1 at the same moment. F8 flips F1 between:

- **HELD** (default): `$ycHoldGodCMs` = 350 ms hold. Undodgeable, invulnerable
  during, but you have to keep the aim on them through the hold. Kit C after
  it: `$ycKitCAfterGodCMs` = **530 ms** (550 → 700 → 560 → 530, 2026-09-05;
  user: Kit C fires sooner than assumed, swap to Yama moderately sooner, then
  another 30 ms earlier).
- **TAPPED**: C is spammed for `$ycGodCTapWindowMs` = 80 ms (3 presses — it is
  the first move, nothing is animating, it fires on press 1). Commits
  instantly — no aim to hold — but it **is** dodgeable and its tracking is
  weak (a few studs off = whiff). Kit C after it gets its own window,
  `$ycKitCAfterGodCTapMs` (530, same as held).

Press F8 again to go back. The mode persists until you close the macro; set
`$godCTapModeDefault = $true` to start in tapped mode.

**Rebinding any hotkey yourself:** every hotkey is one line in the CONFIG
block at the top of the `.ps1` (`$hotkeyGodhuman = 'F1'`,
`$hotkeyGodCTapToggle = 'F8'`, etc.). Change the string and restart the macro.
The key name must exist in the `$VK` table (~line 340); `F1`–`F9`, `Escape`,
`Tab`, `Z/X/C/F`, `1/2/3` are already there. For other keys add a line with
the Windows virtual-key code first, e.g. `'F10' = 0x79`, `'F11' = 0x7A`,
`'F12' = 0x7B`.

**Yama X window** (`$ycYamaXWindowMs`) = **640 ms**, and **Kit Z after Yama X**
(`$ycKitZAfterYamaXMs`) = **600 ms** (2026-09-05). History: Yama X was cut
260 → 120 per user, then got skipped; F6 hand recordings (swap → last press)
measured Yama X at 1011 / 1365 / 1079 ms and Kit Z at 952 / 1313 ms. Another
session set the raw fastest hand numbers (1000 / 950), which the user found
far too slow. The recordings include hand reaction time (you keep pressing
until you *notice* it fired), so they went to fastest-trial minus ~200 ms
(800 / 750), then the user said Yama fires faster than assumed and the same
for Kit Z, so both took the same ~20% cut Kit C got (800 → 640, 750 → 600).
**The swap itself is 60 ms** — what feels like a slow swap is the previous
move's window draining. If Yama X or Kit Z start getting skipped, raise in
~80 ms steps (640 → 720 → 800, 600 → 680 → 750); don't go up for any other
reason.

**Everything after Kit Z** (`$ycAfterKitZWindowMs`) = **240 ms** (2026-09-05,
new knob; was the global 260). Covers Kit X after Kit Z, the style X/Z that
follows it, and the closing style move in F1/F2/E claw, plus F3's closing
Sang X. Per user: "reduce all delays after Kit Z a little little bit". 6
presses per step at the 40 ms interval.

**Kit F window** in F1/F2/F3 (and E claw) is **280 ms** (`$ycKitFWindowMs`;
260 → 300 → 280, 2026-09-05) — the 300 was one extra press attempt for
robustness, the 280 is the same "a little bit shorter after Kit Z" pass as
above. F4/F5's Kit F is a different knob, still 300.

### How the F1–F3 combos time themselves

Target: **2–3 s end to end** (user requirement, 2026-09-04). Every run prints
`--- done in Nms ---` so you can see the real number.

None of the inter-move timings are known, so **every ability is spammed** for
a short window instead of tapped once: `$ycSpamDurationMs` = **260 ms**, one
press every `$ycSpamIntervalMs` = **40 ms** (~7 attempts). A press during the
previous move's animation does nothing; the first press that lands casts; the
rest are eaten by cooldown. Slot keys are pressed exactly once (a slot key
toggles equip) with **no buffer** (`$ycSwapBufferMs` = 0), so a swap costs
only the 60 ms keypress.

Estimated totals with these defaults: **F1 ≈ 2.8 s, F2 ≈ 2.6 s, F3 ≈ 2.6 s.**

Two steps are already widened because the style's C move animates long and
Kit C was being skipped at 260 (both confirmed in testing 2026-09-04):

- **Kit C after Sang C** (F2/F3): `$ycKitCAfterSangCMs` = 330 ms (450 → 360 → 330, 2026-09-05)
- **Kit C after held Godhuman C** (F1): `$ycKitCAfterGodCMs` = 530 ms (550 → 700 → 560 → 530, 2026-09-05)

**The trade-off:** 260 ms is shorter than some moves' own animations (the old
combo's logs show Sanguine C needing ~600 ms before Z would fire, and Kitsune
X channelling ~1070 ms). A move whose predecessor animates longer than the
window gets **skipped**. The combo can't be faster than the sum of its
animations — that's the game, not the macro. When a specific move keeps
getting skipped, widen *that step only* in the step list and leave the global
tight:

```powershell
@('spam', $keyZ, 600, 40)    # this one step gets a 600 ms window
```

- **Godhuman C is held** (`$ycHoldGodCMs` = 350 ms, one attempt, no retry).
  The held version is the undodgeable one; if it comes out as the tap version,
  raise to 400/450 — it's the biggest fixed cost in F1, so don't pad it beyond
  what registers.
- If a style/Yama move comes out as a Kitsune move (or vice versa), raise
  `$ycSwapBufferMs` to ~40 first.
- The combos are step lists (`$Combo_Godhuman` etc.) — reorder by editing one
  line.

---

## F4/F5 superspeed (2026-09-04)

The old combos got the same treatment as F1–F3. Old vs new, from the last
logged 5.1 s run:

| Value | Old | New |
|---|---|---|
| `$preSwapRegisterMs` (buffer each side of the two main swaps) | 140 | **0** |
| `$delayAfterKitCMs` | 350 | 300 |
| Sang C window / interval | 600 / 100 | **400 / 50** |
| Sang Z window / interval | 600 / 100 (+40 lead-in) | **450 / 50** (0 lead-in) |
| Kit F window / interval | 600 / 80 | **300 / 40** |
| Sang X window / interval | 520 / 70 | **300 / 40** |
| Kit X window / interval | 240 / 80 | 240 / 40 |

Estimated F4 ≈ 2.4 s. Sang C and Sang Z are deliberately kept wider than the
260 ms global because your own logs show Sang C needing ~4 presses and Sang Z
needing 5–7 before firing. Every window now has *more* attempts than before
(intervals halved), just packed into less time.

If something breaks, in order of likelihood: Sang Z skipped → raise
`$spamSangZDurationMs` to 550; Sang C skipped → `$spamSangCDurationMs` to
500; the opening swap fails (Sang C comes out as a Kitsune move) →
`$preSwapRegisterMs` to 40, then 80 — not back to 140.

---

## PVP quick-start (read this even if you skipped everything else above)

This is written for using the macro **in a real, fast-paced PVP fight**, not
for understanding the underlying game mechanics. Four steps — there's no
install step, PowerShell already ships with Windows.

### 1. Set up your hotbar once, before you fight

The macro presses hotbar slot keys to swap between your fruit and your
fighting style, because Kitsune and Sanguine Art both use Z/X/C. Before any
fight:

- Put your **fighting style** (Sanguine Art / Godhuman) in hotbar slot **1**
- Put **Kitsune** in hotbar slot **2**
- Put **Yama** in hotbar slot **3**

If you already keep them somewhere else, that's fine — just change
`$slotFruit`, `$slotFightStyle` and `$slotSword` at the top of the `.ps1` file to match your
slot numbers, once, and forget about it.

### 2. Run the macro

Right-click `macro/KitsuneOneshotCombo.ps1` → **Run with PowerShell**. A
console window opens and prints a short "running" message — that window IS
the macro; leave it open in the background while you fight, minimized or
behind the game, doesn't matter. Closing it (or Ctrl+C inside it) stops the
macro entirely.

(If Windows blocks it with an execution-policy message instead of running:
open PowerShell yourself and run
`powershell -ExecutionPolicy Bypass -File macro\KitsuneOneshotCombo.ps1` —
this only affects this one run, it doesn't change any system setting.)

### 3. In the fight: one button

1. Get your **cursor over the enemy**, in range (this is a hover-based combo —
   no auto-aim, no auto-targeting, you do the aiming, same as any normal
   ability).
2. Press the hotkey for the combo you want (see the hotkey table above).
   Make sure the right item is equipped first — F1–F3 start with the fighting
   style equipped, F4/F5 start with Kitsune equipped.
3. Don't touch anything else until it finishes. The macro sends the whole
   sequence for you.
4. If it goes wrong mid-way — you got hit, they escaped, whatever — press
   **Esc** immediately. This cancels the macro instantly and safely releases
   any held key, so you're never stuck with a key jammed down.

That's the entire in-fight workflow: **aim, hotkey, wait, (Esc if needed).**

### 4. Calibrate BEFORE you rely on this in a real fight

The delay numbers in the macro are honest starting estimates, not
frame-perfect data — nobody publishes exact animation lengths for these
moves, only the stun/disable durations, which are already baked in. Test on a
low-stakes target first (an NPC, a friend, a low-level dummy):

1. Press the combo hotkey and watch closely (or record a slow-motion clip on your phone).
2. Find the first move in the sequence that **whiffs, comes out too early, or
   gets eaten** because the character was still mid-animation from the move
   before it.
3. Open the `.ps1` file, find that delay variable (they're named
   `$delayAfter<Move>Ms`), and adjust it up or down by ~50.
4. Save, close and re-run the macro window, test again.
5. Repeat 2–4 until the full combo lands clean twice in a row.

**If you only calibrate one thing, calibrate `$delayAfterKitXMs`.** It's
called out in the macro file as the highest-priority value: Kitsune X now
locks your own input after it connects, and if the next move (Sanguine X)
fires before that lock clears, the game silently drops it — the combo ends
one hit short with no error, no message, nothing to tell you why.

---

## Setup (reference)

1. Nothing to install — PowerShell ships with Windows.
2. Edit `CONFIG` at the top of the `.ps1` file — move keys to match your
   binds, hotbar slots for Kitsune and Sanguine Art.
3. Run it (see "PVP quick-start" above).
4. In-game: hover the target in range, press the combo hotkey. `Escape` aborts.
   Hit them **airborne** if you can — the wiki notes disable/stun durations
   run longer on airborne targets.

## Tuning priority

Delays are split into two kinds: **hard locks** (the game itself won't take
input until this much time passes — don't cut these blind) and **self-recovery
estimates** (your own cast animation ending — undocumented, cut as tight as
your dummy test allows). Only the estimates are padding worth trimming;
`$delayAfterSangCMs` and `$delayAfterSangZMs` are already cut to a 150ms+30ms
buffer floor.

1. **`$delayAfterKitXMs`** (hard lock) — Kitsune X channels on hit since 31.4;
   too short and Sanguine X gets silently dropped, too long and you waste
   Sanguine C's 1.2s window. See "PVP quick-start" above for the calibration
   drill. Don't cut this one by guessing — step it down in small increments.
2. **`$delayAfterSangCMs` / `$delayAfterSangZMs`** (self-recovery estimates)
   — if either whiffs on your dummy, raise the ONE before the move that's
   actually whiffing, not both.
3. **`$chargeTimeKitCMs`** (hard lock) — minimum hold so it registers as a
   hold, not a tap.
4. **Slot swaps** — if a Sanguine move comes out as a Kitsune move (or vice
   versa), raise `$slotSwapDelayMs`.
5. **`$swapKitsuneAndSanguineX`** — flip to `$true` to run Sanguine X before
   Kitsune X instead, putting the hard-locked move last so nothing can drop
   after it. No published data says which order lands more reliably; try both.

## Safety

- `Escape` aborts immediately; held keys are always released (both mid-combo
  and in a `finally` block as a second safety net).
- Re-entry lock prevents overlapping runs — pressing a combo key mid-combo does nothing.
- Keystrokes and clicks only, via the same Win32 `SendInput` path physical
  input uses. No pixel reading, no memory reading, no auto-targeting, no
  mouse movement — you aim and judge range, exactly like playing normally.
  The macro only presses keys you'd otherwise press yourself, faster and in
  the right order.
- No third-party software, no installer, no external dependency of any kind
  — it's a plain text `.ps1` file you can read top to bottom, running on
  PowerShell, which ships with every copy of Windows.

## Git workflow (VS Code)

Open a terminal in the project folder (Terminal → New Terminal, or `` Ctrl+` ``).

**Get the latest changes from GitHub into your folder:**

```bash
git pull
```

**Push your own edits to GitHub:**

```bash
git add .
git commit -m "what you changed"
git push
```

If `git pull` refuses because you have uncommitted local edits, run the
`add` + `commit` lines first, then `git pull`, then `git push`. If `git push`
is rejected with "fetch first", someone else pushed since you last pulled:
`git pull` (resolve any conflict), then `git push` again. Always `git pull`
*before* you start editing so the two sides never drift far.
