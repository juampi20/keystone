#Requires AutoHotkey v2.0
#SingleInstance Force

#Include lib\App.ahk
#Include lib\Text.ahk
#Include lib\Web.ahk
#Include lib\Sound.ahk
#Include lib\DarkMenus.ahk
#Include lib\StartMenu.ahk
#Include lib\Startup.ahk
#Include lib\Cheatsheet.ahk
#Include lib\ClickDebounce.ahk
#Include lib\MouseDebounce.ahk
#Include lib\Keystone.ahk
#Include config\apps.ahk
#Include ui\Panel.ahk

EnableDarkMenus()
Keystone.UpdateTray()

; Double-clicking the tray icon runs the default item.
A_TrayMenu.Insert("1&", "Open Keystone", (*) => Panel.Show())
A_TrayMenu.Insert("2&")
A_TrayMenu.Default := "Open Keystone"

#Include modules\global\_index.ahk
#Include modules\apps\_index.ahk

if !Keystone.IsQuiet()
	Panel.Show()
