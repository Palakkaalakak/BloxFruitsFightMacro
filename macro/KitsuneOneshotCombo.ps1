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
$slotFightStyle = '1'    # Sanguine Art
$slotSwapDelayMs = 25    # ms for a hotbar swap to register - tightened further 2026-09-02. A slot swap has no animation lock in-game (unlike a move), it's purely OS/key-registration time, so it can run tighter than the move-recovery delays below.

# SWAPPED 2026-09-03 per user: the FULL combo is now on F1 and the
# opening-only combo on F2. $hotkeyTrigger still fires Run-Combo (opening
# only) and $hotkeyTrigger2 still fires Run-Combo2 (full) - only the keys
# they're bound to changed, so the function names stay matched to their
# behaviour.
$hotkeyTrigger  = 'F2'   # -> Run-Combo:  combo v1, opening only (Kitsune[C] -> Sanguine[C] -> Sanguine[Z])
$hotkeyTrigger2 = 'F1'   # -> Run-Combo2: combo v2, full (... -> Kitsune[F] -> Sanguine[X] -> Kitsune[X])
$hotkeyAbort   = 'Escape'
$hotkeyAbort2  = 'Tab'   # second abort key, added 2026-09-02 per user - instant-cancel if a move missed, without needing to reach for Escape
$hotkeyRecordToggle = 'F3'   # MOVED from F2 2026-09-02 (F2 is now combo v2) - toggles timing-recorder mode, see "RECORDING MODE" below
$hotkeySwapTest = 'F4'       # isolated swap test (2026-09-03): Kitsune C, then the swap to Sanguine, and nothing else - for checking JUST that transition

# --- Timings (ms). Researched 2026-09-02: no source anywhere (wiki, patch
# notes, guides, community macro threads) publishes exact animation/channel
# length in ms - only stun/disable durations, which are baked in separately.
# Every value below is an estimate with a small +30ms safety buffer on top of
# the bare-minimum estimate. Calibrate on a dummy before relying on this live.
#
# HARD lock  = the game itself won't take input until this much time passes.
# SELF-RECOVERY estimate = your own cast animation ending - undocumented,
# cut as tight as your dummy test allows.

$delayAfterKitCMs  = 350   # HARD: your own end-lag after the tap. TOTAL budget for the Kitsune C -> swap -> Sanguine C stretch; Press-SlotKey's two 170ms buffers (+10ms press) consume all of it now, leaving zero idle slack. Cut 450 -> 380 -> 350 across 2026-09-03 as Sanguine C kept firing slightly late. Raise if Kitsune C starts getting cut off.
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
$spamSangXDurationMs    = 520   # 700 -> 520 on 2026-09-03 per user; still ~7 attempts at the 70ms interval now that logging no longer inflates it
$spamSangXIntervalMs    = 70    # densest spam in the combo (150 -> 70 on 2026-09-03 per user "spam much more"): first retry now lands 70ms after the opening press instead of 150ms

# Kitsune X (channels on hit since 31.4) also spammed now instead of a
# single tap, same rationale as Sanguine X above. 2026-09-02, per user.
$spamKitX = $true
$spamKitXInitialWaitMs = 0     # equip -> first Kitsune X attempt. 202 -> 141 -> 40 -> 0 across 2026-09-03 (zero lead-in promoted from combo v3).
$spamKitXDurationMs    = 240   # ~3 attempts at the tightened 80ms interval - more tries than the old 210/150 gave (~1-2), while finishing sooner. Kitsune X is the last move, so this window delays nothing after it.
$spamKitXIntervalMs    = 80    # 150 -> 80 on 2026-09-03 per user, matching Kitsune F's cadence

# Sanguine C often fails to fire while airborne (2026-09-03, per user). A
# single press has no retry, so an airborne rejection just loses the move
# outright. C is an ability key, not a slot key, so spamming it is safe (no
# equip/unequip toggle risk). The spam window is subtracted from
# $delayAfterSangCMs below, so total time to the next move is unchanged and
# nothing downstream shifts later.
$spamSangC = $true
$spamSangCInitialWaitMs = 0     # start attempting immediately after Press-SlotKey's 170ms post-swap buffer. Dropped 40 -> 0 on 2026-09-03: C was still firing slightly late, and there is no reason to sit idle - a press that arrives too early is simply ignored and retried by the spam below.
$spamSangCDurationMs    = 600   # window length; with the 100ms interval that's ~6 attempts. Cut 780 -> 600 on 2026-09-03 per user: this whole window must elapse before Sanguine Z starts, so shortening it pulls Z (and everything after) earlier by the same amount. Raise back toward 780 if C starts getting missed.
$spamSangCIntervalMs    = 100   # tightened 150 -> 100 so the ready-moment is caught sooner rather than up to 150ms after it opens

$spamSangZ = $true
$spamSangZInitialWaitMs = 40    # last Sanguine C press -> first Z attempt (no swap, same slot). Cut 250 -> 100 -> 40 across 2026-09-03: Z kept firing late. Early presses are harmless here - they just get eaten and retried by the spam.
$spamSangZDurationMs    = 600   # RAISED BACK 200 -> 600 on 2026-09-03: the log showed Z getting only 2 presses and never firing, while the user's own hand-recordings needed 5-7 before it came out. At the 100ms interval this is ~6 attempts. Was trimmed 700 -> 300 -> 200 earlier that day; 200 was too far. Cut 700 -> 300 on 2026-09-03 per user: drop 4 of the 7 Z presses and spend that time switching to Kitsune instead. Z's cast length VARIES WITH TARGET DISTANCE, so the tail presses were usually landing after Z had already gone off anyway - dead time that just delayed the swap. Deliberately below worst case: whatever comes next is spammed too, so a press arriving while Z is still running is just eaten and retried.
$spamSangZIntervalMs    = 100   # tightened 150 -> 100, same reason as Sanguine C above

$spamKitF = $true
$spamKitFInitialWaitMs = 0      # equip -> first Kitsune F attempt. 126 -> 40 -> 0 across 2026-09-03 (zero lead-in promoted from combo v3).
$spamKitFDurationMs    = 600    # 780 -> 600 on 2026-09-03 per user. Still ~8 attempts at the 80ms interval - the same count 780ms used to deliver, because the per-keypress log write that was inflating every interval by ~85ms is gone.
$spamKitFIntervalMs    = 80     # densest spam in the combo (150 -> 80 on 2026-09-03 per user): ~8 attempts in the window, vs ~4 before. F has been the least reliable move to come out, so it gets the most retries.

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
    '1' = 0x31; '2' = 0x32
    'F1' = 0x70
    'F2' = 0x71
    'F3' = 0x72
    'F4' = 0x73
    'Escape' = 0x1B
    'Tab' = 0x09
}

# ---------------------------- STATE -----------------------------------------

$script:running = $false

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
    while ($elapsed -lt $DurationMs) {
        if (-not (Press-Key $Key)) { return $false }
        if (-not (Wait-Interruptible $IntervalMs)) { return $false }
        $elapsed += $IntervalMs
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
$preSwapRegisterMs = 140   # 170 -> 140 on 2026-09-03 per user. CAUTION: 120 broke this swap earlier the same day, but that was while the per-keypress log write was adding ~85ms of hidden padding on top - so the effective buffer back then was ~205ms, not 120ms. With that overhead now removed, this value is closer to its real cost than any earlier number was. If the Kitsune C -> Sanguine swap starts missing again, raise this first. Briefly tried 120ms and the first Kitsune->Sanguine swap stopped working - their real ability->swap gaps are 125ms and 168ms, so 120 was under both. 170 sits at the top of their observed range; do not cut below ~125 again. (Per-move swap->ability gaps are handled separately by each move's own $spam*InitialWaitMs.)

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

# Combo v3 (F5) was folded into v2 on 2026-09-03 once its zero-lead-in
# behaviour was confirmed better - those lead-ins are now simply 0 in CONFIG,
# so v2 IS what v3 was and the separate hotkey/flag are gone.
function Run-Combo2 {
    Invoke-Combo "combo v2" {
        Do-Combo2Steps | Out-Null
    }
}

# ---------------------------- MAIN LOOP -------------------------------------

[Native]::TimeBeginPeriod(1) | Out-Null   # fix ~55-60% Start-Sleep inflation for the life of this process - see comment above the P/Invoke declaration

Write-Host "Kitsune + Sanguine Art combo macro - running." -ForegroundColor Cyan
Write-Host "  $hotkeyTrigger2 = fire FULL combo (Kitsune[C] -> Sanguine[C] -> Sanguine[Z] -> Kitsune[F] -> Sanguine[X] -> Kitsune[X])"
Write-Host "  $hotkeyTrigger  = fire OPENING only (Kitsune[C] -> Sanguine[C] -> Sanguine[Z], then stop)"
Write-Host "  $hotkeyAbort / $hotkeyAbort2 = abort mid-combo instantly"
Write-Host "  Close this window (or Ctrl+C) to stop the macro entirely."
Write-Host ""

Write-Host "  $hotkeySwapTest = partial test (opening only: Kitsune C -> equip -> Sanguine C -> Sanguine Z, then stop)"
Write-Host "  $hotkeyRecordToggle = toggle timing recorder (times YOUR manual keypresses, not the macro)"
Write-Host ""
[Console]::Out.Flush()

# ---------------------------- RECORDING MODE --------------------------------
# Press F3 to start: records timestamps of your OWN manual Z/X/C/F/1/2
# keypresses (real keyboard, not the macro) while you play the combo by hand,
# so the delays used above can be based on your actual pace instead of
# estimates. Press F3 again to stop. MOVED from F2 2026-09-02 (F2 is now
# combo v2's trigger).
$recordKeys = @('Z', 'X', 'C', 'F', '1', '2')
$script:recording = $false
$recordKeyWasDown = @{}
foreach ($k in $recordKeys) { $recordKeyWasDown[$k] = $false }
$recordStartTime = $null
$recordLastPressTime = $null

try {
    $triggerWasDown = $false
    $trigger2WasDown = $false
    $swapTestWasDown = $false
    $recordToggleWasDown = $false
    while ($true) {
        $triggerIsDown = ([Native]::GetAsyncKeyState($VK[$hotkeyTrigger]) -band 0x8000) -ne 0
        if ($triggerIsDown -and -not $triggerWasDown -and -not $script:running) {
            Run-Combo
        }
        $triggerWasDown = $triggerIsDown

        $trigger2IsDown = ([Native]::GetAsyncKeyState($VK[$hotkeyTrigger2]) -band 0x8000) -ne 0
        if ($trigger2IsDown -and -not $trigger2WasDown -and -not $script:running) {
            Run-Combo2
        }
        $trigger2WasDown = $trigger2IsDown

        $swapTestIsDown = ([Native]::GetAsyncKeyState($VK[$hotkeySwapTest]) -band 0x8000) -ne 0
        if ($swapTestIsDown -and -not $swapTestWasDown -and -not $script:running) {
            Run-SwapTest
        }
        $swapTestWasDown = $swapTestIsDown

        $recordToggleIsDown = ([Native]::GetAsyncKeyState($VK[$hotkeyRecordToggle]) -band 0x8000) -ne 0
        if ($recordToggleIsDown -and -not $recordToggleWasDown) {
            $script:recording = -not $script:recording
            if ($script:recording) {
                $recordStartTime = Get-Date
                $recordLastPressTime = $recordStartTime
                foreach ($k in $recordKeys) { $recordKeyWasDown[$k] = $false }
                Write-Host ""
                Write-Host "--- RECORDING: play the combo by hand now (Z/X/C/1/2). Press F2 again to stop. ---" -ForegroundColor Green
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
