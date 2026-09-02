#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; Blox Fruits — Kitsune + Sanguine Art one-shot combo
; Fruit + fighting style only. No sword, no gun, no transformation.
;
; Combo (Blox Fruits Wiki, Kitsune/Combos):
;   Kitsune [C][X] + Sanguine Art [C][Z][X] + Kitsune [Z][F]
;
;   Kitsune  [C] HOLD  - charge, fires on release. BREAKS INSTINCT
;   Kitsune  [X]       - zig-zag, ~0.65s stun, drains a lot of Instinct
;   Sanguine [C]       - THE LOCK. Disables enemy Dashes, Flash Step and
;                        moves for ~1.2s. Kentricking needs a dash, so for
;                        that window they mechanically cannot escape.
;   Sanguine [Z]       - neck grab + drain. Heals 20% max HP even if dodged
;   Sanguine [X]       - six claw slashes + scarlet burst
;   Kitsune  [Z]       - delayed circling flames
;   Kitsune  [F]       - claw flurry finisher
;
; Sanguine [C] is NOT the opener: its projectiles and pull can be dodged, so
; it is thrown into an already-stunned target from Kitsune [C]/[X].
;
; WHY THIS ORDERING: the three Sanguine moves run back-to-back so there are
; ZERO hotbar swaps inside the 1.2s lock. The alternative wiki ordering
; (Sanguine C -> Kitsune F -> Sanguine Z -> X) needs two swaps mid-lock,
; which at ~90ms each spends ~180ms of the window on menu inputs and pushes
; the finisher to the very edge of it.
;
; Keystrokes and clicks only. No memory reading, no injection.
; ============================================================================

; ---------------------------- CONFIG ---------------------------------------

keyZ := "z"
keyX := "x"
keyC := "c"
keyF := "f"
mouseM1 := "LButton"

; Z/X/C are shared between fruit and fighting style — the combo needs swaps.
slotFruit      := "1"    ; Kitsune
slotFightStyle := "2"    ; Sanguine Art
slotSwapDelay  := 90     ; ms for a hotbar swap to register

hotkeyTrigger := "F1"
hotkeyAbort   := "Esc"

; --- Timings (ms). Cooldowns/energy/lock are wiki-exact; delays are NOT. ---

chargeTimeKitC  := 350   ; Kitsune C fires on release
delayAfterKitC  := 480   ; explosion resolves
delayAfterKitX  := 300   ; ~0.65s stun starts here — land Sanguine C inside it
delayAfterSangC := 260   ; TUNE TIGHT. The ~1.2s input-disable starts here.
delayAfterSangZ := 280   ; neck grab + drain
delayAfterSangX := 300   ; claw slashes + scarlet burst
delayAfterKitZ  := 260   ; Z's damage lands later; don't wait for it

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

    ; --- Setup: Kitsune C breaks Instinct, X stuns ~0.65s ---
    if (!Swap(slotFruit))
        return
    if (!Hold(keyC, chargeTimeKitC, delayAfterKitC))
        return
    if (!Tap(keyX, delayAfterKitX))
        return

    ; --- THE LOCK: Sanguine C into the stunned target. ---
    ; ~1.2s with dashes, Flash Step and moves disabled. The next two moves
    ; run with no hotbar swap so they all land inside that window.
    if (!Swap(slotFightStyle))
        return
    if (!Tap(keyC, delayAfterSangC))
        return
    if (!Tap(keyZ, delayAfterSangZ))     ; heals 20% max HP even if dodged
        return
    if (!Tap(keyX, delayAfterSangX))
        return

    ; --- Tail end: lock is expiring, Kitsune F's Instinct break covers it ---
    if (!Swap(slotFruit))
        return
    if (!Tap(keyZ, delayAfterKitZ))
        return

    Loop m1Count {
        if (!running)
            return
        Click(mouseM1)
        if (!Wait(m1Delay))
            return
    }

    Tap(keyF, 0)
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
