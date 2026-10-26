#Requires AutoHotkey v2.0

; Plays a .wav by name from C:\Windows\Media (e.g. "Speech On") or by full path.
; A missing file is ignored so a sound can never break a hotkey.
PlaySound(sound, wait := false) {
	path := InStr(sound, "\") ? sound : A_WinDir "\Media\" sound ".wav"
	try SoundPlay(path, wait)
}
