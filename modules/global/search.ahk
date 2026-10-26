#Requires AutoHotkey v2.0

Cheatsheet.Add("Web", "Alt + G", "Open selected URL or search it on DuckDuckGo")

!g:: Web.SearchOrOpen(GetSelection())
