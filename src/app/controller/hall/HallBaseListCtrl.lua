local HallBaseListCtrl = class("HallBaseListCtrl")

local baseManager = require("app.model.hallBase.HallBaseManager").getInstance()

function HallBaseListCtrl:ctor()
	self:initialize()
end

function HallBaseListCtrl:initialize()
end

function HallBaseListCtrl:getConfList()
	return baseManager:getHallBaseConfs()
end

function HallBaseListCtrl:onBaseIconClick(baseId)
	baseManager:onBaseIconClick(baseId)
end

function HallBaseListCtrl:XXXX()
	
end

function HallBaseListCtrl:XXXX()
	
end

return HallBaseListCtrl
