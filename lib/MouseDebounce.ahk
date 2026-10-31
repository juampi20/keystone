#Requires AutoHotkey v2.0

; Watches left clicks with a low level hook and drops the bounce of a worn
; switch. Clicks reach the app exactly as the mouse sent them. The one exception
; is the release of a long hold: it waits the window out, and is sent again as a
; left up if the switch stayed open, so lost contact mid-drag doesn't end the drag.
class MouseDebounce {
	static INI := A_ScriptDir "\Keystone.ini"
	static SECTION := "MouseDebounce"

	static WM_LBUTTONDOWN := 0x0201
	static WM_LBUTTONUP := 0x0202
	static LLMHF_INJECTED := 1
	static MOUSEEVENTF_LEFTUP := 0x0004
	static WH_MOUSE_LL := 14
	static WS_CAPTION := 0x00C00000
	static GWL_STYLE := -16
	static MONITOR_DEFAULTTONEAREST := 2

	static enabled := false
	static ms := 50
	static rule := ClickDebounce(50)
	static hook := 0
	static callback := 0
	static releaseTimer := 0

	static Start() {
		MouseDebounce.releaseTimer := ObjBindMethod(MouseDebounce, "Release")
		MouseDebounce.SetMs(MouseDebounce.Load("Ms", 50))
		MouseDebounce.SetEnabled(MouseDebounce.Load("Enabled", 1) = 1)
	}

	static SetEnabled(on) {
		MouseDebounce.enabled := on ? true : false
		MouseDebounce.Save("Enabled", MouseDebounce.enabled ? 1 : 0)
		if MouseDebounce.enabled
			MouseDebounce.Install()
		else
			MouseDebounce.Remove()
	}

	static SetMs(ms) {
		try ms := Integer(ms)
		catch
			return
		if ms < 10 || ms > 1000
			return
		MouseDebounce.Release()
		MouseDebounce.ms := ms
		MouseDebounce.rule := ClickDebounce(ms)
		MouseDebounce.Save("Ms", ms)
	}

	; Runs on every mouse event, so it only does a few reads and never throws.
	; Windows silently removes a slow low level hook, so mouse moves leave before
	; the fullscreen check.
	static HookProc(nCode, wParam, lParam) {
		if nCode < 0
			return DllCall("CallNextHookEx", "Ptr", 0, "Int", nCode, "UInt", wParam, "Ptr", lParam)

		pass := true
		isDown := wParam = MouseDebounce.WM_LBUTTONDOWN
		if (isDown || wParam = MouseDebounce.WM_LBUTTONUP)
			&& !(NumGet(lParam, 12, "UInt") & MouseDebounce.LLMHF_INJECTED)
			&& MouseDebounce.enabled && !A_IsSuspended && !MouseDebounce.IsFullscreen() {
			if isDown {
				pass := MouseDebounce.rule.Down(A_TickCount)
				SetTimer(MouseDebounce.releaseTimer, 0)
			} else {
				pass := MouseDebounce.rule.Up(A_TickCount)
				if pass == "hold" {
					SetTimer(MouseDebounce.releaseTimer, -MouseDebounce.ms)
					pass := false
				}
			}
		}
		return pass ? DllCall("CallNextHookEx", "Ptr", 0, "Int", nCode, "UInt", wParam, "Ptr", lParam) : 1
	}

	; A game covers a monitor and has no title bar. If this ever guesses wrong,
	; the panel checkbox or pausing Keystone turns the debounce off.
	static IsFullscreen() {
		win := DllCall("GetForegroundWindow", "Ptr")
		if !win
			return false
		if DllCall("GetWindowLongPtr", "Ptr", win, "Int", MouseDebounce.GWL_STYLE, "Ptr") & MouseDebounce.WS_CAPTION
			return false

		rect := Buffer(16, 0)
		if !DllCall("GetWindowRect", "Ptr", win, "Ptr", rect)
			return false
		x := NumGet(rect, 0, "Int"), y := NumGet(rect, 4, "Int")
		w := NumGet(rect, 8, "Int") - x, h := NumGet(rect, 12, "Int") - y

		monitor := DllCall("MonitorFromWindow", "Ptr", win, "UInt", MouseDebounce.MONITOR_DEFAULTTONEAREST, "Ptr")
		info := Buffer(40, 0)
		NumPut("UInt", 40, info, 0)
		if !DllCall("GetMonitorInfo", "Ptr", monitor, "Ptr", info)
			return false
		left := NumGet(info, 4, "Int"), top := NumGet(info, 8, "Int")
		right := NumGet(info, 12, "Int"), bottom := NumGet(info, 16, "Int")

		return x <= left && y <= top && x + w >= right && y + h >= bottom
	}

	; The window passed with the switch still open, so the held up was real.
	static Release() {
		SetTimer(MouseDebounce.releaseTimer, 0)
		if MouseDebounce.rule.Release(A_TickCount)
			DllCall("mouse_event", "UInt", MouseDebounce.MOUSEEVENTF_LEFTUP, "UInt", 0, "UInt", 0, "UInt", 0, "UPtr", 0)
	}

	static Install() {
		if MouseDebounce.hook
			return
		MouseDebounce.callback := CallbackCreate(MouseDebounceHook, "Fast", 3)
		MouseDebounce.hook := DllCall("SetWindowsHookEx", "Int", MouseDebounce.WH_MOUSE_LL,
			"Ptr", MouseDebounce.callback, "Ptr", 0, "UInt", 0, "Ptr")
	}

	static Remove() {
		if !MouseDebounce.hook
			return
		MouseDebounce.Release()
		DllCall("UnhookWindowsHookEx", "Ptr", MouseDebounce.hook)
		MouseDebounce.hook := 0
		CallbackFree(MouseDebounce.callback)
		MouseDebounce.callback := 0
	}

	static Load(key, default) {
		try
			return IniRead(MouseDebounce.INI, MouseDebounce.SECTION, key, default)
		return default
	}

	; A read only folder only costs the saved value, not the setting.
	static Save(key, value) {
		try IniWrite(value, MouseDebounce.INI, MouseDebounce.SECTION, key)
	}
}

; CallbackCreate refuses a static method in Fast mode, and Fast keeps the hook
; from showing an error dialog on every mouse event.
MouseDebounceHook(nCode, wParam, lParam) {
	return MouseDebounce.HookProc(nCode, wParam, lParam)
}
