#Requires AutoHotkey v2.0

class Panel {
	static gui := ""

	static Show() {
		if !Panel.gui
			Panel.Build()
		Panel.Refresh()
		Panel.gui.Show()
	}

	static Build() {
		g := Gui(, "Keystone")
		g.SetFont("s10", "Segoe UI")

		Panel.status := g.AddText("w560")

		list := g.AddListView("w560 r18 -Multi NoSortHdr ReadOnly", ["Section", "Keys", "Action"])
		for entry in Cheatsheet.entries
			list.Add(, entry*)
		loop 3
			list.ModifyCol(A_Index, "AutoHdr")

		Panel.pauseButton := g.AddButton("w120")
		Panel.pauseButton.OnEvent("Click", (*) => Keystone.TogglePause())
		g.AddButton("x+8 w120", "Reload").OnEvent("Click", (*) => Keystone.Reload())
		g.AddButton("x+8 w120", "Open folder").OnEvent("Click", (*) => Run(A_ScriptDir))

		Panel.startup := g.AddCheckbox("xm", "Start with Windows")
		Panel.startup.OnEvent("Click", (box, *) => box.Value ? Startup.Enable() : Startup.Disable())

		Panel.debounce := g.AddCheckbox("xm", "Debounce left click")
		Panel.debounce.OnEvent("Click", (box, *) => MouseDebounce.SetEnabled(box.Value))
		Panel.debounceMs := g.AddEdit("x+8 w50 Number Limit3")
		Panel.debounceMs.OnEvent("Change", (edit, *) => MouseDebounce.SetMs(edit.Value))
		g.AddText("x+8", "ms")

		g.OnEvent("Escape", (g) => g.Hide())
		Keystone.OnChange.Push(() => Panel.Refresh())
		Panel.gui := g
	}

	static Refresh() {
		Panel.status.Value := A_IsSuspended ? "Paused: hotkeys are off." : "Active: hotkeys are on."
		Panel.pauseButton.Text := A_IsSuspended ? "Resume" : "Pause"
		Panel.startup.Value := Startup.IsEnabled()
		Panel.debounce.Value := MouseDebounce.enabled
		Panel.debounceMs.Value := MouseDebounce.ms
	}
}
