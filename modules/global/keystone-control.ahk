#Requires AutoHotkey v2.0

Cheatsheet.Add("Keystone", "CapsLock + F5", "Reload (plays a ding)")
Cheatsheet.Add("Keystone", "CapsLock + F12", "Pause / resume all hotkeys")

; Exempt from Suspend so they work while paused.
#SuspendExempt
CapsLock & F5::  Keystone.Reload()
CapsLock & F12:: Keystone.TogglePause()
#SuspendExempt False
