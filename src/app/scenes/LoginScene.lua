local LoginScene = class("LoginScene", function()
    return display.newScene("LoginScene")
end)

local LoginView = require("app.view.login.LoginView")

function LoginScene:ctor()
	self.view = LoginView.new():pos(display.cx, display.cy):addTo(self)

    self:initialize()
end

function LoginScene:initialize()
	
end

function LoginScene:onEnter()
end

function LoginScene:onExit()
end

return LoginScene
