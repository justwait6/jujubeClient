require("zlib")
local ActManager = class("ActManager")

local LocalActSwitch = import(".LocalActSwitch")
local ActDef = import(".ActDef")
local ActConf = import(".ActConfig")

local MoneyTreeView = import(".moneyTree.MoneyTreeView")

function ActManager:ctor()
	self:initialize()
end

function ActManager:initialize()
    
end

function ActManager.getInstance()
    if not ActManager.singleInstance then
        ActManager.singleInstance = ActManager.new()
    end
    return ActManager.singleInstance
end

function ActManager:setActSwitches(remoteOpenActIds)
    local localOpenActIds = LocalActSwitch.getLocalOpenActIds()
    local remoteOpenActIds = remoteOpenActIds or {}

    local localSwitches = self:getOpenSwitches(localOpenActIds)
    local remoteSwitches = self:getOpenSwitches(remoteOpenActIds)

    self.switches = {}
    for _, actId in pairs(ActDef.SEQUENCE) do
        if localSwitches[actId] and remoteSwitches[actId] then
            self.switches[actId] = true
        end
    end

    dump(self.switches, "switches")
end

function ActManager:getActSwitches()
    return self.switches
end

function ActManager:getOpenSwitches(openIds)
    local switches = {}
    for _, openActId in pairs(openIds) do
        switches[openActId] = true
    end
    return switches
end

function ActManager:getHallActList()
    local hallSequence = {}

    local switches = self:getActSwitches()
    local hallActSet = ActDef.HALL_ACT_SEQUENCE
    for _, actId in pairs(hallActSet) do
        if switches[actId] then
            table.insert(hallSequence, actId)
        end
    end

    return hallSequence
end

function ActManager:getHallActConfs()
    local hallActConfs = {}
    local hallSequence = self:getHallActList()
    for _, actId in pairs(hallSequence) do
        table.insert(hallActConfs, ActConf[actId])
    end
    return hallActConfs
end

function ActManager:onHallIconClick(actId)
    MoneyTreeView.new():show()
end

return ActManager
