local HallBaseListView = class("HallBaseListView", function ()
	return display.newNode()
end)

local HallBaseListCtrl = require("app.controller.hall.HallBaseListCtrl")

function HallBaseListView:ctor()
	self.ctrl = HallBaseListCtrl.new()

	self:setNodeEventEnabled(true)
	self:initialize()
end

function HallBaseListView:initialize()
	self:renderIconsList()
end

function HallBaseListView:renderIconsList()
	local baseConfs = self.ctrl:getConfList()
	local startX = 0
	local distanceGap = 160
	self.icons = {}
	for i, conf in pairs(baseConfs) do
		self.icons[i] = g.myUi.ScaleButton.new({normal = conf.hallIconRes})
			:onClick(handler(self.ctrl, function ()
				self.ctrl:onBaseIconClick(conf.baseId)
			end))
			:pos(startX + (i - 1) * distanceGap, 0)
			:addTo(self)
			:opacity(0)
	end
end

function HallBaseListView:playShowAnim()
	if self.icons then
		for i, icon in pairs(self.icons) do
			icon:stopAllActions()
			icon:runAction(cc.Sequence:create({
				cc.FadeTo:create(0.16, 0.25 * 256),
				cc.DelayTime:create(0.2 + i * 0.05),
				cc.JumpBy:create(0.16, cc.p(0, 0), (i % 2) * 6 + 6, 1),
				cc.FadeIn:create(0.6),
			}))
		end
	end
end

function HallBaseListView:XXXX()
	
end

function HallBaseListView:XXXX()
	
end

function HallBaseListView:XXXX()
	
end

return HallBaseListView
