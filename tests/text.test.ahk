#Requires AutoHotkey v2.0
#NoTrayIcon

; Run: AutoHotkey64.exe /ErrorStdOut tests\text.test.ahk  (exit code 1 on failure)
#Include ..\lib\Text.ahk

failures := 0

Check(name, actual, expected) {
	global failures
	if actual !== expected {
		failures++
		FileAppend("FAIL " name ": got [" actual "] expected [" expected "]`n", "*", "UTF-8")
	}
}

Check("sentence basic", StrSentence("hola MUNDO. qué TAL? bien"), "Hola mundo. Qué tal? Bien")
Check("sentence spanish marks", StrSentence("¿QUÉ tal? ¡muy bien!"), "¿Qué tal? ¡Muy bien!")
Check("sentence accent first", StrSentence("ÁRBOL grande"), "Árbol grande")
Check("sentence newline", StrSentence("uno.`ndos"), "Uno.`nDos")
Check("upper accents", StrUpper("canción ñandú"), "CANCIÓN ÑANDÚ")
Check("title accents", StrTitle("él está ÁQUÍ"), "Él Está Áquí")

FileAppend((failures ? failures " failed" : "all passed") "`n", "*", "UTF-8")
ExitApp(failures ? 1 : 0)
