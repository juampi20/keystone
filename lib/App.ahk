#Requires AutoHotkey v2.0

class App {
	; target: what Run() launches. title: AHK WinTitle that identifies its window.
	__New(target, title) {
		this.target := target
		this.title := title
	}

	Run() => Run(this.target)

	IsActive() => WinActive(this.title)

	; Hides the app when focused, focuses it when open, launches it otherwise.
	Toggle() {
		if WinActive(this.title)
			WinMinimize(this.title)
		else if WinExist(this.title)
			WinActivate(this.title)
		else
			this.Run()
	}
}
