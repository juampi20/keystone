#Requires AutoHotkey v2.0

; State and actions of Keystone itself, shared by hotkeys and the panel.
class Keystone {
	static ICON := A_ScriptDir "\assets\keystone.ico"
	static ICON_PAUSED := A_ScriptDir "\assets\keystone-paused.ico"
	static OnChange := [] ; callbacks run after pause / resume

	; True when started with --quiet (Windows startup or reload): no panel.
	static IsQuiet() {
		for arg in A_Args
			if arg = "--quiet"
				return true
		return false
	}

	static UpdateTray() {
		A_IconTip := A_IsSuspended ? "Keystone (paused)" : "Keystone"
		; Freeze keeps our icon instead of AHK's default one when suspended.
		TraySetIcon(A_IsSuspended ? Keystone.ICON_PAUSED : Keystone.ICON,, true)
	}

	static TogglePause() {
		Suspend(-1)
		Keystone.UpdateTray()
		PlaySound(A_IsSuspended ? "Speech Off" : "Speech On")
		for callback in Keystone.OnChange
			callback()
	}

	; Restarts the script without opening the panel.
	static Reload() {
		PlaySound("Windows Ding", true)
		Run(Format('"{1}" /restart "{2}" --quiet', A_AhkPath, A_ScriptFullPath))
	}
}
