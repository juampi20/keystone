#Requires AutoHotkey v2.0

; App catalog. Modules refer to apps by name instead of repeating paths.
Apps := {
	Terminal: App("wt.exe", "ahk_exe WindowsTerminal.exe"),
	Browser:  App('"C:\Program Files\Zen Browser\zen.exe"', "ahk_exe zen.exe"),
	Explorer: App("explorer.exe", "ahk_class CabinetWClass"),
	Spotify:  App('"' A_AppData '\Spotify\Spotify.exe"', "ahk_exe Spotify.exe"),
	Discord:  App('"' EnvGet("LOCALAPPDATA") '\Discord\Discord.exe"', "ahk_exe Discord.exe"),
	Docker:   App('"C:\Program Files\Docker\Docker\Docker Desktop.exe"', "ahk_exe Docker Desktop.exe"),
	Obsidian: App('"C:\Program Files\Obsidian\Obsidian.exe"', "ahk_exe Obsidian.exe"),
	; Steam's UI window belongs to steamwebhelper.exe, not steam.exe.
	Steam:    App('"C:\Program Files (x86)\Steam\steam.exe"', "Steam ahk_exe steamwebhelper.exe"),

	OutlastTrials: App("steam://rungameid/1304930", "ahk_exe TOTClient-Win64-Shipping.exe"),
}
