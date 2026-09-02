#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; Blox Fruits — Kitsune + Godhuman one-shot combo macro
;
; Combo:  Kitsune [F] Wild Assault      - dash-GRAB opener, breaks Instinct
;      -> Kitsune [Z] Accursed Enchant. - auto-aimed, cannot be strafed
;      -> Godhuman [X] Heaven and Earth - air launcher, wears off Instinct
;      -> Kitsune [X] Tails of B. Agony - stuns on hit
;      -> Kitsune [C] Fox Fire Disrupt. - breaks Instinct
;      -> Kitsune [V] Transformation    - needs 3 tails (built by the above)
;      -> Kitsune [C] transformed       - strongest single hit, finisher
;
; Sends keystrokes/clicks like a human would. No memory reading, no injection.
; See README.md for the build, sourcing, and tuning. EDIT CONFIG BEFORE USE.
; ============================================================================

; ---------------------------- CONFIG ---------------------------------------

; Move keys — MUST match your in-game keybind menu.
keyWildAssault  := "f"   ; Kitsune F  - grab opener
keyAccursed     := "z"   ; Kitsune Z  - auto-aimed
keyHeavenEarth  := "x"   ; Godhuman X - launcher  (see gearSwapKey below)
keyTailsAgony   := "x"   ; Kitsune X  - stun
keyFoxFire      := "c"   ; Kitsune C  - Instinct-break
keyTransform    := "v"   ; Kitsune V  - transformation
mouseM1         := "LButton"

; Blox Fruits uses the same Z/X/C keys for your fruit and your fighting style
; depending on which is equipped, so the Godhuman link needs a weapon swap.
; Set these to your hotbar slot numbers.
slotFruit       := "1"   ; hotbar slot holding Kitsune
slotFightStyle  := "2"   ; hotbar slot holding Godhuman
slotSwapDelay   := 90    ; ms to let a hotbar swap register before pressing a move

; Macro control hotkeys.
hotkeyTrigger := "F1"    ; fire the combo (hover target, in F range)
hotkeyAbort   := "Esc"   ; cancel a running sequence

; Delays (ms). PLACEHOLDERS — tune on a training dummy. See README "Tuning".
delayAfterF     := 900   ; MOST IMPORTANT: grab carries target up + slams.
                         ; Z must not fire until the slam resolves.
delayAfterZ     := 320   ; auto-aimed flames -> weapon swap + Godhuman X
delayAfterGodX  := 380   ; air launch -> swap back + Kitsune X
delayAfterKitX  := 300   ; zig-zag stun dash -> Kitsune C
delayAfterC     := 420   ; Fox Fire eruption -> Transformation
delayAfterV     := 700   ; transform animation must finish before the finisher

; Optional M1 filler during the burn window (0 to disable).
m1Count         := 0
m1Delay         := 120

; ---------------------------- STATE -----------------------------------------

running := false

; ---------------------------- HOTKEYS ---------------------------------------

Hotkey(hotkeyTrigger, FireCombo)
Hotkey(hotkeyAbort, AbortCombo)

FireCombo(*) {
    global running
    if (running)
        return                      ; already mid-sequence — ignore (prevents desync)
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

    ; Make sure we start on the fruit.
    if (!SendStep(slotFruit, slotSwapDelay))
        return

    ; 1. GRAB opener. Breaks Instinct, closes the gap, locks the target.
    if (!SendStep(keyWildAssault, delayAfterF))
        return

    ; 2. Auto-aimed follow-up — guaranteed link, cannot be strafed.
    if (!SendStep(keyAccursed, delayAfterZ))
        return

    ; 3. Godhuman air launcher (swap to fighting style first).
    if (!SendStep(slotFightStyle, slotSwapDelay))
        return
    if (!SendStep(keyHeavenEarth, delayAfterGodX))
        return

    ; 4. Back to fruit — zig-zag stun dash.
    if (!SendStep(slotFruit, slotSwapDelay))
        return
    if (!SendStep(keyTailsAgony, delayAfterKitX))
        return

    ; 5. Instinct-break sphere.
    if (!SendStep(keyFoxFire, delayAfterC))
        return

    ; Optional M1 filler while the burn DoT ticks.
    Loop m1Count {
        if (!running)
            return
        Click(mouseM1)
        Sleep(m1Delay)
    }

    ; 6. Transform (tail meter should be full from the damage above).
    if (!SendStep(keyTransform, delayAfterV))
        return

    ; 7. Transformed Fox Fire Disruption — strongest single hit.
    SendStep(keyFoxFire, 0)
}

; Sends one key, waits `delay` ms, returns false if aborted mid-wait.
SendStep(key, delay) {
    global running
    if (!running)
        return false
    Send("{" key "}")
    elapsed := 0
    while (elapsed < delay) {
        if (!running)
            return false
        Sleep(10)
        elapsed += 10
    }
    return running
}
