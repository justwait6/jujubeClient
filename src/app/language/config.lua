local LangConfig = {}

local LangDef = import(".LangDef")

LangConfig[tostring(LangDef.CH)] = {
	desc = "Chinese",
	langRes = "app.language.cn.lang",
	platformResPath = "resCN/",
	hostUrl = "http://47.100.99.3:9000",
}

LangConfig[tostring(LangDef.EN)] = {
	desc = "English",
	langRes = "app.language.en.lang",
	platformResPath = "resEN/",
	hostUrl = "http://47.100.99.3:9000",
}

LangConfig[tostring(LangDef.ID)] = {
	desc = "Indonesia",
	langRes = "app.language.id.lang",
	platformResPath = "resID/",
	hostUrl = "http://47.100.99.3:9000",
}

LangConfig[tostring(LangDef.TH)] = {
	desc = "Thailand",
	langRes = "app.language.th.lang",
	platformResPath = "resTH/",
	hostUrl = "http://47.100.99.3:9000",
}

return LangConfig
