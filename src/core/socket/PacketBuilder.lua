-- Author: Jam
-- Date: 2015.04.13

--[[
    封包
]]

local TYPE = import(".PacketDataType")
require("core.util.bit")

local PacketBuilder = class("PacketBuilder")
local ByteArray = require("core.utils.ByteArray")
local Code = import(".Code")

function PacketBuilder:ctor(cmd, config, socketName)
    self.cmd_ = cmd
    self.config_ = config
    self.params_ = {}
    self.logger_ = g.Logger.new(socketName .. ".PacketParser"):enabled(true)
end

function PacketBuilder:setParameter(key, value)
    self.params_[key] = value
    return self
end

function PacketBuilder:setParameters(params)
    table.merge(self.params_, params)
    return self
end

local function writeData(buf, dtype, val, fmt, lengthType)
    if dtype == TYPE.UBYTE then
        if type(val) == "string" and string.len(val) == 1 then
            buf:writeChar(val)
        else
            buf:writeUByte(tonumber(val) or 0)
        end
    elseif dtype == TYPE.BYTE then
        if type(val) == "string" and string.len(val) == 1 then
            buf:writeChar(val)
        else
            local n = tonumber(val)
            if n and n < 0 then
                n = n + 2^8
            end
            buf:writeByte(n or 0)
        end
    elseif dtype == TYPE.INT then
        buf:writeInt(tonumber(val) or 0)
    elseif dtype == TYPE.UINT then
        buf:writeUInt(tonumber(val) or 0)
    elseif dtype == TYPE.SHORT then
        buf:writeShort(tonumber(val) or 0) 
    elseif dtype == TYPE.USHORT then
        buf:writeUShort(tonumber(val) or 0)
    elseif dtype == TYPE.LONG then
        val = tonumber(val) or 0
        local low = val%2^32
        local high = val/2^32
        buf:writeInt(high)
        buf:writeUInt(low)
    elseif dtype == TYPE.ULONG then
        val = tonumber(val) or 0
        local low = val%2^32
        local high = val/2^32
        buf:writeInt(high)
        buf:writeUInt(low)
    elseif dtype == TYPE.STRING then
        val = tostring(val) or ""
        buf:writeUInt(#val + 1)
        buf:writeStringBytes(val)
        buf:writeByte(0)
    elseif dtype == TYPE.ARRAY then
        local len = 0
        if val then
            len = #val
        end
        if lengthType then
            if lengthType == TYPE.UBYTE then
                buf:writeUByte(len)
            elseif lengthType == TYPE.BYTE then
                buf:writeByte(len)
            elseif lengthType == TYPE.INT then
                buf:writeInt(len)
            elseif lengthType == TYPE.UINT then
                buf:writeUInt(len)
            elseif lengthType == TYPE.LONG then
                local low = len%2^32
                local high = len/2^32
                buf:writeInt(high)
                buf:writeUInt(low)
            elseif lengthType == TYPE.ULONG then
                local low = len%2^32
                local high = len/2^32
                buf:writeInt(high)
                buf:writeUInt(low)
            end
        else
            buf:writeUByte(len)
        end
        if len > 0 then
            for i1,v1 in ipairs(val) do
                for i2,v2 in ipairs(fmt) do
                    local name = v2.name
                    local dtype = v2.type
                    local fmt = v2.fmt
                    local value = v1[name]
                    local lengthType = v2.lengthType or nil
                    writeData(buf, dtype, value, fmt, lengthType)
                end
            end
        end
    end
end

function PacketBuilder:build()
    local buf = ByteArray.new(ByteArray.ENDIAN_BIG)
    -- 写包头，包体长度先写0
    buf:writeInt(0) -- 包体长度 4
    buf:writeStringBytes("LW") -- LW 2
    buf:writeInt(self.cmd_) -- 命令字 4
    buf:writeByte(0) --检验码 1
    if self.config_ and self.config_.fmt and #self.config_.fmt>0 then
        -- 写包体
        for i,v in ipairs(self.config_.fmt) do
            local name = v.name
            local dtype = v.type
            local fmt = v.fmt
            local value = self.params_[name]
            local lengthType = v.lengthType or nil
            writeData(buf, dtype, value, fmt, lengthType)
        end
        -- 修改包体长度
        buf:setPos(1)
        buf:writeInt(buf:getLen())
        --self:cbCode(buf)
        self.code = self:cbCode(buf)
        buf:setPos(11)
        if self.code then
            buf:writeByte(self.code)
        end
        buf:setPos(buf:getLen() + 1)
    else
        buf:setPos(1)
        buf:writeInt(buf:getLen())
        buf:setPos(buf:getLen() + 1)
    end
    self.logger_:debugf("BUILD PACKET ==> %x(%s)[%s]", self.cmd_, buf:getLen(), ByteArray.toString(buf, 16))
    return buf
end

function PacketBuilder:cbCode(buf)
    local cbCheckCode = 0
    local s = ByteArray.toString(buf, 16)
    for i = 12, buf:getLen() do
        local x1,_ = ByteArray.toString(buf:getBytes(i, i), 16)
        buf:setPos(i)
        local x,_ = ByteArray.toString(buf:getBytes(i, i), 10)
        local num = tonumber(x) + 1
        cbCheckCode = cbCheckCode + tonumber(x)
        if cbCheckCode >= 256 then
            cbCheckCode = cbCheckCode - 256
        end
        local origal = Code.SocketJiami[num]
        buf:writeByte(origal)
    end
    if cbCheckCode == 0 then
        return 0
    else
        local code = bit.tonot1(cbCheckCode) + 1
        return code 
    end
end

return PacketBuilder