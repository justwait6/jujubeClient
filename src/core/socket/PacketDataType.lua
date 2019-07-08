-- Author: Jam
-- Date: 2015.04.13

--[[
    Socket数据包数据类型
]]

local PacketDataType = {}
PacketDataType.UBYTE = "ubyte"
PacketDataType.BYTE = "byte"
PacketDataType.SHORT = "short"
PacketDataType.USHORT = "ushort"
PacketDataType.INT = "int"
PacketDataType.UINT = "uint"
PacketDataType.LONG = "long"
PacketDataType.ULONG = "ulong"
PacketDataType.STRING = "string"

PacketDataType.ARRAY = "array"

return PacketDataType