local HallCtrl = class("HallCtrl")

function HallCtrl:ctor()
	self:initialize()
end

function HallCtrl:initialize()
end

function HallCtrl:logout()
	g.myApp:enterScene("LoginScene")
end

function HallCtrl:getTable()
	g.mySocket:cliGetTable()
end

function HallCtrl:onGetTableResp(pack)
	g.mySocket:setRoomCmdConfig(pack.gameId)
	g.mySocket:cliEnterRoom(pack.tid)
end

function HallCtrl:XXXX()
	
end

function HallCtrl:XXXX()
	
end

return HallCtrl
