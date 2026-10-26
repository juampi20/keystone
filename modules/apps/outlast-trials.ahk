#Requires AutoHotkey v2.0

Cheatsheet.Add("Outlast Trials", "Alt + left / right click", "Enter / Escape")
Cheatsheet.Add("Outlast Trials", "Alt (hold)", "Also holds W to keep walking")

#HotIf Apps.OutlastTrials.IsActive()
	!LButton:: Send("{Enter}")
	!RButton:: Send("{Escape}")
	~LAlt:: w
#HotIf
