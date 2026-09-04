#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; Blox Fruits — Kitsune + Sanguine Art one-shot combo
; Fruit + fighting style only. No sword, no gun, no transformation.
;
;   Kitsune  [C] HOLD  - charge, fires on release. BREAKS INSTINCT.
;                        The ONLY Instinct break in this combo. User-confirmed.
;   Sanguine [C]        - lands because they're Instinct-broken. Disables
;                         their dashes, Flash Step and moves for ~1.2s.
;                         Does NOT break Instinct (user-confirmed; overrides
;                         a wrong wiki claim — see README).
;   Sanguine [Z]        - heals 20% max HP even if they dodge it with Instinct.
;                         Does NOT break Instinct (user-confirmed; overrides
;                         a wrong wiki claim — see README).
;   Kitsune  [X]        - zig-zag hit, stuns ~0.65s, then CHANNELS ON HIT:
;                         you cannot send the next key until the channel ends.
;                         Does NOT break Instinct (drains only).
;   Sanguine [X]        - burst finisher.
;
; ORDER (per user request, 2026-09-02):
;   Kitsune[C] -> Sanguine[C] -> Sanguine[Z] -> Kitsune[X] -> Sanguine[X]
; The last two can be swapped via `swapKitsuneAndSanguineX` in CONFIG (see
; below) to run ...Sanguine[Z] -> Sanguine[X] -> Kitsune[X] instead.
;
; WHY THIS HOLDS: Kitsune [C] breaks Instinct up front, before they have a
; reason to panic-[E]. Sanguine [C] then disables their inputs for ~1.2s.
; Sanguine [Z] and Kitsune [X] land inside that window; Kitsune [X]'s own
; ~0.65s stun (plus its post-hit channel lock) carries the gap through to
; Sanguine [X]. There is no point in this sequence where the target has both
; a live Instinct charge AND a free input, if the delays below are tuned right.
;
; WHAT IS NOT CLAIMED: the wiki claims Sanguine [C]/[Z] also break Instinct.
; User confirmed directly they do NOT. Kitsune [C] is the only break here —
; the combo holds on that break + Sanguine [C]'s 1.2s lock + Kitsune [X]'s
; stun/channel, not on a chain of breaks.
;
; UPDATE 31.4 / Balance Patch 001 (Aug 6 2026 — verified official, same data)
; constraints baked in here:
;  - Kitsune [X] "now channels on hit; the user cannot cast another ability
;    before the animation completes." -> delayAfterKitX must cover the full
;    channel, not just the 0.65s stun, or Sanguine [X] gets eaten.
;  - Kitsune [C] end-lag increased by 0.3s -> delayAfterKitC raised accordingly.
;  - Kitsune [Z] no longer breaks Instinct (not used in this combo anyway).
;  - Sanguine [C] range -15%, hitbox -10% -> stand closer than before.
;  - Instinct dodge regen is now 30s (was 40s) — irrelevant to a single combo,
;    relevant if you're trading combos repeatedly in one fight.
;
; NONE OF THE TIMING VALUES BELOW ARE FRAME-EXACT. No public source publishes
; animation-length data in milliseconds — only stun/disable durations, which
; are baked in as noted. Every delay is a starting estimate. See README's
; "PVP quick-start" section for the calibration drill.
;
; Keystrokes and clicks only. No memory reading, no injection, no
; auto-targeting. You hover the target and press one key.
; ============================================================================

; ---------------------------- CONFIG ---------------------------------------

keyZ := "z"
keyX := "x"
keyC := "c"
mouseM1 := "LButton"

; Z/X/C are shared between fruit and fighting style — the combo needs swaps.
slotFruit      := "2"    ; Kitsune
slotFightStyle := "1"    ; Sanguine Art
slotSwapDelay  := 90     ; ms for a hotbar swap to register — required, keep tight

hotkeyTrigger := "F1"
hotkeyAbort   := "Esc"

; --- Timings (ms). Cooldowns/energy/stun durations below are wiki-exact;
; the delay values are ESTIMATES — calibrate on a dummy before using this in
; a real fight. See README "PVP quick-start" for how. ---

; Every value below is either a HARD LOCK (the game itself won't accept the
; next input until this much time passes — cannot be shortened without moves
; getting eaten) or a SELF-RECOVERY ESTIMATE (your own cast animation ending
; before you can act again — real, but not documented anywhere, so cut as
; tight as you can get away with on your dummy). None are padding for its
; own sake.

; Researched 2026-09-02: no source anywhere (wiki, patch notes, guides,
; community macro threads) publishes exact animation/channel length in ms —
; only stun/disable durations, which are baked in separately below. Every
; value here is an estimate. Each includes a small +30ms safety buffer on top
; of the bare-minimum estimate, cheap insurance against a whiffed/dropped
; move costing you the whole combo; still tight, not padded.

chargeTimeKitC   := 350   ; HARD: minimum hold so the game reads it as a hold, not a tap
delayAfterKitC   := 810   ; HARD: your own end-lag after release (31.4 added +0.3s) + 30ms buffer
delayAfterSangC  := 180   ; SELF-RECOVERY estimate (150ms floor) + 30ms buffer. Tighten first if anything whiffs
delayAfterSangZ  := 180   ; SELF-RECOVERY estimate (150ms floor) + 30ms buffer ("almost immediate" per wiki)
delayAfterKitX   := 930   ; HARD: X channels on hit since 31.4 — you are LOCKED in your own animation + 30ms buffer. Do not cut this blind.
delayAfterSangX  := 180   ; SELF-RECOVERY estimate (150ms floor) + 30ms buffer. Real gap when order is swapped (below); harmless trailing wait otherwise.

; swapKitsuneAndSanguineX: false (default) = ...Sanguine[Z] -> Kitsune[X] -> Sanguine[X]
;                          true             = ...Sanguine[Z] -> Sanguine[X] -> Kitsune[X]
; Swapping puts Kitsune X — the move with the hard channel-lock — LAST instead
; of second-to-last. That removes the risk of it eating the finisher (nothing
; follows it to drop), at the cost of Sanguine X no longer landing right after
; Sanguine Z's window. Try both orders on a dummy; there's no wiki data saying
; which lands more reliably.
swapKitsuneAndSanguineX := false

; delayAfterKitX is the one number in this file you cannot just "make tighter."
; Kitsune X stuns ~0.65s then "channels on hit" (31.4) — you are locked in
; your OWN animation, same category as Sanguine C's target-lock, just on you
; instead of them. Cut it too short and Sanguine X is sent while you're still
; mid-channel and gets silently dropped by the game (not queued, not delayed
; — gone). Calibrate this one DOWN carefully in small steps, not by guessing.
;
; delayAfterSangC and delayAfterSangZ are the two that were previously padded
; beyond what's required (350ms and 280ms) — cut to 150ms each, a rough floor
; for "your own cast animation clears." If Sanguine Z or Kitsune X whiff on
; your dummy test, raise the ONE before it that's whiffing, not both blindly.

m1Count := 0             ; optional filler (0 = off)
m1Delay := 120

; ---------------------------- STATE -----------------------------------------

running := false

Hotkey(hotkeyTrigger, FireCombo)
Hotkey(hotkeyAbort, AbortCombo)

FireCombo(*) {
    global running
    if (running)
        return                  ; mid-run — ignore, prevents stacked sequences
    running := true
    try
        RunCombo()
    finally
        running := false
}

AbortCombo(*) {
    global running
    running := false
}

; ---------------------------- SEQUENCE ---------------------------------------

RunCombo() {
    global

    ; --- 1. Kitsune C: the confirmed Instinct break. Spend it up front. ---
    if (!Swap(slotFruit))
        return
    if (!Hold(keyC, chargeTimeKitC, delayAfterKitC))
        return

    ; --- 2. Sanguine C into the Instinct-broken target: starts the ~1.2s
    ; input-disable. ---
    if (!Swap(slotFightStyle))
        return
    if (!Tap(keyC, delayAfterSangC))
        return

    ; --- 3. Sanguine Z: heals 20% max HP even if dodged, lands inside the
    ; disable window. ---
    if (!Tap(keyZ, delayAfterSangZ))
        return

    ; --- 4 & 5. Kitsune X and Sanguine X, order controlled by
    ; swapKitsuneAndSanguineX (see CONFIG). Default: Kitsune X then Sanguine X.
    if (!swapKitsuneAndSanguineX) {
        if (!Swap(slotFruit))
            return
        if (!Tap(keyX, delayAfterKitX))
            return
        if (!Swap(slotFightStyle))
            return
        if (!Tap(keyX, delayAfterSangX))
            return
    } else {
        if (!Tap(keyX, delayAfterSangX))     ; already in fight-style slot from step 3
            return
        if (!Swap(slotFruit))
            return
        if (!Tap(keyX, delayAfterKitX))
            return
    }

    Loop m1Count {
        if (!running)
            return
        Click(mouseM1)
        if (!Wait(m1Delay))
            return
    }
}

; ---------------------------- HELPERS ---------------------------------------

Tap(key, delay) {
    global running
    if (!running)
        return false
    Send("{" key "}")
    return Wait(delay)
}

; Hold a key for holdTime, release, then wait. Used for Kitsune C (fires on
; release).
Hold(key, holdTime, delay) {
    global running
    if (!running)
        return false
    Send("{" key " down}")
    ok := Wait(holdTime)
    Send("{" key " up}")        ; always release, even on abort
    if (!ok)
        return false
    return Wait(delay)
}

Swap(slot) {
    return Tap(slot, slotSwapDelay)
}

; Interruptible sleep — false if aborted mid-wait.
Wait(delay) {
    global running
    elapsed := 0
    while (elapsed < delay) {
        if (!running)
            return false
        Sleep(10)
        elapsed += 10
    }
    return running
}
