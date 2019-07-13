local LoginView = class("LoginView", function ()
	return display.newNode()
end)

local LoginCtrl = require("app.controller.login.LoginCtrl")

function LoginView:ctor()
	self.ctrl = LoginCtrl.new(self)
	self:setNodeEventEnabled(true)
	self:initialize()
	self:addEventListeners()
end

function LoginView:initialize()
	display.newSprite(g.Res.login_loginBg):addTo(self)

	display.newTTFLabel({
        	text = g.lang:getText("LOGIN", "LOGIN_TIPS"), size = 28, color = cc.c3b(0, 128, 128)})
    	:pos(0, 160)
    	:addTo(self)

    local yOffset = -236
    -- 邀请码输入框
	self.nameEditBox = g.myUi.EditBox.new({
            image = g.Res.moneytreeinvite_codeBg,
            imageOffset = cc.p(94, 0),
			size = cc.size(180, 54),
			fontColor = cc.c3b(254, 255, 151),
			fontSize = 20,
			maxLength = 20,
			placeHolder = g.lang:getText("LOGIN", "NAME_TIPS"),
			holderColor = cc.c3b(64, 97, 179)
		})
		:pos(-94, 80 + yOffset)
		:addTo(self)

    -- 邀请码输入框
	self.pwdEditBox = g.myUi.EditBox.new({
            image = g.Res.moneytreeinvite_codeBg,
            imageOffset = cc.p(94, 0),
			size = cc.size(180, 54),
			fontColor = cc.c3b(254, 255, 151),
			fontSize = 20,
			maxLength = 20,
			placeHolder = g.lang:getText("LOGIN", "PWD_TIPS"),
			holderColor = cc.c3b(64, 97, 179),
			inputFlag = cc.EDITBOX_INPUT_FLAG_PASSWORD,
		})
		:pos(-94, 0 + yOffset)
		:addTo(self)

	-- 登录按钮
	g.myUi.ScaleButton.new({normal = g.Res.common_btnBlueS})
		:setButtonLabel(display.newTTFLabel({size = 24, text = g.lang:getText("COMMON", "LOGIN")}))
		:onClick(handler(self.ctrl, self.ctrl.requestGuestLogin))
		:pos(0, -80 + yOffset)
		:addTo(self)

	-- test begin 
	-- 登录测试按钮1
	g.myUi.ScaleButton.new({normal = g.Res.common_btnBlueS})
		:setButtonLabel(display.newTTFLabel({size = 24, text = "Login 100"}))
		:onClick(function ()
			self.nameEditBox:setText("100")
			self.pwdEditBox:setText("123456")
			self.ctrl:requestGuestLogin()
		end)
		:pos(200, -80 + yOffset)
		:addTo(self)

	-- 登录测试按钮2
	g.myUi.ScaleButton.new({normal = g.Res.common_btnBlueS})
		:setButtonLabel(display.newTTFLabel({size = 24, text = "Login 111"}))
		:onClick(function ()
			self.nameEditBox:setText("111")
			self.pwdEditBox:setText("123456")
			self.ctrl:requestGuestLogin()
		end)
		:pos(400, -80 + yOffset)
		:addTo(self)
	-- test end

	local leave = cc.ParticleSystemQuad:create("particles/Ye_1.plist")
	self:addChild(leave)
	leave:setPosition(-display.width/2, display.height/2)
end

function LoginView:getInputUserName()
	if self.nameEditBox then
		return self.nameEditBox:getText()
	end
end

function LoginView:getInputUserPassword()
	if self.pwdEditBox then
		return self.pwdEditBox:getText()
	end
end

function LoginView:addEventListeners()
	g.event:on(g.eventNames.LOBBY_UPDATE, handler(self, self.XXXX), self)
end

function LoginView:XXXX()
	
end

function LoginView:XXXX()
	
end

function LoginView:XXXX()
	
end

function LoginView:XXXX()
	
end

function LoginView:removeEventListeners()
	g.event:removeByTag(self)
end

function LoginView:onCleanup()
	self:removeEventListeners()
end

return LoginView
