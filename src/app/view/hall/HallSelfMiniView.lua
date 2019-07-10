local HallSelfMiniView = class("HallSelfMiniView", function ()
	return display.newNode()
end)

function HallSelfMiniView:ctor()
	self:initialize()
end

function HallSelfMiniView:initialize()
	display.newSprite(g.Res.hall_userInfoBg):pos(0, 0):addTo(self)

	self.avatar = g.myUi.AvatarView.new({
		radius = 52,
		gender = g.myUi.AvatarView.Gender.FEMALE,
		frameRes = g.Res.common_headFrame,
		avatarUrl = "http://img1.juimg.com/180709/33069-1PF919360412.jpg",
		clickCallback = function () print("111") end,
	})
        :pos(-110, 10)
        :addTo(self)
	self.avatar:setFrameScale(0.67)

	self.name = display.newTTFLabel({text = "nima", size = 28, color = cc.c3b(237, 226, 201)})
        :pos(-42, 18)
        :setAnchorPoint(cc.p(0, 0.5))
        :addTo(self)

    display.newSprite(g.Res.common_coinIcon):pos(-30, -12):addTo(self)
    self.money = display.newTTFLabel({text = "0", size = 28, color = cc.c3b(255, 255, 255)})
        :pos(30, -11)
        :addTo(self)

end

function HallSelfMiniView:playShowAnim()
	
end

function HallSelfMiniView:XXXX()
	
end

function HallSelfMiniView:XXXX()
	
end

function HallSelfMiniView:XXXX()
	
end

return HallSelfMiniView
