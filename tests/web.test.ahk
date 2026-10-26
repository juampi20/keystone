#Requires AutoHotkey v2.0
#NoTrayIcon

; Run: AutoHotkey64.exe /ErrorStdOut tests\web.test.ahk  (exit code 1 on failure)
#Include ..\lib\Web.ahk

failures := 0

Check(name, actual, expected) {
	global failures
	if actual !== expected {
		failures++
		FileAppend("FAIL " name ": got [" actual "] expected [" expected "]`n", "*", "UTF-8")
	}
}

Check("url with protocol", Web.IsUrl("https://example.com/a?b=1"), true)
Check("bare domain", Web.IsUrl("regex101.com"), true)
Check("domain with path", Web.IsUrl("github.com/jtroo/kanata"), true)
Check("sentence is not url", Web.IsUrl("what time is it"), false)
Check("decimal is not url", Web.IsUrl("3.14"), false)
Check("word is not url", Web.IsUrl("autohotkey"), false)
Check("encode spaces and symbols", Web.Encode("c# & c++"), "c%23%20%26%20c%2B%2B")
Check("encode accents as utf-8", Web.Encode("canción ñ"), "canci%C3%B3n%20%C3%B1")
Check("encode keeps safe chars", Web.Encode("a-b_c.d~e"), "a-b_c.d~e")

FileAppend((failures ? failures " failed" : "all passed") "`n", "*", "UTF-8")
ExitApp(failures ? 1 : 0)
