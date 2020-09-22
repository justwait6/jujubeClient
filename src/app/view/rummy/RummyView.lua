local RummyView = class("RummyView", function ()
	return display.newNode()
end)

local RummyCtrl = require("app.controller.rummy.RummyCtrl")
local SeatView = import("app.view.rummy.SeatView")

local RummyConst = require("app.model.rummy.RummyConst")
local RVP = import("app.model.rummy.RoomViewPosition")
local P1 = RVP.SeatPosition

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
		:pos(display.cx, display.cy)
        :addTo(self.scene.nodes.bgNode)
	g.myFunc:checkScaleBg(roombg)

	-- dealer icon
	self.dIcon = display.newSprite(mResDir .. "d_icon.png"):pos(display.cx, display.cy):addTo(self.scene.nodes.roomNode):hide()

	-- seats
	self.seats_ = {}
	for i = 0, RummyConst.UserNum - 1 do
        self.seats_[i] = SeatView.new(i):pos(P1[i].x,P1[i].y):addTo(self.scene.nodes.seatNode):hide()
	end
	self.ctrl:setSeats(self.seats_)
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
