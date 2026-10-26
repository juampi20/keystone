#Requires AutoHotkey v2.0

#Include lib\Startup.ahk

; Toggles running Keystone when Windows starts (also available in the panel).
if Startup.IsEnabled() {
	Startup.Disable()
	MsgBox("Keystone will no longer start with Windows.", "Keystone")
} else {
	Startup.Enable()
	MsgBox("Keystone will start with Windows.", "Keystone")
}
