local HallView = class("HallView", function ()
	return display.newNode()
end)

local HallCtrl = require("app.controller.hall.HallCtrl")

local HallActListView = import(".HallActListView")

function HallView:ctor()
	self.ctrl = HallCtrl.new()

	self:setNodeEventEnabled(true)
	self:initialize()
	self.actListView = HallActListView.new()
		:pos(display.width/2 - 80, display.height/2 - 80)
		:addTo(self, 1)
	self:addEventListeners()
end

function HallView:initialize()
	display.newSprite(g.Res.hall_hallBg):addTo(self)

    display.newTTFLabel({
        	text = g.lang:getText("HALL", "HALL_TIPS"), size = 28, color = cc.c3b(128, 0, 0)})
    	:pos(0, 100)
    	:addTo(self)

    g.myUi.ScaleButton.new({normal = g.Res.button2})
		:setButtonLabel(display.newTTFLabel({size = 24, text = g.lang:getText("COMMON", "GAME_START")}))
		:onClick(handler(self.ctrl, self.ctrl.requestServerTableId))
		:addTo(self)

	g.myUi.ScaleButton.new({normal = g.Res.button2})
		:setButtonLabel(display.newTTFLabel({size = 24, text = g.lang:getText("COMMON", "LOGOUT")}))
		:onClick(handler(self.ctrl, self.ctrl.logout))
		-- :onClick(handler(self, self.playShowAnim))
		:pos(0, -100)
		:addTo(self)
end

function HallView:addEventListeners()
	-- g.event:on(g.eventNames.XX, handler(self, self.XX), self)
end

function HallView:playShowAnim()
	if self.actListView and self.actListView.playShowAnim then
		self.actListView:playShowAnim()
	end
end

function HallView:XXXX()
	
end

function HallView:XXXX()
	
end

function HallView:XXXX()
	
end

function HallView:removeEventListeners()
	g.event:removeByTag(self)
end

function HallView:onCleanup()
	self:removeEventListeners()
end

return HallView
