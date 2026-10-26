#Requires AutoHotkey v2.0

; Overrides Windows' default of saving a full screenshot to Pictures.
Cheatsheet.Add("Screenshot", "Win + PrintScreen", "Snipping Tool capture")

#PrintScreen:: Run("ms-screenclip:")
