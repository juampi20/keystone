#Requires AutoHotkey v2.0

Cheatsheet.Add("Apps", "CapsLock + t", "Terminal")
Cheatsheet.Add("Apps", "CapsLock + w", "Browser (Zen)")
Cheatsheet.Add("Apps", "CapsLock + f", "File Explorer")
Cheatsheet.Add("Apps", "CapsLock + s", "Spotify")

CapsLock & t:: Apps.Terminal.Toggle()
CapsLock & w:: Apps.Browser.Toggle()
CapsLock & f:: Apps.Explorer.Toggle()
CapsLock & s:: Apps.Spotify.Toggle()
