local RoomManager = class("RoomManager")

local roomInfo = require("app.model.rummy.RoomInfo").getInstance()
local RummyUtil = require("app.model.rummy.RummyUtil")

local RVP = require("app.model.rummy.RoomViewPosition")
local P3 = RVP.RDPosition

local mResDir = "image/rummy/" -- module resource directory

function RoomManager:ctor()
	self:initialize()
end

function RoomManager:initialize()
    
end

function RoomManager:initRoomNode(sceneRoomNode)
    self.sceneRoomNode_ = sceneRoomNode

    -- dealer icon
	self.dIcon = display.newSprite(mResDir .. "d_icon.png"):pos(display.cx, display.cy):addTo(self.sceneRoomNode_):hide()
end

function RoomManager.getInstance()
    if not RoomManager.singleInstance then
        RoomManager.singleInstance = RoomManager.new()
    end
    return RoomManager.singleInstance
end

function RoomManager:showDIcon(fixSeatId,needAnim)
    if fixSeatId < 0 then return end
    self.dIcon:show()
    if needAnim then
        local moveAction = cc.MoveTo:create(0.4,P3[fixSeatId])
        self.dIcon:stopAllActions()
        self.dIcon:runAction(cc.EaseSineOut:create(moveAction))
    else
        self.dIcon:pos(P3[fixSeatId].x,P3[fixSeatId].y)
    end
end

function RoomManager:hideDIcon()
    self.dIcon:hide()
end

function RoomManager:updateDSeat(dSeatId, needAnim)
	roomInfo:setDSeatId(dSeatId or -1)
	if dSeatId >= 0 then
		local fixSeatId = RummyUtil.getFixSeatId(dSeatId)
		if fixSeatId >= 0 then
			self:showDIcon(fixSeatId, needAnim)
		end
	else
		self:hideDIcon()
	end
end

function RoomManager:enterRoomInfo(pack)
end

function RoomManager:countDownTips(sec)
	-- 判断一下是否选择了最后一局 如果选择了最后一句退出到大厅
	local isCheck = roomInfo:getLastRound()
	if isCheck then
		self.scene:logoutRoom()
	end

	if type(sec) ~= "number" then return end
	self:tipsMiddle_(string.format(g.lang:getText("RUMMY", "GAME_START_COUNTDOWN_FMT"), sec) )
    -- PushCenter.pushEvent(g.eventNames.SCORE_POPUP_COUNT, {time = sec, flag = 2})
	local id = g.mySched:doLoop(function()
		sec = sec - 1
		if sec > 0 then
			self:tipsMiddle_(string.format(g.lang:getText("RUMMY", "GAME_START_COUNTDOWN_FMT"), sec) )
    		-- PushCenter.pushEvent(g.eventNames.SCORE_POPUP_COUNT, {time = sec, flag = 2})
			return true
		else
			self:hideTipsMiddle_()
			g.mySched:cancel(id)
		end
	end, 1)
end
function RoomManager:tipsMiddle_(str, sec)
	self:hideAllMiddleTips_() -- 时序优先级
	local width = 320
	local txtWidth = display.newTTFLabel({text = str, size = 24, color = cc.c3b(0xb4, 0xb3, 0xb3)}):getContentSize().width + 20
	if txtWidth > width then
		width = txtWidth
	end
	g.myFunc:safeRemoveNode(self.middleBg)
	self.middleBg = display.newScale9Sprite(mResDir .. "tip_mid_bg.png", display.cx, display.cy + 20, cc.size(width, 54)):addTo(self.sceneRoomNode_)
	self.middleBg:setCapInsets(cc.rect(94/2, 54/2, 1, 1))
	display.newTTFLabel({text = str, size = 24, color = cc.c3b(0xff, 0xff, 0xff)})
		:pos(self.middleBg:getContentSize().width/2, self.middleBg:getContentSize().height/2):addTo(self.middleBg)
	self.middleBg:show()
	if type(sec) == "number" then
		g.mySched:cancel(self.schedId_)
		self.schedId_ = g.mySched:doDelay(function()
			g.mySched:cancel(self.schedId_)
			self:hideTipsMiddle_()
		end, sec)
	end
end

function RoomManager:hideTipsMiddle_()
	if g.myFunc:checkNodeExist(self.middleBg) then self.middleBg:hide() end
end

function RoomManager:showWaitNextGameTips()
	local str = g.lang:getText("RUMMY", "WAIT_NEXT_GAME_TIP")
	local width = 320
	local txtWidth = display.newTTFLabel({text = str, size = 24, color = cc.c3b(0xb4, 0xb3, 0xb3)}):getContentSize().width + 180
	if txtWidth > width then
		width = txtWidth
	end
	g.myFunc:safeRemoveNode(self.waitNextGameBg)
	
	self.waitNextGameBg = display.newScale9Sprite(mResDir .. "tip_mid_bg.png", display.cx, display.cy - 150, cc.size(width, 54)):addTo(self.sceneRoomNode_)
	self.waitNextGameBg:setCapInsets(cc.rect(94/2, 54/2, 1, 1))
	display.newTTFLabel({text = str, size = 24, color = cc.c3b(0xff, 0xff, 0xff)})
		:pos(self.waitNextGameBg:getContentSize().width/2, self.waitNextGameBg:getContentSize().height/2):addTo(self.waitNextGameBg)
	self.waitNextGameBg:show()
end

function RoomManager:hideWaitNextGameTips_()
	if g.myFunc:checkNodeExist(self.waitNextGameBg) then self.waitNextGameBg:hide() end
end

function RoomManager:hideAllMiddleTips_()
	self:hideTipsMiddle_()
	-- self:hideDeclareTips_()
	-- self:hideViewResultTips_()
end

function RoomManager:clearTable()
    self:hideAllMiddleTips_()
end

return RoomManager
