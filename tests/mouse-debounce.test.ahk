#Requires AutoHotkey v2.0
#NoTrayIcon

; Run: AutoHotkey64.exe /ErrorStdOut tests\mouse-debounce.test.ahk  (exit code 1 on failure)
#Include ..\lib\ClickDebounce.ahk

failures := 0

Check(name, actual, expected) {
	global failures
	if actual !== expected {
		failures++
		FileAppend("FAIL " name ": got [" actual "] expected [" expected "]`n", "*", "UTF-8")
	}
}

; One press, one click.
d := ClickDebounce(50)
Check("press down", d.Down(1000), true)
Check("press up", d.Up(1030), true)

; A second closure right after the real one, with its own up.
d := ClickDebounce(50)
d.Down(1000)
Check("first up", d.Up(1003), true)
Check("bounce down", d.Down(1005), false)
Check("bounce up", d.Up(1008), false)
Check("next real down", d.Down(1300), true)

; The window counts from the last release, so a second click needs a full window
; after the first one lets go.
d := ClickDebounce(50)
Check("quick 1 down", d.Down(0), true)
Check("quick 1 up", d.Up(20), true)
Check("quick 2 down", d.Down(69), false)
Check("quick 2 at the edge", d.Down(70), true)
Check("quick 2 up", d.Up(100), true)

; A worn switch also bounces on release, long after the press.
d := ClickDebounce(50)
Check("long press down", d.Down(0), true)
Check("long press up", d.Up(200), "hold")
Check("release bounce down", d.Down(203), false)
Check("release bounce up", d.Up(206), "hold")
Check("release after quiet", d.Release(256), true)
Check("click after release bounce", d.Down(320), true)

; Holding the button: the release reaches the app once the window passes.
d := ClickDebounce(50)
Check("hold down", d.Down(0), true)
Check("hold up", d.Up(2000), "hold")
Check("hold release", d.Release(2050), true)
Check("release twice", d.Release(2051), false)

; Contact lost in the middle of a drag: no release, the drag goes on.
d := ClickDebounce(50)
d.Down(0)
Check("drag up", d.Up(400), "hold")
Check("drag down", d.Down(420), false)
Check("nothing to release", d.Release(470), false)
Check("drag keeps going", d.Up(900), "hold")
Check("drag ends", d.Release(950), true)

; A dropped down that never got an up must not swallow the real release.
d := ClickDebounce(50)
Check("hold with bounce", d.Down(0), true)
Check("bounce down only", d.Down(10), false)
Check("release after hold", d.Up(900), "hold")

; An up with no down before it is not ours to drop.
d := ClickDebounce(50)
Check("orphan up", d.Up(500), true)

; The window comes from the caller.
d := ClickDebounce(100)
d.Down(0)
Check("window 100 down", d.Down(60), false)
d := ClickDebounce(20)
d.Down(0)
Check("window 20 down", d.Down(60), true)

FileAppend((failures ? failures " failed" : "all passed") "`n", "*", "UTF-8")
ExitApp(failures ? 1 : 0)
