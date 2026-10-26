#Requires AutoHotkey v2.0

; Copies the selection, then restores the previous clipboard.
GetSelection() {
	saved := ClipboardAll()
	A_Clipboard := ""
	Send("^c")
	selection := ClipWait(1) ? A_Clipboard : ""
	A_Clipboard := saved
	return selection
}

; Pastes the text, then restores the previous clipboard.
Write(text) {
	saved := ClipboardAll()
	A_Clipboard := text
	ClipWait(1)
	Send("^v")
	Sleep(100) ; give the target app time to read the clipboard before restoring it
	A_Clipboard := saved
}

; Lowercases the text and capitalizes the first letter of each sentence.
StrSentence(text) {
	return RegExReplace(StrLower(text), "(^|[.!?]\s+)([¿¡`"'(]*)(\p{L})", "$1$2$U3")
}

; No-op without a selection or when the transform changes nothing.
TransformSelection(transform) {
	if !(selection := GetSelection())
		return
	if (result := transform(selection)) !== selection
		Write(result)
}
