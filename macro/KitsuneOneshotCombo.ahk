#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; Blox Fruits — Kitsune + Godhuman one-shot combo
; Fruit + fighting style only. No sword, no gun, no transformation.
;
; Combo (Blox Fruits Wiki, Kitsune/Combos — by Rip chaitanya, with the
; HELD variant of Godhuman C specified as opener):
;
;   Godhuman [C] HELD  - dash, invulnerable, CANNOT BE DODGED (only tap can)
;   Kitsune  [F]       - dash + claw flurry. Breaks Instinct only if it connects
;   Kitsune  [X]       - zig-zag, ~0.65s stun, drains a lot of Instinct
;   Kitsune  [C] HOLD  - charge, fires on release. Breaks Instinct
;   Kitsune  [Z]       - flames circle then strike (delayed damage)
;   Godhuman [Z]       - flurry, invulnerable, breaks Instinct at point blank
;   Godhuman [X] tap   - gust, launches upward. Breaks Instinct
;
; Only tap-C can be dodged; HELD C cannot. holdTimeGodC MUST be long enough to
; register as held or the whole premise of the combo is lost.
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
slotFightStyle := "2"    ; Godhuman
slotSwapDelay  := 90     ; ms for a hotbar swap to register

hotkeyTrigger := "F1"
hotkeyAbort   := "Esc"

; --- Timings (ms). Cooldowns/energy are wiki-exact; these delays are NOT. ---

holdTimeGodC   := 600   ; TUNE FIRST. Must register as HELD, not tapped.
delayAfterGodC := 850   ; charged punch must resolve before F
delayAfterKitF := 700   ; dash + claw flurry
delayAfterKitX := 320   ; ~0.65s stun starts here
chargeTimeKitC := 350   ; Kitsune C fires on release
delayAfterKitC := 480   ; explosion resolves
delayAfterKitZ := 300   ; Z's damage lands later; don't wait for it
delayAfterGodZ := 450   ; punch flurry + knockback

m1Count := 0            ; optional filler during the 3-tail burn (0 = off)
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

    ; --- Opener: Godhuman C HELD. Invulnerable, cannot be dodged. ---
    if (!Swap(slotFightStyle))
        return
    if (!Hold(keyC, holdTimeGodC, delayAfterGodC))
        return

    ; --- Kitsune F: claw flurry, breaks Instinct on connect ---
    if (!Swap(slotFruit))
        return
    if (!Tap(keyF, delayAfterKitF))
        return

    ; --- Kitsune X: stun, drains Instinct heavily ---
    if (!Tap(keyX, delayAfterKitX))
        return

    ; --- Kitsune C: charge and release. Breaks Instinct. ---
    if (!Hold(keyC, chargeTimeKitC, delayAfterKitC))
        return

    ; --- Kitsune Z: delayed damage, lands during the rest of the combo ---
    if (!Tap(keyZ, delayAfterKitZ))
        return

    ; --- Godhuman Z: point blank here, so it breaks Instinct ---
    if (!Swap(slotFightStyle))
        return
    if (!Tap(keyZ, delayAfterGodZ))
        return

    ; --- Optional M1 filler ---
    Loop m1Count {
        if (!running)
            return
        Click(mouseM1)
        if (!Wait(m1Delay))
            return
    }

    ; --- Godhuman X tap: launcher finisher, breaks Instinct ---
    Tap(keyX, 0)
}

; ---------------------------- HELPERS ---------------------------------------

Tap(key, delay) {
    global running
    if (!running)
        return false
    Send("{" key "}")
    return Wait(delay)
}

; Hold a key for holdTime, release, then wait. Used for Godhuman C (held
; variant = cannot be dodged) and Kitsune C (fires on release).
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
