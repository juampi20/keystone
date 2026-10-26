#Requires AutoHotkey v2.0

Cheatsheet.Add("Media", "CapsLock + mouse wheel", "Volume up / down")
Cheatsheet.Add("Media", "CapsLock + middle click", "Mute / unmute")

CapsLock & WheelUp::   Send("{Volume_Up}")
CapsLock & WheelDown:: Send("{Volume_Down}")
CapsLock & MButton::   Send("{Volume_Mute}")
