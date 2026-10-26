#Requires AutoHotkey v2.0

; Undocumented uxtheme.dll exports, only reachable by ordinal: 135 SetPreferredAppMode, 136 FlushMenuThemes.
EnableDarkMenus() {
	static ALLOW_DARK := 1
	uxtheme := DllCall("LoadLibrary", "Str", "uxtheme.dll", "Ptr")
	if !uxtheme
		return
	DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 135, "Ptr"), "Int", ALLOW_DARK)
	DllCall(DllCall("GetProcAddress", "Ptr", uxtheme, "Ptr", 136, "Ptr"))
}
