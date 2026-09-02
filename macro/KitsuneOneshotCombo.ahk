#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; Blox Fruits — Kitsune + Sanguine Art one-shot combo
; Fruit + fighting style only. No sword, no gun, no transformation.
;
;   Kitsune  [C] HOLD  - charge, fires on release. BREAKS INSTINCT.
;                        The only confirmed Instinct break in this build.
;   Sanguine [C]        - lands because they are Instinct-broken. Disables
;                         their dashes, Flash Step and moves for ~1.2s.
;   Sanguine [Z]        - heals 20% max HP even if they dodge it
;   Sanguine [X]        - burst finisher
;   Kitsune  [F]        - tail damage after the window
;
; HOW THIS HOLDS: ken-tricking is the target pressing [E] to activate Instinct
; and phase out of damage (nothing to do with dashing). Kitsune [C] breaks
; Instinct, which lets Sanguine [C] land; Sanguine [C] then disables their
; inputs for ~1.2s and the rest is dumped into that window.
;
; WHAT IS NOT CLAIMED: this is NOT a no-gap chain of Instinct breaks. Kitsune
; [Z], [X] and [F] do not break Instinct, and neither does Sanguine [C].
; An earlier version of this file claimed otherwise and was wrong.
;
; UPDATE 31.4 (latest) constraints baked in here:
;  - Kitsune [X] "now channels on hit; the user cannot cast another ability
;    before the animation completes" -> X is NOT used in this combo. If you add
;    it, it will block the next macro input regardless of your delay value.
;  - Kitsune [C] end-lag increased by 0.3s -> delayAfterKitC raised accordingly.
;  - Kitsune [Z] no longer breaks Instinct (now Instinct-trickable).
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
delayAfterKitC  := 780   ; explosion + 31.4 end-lag nerf (+0.3s). Was 480 pre-nerf.
delayAfterSangC := 260   ; ~1.2s dash/move disable starts here
delayAfterSangZ := 280   ; drain
delayAfterSangX := 300   ; scarlet burst

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

    ; --- Kitsune C: the one Instinct break. Spend it up front. ---
    if (!Swap(slotFruit))
        return
    if (!Hold(keyC, chargeTimeKitC, delayAfterKitC))
        return

    ; --- Sanguine C into the Instinct-broken target: starts the ~1.2s
    ; input-disable. Z and X follow with no hotbar swap so they land inside it.
    if (!Swap(slotFightStyle))
        return
    if (!Tap(keyC, delayAfterSangC))
        return
    if (!Tap(keyZ, delayAfterSangZ))     ; heals 20% max HP even if dodged
        return
    if (!Tap(keyX, delayAfterSangX))
        return

    Loop m1Count {
        if (!running)
            return
        Click(mouseM1)
        if (!Wait(m1Delay))
            return
    }

    ; --- Tail damage, after the window ---
    if (!Swap(slotFruit))
        return
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
