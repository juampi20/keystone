#Requires AutoHotkey v2.0

Cheatsheet.Add("Text", "CapsLock + ↑ / ↓", "Selection to UPPERCASE / lowercase")
Cheatsheet.Add("Text", "CapsLock + ← / →", "Selection to Sentence case / Title Case")

CapsLock & Up::    TransformSelection(StrUpper)
CapsLock & Down::  TransformSelection(StrLower)
CapsLock & Left::  TransformSelection(StrSentence)
CapsLock & Right:: TransformSelection(StrTitle)
