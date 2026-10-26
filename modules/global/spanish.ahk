#Requires AutoHotkey v2.0

; CapsLock no longer toggles caps; it only works as a modifier.
SetCapsLockState("AlwaysOff")

SpanishChars := Map(
	"n", ["ñ", "Ñ"],
	"a", ["á", "Á"],
	"e", ["é", "É"],
	"i", ["í", "Í"],
	"o", ["ó", "Ó"],
	"u", ["ú", "Ú"],
	"/", ["¿", "¿"],
)

SendSpanishChar(chars, *) {
	SendText(GetKeyState("Shift", "P") ? chars[2] : chars[1])
}

Cheatsheet.Add("Spanish", "CapsLock + n a e i o u", "ñ á é í ó ú (add Shift for uppercase)")
Cheatsheet.Add("Spanish", "CapsLock + /", "¿")

for key, chars in SpanishChars
	Hotkey("CapsLock & " key, SendSpanishChar.Bind(chars))
