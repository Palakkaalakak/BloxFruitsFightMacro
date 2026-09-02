#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; Blox Fruits — Kitsune + Sanguine Art one-shot combo
; Fruit + fighting style only. No sword, no gun, no transformation.
;
;   Kitsune  [C] HOLD  - charge, fires on release. Breaks Instinct
;                        (initial pull + the flames after)
;   Kitsune  [F]         - breaks Instinct on the first slash
;   Sanguine [C]         - breaks Instinct on grab. Also disables the target's
;                          dashes/Flash Step/moves ~1.2s (bonus, not the point)
;   Sanguine [Z]         - breaks Instinct on grab. Heals 20% max HP even if dodged
;   Sanguine [X]         - breaks Instinct. Finisher
;
; WHY THESE FIVE: ken-tricking is the target pressing [E] to activate Instinct
; mid-combo and phase out of damage. An Instinct-breaking hit instantly forces
; them back out of that state. So EVERY link here breaks Instinct - there is no
; gap to ken-trick in.
;
; Kitsune [X] is deliberately NOT used: it does not break Instinct (it only
; drains it), so as a mid-combo link it is a free escape window.
; Kitsune [Z] is excluded because the wiki contradicts itself on whether it
; breaks Instinct (Instinct/Break says yes, the Kitsune page says no).
;
; Sanguine [C] is not the opener - its projectiles and pull can be dodged, so
; Kitsune [C]/[F] commit the target first.
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
delayAfterKitF  := 320   ; claw flurry; break lands on the FIRST slash
delayAfterSangC := 260   ; ~1.2s dash/move disable starts here
delayAfterSangZ := 280   ; neck grab + drain

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

    ; --- Kitsune: break Instinct and commit them ---
    if (!Swap(slotFruit))
        return
    if (!Hold(keyC, chargeTimeKitC, delayAfterKitC))
        return
    if (!Tap(keyF, delayAfterKitF))
        return

    ; --- Sanguine: three consecutive Instinct breaks, no hotbar swap between
    ; them, so nothing interrupts the chain. C also starts the ~1.2s disable. ---
    if (!Swap(slotFightStyle))
        return
    if (!Tap(keyC, delayAfterSangC))
        return
    if (!Tap(keyZ, delayAfterSangZ))     ; heals 20% max HP even if dodged
        return

    Loop m1Count {
        if (!running)
            return
        Click(mouseM1)
        if (!Wait(m1Delay))
            return
    }

    Tap(keyX, 0)                          ; finisher
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
