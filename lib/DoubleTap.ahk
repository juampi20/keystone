#Requires AutoHotkey v2.0

; Tells the second tap of a pair from the first. It takes timestamps instead of
; reading the clock so it can be tested without a keyboard.
class DoubleTap {
	; window: max ms between two taps that make a pair.
	__New(window) {
		this.window := window
		this.last := -1
	}

	; True on the second tap of a pair; the tap after it starts a new pair.
	Tap(now) {
		if this.last >= 0 && now - this.last <= this.window {
			this.last := -1
			return true
		}
		this.last := now
		return false
	}
}
