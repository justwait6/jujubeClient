local SeatManager = class("SeatManager")

local RummyConst = require("app.model.rummy.RummyConst")
local RummyUtil = require("app.model.rummy.RummyUtil")
local SeatView = require("app.view.rummy.SeatView")
local roomInfo = require("app.model.rummy.RoomInfo").getInstance()
local roomMgr = require("app.model.rummy.RoomManager").getInstance()

local RVP = require("app.model.rummy.RoomViewPosition")
local P1 = RVP.SeatPosition
local P2 = RVP.DeliverCardPosition
local P3 = RVP.LightAngle
local P4 = RVP.Lightscale
local P5 = RVP.PotPosition
local P6 = RVP.MoveCoinBegin
local TAG_DISCARD_CARD = 1
local TAG_MAGIC_CARD = 2
local TAG_FINISH_CARD = 3
local TAG_OLD_AREA = 4
local TAG_NEW_AREA = 5
local TAG_FINISH_AREA = 6

function SeatManager:ctor()
    self.playerInfo = {}
    self.seats_ = {}

	self:initialize()
end

function SeatManager:initialize()
end

function SeatManager:initSeatNode(sceneSeatNode)
    self.sceneSeatNode_ = sceneSeatNode
    -- seats
	for i = 0, RummyConst.UserNum - 1 do
        self.seats_[i] = SeatView.new(i):pos(P1[i].x,P1[i].y):addTo(self.sceneSeatNode_):hide()
	end
end

function SeatManager:initAnimNode(sceneAnimNode)
    self.sceneAnimNode_ = sceneAnimNode
end

function SeatManager.getInstance()
    if not SeatManager.singleInstance then
        SeatManager.singleInstance = SeatManager.new()
    end
    return SeatManager.singleInstance
end

function SeatManager:initSeats(pack)
    self:initPlayerData(pack)
    self:initPlayerView(pack)
end

function SeatManager:initPlayerData(pack)
	if pack.players then
        for _, v in pairs(pack.players) do
            table.insert(self.playerInfo, v)
        end
	end
end

function SeatManager:initPlayerView(pack)
    local seatOffset = 0
    for _, v in ipairs(self.playerInfo) do
         if v.seatId >= 0 and v.seatId <= RummyConst.UserNum - 1 then
              self:initPlayerViewWithSeatId(v)
              local fromSeatId = v.seatId
              local toSeatId = RummyUtil.getFixSeatId(v.seatId) 
              seatOffset = toSeatId - fromSeatId
         end
    end
    if pack.isReconnect then --房间里重连
		self:startAllSeatMove(seatOffset, true)
	else
        self:startAllSeatMove(seatOffset)
    end
end

function SeatManager:initPlayerViewWithSeatId(user)
    local seatId = user.seatId or -1
    if seatId >= 0 then
		local seat = self.seats_[seatId]
		seat:show()
		seat:setUid(user.uid or -1)
		seat:setServerSeatId(seatId)
        seat:updateSeatConfig()
        -- seat:setUState(user.state or RummyConst.USER_SEAT)
        self:updateMoney(seatId, user.carry or user.money or 0)
		self:updateUserinfo(seat, json.decode(user.userinfo))
    end
end

function SeatManager:gameStart(pack)
    self:changeUserState(RummyConst.USER_PLAY) --游戏开始所有坐下玩家置为在玩状态
        self:chooseDealerAnim(pack, handler(self, function()
			roomMgr:updateDSeat(roomInfo:getDSeatId(), true)
		end))
end

function SeatManager:chooseDealerAnim(pack, finishCallback)
    g.myFunc:safeRemoveNode(self.chooseDealerNode)
    local dNode = display.newNode():addTo(self.sceneAnimNode_)
    self.chooseDealerNode = dNode
    
    local refinedPlayers = self:getChooseDealerFixedPlayers(pack.players, pack.dUid)
    dump(refinedPlayers, "refinedPlayers")

    local dealCardTime = 1
    local fixCardNum = 5
    local idleSpritesNode = display.newNode():pos(display.cx, display.cy):scale(0):addTo(dNode, -1)
    for i = 1, fixCardNum do
        g.myUi.PokerCard.new():pos((i - 1 - fixCardNum) * 2, 0)
            :addTo(idleSpritesNode, -1):setRotation(-180):showBack()
    end
    idleSpritesNode:stopAllActions()
    idleSpritesNode:runAction(cc.Sequence:create({
        cc.ScaleTo:create(0.2, 1 * RummyConst.toSFactor)
    }))

    for i = 1, #refinedPlayers do
        local fixSeatId = refinedPlayers[i].fixSeatId
        if fixSeatId >= 0 then
            local cardSprite = g.myUi.PokerCard.new():setCard(refinedPlayers[i].card)
                :pos(display.cx + (#refinedPlayers - i) * 2, display.cy):addTo(dNode, #refinedPlayers - i)
            cardSprite:setRotation(-180)
            cardSprite:setScale(0)
            cardSprite:showBack()
            cardSprite:stopAllActions()
            cardSprite:runAction(cc.Sequence:create({
                cc.ScaleTo:create(0.2, 1 * RummyConst.toSFactor),
                cc.DelayTime:create(i * 0.2),
                cc.Spawn:create({cc.MoveTo:create(0.18, P2[fixSeatId]), cc.RotateTo:create(0.18, 0)}),
                cc.DelayTime:create(dealCardTime - i * 0.2),
                cc.CallFunc:create(function()
                    cardSprite:flip()
                    idleSpritesNode:runAction(cc.Sequence:create({
                        cc.ScaleTo:create(0.2, 0.2),
                        cc.CallFunc:create(function()
                            g.myFunc:safeRemoveNode(idleSpritesNode)
                            idleSpritesNode = nil
                        end),
                    }))
                end),
                cc.DelayTime:create(0.8),
                cc.CallFunc:create(function()
                    if refinedPlayers[i].isScaleCardAnim then
                        cardSprite:runAction(cc.Sequence:create({
                            cc.ScaleTo:create(0.2, 1.2 * RummyConst.toSFactor), cc.ScaleTo:create(0.2, 1.1 * RummyConst.toSFactor), cc.ScaleTo:create(0.2, 1.2 * RummyConst.toSFactor), cc.ScaleTo:create(0.2, 1.1 * RummyConst.toSFactor),
                        }))
                    end
                end),
                cc.DelayTime:create(0.8),
                cc.CallFunc:create(function()
                    if i == #refinedPlayers then
                        if finishCallback then finishCallback() end
                    end
                end),
                cc.DelayTime:create(1.2),
                cc.CallFunc:create(function()
                    g.myFunc:safeRemoveNode(cardSprite)
                    cardSprite = nil
                end),
            }))
        end	
    end
end

function SeatManager:getChooseDealerFixedPlayers(users, dealerUid)	
    local refinedPlayers = clone(users or {})
    local isSelfInPlay = false
    for i = 1, #refinedPlayers do
        local seatId = self:querySeatIdByUid(refinedPlayers[i].uid or -1)
        refinedPlayers[i].fixSeatId = RummyUtil.getFixSeatId(seatId)

        if tonumber(refinedPlayers[i].uid) == tonumber(g.user:getUid()) then
            isSelfInPlay = true
        end
        if tonumber(refinedPlayers[i].uid) == tonumber(dealerUid) then
            if i == 1 then
                refinedPlayers[#refinedPlayers].isScaleCardAnim = true
            else
                refinedPlayers[i - 1].isScaleCardAnim = true
            end
        end
    end
    if isSelfInPlay then -- 自己在玩, 保证自己最后一个
        while (true) do
            local user = table.remove(refinedPlayers, 1)
            table.insert(refinedPlayers, user)
            if tonumber(user.uid) == tonumber(g.user:getUid()) then
                break
            end
        end
    end
    return refinedPlayers
end

function SeatManager:changeUserState(uState)
    for _, v in ipairs(self.playerInfo) do
            v.state = uState
            if v.seatId >= 0 and v.seatId <= RummyConst.UserNum - 1 then
                local seat = self.seats_[v.seatId]
                seat:setUState(uState)
                if uState == RummyConst.USER_PLAY then
                    seat:setHeadBright()
                end
            end
    end
end

function SeatManager:updateMoney(seatId, money)
    if seatId == tonumber(roomInfo:getMSeatId()) then
        -- self.roomManager:updateMBalance(money)
    end
    if seatId and seatId >= 0 and money and money >=0 then
        local seat = self.seats_[seatId]
        seat:updateMoney(money)
    end
end

function SeatManager:updateUserinfo(seat, userinfo)
    if userinfo then
        seat:showHeader()
        local uid = seat:getUid()
        seat:setHeaderConfig(userinfo.icon, userinfo.gender)
        seat:setNickName(userinfo.nickName)
    end
end

function SeatManager:startAllSeatMove(seatOffset, isInstant)
	for i = 0, RummyConst.UserNum - 1 do
		local seat = self.seats_[i]
        local fromSeatId = seat:getServerSeatId()
        if fromSeatId ~= RummyConst.NoPlayerSeatId then
			seat:show()
			local toSeatId = fromSeatId + seatOffset
			if toSeatId < 0 then
				toSeatId = toSeatId + RummyConst.UserNum
			elseif toSeatId > RummyConst.UserNum - 1 then
				toSeatId = toSeatId - RummyConst.UserNum
			end
			self:startSeatMove(seat, fromSeatId, toSeatId)
		else
			seat:hide()
		end                  
	end
end

function SeatManager:startSeatMove(seat, fromSeatId, toSeatId)
    if isInstant then
        self:setToIndexSeat(seat, toSeatId)
    else
        printVgg(seat, fromSeatId, toSeatId)
        self:startMoveSeatAnimation(seat, fromSeatId, toSeatId)
    end
end

function SeatManager:startMoveToNotFix()
    for i = 0, RummyConst.UserNum-1 do
        local seat = self.seats_[i]
        seat:updateSeatConfig()
        self:startMoveSeatAnimation(seat, seat:getNowPos(), i)
    end
end

function SeatManager:setToIndexSeat(seat,toSeatId)
    seat:pos(P1[toSeatId].x, P1[toSeatId].y)
    seat:setNowPos(toSeatId)
end

function SeatManager:startMoveSeatAnimation(seat, fromSeatId, toSeatId)
local moveActions = {}
    seat:pos(P1[toSeatId].x, P1[toSeatId].y)
    local sequence = cc.Sequence:create(cc.CallFunc:create(function()
        seat:setNowPos(toSeatId)
     end))
    seat:stopAllActions()
    seat:runAction(sequence)
end

function SeatManager:castUserSit(pack)
    if pack.seatId >= 0 and pack.seatId <= RummyConst.UserNum - 1 then
        local user = self:insertUser(pack)
        self:initPlayerViewWithSeatId(user)  
        local seat = self:getSeatByUid(user.uid)
        local toSeatId = RummyUtil.getFixSeatId(pack.seatId or -1)
        seat:show()
        self:startSeatMove(seat, user.seatId, toSeatId)
    end
end

function SeatManager:castUserExit(pack)
    self:standUp(pack.uid)
end

function SeatManager:standUp(uid)
    self:deleteUser(uid)
	for i = 0, #self.seats_ do
		if tonumber(uid) == tonumber(self.seats_[i]:getUid()) then
			self.seats_[i]:standUp()
		end
	end
	if tonumber(uid) == tonumber(g.user:getUid()) then
		roomInfo:setMSeatId(-1)
		roomInfo:clearMCards()
		self:startMoveToNotFix()  
		-- self.scene:showChgTableBtn()
		-- self.scene:hideStandUpBtn()
	end
end

function SeatManager:getSeatByUid(uid)
	for i = 0, RummyConst.UserNum - 1 do
		local seat = self.seats_[i]
		if seat:getUid() == uid then
			return seat
		end
	end
end

function SeatManager:querySeatIdByUid(uid)
    local player = self:queryUser(uid)
    if player then
        return player.seatId
    end
    return -1
end

function SeatManager:queryUser(uid)
    if not uid then return end
    if self.playerInfo and #self.playerInfo > 0 then
        for i = 1, #self.playerInfo do
            local player = self.playerInfo[i]
            if player then
                if player.uid and tonumber(player.uid) == tonumber(uid) then
                    return player
                end
            end
        end
    end
end

function SeatManager:insertUser(pack)
    local user = {}
    user.uid = pack.uid or -1
    user.seatId = pack.seatId or -1
    user.userinfo = pack.userinfo or ""
    user.state = pack.state or RummyConst.USER_USER_SEAT
    user.money = pack.money or 0
    user.gold = pack.gold or 0
    table.insert(self.playerInfo, user)
    return user
end

function SeatManager:deleteUser(id)
    if not id then return end
    if self.playerInfo and #self.playerInfo > 0 then
        for i = 1, #self.playerInfo do
            local player = self.playerInfo[i]
            if player then
                if player.uid and tonumber(player.uid) == tonumber(id) then
                    table.remove(self.playerInfo, i)
                    return
                end
            end
        end
    end
end

function SeatManager:clearAll()
    self.playerInfo = {}
    self.seats_ = {}
end

function SeatManager:clearTable()
    for i = 0, RummyConst.UserNum - 1 do
        self.seats_[i]:clearTable()
    end
end

function SeatManager:XXXX()
    
end

return SeatManager
