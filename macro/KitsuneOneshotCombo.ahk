#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; Blox Fruits — Kitsune + Godhuman one-shot combo macro
;
; Moveset source: https://blox-fruits.fandom.com/wiki/Kitsune
;
; CRITICAL MECHANIC: transforming (Kitsune V) DISABLES fighting styles, swords
; and guns. So the combo is strictly two-phase — all Godhuman damage lands in
; human form, then you transform and never touch the fighting style again.
;
; PHASE 1 (human form):
;   Godhuman [Z] Soaring Beast      - dash opener, stuns, i-frames
;   Kitsune  [Z] Accursed Enchant.  - flames circle then strike (delayed damage)
;   Godhuman [X] Heaven and Earth   - tap: launches target airborne
;   Kitsune  [C] Fox Fire Disrupt.  - HOLD to charge, release to fire. Breaks Instinct
;   Kitsune  [X] Tails of B. Agony  - ~0.65s stun, bridges into the transform
;   Kitsune  [V] Transformation     - 1s damage immunity during the animation
;
; PHASE 2 (transformed — no fighting style available):
;   Kitsune  [X] Tails of B. Agony  - GRAB -> air carry -> slam. Breaks Instinct
;   Kitsune  [C] Fox Fire Disrupt.  - widespread hit + extremely large DoT. Finisher
;
; Sends keystrokes/clicks only. No memory reading, no injection.
; See README.md for the build, tails budget, and tuning. EDIT CONFIG FIRST.
; ============================================================================

; ---------------------------- CONFIG ---------------------------------------

; Move keys — MUST match your in-game keybinds.
keyZ := "z"
keyX := "x"
keyC := "c"
keyV := "v"
mouseM1 := "LButton"

; Hotbar slots. Z/X/C are shared between fruit and fighting style, so phase 1
; needs swaps. Phase 2 needs none (the fighting style is locked out anyway).
slotFruit      := "1"    ; slot holding Kitsune
slotFightStyle := "2"    ; slot holding Godhuman
slotSwapDelay  := 90     ; ms for a hotbar swap to register before the next key

; Macro control.
hotkeyTrigger := "F1"
hotkeyAbort   := "Esc"

; --- Timings (ms). PLACEHOLDERS — tune on a dummy. See README "Tuning". ------

; Phase 1
delayAfterGodZ  := 420   ; Soaring Beast dash+punches -> swap to fruit
delayAfterKitZ  := 260   ; Accursed Enchantment cast (its damage lands later)
delayAfterGodX  := 400   ; Heaven and Earth launch -> swap back to fruit
chargeTimeC     := 350   ; TUNE FIRST: how long to HOLD C before releasing
delayAfterKitC  := 480   ; Fox Fire explosion resolves
delayAfterKitX  := 300   ; ~0.65s stun starts here; fire V inside that window
delayAfterV     := 1100  ; TUNE: transform animation MUST finish before phase 2

; Phase 2
delayAfterTX    := 950   ; TUNE: grab carries target up and slams — let it resolve
                         ; (README: instant slam if used while airborne)

; Optional M1 filler during the 3-tail burn window (0 disables).
m1Count := 0
m1Delay := 120

; ---------------------------- STATE -----------------------------------------

running := false

Hotkey(hotkeyTrigger, FireCombo)
Hotkey(hotkeyAbort, AbortCombo)

FireCombo(*) {
    global running
    if (running)
        return                  ; mid-sequence — ignore, prevents stacked runs
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

    ; ---------------- PHASE 1 — human form ----------------

    ; Godhuman Z — dash opener. Stuns, and i-frames protect the approach.
    if (!Swap(slotFightStyle))
        return
    if (!Tap(keyZ, delayAfterGodZ))
        return

    ; Kitsune Z — cast early so the circling flames strike during the mid-combo.
    if (!Swap(slotFruit))
        return
    if (!Tap(keyZ, delayAfterKitZ))
        return

    ; Godhuman X (tap) — launch them airborne, wears off Instinct.
    if (!Swap(slotFightStyle))
        return
    if (!Tap(keyX, delayAfterGodX))
        return

    ; Kitsune C — charge and release. Breaks Instinct.
    if (!Swap(slotFruit))
        return
    if (!Charge(keyC, chargeTimeC, delayAfterKitC))
        return

    ; Kitsune X — ~0.65s stun to cover the transform cast.
    if (!Tap(keyX, delayAfterKitX))
        return

    ; Kitsune V — transform. 1s of damage immunity during the animation.
    if (!Tap(keyV, delayAfterV))
        return

    ; ---------------- PHASE 2 — transformed ----------------
    ; No hotbar swaps here: transforming locks out fighting styles/swords/guns.

    ; Transformed X — the grab. Carries into the air, slams, breaks Instinct.
    if (!Tap(keyX, delayAfterTX))
        return

    ; Optional M1 filler while the burn ticks.
    Loop m1Count {
        if (!running)
            return
        Click(mouseM1)
        if (!Wait(m1Delay))
            return
    }

    ; Transformed C — finisher. Widespread damage + extremely large DoT.
    Tap(keyC, 0)
}

; ---------------------------- HELPERS ---------------------------------------

; Press and release a key, then wait.
Tap(key, delay) {
    global running
    if (!running)
        return false
    Send("{" key "}")
    return Wait(delay)
}

; Hold a key to charge, release, then wait. For Kitsune C (fires on release).
Charge(key, holdTime, delay) {
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

; Switch hotbar slot and let the swap register.
Swap(slot) {
    return Tap(slot, slotSwapDelay)
}

; Interruptible sleep — returns false if aborted mid-wait.
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
