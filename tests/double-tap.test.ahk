#Requires AutoHotkey v2.0
#NoTrayIcon

; Run: AutoHotkey64.exe /ErrorStdOut tests\double-tap.test.ahk  (exit code 1 on failure)
#Include ..\lib\DoubleTap.ahk

failures := 0

Check(name, actual, expected) {
	global failures
	if actual !== expected {
		failures++
		FileAppend("FAIL " name ": got [" actual "] expected [" expected "]`n", "*", "UTF-8")
	}
}

; Two taps inside the window make a pair; the window edge still counts.
d := DoubleTap(400)
Check("first tap", d.Tap(1000), false)
Check("second tap", d.Tap(1300), true)
d := DoubleTap(400)
d.Tap(0)
Check("edge of the window", d.Tap(400), true)

; Too slow: the second tap is a first tap again.
d := DoubleTap(400)
d.Tap(0)
Check("too slow", d.Tap(401), false)
Check("pair after a slow tap", d.Tap(500), true)

; A third tap starts a new pair instead of chaining.
d := DoubleTap(400)
d.Tap(0)
Check("pair", d.Tap(100), true)
Check("third tap", d.Tap(150), false)
Check("second pair", d.Tap(200), true)

; The window comes from the caller.
d := DoubleTap(200)
d.Tap(0)
Check("window 200", d.Tap(300), false)

FileAppend((failures ? failures " failed" : "all passed") "`n", "*", "UTF-8")
ExitApp(failures ? 1 : 0)
