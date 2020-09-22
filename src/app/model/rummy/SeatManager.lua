local SeatManager = class("SeatManager")

local RummyConst = require("app.model.rummy.RummyConst")
local RummyUtil = require("app.model.rummy.RummyUtil")
local roomInfo = require("app.model.rummy.RoomInfo").getInstance()

local RVP = import("app.model.rummy.RoomViewPosition")
local P1 = RVP.SeatPosition

function SeatManager:ctor()
    self.playerInfo = {}
    self.seats_ = {}

	self:initialize()
end

function SeatManager:initialize()
end

function SeatManager:setSeats(seats)
    self.seats_ = seats
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
            print('123')
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
        self:startMoveSeatAnimation(seat, fromSeatId, toSeatId)
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

function SeatManager:XXXX()
    
end

function SeatManager:XXXX()
    
end

function SeatManager:XXXX()
    
end

return SeatManager
