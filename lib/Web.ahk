#Requires AutoHotkey v2.0

class Web {
	static SEARCH_URL := "https://duckduckgo.com/?q="

	; A full URL ("https://...") or a bare domain ("regex101.com/path").
	static IsUrl(text) {
		return text ~= "i)^\w+://\S+$"
			|| text ~= "i)^[\w-]+(\.[\w-]+)*\.[a-z]{2,}(:\d+)?([/?#]\S*)?$"
	}

	; Percent-encodes text as UTF-8 for use in a query string.
	static Encode(text) {
		buf := Buffer(StrPut(text, "UTF-8"))
		StrPut(text, buf, "UTF-8")
		encoded := ""
		loop buf.Size - 1 {
			byte := NumGet(buf, A_Index - 1, "UChar")
			char := Chr(byte)
			encoded .= (char ~= "[A-Za-z0-9_.~-]") ? char : Format("%{:02X}", byte)
		}
		return encoded
	}

	static Open(url) {
		Run(url ~= "^\w+://" ? url : "https://" url)
	}

	static Search(query) {
		Run(Web.SEARCH_URL Web.Encode(query))
	}

	static SearchOrOpen(text) {
		text := Trim(RegExReplace(text, "\s+", " "))
		if !text
			return
		Web.IsUrl(text) ? Web.Open(text) : Web.Search(text)
	}
}
