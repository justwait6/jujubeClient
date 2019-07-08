local HallCtrl = class("HallCtrl")

function HallCtrl:ctor()
	self:initialize()
end

function HallCtrl:initialize()
end

function HallCtrl:addEventListeners()
	-- g.event:on(g.eventNames.XX, handler(self, self.XX), self)
end

function HallCtrl:requestServerTableId()
end

function HallCtrl:logout()
	g.myApp:enterScene("LoginScene")
end

function HallCtrl:XXXX()
	
end

function HallCtrl:XXXX()
	
end

return HallCtrl
