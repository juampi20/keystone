#Requires AutoHotkey v2.0

; Shortcut in the Windows startup folder that runs Keystone without the panel.
class Startup {
	static SHORTCUT := A_Startup "\Keystone.lnk"

	static IsEnabled() => FileExist(Startup.SHORTCUT) != ""

	static Enable() {
		FileCreateShortcut(A_ScriptDir "\Keystone.ahk", Startup.SHORTCUT, A_ScriptDir, "--quiet")
	}

	static Disable() {
		if Startup.IsEnabled()
			FileDelete(Startup.SHORTCUT)
	}
}
