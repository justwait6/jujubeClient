local CommandConfig = {}

local C = import(".CommandDef")
local T = require("core.socket.PacketDataType")

CommandConfig.CLIENT = {
    --[[
        客户端包，对于空包体，可以永许不定义协议内容，将默认版本号为1， 包体长度为0
    ]]
    [C.CLISVR_HEART_BEAT] = {
        ver = 1,
        fmt = {
            {name="random",type=T.ARRAY,lengthType=T.BYTE,
               fmt = {
                   {name="value",type=T.INT},
               },
            }
        }
    },
    [C.CLI_COMMON_BROADCAST] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="msg",type=T.STRING},
        }
    },
    [C.CLI_UPDATE_USERINFO] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="userinfo",type=T.STRING},
        }
    },
    -- 骰子协议
    [C.CLI_DICE_LOGIN] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="token", type=T.STRING},
            {name="version", type=T.STRING},
            {name="channel", type=T.STRING},
            {name="deviceId", type=T.SHORT}
        }
    },
    [C.CLI_DICE_GET_TABLEID] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="gameId", type=T.INT},
            {name="level", type=T.INT}
        }
    },
    [C.CLI_DICE_LOGIN_ROOM] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="gameId", type=T.INT},
            {name="tid", type=T.INT},
            {name="userinfo", type=T.STRING}
        }
    },
    [C.CLI_DICE_EXIT_ROOM] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT}
        }
    },
    [C.CLI_DICE_SEND_CHAT] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="chatInfo", type=T.STRING}
        }
    },
    [C.CLI_DICE_SEND_FACE] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="info", type=T.STRING}
        }
    },
    [C.CLI_DICE_BET] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="type", type=T.INT},
            {name="param", type=T.INT},
            {name="money", type=T.LONG}
        }
    },
    [C.CLI_DICE_SITDOWN] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="seatId", type=T.INT}
        }
    },
    [C.CLI_DICE_SEND_PRO] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="duid", type=T.INT},
            {name="id", type=T.INT},
            {name="money", type=T.LONG}
        }
    },
    [C.CLI_DICE_DEALER_FEE] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="money", type=T.LONG}
        }
    },
    [C.CLI_DICE_FOLLOW] = {
        ver = 1,
        fmt = {
            {name="followId", type=T.INT},
            {name="key", type=T.STRING},
            {name="info", type=T.STRING},
            {name="followNick", type=T.STRING}
        }
    },
    [C.CLI_DICE_STANDUP] = {
        ver = 1,
        fmt = {
        }
    },
    [C.CLI_DICE_REBET] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT}
        }
    },
    [C.CLI_DICE_ADD_FRIEND] = {
        ver = 1,
        fmt = {
            {name="sendUid", type=T.INT},
            {name="toUid", type=T.INT},
        }
    },
}

CommandConfig.SERVER = {
    [C.SVR_COMMON_BROADCAST] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="msg",type=T.STRING},
        }
    },
    [C.SVR_LAND_FALL] = {
        ver = 1,
        fmt = {

        }
    },
    [C.SVR_DICE_LOGIN] = {
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
    [C.SVR_DICE_GET_TABLE] = {
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
    [C.SVR_DICE_LOGIN_ROOM] = {
        ver = 1,
        fmt = {
            {name="ret",type=T.BYTE},
            {name="tid", type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="level",type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="state",type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="users", type=T.ARRAY, lengthType=T.BYTE, depends = function(ctx) return ctx.ret == 0 end,
                fmt = {
                    {name="uid", type=T.INT},
                    {name="seatId", type=T.INT},
                    {name="money", type=T.LONG},
                    {name="gold", type=T.LONG},
                    {name="userinfo", type=T.STRING},
                    {name="gameinfo", type=T.STRING},
                    {name="betinfo", type=T.ARRAY, lengthType=T.INT,
                        fmt = {
                            {name="type", type=T.INT},
                            {name="param", type=T.INT},
                            {name="money", type=T.LONG}
                        }
                    }
                }
            },
            {name="time",type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="points", type=T.ARRAY, lengthType=T.INT, depends = function(ctx) return ctx.ret == 0 end,
                fmt = {
                    {name="p1", type=T.BYTE},
                    {name="p2", type=T.BYTE},
                    {name="p3", type=T.BYTE}
                }
            },
            {name="lastwinmoney",type=T.LONG, depends = function(ctx) return (ctx.ret == 0 and ctx.state == 3) end}
        }
    },
    [C.SVR_DICE_EXIT_ROOM] = {
        ver = 1,
        fmt = {
            {name="ret",type=T.BYTE},
            {name="money", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end}
        }
    },
    [C.SVR_DICE_SEND_CHAT] = {
        ver = 1, 
        fmt = {
            {name="uid",type=T.INT},
            {name="message", type=T.STRING}
        }
    },
    [C.SVR_DICE_DEND_FACE] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="info", type=T.STRING},
        }
    },
    [C.SVR_DICE_START] = {
        ver = 1,
        fmt = {
        }
    },
    [C.SVR_DICE_GAME_END] = {
        ver = 1,
        fmt = {
            {name="p1", type=T.BYTE},
            {name="p2", type=T.BYTE},
            {name="p3", type=T.BYTE},
            {name="user", type=T.ARRAY, lengthType=T.INT,
                fmt = {
                    {name="uid", type=T.INT},
                    {name="seatId", type=T.INT},
                    {name="exp", type=T.INT},
                    {name="wintimes", type=T.INT},
                    {name="losetimes", type=T.INT},
                    {name="changeExp", type=T.INT},
                    {name="allmoney", type=T.LONG},
                    {name="gold", type=T.LONG},
                    {name="betInfo", type=T.ARRAY, lengthType=T.INT, 
                        fmt = {
                            {name="type", type=T.INT},
                            {name="point", type=T.INT},
                            {name="multiple", type=T.INT},
                            {name="chip", type=T.ULONG},
                            {name="win", type=T.ULONG}
                        }
                    }
                }
            }
        } 
    },
    [C.SVR_DICE_START_BET] = {
        ver = 1,
        fmt = {
            {name="time", type=T.INT}
        }
    },
    [C.SVR_DICE_SIT_UP] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE},
            {name="seatId", type=T.INT},
            {name="type", type=T.INT},
            {name="money",type=T.LONG},
        }
    },
    [C.SVR_DICE_BET] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE},
            {name="type", type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="param", type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="money", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end},
            {name="allmoney", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end}
        }
    },
    [C.SVR_DICE_BROADCAST_STANDUP] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="seatId", type=T.INT}
        }
    },
    [C.SVR_DICE_SIT_DOWN] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE},
            {name="seatId", type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="money", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end}
        }
    },
    [C.SVR_DICE_BROADCAST_DOWN] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="seatId", type=T.INT},
            {name="money", type=T.LONG},
            {name="userinfo", type=T.STRING},
            {name="gameinfo", type=T.STRING}
        }
    },
    [C.SVR_HEART_BEAT] = {
        ver = 1,
        fmt = {
            {name="random",type=T.ARRAY,lengthType=T.BYTE,
               fmt = {
                   {name="value",type=T.INT},
               },
            }
        }
    },
    [C.SVR_DICE_STOP] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.INT},
        }
    },
    [C.SVR_DICE_SEND_PRO] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE}
        }
    },
    [C.SVR_DICE_PROP] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="tuid", type=T.INT},
            {name="money", type=T.LONG},
            {name="id", type=T.INT}
        }
    },
    [C.SVR_DICE_OTHER_BET] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="seatId", type=T.INT},
            {name="type", type=T.INT},
            {name="param", type=T.INT},
            {name="money", type=T.LONG},
            {name="allmoney", type=T.LONG}
        }
    },
    [C.SVR_DICE_DEALER_FEE] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE},
            {name="uid", type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="money", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end},
            {name="tips", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end}
        }
    },
    [C.SVR_PHP_MESSAGE] = {
        ver = 1,
        fmt = {
            {name="msg", type=T.STRING},
            {name="phpType", type=T.INT}
        }
    },
    [C.SVR_DICE_OUT_ROOM] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="seatId", type=T.INT}
        }
    },
    [C.SVR_REFRESH_MONEY] = {
        ver = 1,
        fmt = {
            {name="money", type=T.LONG},
            {name="gold", type=T.LONG},
            {name="safebox", type=T.LONG}
        }      
    },
    [C.SVR_REFRESH_MONEY_UID] = {
        ver = 1,
        fmt = {
             {name="uid", type=T.INT},
            {name="money", type=T.LONG},
            {name="gold", type=T.LONG},
            {name="safebox", type=T.LONG}
        }      
    },
    [C.SVR_DICE_REBET] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE}
        }
    },

    [C.SVR_DICE_FOLLOW] = {
        ver = 1,
        fmt = {
            {name="code", type=T.INT}
        }
    },
    [C.SVR_DICE_FOLLOWED] = {
        ver = 1,
        fmt = {
            {name="code", type=T.INT},
            {name="uid", type=T.INT},
            {name="nick", type=T.STRING}
        }
    },
    [C.SVR_DICE_ADD_FRIEND] = {
        ver = 1,
        fmt = {
            {name="sendUid", type=T.INT},
            {name="toUid", type=T.INT},
        }
    },
}

return CommandConfig
