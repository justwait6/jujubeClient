local HallSocketProtocol = {}
local P = HallSocketProtocol

local T = require("core.socket.PacketDataType")
local PR = import("core.protocol.SocketProtocol")

P.SERVER_CONFIG = {
    [PR.SVR_HEART_BEAT] = {
        ver = 1,
        fmt = {
            {name="random", type=T.INT}
        }
    },
    [PR.SVR_LAND_FALL] = {
        ver = 1,
        fmt = {

        }
    },
    [PR.SVR_REFRESH_MONEY] = {
        ver = 1,
        fmt = {
            {name="money", type=T.LONG},
            {name="gold", type=T.LONG},
            {name="safebox", type=T.LONG}
        }      
    },
    [PR.SVR_DICE_LOGIN] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE},
            {name="table", type=T.INT, depends = function(ctx) return (ctx.ret == 1 or ctx.ret == 0) end},
            {name="GameId", type=T.INT, depends = function(ctx) return (ctx.ret == 1 or ctx.ret == 0) end},
            {name="IP", type=T.STRING, depends = function(ctx) return (ctx.ret == 1 or ctx.ret == 0) end},
            {name="port", type=T.INT, depends = function(ctx) return (ctx.ret == 1 or ctx.ret == 0) end},
            {name="level", type=T.SHORT, depends = function(ctx) return (ctx.ret == 1 or ctx.ret == 0) end},
        }
    },
    [PR.SVR_DICE_GET_TABLE] = {
        ver = 1,
        fmt = {
            {name="ret",type=T.BYTE},
            {name="tid", type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="gameId",type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="level",type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="ip",type=T.STRING, depends = function(ctx) return ctx.ret == 0 end},
            {name="port",type=T.INT, depends = function(ctx) return ctx.ret == 0 end}
        }
    },
    [PR.SVR_PHP_MESSAGE] = {
        ver = 1,
        fmt = {
            {name="msg", type=T.STRING},
            {name="phpType", type=T.INT}
        }
    },
}


return HallSocketProtocol