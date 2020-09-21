local RummyView = class("RummyView", function ()
	return display.newNode()
end)

local RummyCtrl = require("app.controller.rummy.RummyCtrl")

local mResDir = "image/rummy/" -- module resource directory

function RummyView:ctor(scene)
	self.scene = scene
	self.ctrl = RummyCtrl.new(self)
	self:setNodeEventEnabled(true)
	self:initialize()
	self:addEventListeners()
end

function RummyView:initialize()
	-- table bg
	local roombg = display.newSprite(mResDir .. "room_bg.png")
        :addTo(self)
	g.myFunc:checkScaleBg(roombg)
end

function RummyView:addEventListeners()
	g.event:on(g.eventNames.LOBBY_UPDATE, handler(self, self.XXXX), self)
end

function RummyView:XXXX()
	
end

function RummyView:XXXX()
	
end

function RummyView:XXXX()
	
end

function RummyView:XXXX()
	
end

function RummyView:onCleanup()
	g.event:removeByTag(self)
end

return RummyView
