local CURRENT_MODULE_NAME = ...

local ProxySelector = import(".ProxySelector")
local SocketService = import(".SocketService")

local MySocketBase = class("MySocketBase")

MySocketBase.EVT_PACKET_RECEIVED  = "MySocketBase.EVT_PACKET_RECEIVED"
MySocketBase.EVT_CONNECTED        = "MySocketBase.EVT_CONNECTED"
MySocketBase.EVT_CONNECT_FAIL     = "MySocketBase.EVT_CONNECT_FAIL"
MySocketBase.EVT_CLOSED           = "MySocketBase.EVT_CLOSED"
MySocketBase.EVT_ERROR            = "MySocketBase.EVT_ERROR"

function MySocketBase:ctor(name, protocol)
    self.PROTOCOL = protocol

    self.socketService_ = SocketService.new(name, protocol):setMySocket(self)
    self.name_ = name
    self.shouldConnect_ = false
    self.isConnected_ = false
    self.isConnecting_ = false
    self.isPaused_ = false
    self.delayPackCache_ = nil
    self.retryLimit_ = 3
    self.logger_ = g.Logger.new(self.name_)
end

function MySocketBase:isConnected()
    return self.isConnected_
end

function MySocketBase:connect(ip, port, retryConnectWhenFailure)
    self:disconnect(true)
    self.shouldConnect_ = true
    self.ip_ = ip
    self.port_ = port
    if self:isConnected() then
        self.logger_:warn("connect: isConnected true")
    elseif self.isConnecting_ then
        self.logger_:warn("connect: isConnecting true")
    else
        self.isConnecting_ = true
        self.proxySelector_ = nil
        self.proxy_ = nil
        self.retryLimit_ = 3
        self.retryConnectWhenFailure_ = retryConnectWhenFailure
        self.logger_:warnf("connect: direct connect to %s:%s", self.ip_, self.port_)
        self.socketService_:connect(self.ip_, self.port_, retryConnectWhenFailure)
    end
end

function MySocketBase:disconnect(noEvent)
    self.shouldConnect_ = false
    self.isConnecting_ = false
    self.isConnected_ = false
    -- self.ip_ = nil
    -- self.port_ = nil
    self:unscheduleHeartBeat()
    self.socketService_:disconnect(noEvent)
end

function MySocketBase:pause()
    self.isPaused_ = true
    self.logger_:warn("pause: paused event dispatching")
end

function MySocketBase:resume()
    self.isPaused_ = false
    self.logger_:warn("resume: resume event dispatching")
    if self.delayPackCache_ and #self.delayPackCache_ > 0 then
        for i,v in ipairs(self.delayPackCache_) do
            g.event:emit(MySocketBase.EVT_PACKET_RECEIVED, {v})
        end
        self.delayPackCache_ = nil
    end
end

function MySocketBase:createPacketBuilder(cmd)
    return self.socketService_:createPacketBuilder(cmd)
end

function MySocketBase:send(pack)
    if self:isConnected() then
        self.socketService_:send(pack)
    else
        self.logger_:error("send: sending packet when socket is not connected")
    end
end

function MySocketBase:onConnected(evt)
    g.event:emit(MySocketBase.EVT_CONNECTED, {})
    self.isConnected_ = true
    self.isConnecting_ = false
    self.heartBeatTimeoutCount_ = 0
    self:onAfterConnected()
end

function MySocketBase:scheduleHeartBeat(command, interval, timeout)
    self.logger_:warn(":scheduleHeartBeat send scheduleHeartBeat")
    self.heartBeatCommand_ = command
    self.heartBeatTimeout_ = timeout
    self.heartBeatTimeoutCount_ = 0
    if not self.heartBeatSchedId then
        self.heartBeatSchedId = g.mySched:doLoop(handler(self, self.onHeartBeat_), interval)
    end
end

function MySocketBase:unscheduleHeartBeat()
    self.heartBeatTimeoutCount_ = 0
    if self.heartBeatSchedId then
        -- g.mySched:cancel(self.heartBeatSchedId)
        self.heartBeatSchedId = nil
    end
    self:cancelHeartBeatTimeOut()
end

function MySocketBase:cancelHeartBeatTimeOut()
    if self.heartBeatTimeoutId_ then
        g.mySched:cancel(self.heartBeatTimeoutId_)
        self.heartBeatTimeoutId_ = nil
    end
end

function MySocketBase:buildHeartBeatPack()
    self.logger_:warn("buildHeartBeatPack: not implemented method buildHeartBeatPack")
    return nil
end

function MySocketBase:onHeartBeatTimeout(timeoutcount)
    self.logger_:warn("onHeartBeatTimeout: not implemented method onHeartBeatTimeout")
end

function MySocketBase:onHeartBeatReceived(delaySeconds)
    self.logger_:warn("onHeartBeatReceived: not implemented method onHeartBeatReceived")
end

function MySocketBase:onHeartBeat_()
    local heartBeatPack = self:buildHeartBeatPack()
    if heartBeatPack then
        self.heartBeatPackSendTime_ = g.timeUtil:getSocketTime()
        self:send(heartBeatPack)
        if not self.heartBeatTimeoutId_ then
            self.heartBeatTimeoutId_ = g.mySched:doDelay(handler(self, self.onHeartBeatTimeout_), self.heartBeatTimeout_)
        end
        self.logger_:warnf("onHeartBeat_: send heart beat packet time %s", self.heartBeatPackSendTime_)
    end
    return true
end

function MySocketBase:onHeartBeatTimeout_()
    self.heartBeatTimeoutId_ = nil
    self.heartBeatTimeoutCount_ = (self.heartBeatTimeoutCount_ or 0) + 1
    self:onHeartBeatTimeout(self.heartBeatTimeoutCount_)
    self.logger_:warnf("onHeartBeatTimeout_: heart beat timeout = %s", self.heartBeatTimeoutCount_)
end

function MySocketBase:onHeartBeatReceived_()
    local delaySeconds = g.timeUtil:getSocketTime() - self.heartBeatPackSendTime_
    if self.heartBeatTimeoutId_ then
        self:cancelHeartBeatTimeOut()
        self.heartBeatTimeoutCount_ = 0
        self:onHeartBeatReceived(delaySeconds)
        self.logger_:warnf("onHeartBeatReceived_: received delaySeconds = %s", delaySeconds)
    else
        self.logger_:warnf("onHeartBeatReceived_: timeout received delaySeconds = %s", delaySeconds)
    end
end

function MySocketBase:onConnectFailure(evt)
    self.isConnected_ = false
    self.logger_:warn("onConnectFailure: connect failure ...")

    self.ipIndex = self.ipIndex or 1
    self.ipIndex = self.ipIndex + 1
    if self.ipIndex > 1 then
        local backupIp = g.user:getBackupIp()
        if backupIp and (self.ipIndex <= (#backupIp + 1)) then
            local ipportsbackupIp = g.myFunc:split(backupIp[self.ipIndex - 1], ":")
            if ipportsbackupIp and #ipportsbackupIp == 2 then
                g.Const.IP = ipportsbackupIp[1]
                g.Const.PORT = ipportsbackupIp[2]
            end
        else
            local ipPort = g.user:getHallIp()
            if ipPort then
                local ipports = g.myFunc:split(ipPort, ":")
                if #ipports == 2 then
                    self.ipIndex = 1
                    g.Const.IP = ipports[1]
                    g.Const.PORT = ipports[2]
                end
            end
        end
    end
    --g.Native:umengError(errorMsg)
    if not self:reconnect_() then
        self:onAfterConnectFailure()
        g.event:emit(MySocketBase.EVT_CONNECT_FAIL, {})
    end
end

function MySocketBase:onError(evt)
    self.isConnected_ = false
    self:disconnect(true)
    self.logger_:warn("onError: data error ...")
    if not self:reconnect_() then
        self:onAfterDataError()
        g.event:emit(MySocketBase.EVT_ERROR, {})
    end
end

function MySocketBase:onClosed(evt)
    self.isConnected_ = false
    self:unscheduleHeartBeat()
    if self.shouldConnect_ then
        if not self:reconnect_() then
            self:onAfterConnectFailure()
            g.event:emit(MySocketBase.EVT_CONNECT_FAIL, {})
            self.logger_:warn("onClosed: closed and reconnect fail")
        else
            self.logger_:warn("onClosed: closed and reconnecting")
        end
    else
        self.logger_:warn("onClosed: closed and do not reconnect")
        g.event:emit(MySocketBase.EVT_CLOSED, {})
    end
end

function MySocketBase:onClose()
    self:unscheduleHeartBeat()
end

function MySocketBase:reconnect_()
    self.logger_:warn("reconnect_: reconnecting")
    -- self.socketService_:disconnect(true)
    self:disconnect(true)
    self.retryLimit_ = self.retryLimit_ - 1
    local isRetrying = true
    self.logger_:warnf("reconnect_: self.ip_ = %s, self.port_ = %s", self.ip_, self.port_)
    if self.retryLimit_ > 0 or self.retryConnectWhenFailure_ then
        self.socketService_:connect(self.ip_, self.port_, self.retryConnectWhenFailure_)
    else
        isRetrying = false
        self.isConnecting_ = false
    end
    return isRetrying
end

function MySocketBase:onPacketReceived(evt)
    local pack = evt.data
    if pack.cmd == self.heartBeatCommand_ then
        if self.heartBeatTimeoutId_ then
            self:onHeartBeatReceived_()
        end
    else
        self:onProcessPacket(pack)
        if self.isPaused_ then
            if not self.delayPackCache_ then
                self.delayPackCache_ = {}
            end
            self.delayPackCache_[#self.delayPackCache_ + 1] = pack
            self.logger_:warnf("onPacketReceived: %s pausd cmd:%x", self.name_, pack.cmd)
        else
            self.logger_:warnf("onPacketReceived: %s dispatching cmd:%x", self.name_, pack.cmd)
            local ret,errMsg = pcall(function() self:dispatchEvent(MySocketBase.EVT_PACKET_RECEIVED, {evt.data}) end)
            if errMsg then
                self.logger_:errorf("onPacketReceived: %s dispatching cmd:%x error %s", self.name_, pack.cmd, errMsg)
            end
        end
    end
end

function MySocketBase:onProcessPacket(pack)
    self.logger_:warn("onProcessPacket: not implemented method onProcessPacket")
end

function MySocketBase:onAfterConnected()
    self.logger_:warn("onAfterConnected: not implemented method onAfterConnected")
end

function MySocketBase:onAfterConnectFailure()
    self.logger_:warn("onAfterConnectFailure: not implemented method onAfterConnectFailure")
end

function MySocketBase:onAfterDataError()
    self:onAfterConnectFailure()
    self.logger_:warn("onAfterDataError: not implemented method onAfterDataError")
end

return MySocketBase
