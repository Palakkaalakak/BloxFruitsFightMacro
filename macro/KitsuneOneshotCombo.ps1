# ============================================================================
# Blox Fruits - Kitsune + Sanguine Art one-shot combo
# Native PowerShell + Win32 SendInput/GetAsyncKeyState. NO third-party runtime,
# NO AutoHotkey, NO installer - this is the entire macro, self-contained.
#
# Same combo, same design rationale, as the AHK version this replaces:
#
#   Kitsune  [C] TAP    - quick tap, NOT a hold/charge (corrected 2026-09-02,
#                        user-confirmed; the wiki's "charges, fires on release"
#                        description was wrong for this move). BREAKS INSTINCT.
#                        The ONLY Instinct break in this combo. User-confirmed.
#   Sanguine [C]        - lands because they're Instinct-broken. Disables
#                         their dashes, Flash Step and moves for ~1.2s.
#                         Does NOT break Instinct (user-confirmed).
#   Sanguine [Z]        - heals 20% max HP even if they dodge it with Instinct.
#                         Does NOT break Instinct (user-confirmed).
#   Kitsune  [X]        - zig-zag hit, stuns ~0.65s, then CHANNELS ON HIT:
#                         you cannot send the next key until the channel ends.
#                         Does NOT break Instinct (drains only).
#   Sanguine [X]        - burst finisher.
#
# ORDER (CURRENT, 2026-09-02): Kitsune[C] -> Sanguine[C] -> Sanguine[Z] -> Sanguine[X] -> Kitsune[X]
# Kitsune X re-added after Sanguine X's spam window (was removed earlier,
# then placed last per user request instead of its original second-to-last
# spot). $swapKitsuneAndSanguineX is unused now that the order is fixed.
#
# HOTKEYS (2026-09-04 layout — Yama combos added, old combos shifted down):
#   F1  Godhuman combo   Godhuman C(held) + Kit C + Yama X + Kit Z X + Godhuman X + Kit F + Godhuman Z
#                        (ping / reaction-speed dependent)
#   F2  Sanguine combo   Sang C + Kit C + Yama X + Kit Z X + Sang Z + Kit F + Sang X
#                        (slower than the others)
#   F3  Sanguine alt     Sang C + Kit C + Kit X + Yama X + Sang Z + Kit F + Kit Z + Sang X
#   F4  old F1           combo v2, full  (Kit C -> Sang C Z -> Kit F -> Sang X -> Kit X)
#   F5  old F2           combo v1, opening only
#   F6  old F3           timing recorder toggle
#   F7  old F4           isolated swap test
#   F8  TOGGLE           F1's Godhuman C: HELD (default) <-> TAPPED. Press again to
#                        switch back. Added 2026-09-05: the held C is the hardest
#                        part of F1 to aim (you have to hold the aim while
#                        reaching from WASD to F1), tapped C is a quick commit.
#   --  E claw combo     saved as $Combo_EClaw, NOT bound (ignored for now)
#   Esc / Tab            abort
#
# The three new combos are pure step lists run by Run-Steps (see "YAMA
# COMBOS" below). Every ability in them is SPAMMED for a window (same idea as
# the existing $spam* settings) because exact inter-move timings are unknown;
# slot keys are still pressed exactly once. They assume the FIGHTING STYLE is
# the active hotbar slot when you press the trigger (the first move is a style
# move), the same way the old combos assume Kitsune is active.
#
# Keystrokes and clicks only, via SendInput - the same OS-level input path a
# physical keyboard/mouse uses. No memory reading, no process injection,
# nothing touching the Roblox process itself. No mouse movement, no
# auto-targeting - you aim, this only presses keys for you, in order, with
# researched delays. See README.md for full sourcing and combo rationale.
#
# HOW TO RUN: right-click this file -> Run with PowerShell. Or from a
# terminal: powershell -ExecutionPolicy Bypass -File KitsuneOneshotCombo.ps1
# A console window stays open while it's active - that's the "tray icon"
# equivalent. Close the window (or Ctrl+C) to stop it entirely.
# ============================================================================

# ---------------------------- CONFIG ---------------------------------------

$keyZ = 'Z'
$keyX = 'X'
$keyC = 'C'
$keyF = 'F'

# Z/X/C are shared between fruit and fighting style - the combo needs swaps.
$slotFruit      = '2'    # Kitsune
$slotFightStyle = '1'    # fighting style - Sanguine Art / Godhuman / E claw, whichever is equipped
$slotSword      = '3'    # Yama (2026-09-04)
$slotSwapDelayMs = 25    # ms for a hotbar swap to register - tightened further 2026-09-02. A slot swap has no animation lock in-game (unlike a move), it's purely OS/key-registration time, so it can run tighter than the move-recovery delays below.

# SWAPPED 2026-09-03 per user: the FULL combo is now on F1 and the
# opening-only combo on F2. $hotkeyTrigger still fires Run-Combo (opening
# only) and $hotkeyTrigger2 still fires Run-Combo2 (full) - only the keys
# they're bound to changed, so the function names stay matched to their
# behaviour.
# SHIFTED 2026-09-04: F1-F3 are now the Yama combos (below). Everything that
# used to be on F1-F4 moved down by three: F1->F4, F2->F5, F3->F6, F4->F7.
$hotkeyGodhuman    = 'F1'   # -> Run-Godhuman:    Godhuman C(held) + Kit C + Yama X + Kit Z X + Godhuman X + Kit F + Godhuman Z
$hotkeySanguine    = 'F2'   # -> Run-Sanguine:    Sang C + Kit C + Yama X + Kit Z X + Sang Z + Kit F + Sang X
$hotkeySanguineAlt = 'F3'   # -> Run-SanguineAlt: Sang C + Kit C + Kit X + Yama X + Sang Z + Kit F + Kit Z + Sang X
$hotkeyTrigger2 = 'F4'   # -> Run-Combo2: combo v2, full (... -> Kitsune[F] -> Sanguine[X] -> Kitsune[X]). Was F1.
$hotkeyTrigger  = 'F5'   # -> Run-Combo:  combo v1, opening only (Kitsune[C] -> Sanguine[C] -> Sanguine[Z]). Was F2.
$hotkeyAbort   = 'Escape'
$hotkeyAbort2  = 'Tab'   # second abort key, added 2026-09-02 per user - instant-cancel if a move missed, without needing to reach for Escape
$hotkeyRecordToggle = 'F6'   # was F3 (and F2 before that) - toggles timing-recorder mode, see "RECORDING MODE" below
$hotkeySwapTest = 'F7'       # was F4 - isolated swap test (2026-09-03): Kitsune C, then the swap to Sanguine, and nothing else
$hotkeyEClaw    = ''         # E claw combo is saved ($Combo_EClaw) but NOT bound. Set to e.g. 'F10' (and add F10 = 0x79 to $VK) to enable. F8 is now the held/tap toggle.
$hotkeyGodCTapToggle = 'F8'  # F9 -> F8 (2026-09-05, per user). 2026-09-05: toggles F1's Godhuman C between HELD and TAPPED. Starts in HELD mode ($godCTapModeDefault).

# --- THE TIMING MODEL (user, 2026-09-05) - read before touching any window ---
# You can SWAP hotbar slots the instant an ability has FIRED; you just cannot
# FIRE the next ability until the previous one's animation ends. So the
# right shape for every step is: press the key until it fires -> swap
# immediately -> start spamming the next key straight away, so the first
# press that lands after the previous animation ends casts with zero gap.
# Consequences for the numbers below:
#   * A spam window is NOT "how long this move takes". It is "how long until
#     the PREVIOUS move's animation is over" plus a little slack, because
#     the window has to keep pressing until this move becomes castable.
#   * The FIRST move of a combo (nothing animating before it) fires on its
#     first press. Its window should be near zero - just enough retries to
#     cover one eaten press - then swap. Every ms past that is dead time.
#   * Swaps cost only the 60ms key press. Zero buffer either side, never
#     wait for an animation before swapping.
# Run-Steps already does swap->spam back-to-back with no wait; what this
# model changes is how the windows are SIZED, not the mechanics.

# --- Yama combos (F1/F2/F3) spam settings, 2026-09-04 ---------------------
# Every ability in the new combos is spammed for a window instead of tapped
# once, because none of their inter-move timings are known yet. A press that
# arrives during the previous move's animation does nothing; the first press
# that lands casts; later presses are eaten by cooldown. So a window only has
# to be LONG ENOUGH, not exact. Tune by shrinking $ycSpamDurationMs until a
# move starts getting skipped, then back off. Any single step can override
# these by giving its own duration/interval in the step list.
#
# CUT HARD 2026-09-04 per user ("combos must be incredibly quick, 2-3s").
# Was 600ms window / 80ms interval / 140ms swap buffers / 1400ms hold window
# = ~7.6s for the 7-move F1. Now:
#   F1: 350 hold + 7 x 260 windows + 6 x 60 slot presses = ~2.5s
#   F2: 8 x 260 + 6 x 60 = ~2.4s      F3: 8 x 260 + 5 x 60 = ~2.4s
# THE TRADE-OFF: a 260ms window means every move has ~260ms after the
# previous press-window ends to become castable. Any move whose PREVIOUS move
# animates longer than that gets skipped outright (the old combo's logs show
# Sanguine C needing ~600ms before Z would fire, and Kitsune X channelling
# ~1070ms). Physics, not the macro: total combo time cannot go below the sum
# of the moves' own animation lengths. If a specific move keeps getting
# skipped, give THAT step its own window in the step list, e.g.
#   @('spam', $keyZ, 600, 40)
# and leave the global tight. Every run logs "done in Nms" so you can see the
# real total.
$ycSpamDurationMs = 260   # per-ability spam window. 600 -> 260 (2026-09-04, per user)
$ycSpamIntervalMs = 40    # press cadence inside the window. 80 -> 40: ~7 attempts per window, same count 600/80 gave
$ycSwapBufferMs   = 0     # buffer either side of each slot press. 140 -> 0 (2026-09-04): matches $lateSwapRegisterMs, which the user already runs at 0 ("instant") in the old combo's tail swaps. A slot press now costs only its $slotKeyHoldMs (60ms). FIRST value to raise (try 40) if a style/Yama move comes out as a Kitsune move or vice versa.
# Godhuman C must register as HELD - the held version is the invulnerable,
# undodgeable one; the tap version is dodgeable. It is the FIRST move of F1,
# so nothing is animating when it fires and ONE hold attempt is enough -
# $ycHoldWindowMs = 0 means exactly one hold, no retry (1400 -> 0, 2026-09-04).
# $ycHoldGodCMs is the minimum hold that the game reads as "held" rather than
# tapped - unknown; 350 is a guess. If Godhuman C comes out as the tap
# version, raise this first (400, 450...). It is the single biggest fixed
# cost in F1 so do not pad it beyond what registers.
$ycHoldGodCMs   = 350     # 600 -> 350 (2026-09-04, per user)
$ycHoldWindowMs = 0       # 0 = one hold attempt only. 1400 -> 0 (2026-09-04, per user)
# Kitsune C when it follows SANGUINE C (F2, F3, E claw). Sanguine C is a
# long multi-phase move (projectile -> pull -> orbs) and the old combo's logs
# show ~600ms before the next ability would fire after it. With the global
# 260ms window Kit C was getting skipped (user, 2026-09-04) - so this one step
# gets its own wider window. Only the FIRST Kit C after Sang C; Godhuman's F1
# opener is unaffected. Trim toward 260 if Kit C fires reliably with room.
$ycKitCAfterSangCMs = 360     # 450 -> 360 (2026-09-05, per user: Kit C fires sooner than assumed, swap to Yama moderately sooner)
# Same problem after GODHUMAN C (F1): held C is dash -> seize -> charged punch
# -> knockback, a long animation, and Kit C was being skipped at the 260ms
# global (user, 2026-09-04). Own knob because Godhuman C's held animation is
# not the same length as Sanguine C's. Starts higher than the Sanguine one
# since the held punch is the longer move; trim toward 450 if it fires with
# room to spare, raise (700) if it still gets skipped.
$ycKitCAfterGodCMs = 560     # 550 -> 700 -> 560 (2026-09-05). 700 was set when Kit C was skipping at 550 - but that was with the OLD window meaning. Under the swap-as-soon-as-fired model this window only has to outlast Godhuman C's animation until Kit C FIRES, then we swap; per user Kit C fires sooner than assumed. Raise back toward 700 only if Kit C itself gets skipped.
# F8 toggle (2026-09-05). Godhuman C's TAP version is a fast dash-punch that
# commits instantly - no aim to hold while you're still coming off WASD. It
# IS dodgeable where the held one isn't, and its tracking (like every
# "autoaim" move in this build, Godhuman C included) is weak - miss by a few
# studs and it whiffs. Trade-off is yours per fight, hence a toggle not a
# setting. In tap mode the C press is spammed for $ycGodCTapWindowMs like any
# other ability (10ms keydown per press = unambiguously a tap).
$godCTapModeDefault = $false   # $false = F1 starts in HELD mode; $true = starts in TAPPED. $hotkeyGodCTapToggle flips it at runtime either way.
$ycGodCTapWindowMs  = 80       # 260 -> 80 (2026-09-05). FIRST move, nothing animating, fires on press 1; 80ms = 3 presses is enough to cover one eaten press. Swap follows immediately - Godhuman C's own animation is covered by $ycKitCAfterGodCTapMs, not by this.
# Opening style-C window for F2 / F3 / E claw (Sanguine C, E claw C). Same
# logic: first move, fires on press 1. 260 -> 80 (2026-09-05). The long
# Sanguine C animation is what $ycKitCAfterSangCMs is for.
$ycOpenerWindowMs   = 80
# Kit C window after a TAPPED Godhuman C. The tap animation is shorter than
# the held dash->seize->punch, so this can probably be trimmed below the held
# value, but no data yet - starts equal to $ycKitCAfterGodCMs. Trim toward
# 550 once tap mode has been seen firing Kit C with room to spare.
$ycKitCAfterGodCTapMs = 560   # 700 -> 560 (2026-09-05, same reason as the held knob above; tap animation is if anything shorter)
# Kit F window in the F1/F2/F3 (and E claw) step lists. 260 -> 300
# (2026-09-05, per user: "slightly increase to make it more robust"). One
# extra press attempt at the 40ms cadence. F4/F5's Kit F uses its own
# $spamKitFDurationMs (already 300) and is unchanged.
$ycKitFWindowMs = 300
# Yama X window in every step-list combo. History 2026-09-05: 260 -> 120
# (user: "decrease by a lot") -> Yama X got skipped -> another session took
# it 200 -> 300 -> 1000 from the user's F6 hand recordings (swap-to-3 ->
# LAST X press: 1011 / 1365 / 1079ms). User then said the swaps were far too
# slow and that those recordings include their own hand variance. So: the
# 120 was wrong (Kit C's own animation is still running when we swap - Yama
# X is NOT castable straight after the swap, the window has to outlast Kit
# C's end-lag), and the 1000 was hand-spam-until-you-notice-it-fired, which
# overshoots the real ready-moment by a reaction time. Set from the FASTEST
# trial minus ~200ms hand lag. Raise to 900, then 1000, if Yama X gets
# skipped; that is the only reason to go up. The swap itself costs 60ms -
# the "slow swap" you see is THIS window draining, and the one before it.
$ycYamaXWindowMs = 800
# Kitsune Z where it directly follows Yama X (F1 tail, F2, E claw). Same
# story: hand data swap-to-2 -> last Z was 952 / 1313ms because Yama X's
# animation is still playing when we swap back. The 260 global was too
# short; the 950 the other session set was the raw hand number. Fastest
# trial minus hand lag. Raise to 850, then 950, if Kit Z gets skipped. F3's
# Kit Z follows Kit F, not Yama X, and keeps the global.
$ycKitZAfterYamaXMs = 750

# --- Timings (ms). Researched 2026-09-02: no source anywhere (wiki, patch
# notes, guides, community macro threads) publishes exact animation/channel
# length in ms - only stun/disable durations, which are baked in separately.
# Every value below is an estimate with a small +30ms safety buffer on top of
# the bare-minimum estimate. Calibrate on a dummy before relying on this live.
#
# HARD lock  = the game itself won't take input until this much time passes.
# SELF-RECOVERY estimate = your own cast animation ending - undocumented,
# cut as tight as your dummy test allows.

$delayAfterKitCMs = 300   # 350 -> 300 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3). Kit C -> Sang C total budget; with $preSwapRegisterMs now 0 this is all idle wait, so it is the real Kit C end-lag estimate. Raise if Sang C never comes out.    | was: HARD: your own end-lag after the tap. TOTAL budget for the Kitsune C -> swap -> Sanguine C stretch; Press-SlotKey's two 170ms buffers (+10ms press) consume all of it now, leaving zero idle slack. Cut 450 -> 380 -> 350 across 2026-09-03 as Sanguine C kept firing slightly late. Raise if Kitsune C starts getting cut off.
$delayAfterSangCMs = 900   # SELF-RECOVERY estimate, RAISED AGAIN 2026-09-02: 300ms still dropped Z in every test. Sanguine C is NOT a single quick hit - the move description is multi-phase (projectile travel -> grab/pull-in -> summon 5 orbs -> orb attacks), and that whole sequence plays out on YOUR end, not just the ~1.2s lock on the target. 900ms is a deliberately generous starting point to confirm Z fires reliably at all; once confirmed, calibrate DOWN from here in ~100ms steps rather than guessing up from a too-low number again.
$delayAfterSangZMs = 700   # SELF-RECOVERY estimate. Was 1080 (from recorded data, Sanguine C landing to Z landing) - cut down 2026-09-02 per user request now that this is directly the Z-to-X gap (Kitsune X removed). Tune further from here.
$delayAfterKitXMs  = 1070  # HARD: X channels on hit since 31.4 - LOCKED in your own animation. Nudged up from 930 2026-09-02 based on user's manual-spam recording (~1069ms observed).
$delayAfterSangXMs = 80    # SELF-RECOVERY estimate, tightened 2026-09-02. Real gap when order is swapped; harmless trailing wait otherwise.
$delayAfterKitFMs  = 700   # SELF-RECOVERY estimate, UNTESTED 2026-09-02 - combo v2 is brand new, no prior data for Kitsune F ("Wild Assault": dash forward, claw flurry on connect) in this combo at all. Pure placeholder - calibrate with F3 recording before trusting it.
$delayAfterSangZBeforeKitFMs = 0     # extra beat before swapping to Kitsune for F (combo v2 only), ON TOP of Press-SlotKey's own 170ms pre-swap buffer. Dropped 180 -> 0 on 2026-09-03 per user: the shortened Z window is meant to be replaced BY the switch, so the switch starts immediately once Z's spam ends rather than idling first.

# $swapKitsuneAndSanguineX: $false (default) = ...Sanguine[Z] -> Kitsune[X] -> Sanguine[X]
#                           $true             = ...Sanguine[Z] -> Sanguine[X] -> Kitsune[X]
# Swapping puts Kitsune X - the move with the hard channel-lock - LAST instead
# of second-to-last, removing the risk of it eating the finisher. Try both on
# a dummy; there's no published data saying which lands more reliably.
$swapKitsuneAndSanguineX = $false

$m1Count = 0     # optional filler (0 = off)
$m1DelayMs = 120

# Sanguine X ("Scarlet Tear") is a skillshot whose real cooldown-to-actually-
# fire depends on distance to the target, so a single fixed delay can't cover
# it reliably. 2026-09-02, per user: instead of one tap, wait a short beat
# after Z then spam X repeatedly for a window, since spamming until it lands
# is how this is actually played by hand (see the F2 recording feature).
# --- All spam windows below are set from the user's F3 hand-recordings
# (2026-09-03), taking the SHORTEST of their runs per the user's
# instruction. Their fastest full combo is ~4965ms end to end. Interval
# 150ms matches their ~106-200ms hand cadence throughout. ---

$spamSangX = $true
$spamSangXInitialWaitMs = 0     # equip -> first Sanguine X attempt. 156 -> 109 -> 40 -> 0 across 2026-09-03: the zero lead-in was trialled as combo v3 (F5), confirmed better, and promoted to the default here.
$spamSangXDurationMs = 300   # 520 -> 300 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3).     | was: 700 -> 520 on 2026-09-03 per user; still ~7 attempts at the 70ms interval now that logging no longer inflates it
$spamSangXIntervalMs = 40   # 70 -> 40 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3).      | was: densest spam in the combo (150 -> 70 on 2026-09-03 per user "spam much more"): first retry now lands 70ms after the opening press instead of 150ms

# Kitsune X (channels on hit since 31.4) also spammed now instead of a
# single tap, same rationale as Sanguine X above. 2026-09-02, per user.
$spamKitX = $true
$spamKitXInitialWaitMs = 0     # equip -> first Kitsune X attempt. 202 -> 141 -> 40 -> 0 across 2026-09-03 (zero lead-in promoted from combo v3).
$spamKitXDurationMs = 240   # 240 -> 240 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3). unchanged - last move, costs nothing downstream.    | was: ~3 attempts at the tightened 80ms interval - more tries than the old 210/150 gave (~1-2), while finishing sooner. Kitsune X is the last move, so this window delays nothing after it.
$spamKitXIntervalMs = 40   # 80 -> 40 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3).      | was: 150 -> 80 on 2026-09-03 per user, matching Kitsune F's cadence

# Sanguine C often fails to fire while airborne (2026-09-03, per user). A
# single press has no retry, so an airborne rejection just loses the move
# outright. C is an ability key, not a slot key, so spamming it is safe (no
# equip/unequip toggle risk). The spam window is subtracted from
# $delayAfterSangCMs below, so total time to the next move is unchanged and
# nothing downstream shifts later.
$spamSangC = $true
$spamSangCInitialWaitMs = 0     # start attempting immediately after Press-SlotKey's 170ms post-swap buffer. Dropped 40 -> 0 on 2026-09-03: C was still firing slightly late, and there is no reason to sit idle - a press that arrives too early is simply ignored and retried by the spam below.
$spamSangCDurationMs = 400   # 600 -> 400 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3). Kept wider than the 260 global: the last logged run shows Sang C needing ~4 presses. First to raise (500) if Sang C gets skipped.    | was: window length; with the 100ms interval that's ~6 attempts. Cut 780 -> 600 on 2026-09-03 per user: this whole window must elapse before Sanguine Z starts, so shortening it pulls Z (and everything after) earlier by the same amount. Raise back toward 780 if C starts getting missed.
$spamSangCIntervalMs = 50   # 100 -> 50 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3). ~8 attempts in the window.    | was: tightened 150 -> 100 so the ready-moment is caught sooner rather than up to 150ms after it opens

$spamSangZ = $true
$spamSangZInitialWaitMs = 0   # 40 -> 0 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3). Early presses are free.     | was: last Sanguine C press -> first Z attempt (no swap, same slot). Cut 250 -> 100 -> 40 across 2026-09-03: Z kept firing late. Early presses are harmless here - they just get eaten and retried by the spam.
$spamSangZDurationMs = 450   # 600 -> 450 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3). Kept wider than global: log shows Z needing 5-7 presses at 100ms (~600ms) before it fires - Sang C animates long. Raise (550) if Z gets skipped.    | was: RAISED BACK 200 -> 600 on 2026-09-03: the log showed Z getting only 2 presses and never firing, while the user's own hand-recordings needed 5-7 before it came out. At the 100ms interval this is ~6 attempts. Was trimmed 700 -> 300 -> 200 earlier that day; 200 was too far. Cut 700 -> 300 on 2026-09-03 per user: drop 4 of the 7 Z presses and spend that time switching to Kitsune instead. Z's cast length VARIES WITH TARGET DISTANCE, so the tail presses were usually landing after Z had already gone off anyway - dead time that just delayed the swap. Deliberately below worst case: whatever comes next is spammed too, so a press arriving while Z is still running is just eaten and retried.
$spamSangZIntervalMs = 50   # 100 -> 50 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3). ~9 attempts in the window, more than the 6 it used to get.    | was: tightened 150 -> 100, same reason as Sanguine C above

$spamKitF = $true
$spamKitFInitialWaitMs = 0      # equip -> first Kitsune F attempt. 126 -> 40 -> 0 across 2026-09-03 (zero lead-in promoted from combo v3).
$spamKitFDurationMs = 300   # 600 -> 300 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3). Kit F follows a slot swap, nothing animating on the Kitsune side, so a short window should do. Raise (400) if F gets skipped.     | was: 780 -> 600 on 2026-09-03 per user. Still ~8 attempts at the 80ms interval - the same count 780ms used to deliver, because the per-keypress log write that was inflating every interval by ~85ms is gone.
$spamKitFIntervalMs = 40   # 80 -> 40 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3).       | was: densest spam in the combo (150 -> 80 on 2026-09-03 per user): ~8 attempts in the window, vs ~4 before. F has been the least reliable move to come out, so it gets the most retries.

# Equip-swap keys are pressed exactly once (see Press-SlotKey below) - a slot
# key TOGGLES equip/unequip in Roblox, and both time-based spam and odd-count
# redundancy were tried and reverted 2026-09-02 (spam caused equip/unequip
# flicker; odd-count redundancy added ~80ms of "equip -> act" latency that
# was too slow). A dropped equip press is a real but accepted risk now.
$debugLog = $true    # prints a timestamped log of every keypress to the console. Turn off once timings are dialed in.

# ---------------------------- WIN32 P/INVOKE --------------------------------

Add-Type @"
using System;
using System.Runtime.InteropServices;

public static class Native {
    [StructLayout(LayoutKind.Sequential)]
    public struct INPUT {
        public uint type;
        public InputUnion U;
    }

    [StructLayout(LayoutKind.Explicit)]
    public struct InputUnion {
        [FieldOffset(0)] public KEYBDINPUT ki;
        [FieldOffset(0)] public MOUSEINPUT mi;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct KEYBDINPUT {
        public ushort wVk;
        public ushort wScan;
        public uint dwFlags;
        public uint time;
        public IntPtr dwExtraInfo;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct MOUSEINPUT {
        public int dx;
        public int dy;
        public uint mouseData;
        public uint dwFlags;
        public uint time;
        public IntPtr dwExtraInfo;
    }

    public const uint INPUT_KEYBOARD = 1;
    public const uint INPUT_MOUSE = 0;
    public const uint KEYEVENTF_KEYUP = 0x0002;
    public const uint KEYEVENTF_SCANCODE = 0x0008;
    public const uint MOUSEEVENTF_LEFTDOWN = 0x0002;
    public const uint MOUSEEVENTF_LEFTUP = 0x0004;
    public const uint MAPVK_VK_TO_VSC = 0x00;

    [DllImport("user32.dll", SetLastError = true)]
    public static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);

    [DllImport("user32.dll")]
    public static extern uint MapVirtualKey(uint uCode, uint uMapType);

    // Windows' default scheduler timer resolution is ~15.6ms, so Start-Sleep
    // -Milliseconds 10 actually sleeps ~15.6ms - every wait in this script
    // was inflated ~55-60% by this, confirmed via debug log 2026-09-02
    // (a nominal 900ms wait measured at ~1420ms actual). timeBeginPeriod(1)
    // asks Windows for 1ms scheduler granularity system-wide for as long as
    // this process is running, which is the standard fix and is what
    // AutoHotkey/most games already do implicitly. Reset with
    // timeEndPeriod(1) on exit since this is a system-wide setting.
    [DllImport("winmm.dll", EntryPoint = "timeBeginPeriod")]
    public static extern uint TimeBeginPeriod(uint uMilliseconds);

    [DllImport("winmm.dll", EntryPoint = "timeEndPeriod")]
    public static extern uint TimeEndPeriod(uint uMilliseconds);

    // Roblox (like most games) reads hardware scan codes, not virtual-key
    // codes. Plain SendInput with wVk set and no scan code is silently
    // ignored by the game even though it works fine against normal Windows
    // apps/text fields. Sending KEYEVENTF_SCANCODE with the real hardware
    // scan code (via MapVirtualKey) makes this indistinguishable from a
    // physical keypress, which is what AutoHotkey's Send does by default —
    // this is why the original AHK version worked and the first VK-only
    // version of this script did not.
    public static void KeyDown(ushort vk) {
        ushort scan = (ushort)MapVirtualKey(vk, MAPVK_VK_TO_VSC);
        INPUT[] inputs = new INPUT[1];
        inputs[0].type = INPUT_KEYBOARD;
        inputs[0].U.ki = new KEYBDINPUT { wVk = 0, wScan = scan, dwFlags = KEYEVENTF_SCANCODE, time = 0, dwExtraInfo = IntPtr.Zero };
        SendInput(1, inputs, Marshal.SizeOf(typeof(INPUT)));
    }

    public static void KeyUp(ushort vk) {
        ushort scan = (ushort)MapVirtualKey(vk, MAPVK_VK_TO_VSC);
        INPUT[] inputs = new INPUT[1];
        inputs[0].type = INPUT_KEYBOARD;
        inputs[0].U.ki = new KEYBDINPUT { wVk = 0, wScan = scan, dwFlags = KEYEVENTF_SCANCODE | KEYEVENTF_KEYUP, time = 0, dwExtraInfo = IntPtr.Zero };
        SendInput(1, inputs, Marshal.SizeOf(typeof(INPUT)));
    }

    public static void MouseLeftClick() {
        INPUT[] inputs = new INPUT[2];
        inputs[0].type = INPUT_MOUSE;
        inputs[0].U.mi = new MOUSEINPUT { dx = 0, dy = 0, mouseData = 0, dwFlags = MOUSEEVENTF_LEFTDOWN, time = 0, dwExtraInfo = IntPtr.Zero };
        inputs[1].type = INPUT_MOUSE;
        inputs[1].U.mi = new MOUSEINPUT { dx = 0, dy = 0, mouseData = 0, dwFlags = MOUSEEVENTF_LEFTUP, time = 0, dwExtraInfo = IntPtr.Zero };
        SendInput(2, inputs, Marshal.SizeOf(typeof(INPUT)));
    }
}
"@

# Virtual-key codes for the keys we need.
$VK = @{
    'Z' = 0x5A; 'X' = 0x58; 'C' = 0x43; 'F' = 0x46
    '1' = 0x31; '2' = 0x32; '3' = 0x33
    'F1' = 0x70
    'F2' = 0x71
    'F3' = 0x72
    'F4' = 0x73
    'F5' = 0x74
    'F6' = 0x75
    'F7' = 0x76
    'F8' = 0x77
    'F9' = 0x78
    'Escape' = 0x1B
    'Tab' = 0x09
}

# ---------------------------- STATE -----------------------------------------

$script:running = $false
$script:godCTapMode = $godCTapModeDefault   # flipped by $hotkeyGodCTapToggle - see $hotkeyGodCTapToggle

# Debug logging: prints every raw keypress with a millisecond-precision
# timestamp so a run can be correlated against what actually happened
# in-game (or a slow-motion recording), instead of guessing blind. Set
# $debugLog = $false in CONFIG to silence it once timings are dialed in.
$script:comboStartTime = $null

# Everything logged to console is also appended to this file, so a run can be
# reviewed after the fact regardless of who launched the script or whether
# the console is still open. Added 2026-09-03.
$script:logFile = Join-Path $PSScriptRoot "combo-log.txt"
$script:logBuffer = [System.Collections.Generic.List[string]]::new()

# FIXED 2026-09-03: this used to Add-Content (a disk write) on EVERY
# keypress. That cost ~85ms per press - confirmed from the log itself, where
# a configured 100ms spam interval was landing ~185ms apart - which silently
# inflated every interval in the combo and cost real attempts inside each
# spam window. Lines are now buffered in memory and flushed once at the end
# of a run, so logging no longer distorts the timings it is measuring.
function Write-Log {
    param([string]$Text, [string]$Color = 'DarkGray')
    Write-Host $Text -ForegroundColor $Color
    $script:logBuffer.Add($Text)
}

function Flush-Log {
    if ($script:logBuffer.Count -eq 0) { return }
    try { Add-Content -Path $script:logFile -Value $script:logBuffer -ErrorAction Stop } catch { }
    $script:logBuffer.Clear()
}

function Log-Key {
    param([string]$Key)
    if (-not $debugLog) { return }
    if ($null -eq $script:comboStartTime) { $script:comboStartTime = Get-Date }
    $elapsed = [int](New-TimeSpan -Start $script:comboStartTime -End (Get-Date)).TotalMilliseconds
    Write-Log ("  [+{0,5}ms] press {1}" -f $elapsed, $Key)
}

# Raw keypress, no wait attached - callers decide what to wait for. $HoldMs
# is the keydown-to-keyup gap - longer for slot-swap keys (see below) since
# those can't be safely spammed: pressing the SAME hotbar slot number twice
# toggles equip/unequip in Roblox, so spam-retrying a slot key alternately
# equips and unequips it and ends in an unpredictable state (confirmed by
# user testing 2026-09-02). A held-longer single press is the safe way to
# make it more likely to register alongside concurrent physical input (e.g.
# Space for jump/flight) without that toggle risk.
function Press-Key {
    param([string]$Key, [int]$HoldMs = 10)
    if (-not $script:running) { return $false }
    Log-Key $Key
    [Native]::KeyDown($VK[$Key])
    Start-Sleep -Milliseconds $HoldMs
    [Native]::KeyUp($VK[$Key])
    return $true
}

# Waits a short registration buffer, presses a hotbar slot key, then waits
# ANOTHER short buffer before returning. FIXED 2026-09-02 (two rounds):
# (1) every swap EXCEPT the first was pressing the slot key with ZERO delay
# right after the previous move, so the previous ability's animation was
# still playing when the swap landed. (2) even after fixing that, the very
# NEXT ability (Kitsune F) was then pressed with ZERO delay after the swap
# itself - confirmed via debug log: swap at +2675ms, F pressed +2706ms (31ms
# later), and F never fired at all (still-equipped Sanguine has no F move -
# not a whiff, a dead keypress). The swap needs a moment to actually
# register client-side before whatever's newly equipped can be used. Both
# sides now get a buffer.
# FIXED 2026-09-03: this called Press-Key WITHOUT $HoldMs, so every equip
# press was a 10ms keydown - despite Press-Key's own comment saying slot keys
# need to be held longer. A real human keypress is ~50-100ms. 10ms is fine
# for an ability key (registers on the press edge) but marginal for a hotbar
# equip, which is exactly why the swap intermittently "didn't equip".
function Press-SlotKey {
    param([string]$Slot, [int]$BufferMs = -1)
    if ($BufferMs -lt 0) { $BufferMs = $preSwapRegisterMs }
    if (-not (Wait-Interruptible $BufferMs)) { return $false }
    if (-not (Press-Key $Slot $slotKeyHoldMs)) { return $false }
    return Wait-Interruptible $BufferMs
}

function Tap-Key {
    param([string]$Key, [int]$DelayMs)
    if (-not (Press-Key $Key)) { return $false }
    return Wait-Interruptible $DelayMs
}

# Presses $Key repeatedly every $IntervalMs for $DurationMs total, instead of
# once - for a move whose real activation window varies (e.g. distance-
# dependent) and is more reliably hit by spamming than by guessing one delay.
function Spam-Key {
    param([string]$Key, [int]$DurationMs, [int]$IntervalMs)
    $elapsed = 0
    while ($true) {
        if (-not (Press-Key $Key)) { return $false }
        $elapsed += $IntervalMs
        if ($elapsed -ge $DurationMs) { break }   # 2026-09-04: no idle interval after the LAST press - saves one $IntervalMs per spam step, the next step starts right away
        if (-not (Wait-Interruptible $IntervalMs)) { return $false }
    }
    return $true
}

# How long to wait after firing an ability before pre-swapping equipment.
# FIXED 2026-09-02: swapping at 0ms (immediately back-to-back with the
# ability keypress) caused Sanguine Z to silently fail to fire/appear
# entirely in testing - the game needs a brief moment to actually register
# the ability activation before the equipped item changes out from under it,
# or the activation gets cancelled. This buffer is intentionally small: the
# whole point of pre-swapping is to ride inside the move's own recovery
# delay, not add a second full delay on top of it.
$slotKeyHoldMs = 60        # keydown duration for hotbar slot keys. Ability keys use the 10ms default, which registers fine on the press edge, but a 10ms equip press is marginal - a real hand press is ~50-100ms. Added 2026-09-03 when the first swap kept failing.
$lateSwapRegisterMs = 0    # swap buffer for the two TAIL swaps (Kitsune F -> Sanguine X, and Sanguine X -> Kitsune X). Trimmed 170 -> 60 -> 35 -> 0 across 2026-09-03 per user ("instant"): those swaps now cost only the 60ms key press itself. Deliberately separate from $preSwapRegisterMs below so the opening Kitsune C -> Sanguine swap - the one that broke when cut - keeps its full 170ms. If Kitsune X or Sanguine X stop firing at the end, this is the first value to raise.
$preSwapRegisterMs = 0   # 140 -> 0 (2026-09-04 SUPERSPEED, per user: F4/F5 must be 2-3s like F1-F3). Matches $lateSwapRegisterMs and $ycSwapBufferMs, both already 0. The old 140 was applied on BOTH sides of the opening swap (280ms) and the Z->F swap (280ms) = 560ms of the old 5.1s run. If the opening Kit C -> Sanguine swap breaks again (style move comes out as Kitsune), raise to 40, then 80 - not back to 140.    | was: 170 -> 140 on 2026-09-03 per user. CAUTION: 120 broke this swap earlier the same day, but that was while the per-keypress log write was adding ~85ms of hidden padding on top - so the effective buffer back then was ~205ms, not 120ms. With that overhead now removed, this value is closer to its real cost than any earlier number was. If the Kitsune C -> Sanguine swap starts missing again, raise this first. Briefly tried 120ms and the first Kitsune->Sanguine swap stopped working - their real ability->swap gaps are 125ms and 168ms, so 120 was under both. 170 sits at the top of their observed range; do not cut below ~125 again. (Per-move swap->ability gaps are handled separately by each move's own $spam*InitialWaitMs.)

# Fires $Key, then swaps to the next hotbar slot via Press-SlotKey (which
# now owns the registration-buffer wait itself), then waits out whatever's
# left of $DelayMs. Net wait is still just $DelayMs total - the swap rides
# inside it instead of adding to the critical path.
function Tap-Then-PreSwap {
    param([string]$Key, [string]$NextSlot, [int]$DelayMs)
    if (-not (Press-Key $Key)) { return $false }
    if (-not (Press-SlotKey $NextSlot)) { return $false }
    $remainingMs = [Math]::Max(0, $DelayMs - (2 * $preSwapRegisterMs) - 10)   # Press-SlotKey now waits register on BOTH sides of the press
    return Wait-Interruptible $remainingMs
}

# Interruptible sleep - false if aborted mid-wait (Escape or Tab set $script:running = $false).
function Wait-Interruptible {
    param([int]$DelayMs)
    $elapsed = 0
    while ($elapsed -lt $DelayMs) {
        if (-not $script:running) { return $false }
        if (([Native]::GetAsyncKeyState($VK[$hotkeyAbort]) -band 0x8000) -or ([Native]::GetAsyncKeyState($VK[$hotkeyAbort2]) -band 0x8000)) {
            $script:running = $false
            return $false
        }
        Start-Sleep -Milliseconds 10
        $elapsed += 10
    }
    return $script:running
}

# --- Shared opening: Kitsune[C] -> Sanguine[C] -> Sanguine[Z]. Identical in
# both combo variants. Returns $false the instant anything fails/aborts. ---
function Do-OpeningSteps {
    # 1. Kitsune C: the confirmed Instinct break. Spend it up front. Quick
    # tap, NOT a hold. Assumes Kitsune is ALREADY the active hotbar slot when
    # you press the trigger. Pre-swap to Sanguine immediately after firing -
    # equip-swapping has no cooldown, so it rides inside this move's own
    # recovery wait instead of adding a separate delay.
    if (-not (Tap-Then-PreSwap $keyC $slotFightStyle $delayAfterKitCMs)) { return $false }

    # 2. Sanguine C into the Instinct-broken target: starts the ~1.2s
    # input-disable. Already on the fight-style slot from the pre-swap above.
    # $spamSangC ($true, default): retries for a short window because a
    # single press often fails outright while airborne (2026-09-03, per
    # user). The spam window is subtracted from the recovery wait, so the
    # total time before Sanguine Z is unchanged either way.
    if ($spamSangC) {
        if (-not (Wait-Interruptible $spamSangCInitialWaitMs)) { return $false }
        if (-not (Spam-Key $keyC $spamSangCDurationMs $spamSangCIntervalMs)) { return $false }
    } else {
        if (-not (Tap-Key $keyC $delayAfterSangCMs)) { return $false }
    }

    # 3. Sanguine Z: heals 20% max HP even if dodged, lands inside the
    # disable window. Already on the fight-style slot - no swap needed.
    # Spammed since 2026-09-03 (F3 recording shows ~797ms of hand-spamming
    # before it fires); was a single press before that.
    if ($spamSangZ) {
        if (-not (Wait-Interruptible $spamSangZInitialWaitMs)) { return $false }
        if (-not (Spam-Key $keyZ $spamSangZDurationMs $spamSangZIntervalMs)) { return $false }
    } else {
        if (-not (Press-Key $keyZ)) { return $false }
    }

    return $true
}

# Sanguine X, wherever it falls in a combo. $spamSangX ($true, default):
# Sanguine X's real activation window is distance-dependent (it's a
# skillshot), so one fixed delay can't cover it reliably. Wait a short beat,
# then spam X for a window instead of a single guessed-timing tap - this is
# also how it's actually played by hand (see the F3 recording feature).
function Do-SanguineX {
    if ($spamSangX) {
        # The move before this one (Sanguine Z, or Kitsune F in combo v2) now
        # spams for its own full window, which already absorbs its cast time -
        # so this only needs the short hand-gap the user actually leaves
        # between a move landing and the next input (~180ms in the F3
        # recording), not another full recovery wait on top.
        if (-not (Wait-Interruptible $spamSangXInitialWaitMs)) { return $false }
        if (-not (Spam-Key $keyX $spamSangXDurationMs $spamSangXIntervalMs)) { return $false }
    } else {
        if (-not (Wait-Interruptible $delayAfterSangZMs)) { return $false }
        if (-not (Tap-Key $keyX $delayAfterSangXMs)) { return $false }
    }
    return $true
}

# Kitsune X: always the last move in both combos. $spamKitX ($true, default):
# same rationale as Do-SanguineX - spam for a window instead of one guessed-
# timing tap. Assumes you're already on the Kitsune slot when called.
function Do-KitsuneX {
    if ($spamKitX) {
        if (-not (Wait-Interruptible $spamKitXInitialWaitMs)) { return $false }
        return Spam-Key $keyX $spamKitXDurationMs $spamKitXIntervalMs
    } else {
        return Press-Key $keyX
    }
}

function Do-M1Filler {
    for ($i = 0; $i -lt $m1Count; $i++) {
        if (-not $script:running) { return $false }
        [Native]::MouseLeftClick()
        if (-not (Wait-Interruptible $m1DelayMs)) { return $false }
    }
    return $true
}

# Runs $StepsBlock inside the running/logging/cleanup wrapper shared by both
# combo variants, so neither variant has to repeat this bookkeeping.
function Invoke-Combo {
    param([string]$Label, [scriptblock]$StepsBlock)
    $script:running = $true
    $script:comboStartTime = Get-Date
    Write-Log ("--- $Label fired ({0:HH:mm:ss}) ---" -f (Get-Date)) 'Yellow'
    try {
        & $StepsBlock
    }
    finally {
        # Safety net: release every key this script could conceivably still
        # be holding, in case a variant exited mid-hold via an unexpected path.
        [Native]::KeyUp($VK[$keyC])
        [Native]::KeyUp($VK[$keyX])
        [Native]::KeyUp($VK[$keyZ])
        [Native]::KeyUp($VK[$keyF])
        $totalMs = [int](New-TimeSpan -Start $script:comboStartTime -End (Get-Date)).TotalMilliseconds
        Write-Log ("--- done in {0}ms ---" -f $totalMs) 'Yellow'   # real end-to-end time, for hitting the 2-3s target (2026-09-04)
        $script:running = $false
        Flush-Log   # write the whole run's log in one go - never mid-combo, see Write-Log
    }
}

# --- Partial-combo test (F4), 2026-09-03. Built up incrementally as each
# stage is confirmed working, so a failure can be isolated to the stage just
# added instead of hunting through the whole combo. Uses the exact same code
# paths the real combo uses, so behaviour here matches behaviour there.
#   Stage 1 (confirmed working): Kitsune C -> equip Sanguine
#   Stage 2 (confirmed working): -> Sanguine C
#   Stage 3 (testing now):       -> Sanguine Z
# Stages 1-3 are exactly Do-OpeningSteps, so this now tests the whole shared
# opening that BOTH combos run.
# ---
function Run-SwapTest {
    Invoke-Combo "partial test (opening: Kitsune C -> equip -> Sanguine C -> Sanguine Z)" {
        if (-not (Do-OpeningSteps)) { return }
    }
}

# --- Combo v1 (F1), TRUNCATED 2026-09-03 per user: now stops after
# Sanguine Z instead of continuing into Sanguine X -> Kitsune X. It is the
# opening only - Kitsune[C] -> [swap] -> Sanguine[C] -> Sanguine[Z] - which
# is exactly the stretch of combo v2 that comes before Kitsune F. Both run
# the same Do-OpeningSteps, so F1 and F2 are identical up to that point. ---
function Run-Combo {
    Invoke-Combo "combo v1 (opening only, stops after Sanguine Z)" {
        if (-not (Do-OpeningSteps)) { return }

        Do-M1Filler | Out-Null
    }
}

# --- Combo v2 (F2), REORDERED 2026-09-03 to match how the user actually
# plays it by hand (per their F3 recordings):
#   Kitsune[C] -> [swap] -> Sanguine[C] -> Sanguine[Z] -> [swap] ->
#   Kitsune[F] -> [swap] -> Sanguine[X] -> [swap] -> Kitsune[X]
# X's run Sanguine-first per the user (2026-09-03). That costs a swap versus
# grouping F and Kitsune X together, but it's the order they want. ---
function Do-Combo2Steps {
    if (-not (Do-OpeningSteps)) { return $false }
    if (-not (Wait-Interruptible $delayAfterSangZBeforeKitFMs)) { return $false }

    # Kitsune F ("Wild Assault"): dash forward, claw flurry on connect.
    # Spammed since 2026-09-03 - a single tap was why it appeared to
    # "not fire" at all.
    if (-not (Press-SlotKey $slotFruit)) { return $false }
    if ($spamKitF) {
        if (-not (Wait-Interruptible $spamKitFInitialWaitMs)) { return $false }
        if (-not (Spam-Key $keyF $spamKitFDurationMs $spamKitFIntervalMs)) { return $false }
    } else {
        if (-not (Tap-Key $keyF $delayAfterKitFMs)) { return $false }
    }

    # Sanguine X - REORDERED 2026-09-03 per user ("definitely sang x before
    # kit x"): X's now run Sanguine-first, which costs an extra swap (F and
    # Kitsune X no longer share the Kitsune slot back-to-back) but is the
    # order the user wants. Uses the instant $lateSwapRegisterMs buffer.
    if (-not (Press-SlotKey $slotFightStyle $lateSwapRegisterMs)) { return $false }
    if (-not (Do-SanguineX)) { return $false }

    # Kitsune X: the finisher. Channels on hit (31.4), but nothing follows
    # it, so that lock costs nothing here. Uses the reduced
    # $lateSwapRegisterMs buffer to keep the Sanguine X -> Kitsune X gap tight.
    if (-not (Press-SlotKey $slotFruit $lateSwapRegisterMs)) { return $false }
    if (-not (Do-KitsuneX)) { return $false }

    Do-M1Filler | Out-Null
    return $true
}

# Combo v3 (old F5) was folded into v2 on 2026-09-03 once its zero-lead-in
# behaviour was confirmed better - those lead-ins are now simply 0 in CONFIG,
# so v2 IS what v3 was and the separate hotkey/flag are gone.
function Run-Combo2 {
    Invoke-Combo "combo v2" {
        Do-Combo2Steps | Out-Null
    }
}

# ---------------------------- YAMA COMBOS (2026-09-04) ----------------------
# Three new combos using Yama on slot 3, written as plain step lists so the
# order can be changed by editing one line. Step forms:
#   @('swap', slot)                        press a hotbar key once (Press-SlotKey, $ycSwapBufferMs each side)
#   @('spam', key)                         spam key for $ycSpamDurationMs every $ycSpamIntervalMs
#   @('spam', key, durationMs, intervalMs) same, with per-step override
#   @('hold', key)                         hold key $ycHoldGodCMs, release, retry within $ycHoldWindowMs
#   @('hold', key, holdMs, windowMs)       same, with per-step override
#
# ASSUMPTION: the fighting style is ALREADY equipped when you press the
# trigger - all three open with a style move, so there is no leading swap
# (a slot key TOGGLES equip, so pressing 1 while 1 is already equipped
# would unequip it). Same convention as the old combos, which assume Kitsune.
#
# Kitsune X channels on hit (31.4): presses for the NEXT step are eaten until
# the channel ends (~1070ms observed in the old combo). With the 260ms global
# window the move after Kit X is the MOST likely to be skipped when Kit X
# connects. If it is, give that step a longer window, e.g.
#   @('spam', $keyX, 1000, 40)
# - or move Kit X to the end of the combo where nothing follows it.

# Hold a key for $HoldMs then release. Interruptible - the key is ALWAYS
# released, including on abort.
function Hold-Key {
    param([string]$Key, [int]$HoldMs)
    if (-not $script:running) { return $false }
    Log-Key "$Key (hold ${HoldMs}ms)"
    [Native]::KeyDown($VK[$Key])
    $ok = Wait-Interruptible $HoldMs
    [Native]::KeyUp($VK[$Key])
    return $ok
}

# Repeat {hold, release} until $WindowMs has elapsed (at least once).
function HoldSpam-Key {
    param([string]$Key, [int]$HoldMs, [int]$WindowMs)
    $elapsed = 0
    do {
        if (-not (Hold-Key $Key $HoldMs)) { return $false }
        $elapsed += $HoldMs
        if ($elapsed -ge $WindowMs) { break }   # no idle gap after the final hold - the next step starts immediately
        if (-not (Wait-Interruptible $ycSpamIntervalMs)) { return $false }
        $elapsed += $ycSpamIntervalMs
    } while ($true)
    return $true
}

function Run-Steps {
    param([object[]]$Steps)
    foreach ($step in $Steps) {
        if (-not $script:running) { return $false }
        switch ($step[0]) {
            'swap' {
                if (-not (Press-SlotKey $step[1] $ycSwapBufferMs)) { return $false }
            }
            'spam' {
                $dur = if ($step.Count -ge 3) { $step[2] } else { $ycSpamDurationMs }
                $int = if ($step.Count -ge 4) { $step[3] } else { $ycSpamIntervalMs }
                if (-not (Spam-Key $step[1] $dur $int)) { return $false }
            }
            'hold' {
                $hold = if ($step.Count -ge 3) { $step[2] } else { $ycHoldGodCMs }
                $win  = if ($step.Count -ge 4) { $step[3] } else { $ycHoldWindowMs }
                if (-not (HoldSpam-Key $step[1] $hold $win)) { return $false }
            }
            default { Write-Log "  unknown step type '$($step[0])' - aborting" 'Red'; return $false }
        }
    }
    return $true
}

# F1 - Godhuman C + Kitsune C + Yama X + Kitsune Z X + Godhuman X + Kit F + Godhuman Z
#      Ping / reaction-speed dependent. Godhuman must be the equipped style.
# Split 2026-09-05 into two OPENERS (picked at run time by the $hotkeyGodCTapToggle toggle) and
# one shared TAIL, so the order after Kit C is still edited in one place.
$Combo_Godhuman_OpenHeld = @(
                            @('hold', $keyC),          # Godhuman C (HELD - see $ycHoldGodCMs). Undodgeable, but the aim has to be held.
    @('swap', $slotFruit),  @('spam', $keyC, $ycKitCAfterGodCMs, $ycSpamIntervalMs)   # Kitsune C (tap) - wider window, held Godhuman C animates long
)
$Combo_Godhuman_OpenTap = @(
                            @('spam', $keyC, $ycGodCTapWindowMs, $ycSpamIntervalMs),   # Godhuman C (TAPPED - 10ms presses). Commits instantly, dodgeable, weak tracking.
    @('swap', $slotFruit),  @('spam', $keyC, $ycKitCAfterGodCTapMs, $ycSpamIntervalMs)   # Kitsune C (tap) - own knob, tap animation is shorter than held
)
$Combo_Godhuman_Tail = @(
    @('swap', $slotSword),  @('spam', $keyX, $ycYamaXWindowMs, $ycSpamIntervalMs),   # Yama X - own window, see $ycYamaXWindowMs
    @('swap', $slotFruit),  @('spam', $keyZ, $ycKitZAfterYamaXMs, $ycSpamIntervalMs), @('spam', $keyX),   # Kitsune Z (own window after Yama X), X
    @('swap', $slotFightStyle), @('spam', $keyX),      # Godhuman X
    @('swap', $slotFruit),  @('spam', $keyF, $ycKitFWindowMs, $ycSpamIntervalMs),   # Kitsune F - 300ms window (was global 260), 2026-09-05
    @('swap', $slotFightStyle), @('spam', $keyZ)       # Godhuman Z
)
# Kept for reference / anything that still points at it: the held layout as
# one flat list, identical to OpenHeld + Tail.
$Combo_Godhuman = $Combo_Godhuman_OpenHeld + $Combo_Godhuman_Tail

# F2 - Sanguine C + Kitsune C + Yama X + Kitsune Z X + Sanguine Z + Kit F + Sanguine X
#      Slower than the others. Sanguine must be the equipped style.
$Combo_Sanguine = @(
                            @('spam', $keyC, $ycOpenerWindowMs, $ycSpamIntervalMs),   # Sanguine C - first move, fires on press 1, swap right away
    @('swap', $slotFruit),  @('spam', $keyC, $ycKitCAfterSangCMs, $ycSpamIntervalMs),   # Kitsune C - window covers Sang C's animation
    @('swap', $slotSword),  @('spam', $keyX, $ycYamaXWindowMs, $ycSpamIntervalMs),   # Yama X - own window, see $ycYamaXWindowMs
    @('swap', $slotFruit),  @('spam', $keyZ, $ycKitZAfterYamaXMs, $ycSpamIntervalMs), @('spam', $keyX),   # Kitsune Z (own window after Yama X), X
    @('swap', $slotFightStyle), @('spam', $keyZ),      # Sanguine Z
    @('swap', $slotFruit),  @('spam', $keyF, $ycKitFWindowMs, $ycSpamIntervalMs),   # Kitsune F - 300ms window, 2026-09-05
    @('swap', $slotFightStyle), @('spam', $keyX)       # Sanguine X
)

# F3 - Sanguine C + Kitsune C + Kitsune X + Yama X + Sanguine Z + Kit F + Kit Z + Sanguine X
$Combo_SanguineAlt = @(
                            @('spam', $keyC, $ycOpenerWindowMs, $ycSpamIntervalMs),   # Sanguine C - first move, fires on press 1, swap right away
    @('swap', $slotFruit),  @('spam', $keyC, $ycKitCAfterSangCMs, $ycSpamIntervalMs), @('spam', $keyX),   # Kitsune C (window covers Sang C's animation), X
    @('swap', $slotSword),  @('spam', $keyX, $ycYamaXWindowMs, $ycSpamIntervalMs),   # Yama X - own window, see $ycYamaXWindowMs
    @('swap', $slotFightStyle), @('spam', $keyZ),      # Sanguine Z
    @('swap', $slotFruit),  @('spam', $keyF, $ycKitFWindowMs, $ycSpamIntervalMs), @('spam', $keyZ),   # Kitsune F (300ms window, 2026-09-05), Z
    @('swap', $slotFightStyle), @('spam', $keyX)       # Sanguine X
)

# (unbound) - E claw C + Kitsune C + Yama X + Kitsune Z X + E claw X + Kit F + E claw Z
#      Aim dependent. Alt ending that also works: E claw Z X + Kit F.
#      Saved for later per user; set $hotkeyEClaw to bind it.
$Combo_EClaw = @(
                            @('spam', $keyC, $ycOpenerWindowMs, $ycSpamIntervalMs),   # E claw C - first move, fires on press 1, swap right away
    @('swap', $slotFruit),  @('spam', $keyC, $ycKitCAfterSangCMs, $ycSpamIntervalMs),   # Kitsune C - same wider window as F2/F3, untested for E claw
    @('swap', $slotSword),  @('spam', $keyX, $ycYamaXWindowMs, $ycSpamIntervalMs),   # Yama X - own window, see $ycYamaXWindowMs
    @('swap', $slotFruit),  @('spam', $keyZ, $ycKitZAfterYamaXMs, $ycSpamIntervalMs), @('spam', $keyX),   # Kitsune Z (own window after Yama X), X
    @('swap', $slotFightStyle), @('spam', $keyX),      # E claw X
    @('swap', $slotFruit),  @('spam', $keyF, $ycKitFWindowMs, $ycSpamIntervalMs),   # Kitsune F - 300ms window, 2026-09-05
    @('swap', $slotFightStyle), @('spam', $keyZ)       # E claw Z
)
# Alt ending (replace the last three lines above):
#   @('swap', $slotFightStyle), @('spam', $keyZ), @('spam', $keyX),   # E claw Z, X
#   @('swap', $slotFruit),  @('spam', $keyF)                          # Kitsune F

# F1 picks its opener from the $hotkeyGodCTapToggle toggle at the moment you press F1, so
# flipping the toggle mid-fight takes effect on the very next F1.
function Run-Godhuman {
    if ($script:godCTapMode) {
        Invoke-Combo "Godhuman combo (F1, C TAPPED)" { Run-Steps ($Combo_Godhuman_OpenTap  + $Combo_Godhuman_Tail) | Out-Null }
    } else {
        Invoke-Combo "Godhuman combo (F1, C HELD)"   { Run-Steps ($Combo_Godhuman_OpenHeld + $Combo_Godhuman_Tail) | Out-Null }
    }
}
function Get-GodCModeText { if ($script:godCTapMode) { 'TAPPED' } else { 'HELD' } }
function Run-Sanguine    { Invoke-Combo "Sanguine combo (F2)"     { Run-Steps $Combo_Sanguine    | Out-Null } }
function Run-SanguineAlt { Invoke-Combo "Sanguine alt combo (F3)" { Run-Steps $Combo_SanguineAlt | Out-Null } }
function Run-EClaw       { Invoke-Combo "E claw combo"            { Run-Steps $Combo_EClaw       | Out-Null } }

# ---------------------------- MAIN LOOP -------------------------------------

[Native]::TimeBeginPeriod(1) | Out-Null   # fix ~55-60% Start-Sleep inflation for the life of this process - see comment above the P/Invoke declaration

Write-Host "Kitsune combo macro - running.  Hotbar: $slotFightStyle = style, $slotFruit = Kitsune, $slotSword = Yama" -ForegroundColor Cyan
Write-Host "  $hotkeyGodhuman = Godhuman combo   (Godhuman C -> Kit C -> Yama X -> Kit Z X -> Godhuman X -> Kit F -> Godhuman Z)  [start with Godhuman equipped]"
Write-Host "       Godhuman C is currently $(Get-GodCModeText). Press $hotkeyGodCTapToggle to toggle HELD <-> TAPPED." -ForegroundColor Cyan
Write-Host "  $hotkeySanguine = Sanguine combo   (Sang C -> Kit C -> Yama X -> Kit Z X -> Sang Z -> Kit F -> Sang X)  [start with Sanguine equipped]"
Write-Host "  $hotkeySanguineAlt = Sanguine alt    (Sang C -> Kit C -> Kit X -> Yama X -> Sang Z -> Kit F -> Kit Z -> Sang X)  [start with Sanguine equipped]"
Write-Host "  $hotkeyTrigger2 = old FULL combo   (Kit C -> Sang C -> Sang Z -> Kit F -> Sang X -> Kit X)  [start with Kitsune equipped]"
Write-Host "  $hotkeyTrigger  = old OPENING only (Kit C -> Sang C -> Sang Z, then stop)"
if ($hotkeyEClaw) { Write-Host "  $hotkeyEClaw = E claw combo" }
Write-Host "  $hotkeyAbort / $hotkeyAbort2 = abort mid-combo instantly"
Write-Host "  Close this window (or Ctrl+C) to stop the macro entirely."
Write-Host ""

Write-Host "  $hotkeySwapTest = partial test (opening only: Kitsune C -> equip -> Sanguine C -> Sanguine Z, then stop)"
Write-Host "  $hotkeyRecordToggle = toggle timing recorder (times YOUR manual keypresses, not the macro)"
Write-Host ""
[Console]::Out.Flush()

# ---------------------------- RECORDING MODE --------------------------------
# Press $hotkeyRecordToggle (F6) to start: records timestamps of your OWN manual Z/X/C/F/1/2
# keypresses (real keyboard, not the macro) while you play the combo by hand,
# so the delays used above can be based on your actual pace instead of
# estimates. Press the toggle again to stop. Now on $hotkeyRecordToggle (F6);
# was F3, and F2 before that.
$recordKeys = @('Z', 'X', 'C', 'F', '1', '2', '3')
$script:recording = $false
$recordKeyWasDown = @{}
foreach ($k in $recordKeys) { $recordKeyWasDown[$k] = $false }
$recordStartTime = $null
$recordLastPressTime = $null

# Combo triggers: hotkey name -> function. Each fires once on the key's
# down-edge, and only when no combo is already running (re-entry lock).
# Generalised 2026-09-04 from four copy-pasted edge-detect blocks.
$comboTriggers = [ordered]@{
    $hotkeyGodhuman    = { Run-Godhuman }
    $hotkeySanguine    = { Run-Sanguine }
    $hotkeySanguineAlt = { Run-SanguineAlt }
    $hotkeyTrigger2    = { Run-Combo2 }
    $hotkeyTrigger     = { Run-Combo }
    $hotkeySwapTest    = { Run-SwapTest }
}
if ($hotkeyEClaw) { $comboTriggers[$hotkeyEClaw] = { Run-EClaw } }
$triggerWasDown = @{}
foreach ($k in $comboTriggers.Keys) { $triggerWasDown[$k] = $false }

try {
    $recordToggleWasDown = $false
    $godCToggleWasDown = $false
    while ($true) {
        # $hotkeyGodCTapToggle (F8): flip F1's Godhuman C between HELD and TAPPED (down-edge only).
        $godCToggleIsDown = ([Native]::GetAsyncKeyState($VK[$hotkeyGodCTapToggle]) -band 0x8000) -ne 0
        if ($godCToggleIsDown -and -not $godCToggleWasDown) {
            $script:godCTapMode = -not $script:godCTapMode
            Write-Host ("--- F1 Godhuman C is now {0} ---" -f (Get-GodCModeText)) -ForegroundColor Cyan
            [Console]::Out.Flush()
        }
        $godCToggleWasDown = $godCToggleIsDown

        foreach ($k in $comboTriggers.Keys) {
            $isDown = ([Native]::GetAsyncKeyState($VK[$k]) -band 0x8000) -ne 0
            if ($isDown -and -not $triggerWasDown[$k] -and -not $script:running) {
                & $comboTriggers[$k]
            }
            $triggerWasDown[$k] = $isDown
        }

        $recordToggleIsDown = ([Native]::GetAsyncKeyState($VK[$hotkeyRecordToggle]) -band 0x8000) -ne 0
        if ($recordToggleIsDown -and -not $recordToggleWasDown) {
            $script:recording = -not $script:recording
            if ($script:recording) {
                $recordStartTime = Get-Date
                $recordLastPressTime = $recordStartTime
                foreach ($k in $recordKeys) { $recordKeyWasDown[$k] = $false }
                Write-Host ""
                Write-Host "--- RECORDING: play the combo by hand now (Z/X/C/F/1/2/3). Press $hotkeyRecordToggle again to stop. ---" -ForegroundColor Green
            } else {
                Write-Host "--- RECORDING STOPPED ---" -ForegroundColor Green
                Write-Host ""
            }
            [Console]::Out.Flush()
        }
        $recordToggleWasDown = $recordToggleIsDown

        if ($script:recording) {
            foreach ($k in $recordKeys) {
                $isDown = ([Native]::GetAsyncKeyState($VK[$k]) -band 0x8000) -ne 0
                if ($isDown -and -not $recordKeyWasDown[$k]) {
                    $now = Get-Date
                    $sinceStart = [int](New-TimeSpan -Start $recordStartTime -End $now).TotalMilliseconds
                    $sinceLast  = [int](New-TimeSpan -Start $recordLastPressTime -End $now).TotalMilliseconds
                    Write-Host ("  [+{0,5}ms total | +{1,4}ms since last] you pressed {2}" -f $sinceStart, $sinceLast, $k) -ForegroundColor Magenta
                    [Console]::Out.Flush()
                    $recordLastPressTime = $now
                }
                $recordKeyWasDown[$k] = $isDown
            }
        }

        Start-Sleep -Milliseconds 15
    }
}
finally {
    [Native]::TimeEndPeriod(1) | Out-Null   # restore normal system timer resolution on exit
}
