local MySocketBase = import(".MySocketBase")
local MySocket = class("MySocket", MySocketBase)

local SocketProtocol = require("core.protocol.SocketProtocol")

local scheduler = require(cc.PACKAGE_NAME .. ".scheduler")

function MySocket:ctor()
    MySocket.super.ctor(self, "MySocket", SocketProtocol)
    self.level = 0
    self.gameId = 0
    self.timerScheduleId = g.mySched:doLoop(handler(self, self.timer_), 10)
end

function MySocket.getInstance()
	if not MySocket.singleInstance then
		MySocket.singleInstance = MySocket.new()
	end
	return MySocket.singleInstance
end

--倒计时
function MySocket:timer_(dt)
    print("MySocket:timer_ current time: ", os.time())
    if not self:isConnected() then
        print("MySocket:timer_ isConnected: FALSE")
        self:disconnect()
        self:connectServer()
    end
    return true
end

function MySocket:connectServer()
    local ip = g.user:getHallIp()
    local port = g.user:getHallPort()
    print("ip port: ", ip, port)
    if ip and port then 
        print("MySocket:connectServer INFO ip-port: ", ip, port)
        -- 设置定时器
        self:removeConnectScheduler()
        self.connectSchedulerHandle_ = scheduler.performWithDelayGlobal(handler(self, self.onConnectTimeout_), 15)
        self:connect(ip, port)
    end
end

function MySocket:removeConnectScheduler()
    if self.connectSchedulerHandle_ then
        scheduler.unscheduleGlobal(self.connectSchedulerHandle_)
        self.connectSchedulerHandle_ = nil
    end
end

function MySocket:setLevel(level)
    self.level = level
end

function MySocket:setGameId(gameId)
    self.gameId = gameId
end


function MySocket:disconnect(noEvent)
    MySocket.super.disconnect(self, noEvent)
end

function MySocket:onConnectTimeout_()
    self:onFail_()
end

function MySocket:onAfterConnected()
    self.logoutRequested_ = false
    self:removeConnectScheduler()
    -- 请求桌子
    -- 登录房间超时检测
    if self.loginTimeoutHandle_ then
        scheduler.unscheduleGlobal(self.loginTimeoutHandle_)
        self.loginTimeoutHandle_ = nil
    end
    self.loginTimeoutHandle_ = scheduler.performWithDelayGlobal(function()
        self.loginTimeoutHandle_ = nil
        self.socketService_:disconnect()
    end, 4)
    print("g.Const.SERVER_CHANNEL = %s", g.Const.SERVER_CHANNEL)
    if tonumber(g.user:getUid()) ~= 0 then
        self:sendLogin(tonumber(g.user:getUid()), g.Const.version, g.Const.SERVER_CHANNEL, g.Const.SERVER_PLATFORM, g.user:getAccessServerToken())
    else
        local errorMsg = "server login success but uid id == 0"
        -- g.native:umengError(errorMsg)
    end

    if self.timeoutScheduler then
        scheduler.unscheduleGlobal(self.timeoutScheduler)
        self.timeoutScheduler = nil
    end

    -- 发送心跳包
    self:scheduleHeartBeat(SocketProtocol.CLISVR_HEART_BEAT, 10, 2)
    --
    -- g.umeng:report(KUmengServerLoginOk)
end

function MySocket:onFail_(silent)
    -- g.umeng:report(KUmengServerLoginFail)
    self:removeConnectScheduler()
    self:disconnect(true)
end

function MySocket:onClose(evt)
    self:unscheduleHeartBeat()
end

function MySocket:buildHeartBeatPack()
    local data = {}
    local num = math.random(1, 2)
    if num == 1 then
        local random1 = math.random(0, 2147483647)
        local param1 = {}
        param1.value = random1
        table.insert(data, param1)
    elseif num == 2 then
        local random1 = math.random(0, 2147483647)
        local random2 = math.random(0, 2147483647)
        
        local param1 = {}
        param1.value = random1
        local param2 = {}
        param2.value = random2

        table.insert(data, param1)
        table.insert(data, param2)
    end
    return self:createPacketBuilder(SocketProtocol.CLISVR_HEART_BEAT):setParameter("random", data):build()
end

function MySocket:onHeartBeatTimeout(timeoutCount)
    print("MySocket:onHeartBeatTimeout = %s", timeoutCount)
    if timeoutCount >= 2 then
        self.socketService_:disconnect()
    end
end

function MySocket:onHeartBeatReceived(delaySeconds)
    print("MySocket:onHeartBeatReceived.." .. delaySeconds)
    local signalStrength
    if delaySeconds < 0.4 then
        signalStrength = 4
    elseif delaySeconds < 0.8 then
        signalStrength = 3
    elseif delaySeconds < 1.2 then
        signalStrength = 2
    else
        signalStrength = 1
    end
end

function MySocket:onAfterConnectFailure()
    self:onFail_()
end

function MySocket:sendLogin(uid, version, channel, deviceId, token)
    print(uid, version, channel, deviceId, token)
    print(SocketProtocol.CLI_DICE_LOGIN)
    local pack = self:createPacketBuilder(SocketProtocol.CLI_DICE_LOGIN)
        :setParameter("uid", uid)
        :setParameter("token", token)
        :setParameter("version", version)
        :setParameter("channel", channel)
        :setParameter("deviceId", deviceId)
        :build()
    self:send(pack)
end

function MySocket:sendLogout()
    self.logoutRequested_ = true
    self:send(self:createPacketBuilder(SocketProtocol.CLI_DICE_EXIT_ROOM):build())
end

function MySocket:onProcessPacket(pack)
    local cmd = pack.cmd
    print("MySocket:onProcessPacket: receive packet")
end

function MySocket:isConnected()
    return self.isConnected_
end

-- 跟踪
function MySocket:follow(followId, key, info, followNick)
    if self.isConnected_  then
        self:send(self:createPacketBuilder(SocketProtocol.CLI_DICE_GET_TABLEID)
            :setParameter("followId", self.followId)
            :setParameter("key", self.key)
            :setParameter("info", self.info)
            :setParameter("followNick", self.followNick)
            :build())
    end
end

-- 登录
function MySocket:login(tableId, uid, key, info, flag)
    if self.isConnected_  then
        self:send(self:createPacketBuilder(SocketProtocol.CLI_DICE_GET_TABLEID)
            :setParameter("tableId", self.tableId)
            :setParameter("uid", self.uid)
            :setParameter("key", self.key)
            :setParameter("info", self.info)
            :setParameter("flag", self.flag)
            :build())
    end
end

return MySocket
