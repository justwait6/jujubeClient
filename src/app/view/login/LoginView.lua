local LoginView = class("LoginView", function ()
	return display.newNode()
end)

local LoginCtrl = require("app.controller.login.LoginCtrl")

function LoginView:ctor()
	self.ctrl = LoginCtrl.new()
	self:setNodeEventEnabled(true)
	self:initialize()
	self:addEventListeners()
end

function LoginView:initialize()
	display.newSprite(g.Res.login_loginBg):pos(display.cx, display.cy):addTo(self)

	display.newTTFLabel({
        	text = g.lang:getText("LOGIN", "LOGIN_TIPS"), size = 28, color = cc.c3b(0, 128, 128)})
    	:pos(display.cx, display.cy + 100)
    	:addTo(self)

	g.myUi.ScaleButton.new({normal = g.Res.button2})
		:setButtonLabel(display.newTTFLabel({size = 24, text = g.lang:getText("COMMON", "LOGIN")}))
		:onClick(handler(self.ctrl, self.ctrl.requestGuestLogin))
		:pos(display.cx, display.cy)
		:addTo(self)

	local leave = cc.ParticleSystemQuad:create("particles/Ye_1.plist")
	self:addChild(leave)
	leave:setPosition(-display.width/2, display.height/2)
end

function LoginView:addEventListeners()
	-- g.event:on(g.eventNames.XX, handler(self, self.XX), self)
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
