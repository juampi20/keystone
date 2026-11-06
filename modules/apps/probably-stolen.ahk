#Requires AutoHotkey v2.0

Cheatsheet.Add("Probably Stolen", "Middle click", "Shift + click (move to display)")
Cheatsheet.Add("Probably Stolen", "Side button, upper", "Alt + click (move to counter)")
Cheatsheet.Add("Probably Stolen", "Side button, lower", "Ctrl + click (move to inventory)")

; The game works per frame: a click with no duration loses its up and leaves the
; item in hand, and modifiers are polled, so both are held for a few frames.
ProbablyStolenClick(modifier) {
	Send("{" modifier " down}")
	Sleep(30)
	Click("Down")
	Sleep(40)
	Click("Up")
	Sleep(30)
	Send("{" modifier " up}")
}

#HotIf Apps.ProbablyStolen.IsActive()
	MButton::  ProbablyStolenClick("Shift")
	XButton2:: ProbablyStolenClick("Alt")
	XButton1:: ProbablyStolenClick("Ctrl")
#HotIf
