local User = class("User")

local Gender = require("app.model.baseDef.Gender")
User.Gender = Gender

function User:ctor()
	self:initialize()
end

function User.getInstance()
	if not User.singleInstance then
		User.singleInstance = User.new()
	end
	return User.singleInstance
end

function User:initialize()

end

function User:setUid(uid)
	self.uid = uid
end

function User:getUid()
	return self.uid
end

function User:setName(name)
	self.name = name
end

function User:getName()
	return self.name
end

function User:setGender(gender)
	self.gender = gender
end

function User:getGender()
	return self.gender or Gender.FEMALE
end

function User:setIconUrl(iconUrl, isRelative)
	if isRelative then
		self.iconUrl = self:getImageBase() .. iconUrl
    else
        self.iconUrl = iconUrl
    end
end

function User:getIconUrl()
	return self.iconUrl or ""
end

function User:setImageBase(imageBase)
	self.imageBase = imageBase
end

function User:getImageBase()
	return self.imageBase or ""
end

function User:setMoney(money)
	self.money = money
end

function User:getMoney()
	return self.money
end

function User:setGold(gold)
	self.gold = gold
end

function User:getGold()
	return self.gold
end

function User:getAccessToken()

end

--大厅ip
function User:setHallIp(hallip)
    self.hallip = hallip
end

function User:getHallIp()
    return self.hallip
end

--大厅port
function User:setHallPort(hallPort)
    self.hallPort = hallPort
end

function User:getHallPort()
    return self.hallPort
end

function User:setHallIpAndPort(hallIpPort)
    if not hallIpPort then return end
    local ipports = g.myFunc:split(hallIpPort, ":")
    if #ipports ~= 2 then return end
    g.user:setHallIp(ipports[1])
    g.user:setHallPort(ipports[2])
end

function User:setBackupIp(backupip)
    self.backupIp = backupip
end

function User:getBackupIp()
    return self.backupIp
end

function User:setAccessServerToken(serverToken)
	self.serverToken = serverToken
end

--[[
	访问Server所需要的token
--]]
function User:getAccessServerToken()
	return self.serverToken
end

function User:getLoginType()
	return self.loginType
end

--[[
	设置登录类型: LoginType.FACEBOOK, LoginType.GUEST
--]]
function User:setLoginType(loginType)
	self.loginType = loginType
end

return User