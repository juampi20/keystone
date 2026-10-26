#Requires AutoHotkey v2.0

; Call inside a Win + mouse hotkey. Mouse input does not count as a combo,
; so releasing Win would open Start; vkE8 is an unassigned key that counts.
KeepStartMenuClosed() {
	Send("{Blind}{vkE8}")
}
