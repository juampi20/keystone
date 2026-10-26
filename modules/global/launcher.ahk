#Requires AutoHotkey v2.0

Cheatsheet.Add("Apps", "CapsLock + t", "Terminal")
Cheatsheet.Add("Apps", "CapsLock + w", "Browser (Zen)")
Cheatsheet.Add("Apps", "CapsLock + f", "File Explorer")
Cheatsheet.Add("Apps", "CapsLock + s", "Spotify")
Cheatsheet.Add("Apps", "CapsLock + d", "Discord")
Cheatsheet.Add("Apps", "CapsLock + c", "Docker Desktop")
Cheatsheet.Add("Apps", "CapsLock + m", "Obsidian")
Cheatsheet.Add("Apps", "CapsLock + g", "Steam")

CapsLock & t:: Apps.Terminal.Toggle()
CapsLock & w:: Apps.Browser.Toggle()
CapsLock & f:: Apps.Explorer.Toggle()
CapsLock & s:: Apps.Spotify.Toggle()
CapsLock & d:: Apps.Discord.Toggle()
CapsLock & c:: Apps.Docker.Toggle()
CapsLock & m:: Apps.Obsidian.Toggle()
CapsLock & g:: Apps.Steam.Toggle()
