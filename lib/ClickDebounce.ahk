#Requires AutoHotkey v2.0

; A worn switch closes twice for one press: two downs a few ms apart, each with
; its own up. The rule takes timestamps instead of reading the clock so it can be
; tested without a mouse. True means let the event through, false means drop it.
class ClickDebounce {
	; A press held at least this long is a drag, where one lost contact would end it.
	static HOLD := 150

	; window: ms between two downs that still count as one press.
	__New(window) {
		this.window := window
		this.prevDown := -1
		this.prevUp := -1
		this.droppedDown := -1
		this.held := false
		this.pendingUp := false
	}

	; Measured from the last release too: a worn switch also bounces when it lets
	; go, which can be long after the previous down.
	Down(now) {
		; The switch lost contact mid-hold: the held up never went out, so the app
		; still has the button down and this down is the same press coming back.
		if this.pendingUp {
			this.pendingUp := false
			return false
		}
		if (this.prevDown >= 0 && now - this.prevDown < this.window)
			|| (this.prevUp >= 0 && now - this.prevUp < this.window) {
			this.droppedDown := now
			return false
		}
		this.prevDown := now
		this.droppedDown := -1
		this.held := true
		return true
	}

	; The up of a dropped down is dropped too, or apps that count on up see two clicks.
	; After a long hold the up returns "hold": wait window ms, then call Release.
	Up(now) {
		if this.held && now - this.prevDown >= ClickDebounce.HOLD {
			this.pendingUp := true
			return "hold"
		}
		this.held := false
		drop := this.droppedDown >= 0 && now - this.droppedDown <= this.window
		this.droppedDown := -1
		this.prevUp := now
		return !drop
	}

	; The window passed with no down: the held up was real. True means send it.
	Release(now) {
		if !this.pendingUp
			return false
		this.pendingUp := false
		this.held := false
		this.prevUp := now
		return true
	}
}
