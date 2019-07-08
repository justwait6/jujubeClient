-- Author: Jam
-- Date: 2015.04.15
local SimpleTCP = require("framework.SimpleTCP")
local ByteArray = require("core.utils.ByteArray")
local PacketBuilder = import(".PacketBuilder")
local PacketParser = import(".PacketParser")
local KatoSocketProtocol = import("core.protocol.KatoSocketProtocol")
local SocketService = class("SocketService")

local SOCKET_ID = 1

function SocketService:ctor(name, protocol)
    self.name_ = name
    self.protocol_ = protocol
    self.parser_ = PacketParser.new(protocol, self.name_)
end

function SocketService:getSocketId(mySocket)
    SOCKET_ID = SOCKET_ID + 1
    return SOCKET_ID
end

function SocketService:setMySocket(mySocket)
    self.mySocket = mySocket
    return self
end

-- function SocketService:setParserClass(ParserClass)
--     self.parser_ = ParserClass.new(self.protocol_, self.name_)
-- end

function SocketService:createPacketBuilder(cmd)
    if app.name == "GapleRoomScene" then
        if GAPLE_SOCKET_PROTOCOL.CONFIG[cmd] then
            return PacketBuilder.new(cmd, GAPLE_SOCKET_PROTOCOL.CONFIG[cmd],self.name_)
        else
            return PacketBuilder.new(cmd, self.protocol_.CONFIG[cmd], self.name_)
        end
    -- elseif 
    else
        return PacketBuilder.new(cmd, self.protocol_.CONFIG[cmd], self.name_)
    end
end

function SocketService:getSocketTCP()
    return self.socket_
end

function SocketService:connect(host, port, retryConnectWhenFailure)
    -- self:disconnect()
    if not self.socket_ then
        self.socket_ = SimpleTCP.new(host, port, handler(self, self.onTCPEvent))
        self.socket_.socketId_ = self:getSocketId()
    end
    self.socket_:connect()
end

function SocketService:onTCPEvent(even, data)
    if even == SimpleTCP.EVENT_DATA then
        print("onTCPEvent ==receive data:", data)
        self:onData(data)
    elseif even == SimpleTCP.EVENT_CONNECTING then
        print("onTCPEvent ==connecting")
    elseif even == SimpleTCP.EVENT_CONNECTED then
        print('onTCPEvent connected')
        self:onConnected()
    elseif even == SimpleTCP.EVENT_CLOSED then
        print('onTCPEvent closed')
        self:onClosed()
    elseif even == SimpleTCP.EVENT_FAILED then
        print('onTCPEvent failed')
        self:onConnectFailure()
    end
end

function SocketService:send(data)
    if self.socket_ then
        if type(data) == "string" then
            self.socket_:send(data)
        else
            self.socket_:send(data:getPack())
        end
    end
end

function SocketService:disconnect(noEvent)
    if self.socket_ then
        local socket = self.socket_
        self.socket_ = nil
        socket:close()
    end
end

function SocketService:onConnected()
    print("SocketService:onConnected [%d] onConnected.")
    self.parser_:reset()
    if self.mySocket then self.mySocket:onConnected() end
end

function SocketService:onClose()
    print("SocketService:onClose [%d] onClose. %s")
    if self.mySocket then self.mySocket:onClose() end
end

function SocketService:onClosed()
    print("SocketService:onClosed: [%d] onClosed. %s")
    if self.mySocket then self.mySocket:onClosed() end
end

function SocketService:onConnectFailure()
    if self.mySocket then self.mySocket:onConnectFailure() end
end

function SocketService:onData(evt)
    print("socket receive raw data. %s", ByteArray.toString(evt.data, 16))
    local buf = ByteArray.new(ByteArray.ENDIAN_BIG)
    buf:writeBuf(evt.data)
    buf:setPos(1)
    local success, packets = self.parser_:read(buf)
    if not success then
        if self.mySocket then self.mySocket:onError(evt) end
    else
       for i,v in ipairs(packets) do
            if v and v.cmd then
                --print("SocketService:onData[==PACK==][%x][%s]\n==>%s", v.cmd, table.keyof(self.protocol_, v.cmd), json.encode(v))
                if self.mySocket then self.mySocket:onPacketReceived({data = v}) end
            end
       end 
    end
end

return SocketService