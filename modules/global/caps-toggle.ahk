#Requires AutoHotkey v2.0

Cheatsheet.Add("Text", "CapsLock twice", "Toggle Caps Lock (plays a sound)")

; CapsLock is a modifier: a lone tap does nothing, two quick taps flip Caps Lock.
; Send would restore the state it remembers, which is stale in this thread.
SetStoreCapsLockMode(false)
SetCapsLockState("Off")

; GetKeyState never sees these key presses, so the state is tracked here.
capsOn := false
capsTaps := DoubleTap(400)

FlipCapsLock() {
	global capsOn
	capsOn := !capsOn
	Send("{CapsLock}")
	PlaySound(capsOn ? "Windows Hardware Insert" : "Windows Hardware Remove")
}

; A Send inside the hotkey is sometimes lost, so the flip runs from a timer.
CapsLock:: {
	if capsTaps.Tap(A_TickCount)
		SetTimer(FlipCapsLock, -30)
}
