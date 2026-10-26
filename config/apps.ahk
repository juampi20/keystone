#Requires AutoHotkey v2.0

; App catalog. Modules refer to apps by name instead of repeating paths.
Apps := {
	Terminal: App("wt.exe", "ahk_exe WindowsTerminal.exe"),
	Browser:  App('"C:\Program Files\Zen Browser\zen.exe"', "ahk_exe zen.exe"),
	Explorer: App("explorer.exe", "ahk_class CabinetWClass"),
	Spotify:  App('"' A_AppData '\Spotify\Spotify.exe"', "ahk_exe Spotify.exe"),

	OutlastTrials: App("steam://rungameid/1304930", "ahk_exe TOTClient-Win64-Shipping.exe"),
}
