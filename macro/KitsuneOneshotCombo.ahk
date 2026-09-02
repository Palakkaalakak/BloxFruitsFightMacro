#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; Blox Fruits — Godhuman + Kitsune one-shot combo macro
;
; This sends keystrokes/mouse clicks like a human would (no memory reading,
; no injection). See README.md for the build, combo theory, and tuning
; instructions. EDIT THE CONFIG BLOCK BELOW BEFORE USING.
; ============================================================================

; ---------------------------- CONFIG ---------------------------------------

; Keybinds — MUST match your actual in-game keybind menu.
keyGodhumanZ := "z"
keyKitsuneC  := "c"
keyKitsuneX  := "x"
keyKitsuneV  := "v"
mouseM1      := "LButton"

; Hotkeys that control the macro itself.
hotkeyTrigger := "F1"   ; press this (while hovering the target, in range) to fire the combo
hotkeyAbort   := "Esc"  ; press this at any time to cancel a running sequence

; Delays (ms) between each step. These are placeholders — tune them in a
; private server against a training dummy. See README "Tuning" section.
delayAfterZ   := 350   ; Godhuman Z stun animation -> Kitsune C
delayAfterC   := 300   ; Kitsune C (Instinct-break) -> Kitsune X
delayAfterX   := 250   ; Kitsune X chain-hit -> follow-up M1s
m1Count       := 3     ; number of M1 clicks in the follow-up string
m1Delay       := 120   ; ms between each M1 click
delayBeforeV  := 200   ; last M1 -> Kitsune V finisher/transform

; ---------------------------- STATE -----------------------------------------

running := false

; ---------------------------- HOTKEYS ---------------------------------------

Hotkey(hotkeyTrigger, FireCombo)
Hotkey(hotkeyAbort, AbortCombo)

FireCombo(*) {
    global running
    if (running) {
        return  ; already mid-sequence, ignore re-trigger (prevents desync)
    }
    running := true
    try {
        RunCombo()
    } finally {
        running := false
    }
}

AbortCombo(*) {
    global running
    running := false
}

; ---------------------------- SEQUENCE ---------------------------------------

RunCombo() {
    global running

    ; 1. Godhuman Z — stun, opens the lock.
    if (!SendStep(keyGodhumanZ, delayAfterZ))
        return

    ; 2. Kitsune C — Instinct-break, big hitbox.
    if (!SendStep(keyKitsuneC, delayAfterC))
        return

    ; 3. Kitsune X — chain-hit up to 3 targets, DoT burn wrap.
    if (!SendStep(keyKitsuneX, delayAfterX))
        return

    ; 4. Godhuman M1 string while the target is stunned/burning.
    Loop m1Count {
        if (!running)
            return
        Click(mouseM1)
        Sleep(m1Delay)
    }

    Sleep(delayBeforeV)
    if (!running)
        return

    ; 5. Kitsune V — transform finisher / i-frame close.
    SendStep(keyKitsuneV, 0)
}

; Sends one key, waits `delay` ms, and returns false early if aborted mid-wait.
SendStep(key, delay) {
    global running
    if (!running)
        return false
    Send("{" key "}")
    if (delay > 0) {
        elapsed := 0
        step := 10
        while (elapsed < delay) {
            if (!running)
                return false
            Sleep(step)
            elapsed += step
        }
    }
    return running
}
