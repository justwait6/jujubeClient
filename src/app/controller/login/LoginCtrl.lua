local LoginCtrl = class("LoginCtrl")

local LoginType = require("app.model.login.LoginType")

local actMgr = require("app.model.activity.ActManager").getInstance()

function LoginCtrl:ctor()
	self:initialize()
end

function LoginCtrl:initialize()
end

function LoginCtrl:addEventListeners()
	-- g.event:on(g.eventNames.XX, handler(self, self.XX), self)
end

function LoginCtrl:requestGuestLogin()
	g.user:setLoginType(LoginType.GUEST)
	self:login(handler(self, self.onLoginSucc), handler(self, self.onLoginFail))
end

function LoginCtrl:requestFaceBookLogin()
	g.user:setLoginType(LoginType.FACEBOOK)
	self:login(handler(self, self.onLoginSucc), handler(self, self.onLoginFail))
end

function LoginCtrl:requestServerTableId()
end

function LoginCtrl:login(successCallback, failCallback)
	g.myUi.miniLoading:show()

	local loginParams = self:getLoginParams()
	
	-- timeout连接显示一次
	self.postLoginId = g.http:simplePost(loginParams,
        successCallback, failCallback)
end

function LoginCtrl:getLoginParams(data)
	local loginParams = {}
	loginParams.access_token 	= g.myDevice:getAccessToken()
	loginParams.imei 		 	= g.myDevice:getImei() 
	loginParams.mac_address 	= g.myDevice:getMacAddress()
	loginParams.os 				= g.myDevice:getOs() -- 终端操作系统
	loginParams.machine_type 	= g.myDevice:getPhoneModel() -- 移动终端设备机型 iphone7
	loginParams.network 		= g.myDevice:getInternetAccess() -- 接入方式，例如wifi
	loginParams.pid 			= g.myDevice:getPlatformId() --平台ID 1-安卓 2-ios
	loginParams.timezone  		= g.Const.timeZone
	loginParams.version 		= g.Const.version -- 当前游戏版本号
	loginParams.gid 			= g.Const.gameId --游戏客户端ID  200-骰子
	loginParams.lid 			= g.user:getLoginType() --登录类型Id 1-fb 2-游客
	loginParams.cid 			= 0 --渠道id，预留字段，目前传0即可
	loginParams.name 			= '100'
	loginParams.password 		= '123456'
	loginParams._interface		= '/login'

	loginParams.sig = self:getEncryptSiganature(loginParams)
   
    if referrer and referrer ~= "" and device.platform == "android" then
          loginParams.ads = g.myFunc:encodeURI(referrer)
    end
    if device.platform == "android" then
          loginParams.timezone = g.myFunc:encodeURI(g.Const.timeZone)
	end
	return loginParams
end

function LoginCtrl:getEncryptSiganature(params)
	local key_table = {}
	for key, _ in pairs(params) do
		table.insert(key_table, key)
	end
	table.sort(key_table)
	-- dump(key_table)
	local str = ""
	for _,key in pairs(key_table) do
		str = str .. key .. "=" .. params[key] .. "&"
	end
	str = str .. "!@#$iop"
	return crypto.md5(str)
end

function LoginCtrl:onLoginSucc(data)
	dump(data)

	local data = data or {}
	data.info = data.info or {}
	data.info.hallip = data.info.hallip or "47.88.215.218:9003"

	local user = data.info.user
	-- g.user:setUid(user.uid or 0) --用户uid
	-- g.user:setAccessServerToken(data.info.token)
	-- g.user:setHallIpAndPort(data.info.hallip)
	-- g.user:setBackupIp(data.info.backupHallIp)
	g.http:setToken(data.token)
	actMgr:setActSwitches(data.switches)

	g.myApp:enterScene("HallScene")
end

function LoginCtrl:onLoginFail(errData)
    if tonumber(errData) == 28 or tonumber(errData) == 7 or tonumber(errData) == 6 then
    	g.myUi.topTip:showText(g.lang:getText("HTTP", "TIMEOUT"))
    elseif type(errData) == "table" then
    	errData.info = errData.info or {}
    	print("LoginScene:onLoginFail ERROR: ", errData.info.msg)
    else
    	g.myUi.topTip:clearAll()
    	g.myUi.topTip:showText(g.lang:getText("COMMON", "NO_NETWORK"))
    end
end

function LoginCtrl:XXXX()
	
end

function LoginCtrl:XXXX()
	
end

function LoginCtrl:XXXX()
	
end

return LoginCtrl
