local RummyCmdConfig = {}

local C = import(".CommandDef")
local T = require("core.socket.PacketDataType")

RummyCmdConfig = {
    --[[
        客户端包，对于空包体，可以永许不定义协议内容，将默认版本号为1， 包体长度为0
    --]]
    [C.CLI_ENTER_ROOM] = {
        ver = 1,
        fmt = {
            {name = "uid", type = T.INT},
            {name = "gameId", type = T.INT},
            {name = "tid", type = T.INT},
            {name = "userinfo", type = T.STRING},
        }
    },

    --[[
        服务器包
    --]]
    [C.SVR_ENTER_ROOM] = {
        ver = 1,
        fmt = {
            {name="ret",type=T.BYTE},
            {name="tid",type=T.INT,depends = function(ctx) return ctx.ret == 0 end},
            {name="level",type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="state",type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="smallbet",type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="dUid",type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="players", type=T.ARRAY, lengthType=T.BYTE, depends = function(ctx) return ctx.ret == 0 end,
                fmt = {
                    {name="uid", type=T.INT},
                    {name="seatId", type=T.INT},
                    {name="money", type=T.LONG},
                    {name="gold", type=T.LONG},
                    {name="userinfo", type=T.STRING},
                    {name="state",type=T.INT}
                }
            },
            {name="groups", type=T.ARRAY, lengthType=T.BYTE,depends = function(ctx) return ctx.ret == 0 and (ctx.state == 1) end,
                fmt = {
                    {name="cards", type=T.ARRAY, lengthType=T.BYTE,
                        fmt = {
                            {name="card", type=T.BYTE},
                        }
                    }
                }
            },
            {name="drawCardPos", type=T.INT, depends = function(ctx) return ctx.ret == 0 and (ctx.state == 1) end},
            {name="dropCard", type=T.BYTE, depends = function(ctx) return ctx.ret == 0 and (ctx.state == 1) end},
            {name="magicCard", type=T.BYTE, depends = function(ctx) return ctx.ret == 0 and (ctx.state == 1) end},
            {name="heapCardNum", type=T.INT, depends = function(ctx) return ctx.ret == 0 and (ctx.state == 1) end},
            {name="operUid", type=T.INT, depends = function(ctx) return ctx.ret == 0 and (ctx.state == 1) end},
            {name="leftOperSec", type=T.INT, depends = function(ctx) return ctx.ret == 0 and (ctx.state == 1) end},
            {name="users", type=T.ARRAY, lengthType=T.BYTE, depends = function(ctx) return ctx.ret == 0 and (ctx.state == 1) end,
                fmt = {
                    {name="uid", type=T.INT},
                    {name="operStatus", type=T.BYTE},
                    {name="isDrop", type=T.BYTE},
                    {name="isNeedDeclare", type=T.BYTE},
                    {name="isFinishDeclare", type=T.BYTE},
                    {name="groups", type=T.ARRAY, lengthType=T.BYTE,depends = function(ctx) return ctx.ret == 0 and (ctx.state == 1) end,
                        fmt = {
                            {name="cards", type=T.ARRAY, lengthType=T.BYTE,
                                fmt = {
                                    {name="card", type=T.BYTE},
                                }
                            }
                        }
                    }
                }
            },
            {name="finishCard", type=T.BYTE, depends = function(ctx) return ctx.ret == 0 and (ctx.state == 1) end},
        }
    },
}

return RummyCmdConfig
