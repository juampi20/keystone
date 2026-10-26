#Requires AutoHotkey v2.0

; Hotkey descriptions shown in the panel. Each module adds its own.
class Cheatsheet {
	static entries := []

	static Add(section, keys, action) {
		Cheatsheet.entries.Push([section, keys, action])
	}
}
