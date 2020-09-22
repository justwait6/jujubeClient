local RoomManager = class("RoomManager")

local roomInfo = require("app.model.rummy.RoomInfo").getInstance()

function RoomManager:ctor()
	self:initialize()
end

function RoomManager:initialize()
    
end

function RoomManager.getInstance()
    if not RoomManager.singleInstance then
        RoomManager.singleInstance = RoomManager.new()
    end
    return RoomManager.singleInstance
end

function RoomManager:enterRoomInfo(pack)
end

return RoomManager
