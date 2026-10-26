#Requires AutoHotkey v2.0

; Hotkeys active only inside one app. Each module wraps its hotkeys in
; #HotIf Apps.<Name>.IsActive() ... #HotIf. Add one #Include per module.
#Include outlast-trials.ahk
