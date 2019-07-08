local ActivityManager = class("ActivityManager")

function ActivityManager:ctor()
	self:initialize()
end

function ActivityManager:initialize()
	
end

function ActivityManager.getInstance()
    if not ActivityManager.singleInstance then
        ActivityManager.singleInstance = ActivityManager.new()
    end
    return ActivityManager.singleInstance
end

return ActivityManager
