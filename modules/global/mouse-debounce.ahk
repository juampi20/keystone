#Requires AutoHotkey v2.0

; A worn switch can report two clicks for one press. The panel has the on/off
; and the window in milliseconds.
Cheatsheet.Add("Mouse", "Left click", "Bounces inside the panel window are dropped")

MouseDebounce.Start()
