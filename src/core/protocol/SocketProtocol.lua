-- Author: Jam
-- Date: 2015.04.20
local SocketProtocol = {}
local P = SocketProtocol

local T = require("core.socket.PacketDataType")

-- 客户端请求
P.CLISVR_HEART_BEAT                     = 0x0200     --心跳
P.CLI_COMMON_BROADCAST                  = 0x2200     --客户端广播给其他客户端
P.CLI_UPDATE_USERINFO                   = 0x2201     --更新用户信息

-- 刷新金币
P.SVR_REFRESH_MONEY                     = 0x2100     --刷新money
P.SVR_REFRESH_MONEY_UID                 = 0x2101     --刷新钱
P.SVR_COMMON_BROADCAST                  = 0x2200     --客户端广播给其他客户端
P.SVR_LAND_FALL                         = 0x10f      -- 异地登陆

--筛子协议
P.CLI_DICE_LOGIN                        = 0x0201    -- 登录大厅
P.CLI_DICE_GET_TABLEID                  = 0x0110    -- 请求分配桌子ID
P.CLI_DICE_LOGIN_ROOM                   = 0x2001    -- 进入房间
P.CLI_DICE_EXIT_ROOM                    = 0x2002    -- 登出房间
P.CLI_DICE_SEND_CHAT                    = 0x2003    -- 发送聊天
P.CLI_DICE_SEND_FACE                    = 0x2004    -- 发送表情
P.CLI_DICE_BET                          = 0x2012    -- 请求下注
P.CLI_DICE_SITDOWN                      = 0x2010    -- 请求坐下
P.CLI_DICE_SEND_PRO                     = 0x2014    -- 互动表情
P.CLI_DICE_DEALER_FEE                   = 0x2013    -- 荷官小费
P.CLI_DICE_REBET                        = 0x2015    -- 重复投

P.CLI_DICE_FOLLOW                       = 0x123     -- 跟踪玩家
P.CLI_DICE_STANDUP                      = 0x1033    -- 玩家站起

P.CLI_DICE_ADD_FRIEND                   = 0x2007    -- 加好友



-- 骰子协议
P.SVR_HEART_BEAT                        = 0x0200     --心跳
P.SVR_DICE_LOGIN                        = 0x0101    -- 登录成功
P.SVR_DICE_GET_TABLE                    = 0x0110    -- 分桌返回
P.SVR_DICE_LOGIN_ROOM                   = 0x2001    -- 进入房间返回
P.SVR_DICE_EXIT_ROOM                    = 0x2002    -- 退出房间
P.SVR_DICE_SEND_CHAT                    = 0x2003    -- 发送聊天
P.SVR_DICE_DEND_FACE                    = 0x2004    -- 发送表情
P.SVR_DICE_START                        = 0x4001    -- 开始比赛
P.SVR_DICE_GAME_END                     = 0x4004    -- 游戏结束
P.SVR_DICE_START_BET                    = 0x4005    -- 可以开始下注
P.SVR_DICE_SIT_UP                       = 0x2011    -- 玩家站起
P.SVR_DICE_BET                          = 0x2012    -- 下注
P.SVR_DICE_BROADCAST_STANDUP            = 0x4006    -- 广播站起
P.SVR_DICE_SIT_DOWN                     = 0x2010    -- 玩家入座
P.SVR_DICE_BROADCAST_DOWN               = 0x4002    -- 广播坐下
P.SVR_DICE_STOP                         = 0x200F    -- 服务器退休
P.SVR_DICE_SEND_PRO                     = 0x2014    -- 互动表情
P.SVR_DICE_PROP                         = 0x4007    -- 发送道具
P.SVR_DICE_OTHER_BET                    = 0x4003    -- 其他用户下注
P.SVR_DICE_DEALER_FEE                   = 0x2013    -- 荷官小费
P.SVR_PHP_MESSAGE                       = 0x7001    -- php广播
P.SVR_DICE_OUT_ROOM                     = 0x200E    -- 用户退出房间
P.SVR_DICE_REBET                        = 0x2015    -- 重复投

P.SVR_DICE_FOLLOW                       = 0x214     -- 跟踪玩家
P.SVR_DICE_FOLLOWED                     = 0x215     -- 被跟踪玩家
P.SVR_DICE_LOGIN_ERROR                  = 0x1005    -- 登录失败
P.SVR_DICE_RELOGIN                      = 0x1009    -- 重登游戏

P.SVR_DICE_ADD_FRIEND                   = 0x2007    -- 加好友

--博定协议

P.CLI_POKDENG_LOGIN_ROOM                = 0x2001    -- 进入房间
P.CLI_POKDENG_EXIT_ROOM                 = 0x2002    -- 登出房间
P.CLI_POKDENG_BET                       = 0x2015    -- 用户下注
P.CLI_POKDENG_OPER                      = 0X2017    -- 用户操作
P.CLI_POKDENG_GRAB_DEALER               = 0x2018    -- 用户排队抢庄
P.CLI_POKDENG_NOT_BE_DEALER             = 0x2019    -- 用户下庄
P.CLI_POKDENG_REQUEST_SEAT              = 0x2010    -- 用户请求坐下
P.CLI_POKDENG_REQUEST_D_QUEUE           = 0x201A    -- 获取庄家排队列表
P.CLI_POKDENG_SEND_CHAT                 = 0x2003    -- 发送聊天
P.CLI_POKDENG_SEND_FACE                 = 0x2004    -- 发送表情
P.CLI_POKDENG_SEND_PRO                  = 0x2014    -- 互动表情
P.CLI_POKDENG_DEALER_FEE                = 0x2013    -- 荷官小费
P.CLI_POKDENG_CHG_TABLE                 = 0x2006    -- 换桌
P.CLI_POKDENG_REQ_STAND                 = 0x2011    -- 主动站起


P.SVR_POKDENG_LOGIN_ROOM                = 0x2001    -- 进入房间返回
P.SVR_POKDENG_EXIT_ROOM                 = 0x2002    -- 退出房间
P.SVR_POKDENG_BROADCAST_DOWN            = 0x4002    -- 广播坐下
P.SVR_POKDENG_BROADCAST_LEAVE           = 0x200E    -- 广播用户退出
P.SVR_POKDENG_BROADCAST_STANDUP         = 0x4006    -- 广播用户站起
P.SVR_POKDENG_BROADCAST_START           = 0x4001    -- 广播游戏开始
P.SVR_POKDENG_BROADCAST_BET             = 0x4003    -- 广播用户下注
P.SVR_POKDENG_HANDCARD                  = 0x400D    -- 发手牌
P.SVR_POKDENG_BROADCAST_SHOWCARD        = 0x400C    -- 广播亮牌操作
P.SVR_POKDENG_BET                       = 0x2015    -- 自己下注返回
P.SVR_POKDENG_OPER                      = 0x2017    -- 自己操作返回
P.SVR_POKDENG_BROADCAST_CUR_OPER        = 0x4009    -- 广播用户进行操作
P.SVR_POKDENG_BROADCAST_USER_OPER       = 0x400B    -- 广播其他用户的操作结果
P.SVR_POKDENG_BROADCAST_GAME_OVER       = 0x4004    -- 广播游戏结束
P.SVR_POKDENG_GRAB_DEALER               = 0x2018    -- 用户排队抢庄返回
P.SVR_POKDENG_BROADCAST_CHG_DEALER      = 0x400E    -- 广播换庄家
P.SVR_POKDENG_NOT_BE_DEALER             = 0x2019    -- 用户下庄请求返回  
P.SVR_POKDENG_SELF_STAND                = 0x2011    -- 用户自己站起
P.SVR_POKDENG_SEAT_RESPONSE             = 0x2010    -- 用户请求坐下返回
P.SVR_POKDENG_D_QUEUE_RESPONSE          = 0x201A    -- 庄家排队列表返回  
P.SVR_POKDENG_SEND_CHAT                 = 0x2003    -- 发送聊天
P.SVR_POKDENG_SEND_FACE                 = 0x2004    -- 发送表情
P.SVR_POKDENG_SEND_PRO                  = 0x2014    -- 互动表情
P.SVR_POKDENG_PROP                      = 0x4007    -- 发送道具
P.SVR_POKDENG_DEALER_FEE                = 0x2013    -- 荷官小费
P.SVR_POKDENG_CHG_TABLE                 = 0x2006    -- 换桌

--大米协议
P.CLI_DUMMY_LOGIN_ROOM                  = 0x2001    -- 进入房间
P.CLI_DUMMY_EXIT_ROOM                   = 0x2002    -- 退出房间
P.CLI_DUMMY_REQUEST_SEAT                = 0x2010    -- 用户请求坐下
P.CLI_DUMMY_REQUEST_READY               = 0x2015    -- 用户准备
P.CLI_DUMMY_REQUEST_GETCARD             = 0x2017    -- 玩家摸牌
P.CLI_DUMMY_REQUEST_BUILDCARD           = 0x2016    -- 玩家生牌
P.CLI_DUMMY_REQUEST_FOLDCARD            = 0x2018    -- 玩家出牌
P.CLI_DUMMY_REQUEST_SUITCARD            = 0x201A    -- 玩家放牌
P.CLI_DUMMY_REQUEST_SAVECARD            = 0x201B    -- 玩家存牌
P.CLI_DUMMY_REQUEST_KNOCK               = 0x201C    -- 玩家knock
P.CLI_DUMMY_CANCEL_AUTO                 = 0x2019    -- 取消托管
P.CLI_DUMMY_ONCE_KNOCK                  = 0x201D    -- 一次性knock
P.CLI_DUMMY_CHG_TABLE                   = 0x2006    -- 换桌


P.SVR_DUMMY_LOGIN_ROOM                  = 0x2001    -- 进入房间返回
P.SVR_DUMMY_EXIT_ROOM                   = 0x2002    -- 退出房间
P.SVR_DUMMY_BROADCAST_DOWN              = 0x4002    -- 广播用户坐下
P.SVR_DUMMY_BROADCAST_LEAVE             = 0x200E    -- 广播用户退出
P.SVR_DUMMY_BROADCAST_STANDUP           = 0x4006    -- 广播用户站起
P.SVR_DUMMY_SELF_STAND                  = 0x2011    -- 用户自己站起
P.SVR_DUMMY_SEAT_RESPONSE               = 0x2010    -- 用户请求坐下返回
P.SVR_DUMMY_READY_RESPONSE              = 0x2015    -- 用户准备返回
P.SVR_DUMMY_BROADCAST_READY             = 0x4008    -- 广播用户准备
P.SVR_DUMMY_GAME_START                  = 0x4001    -- 广播游戏开始
P.SVR_DUMMY_OPERATION                   = 0x4009    -- 广播用户操作
P.SVR_DUMMY_BROADCAST_FOLD_CARD         = 0x400E    -- 广播玩家出牌
P.SVR_DUMMY_BROADCAST_GET_CARD          = 0x400A    -- 广播玩家从新牌堆摸牌
P.SVR_DUMMY_BUILDCARD                   = 0x2016    -- 玩家生牌
P.SVR_DUMMY_FOLDCARD                    = 0x2018    -- 玩家出牌
P.SVR_DUMMY_GAME_OVER                   = 0x4004    -- 游戏结束
P.SVR_DUMMY_BROADCAST_BUILD_CARD        = 0x4010    -- 广播从弃牌堆摸牌生牌
P.SVR_DUMMY_RESPONSE_SUITCARD           = 0x201A    -- 玩家放牌返回
P.SVR_DUMMY_BROADCAST_SUITCARD          = 0x400F    -- 广播玩家放牌
P.SVR_DUMMY_BROADCAST_SAVECARD          = 0x400B    -- 广播用户存牌
P.SVR_DUMMY_BROADCAST_KNOCK             = 0x400C    -- 广播玩家knock
P.SVR_DUMMY_AUTO                        = 0x4011    -- 用户托管状态通知 
P.SVR_DUMMY_FLOWER_CARD                 = 0x400D    -- 花牌加分或减分牌提示
P.SVR_DUMMY_ONCE_KNOCK                  = 0x201D    -- 一次性knock
P.SVR_DUMMY_WIN_TIMES                   = 0x4012    -- 广播连赢
P.SVR_DUMMY_COUNT_DOWN                  = 0x4013    -- 倒计时游戏开始
P.SVR_DUMMY_CHG_TABLE                   = 0x2006    -- 换桌

--99协议
P.CLI_QIUQIU_LOGIN_ROOM                 = 0x2001    -- 进入房间
P.CLI_QIUQIU_EXIT_ROOM                  = 0x2002    -- 登出房间
P.CLI_QIUQIU_ACTION                     = 0x2015    -- 用户操作
P.CLI_QIUQIU_DEALER_FEE                 = 0x2016    -- 小费
P.CLI_QIUQIU_REQUEST_SEAT               = 0x2010    -- 用户请求坐下
P.CLI_QIUQIU_SEND_PRO                   = 0x2017    -- 发互动道具
P.CLI_QIUQIU_CHG_TABLE                  = 0x2006    -- 换桌
P.CLI_QIUQIU_REQ_STAND                  = 0x2014    -- 主动站起
P.CLI_QIUQIU_SWITCH_CARD                = 0x201A    -- 客户端发起选牌结果

P.SVR_QIUQIU_LOGIN_ROOM                 = 0x2001    -- 进入房间返回
P.SVR_QIUQIU_EXIT_ROOM                  = 0x2002    -- 退出房间
P.SVR_QIUQIU_BROADCAST_LEAVE            = 0x200E    -- 广播用户退出
P.SVR_QIUQIU_BROADCAST_DOWN             = 0x3002    -- 广播用户坐下
P.SVR_QIUQIU_STAND_UP                   = 0x3001    -- 广播用户站起 
P.SVR_QIUQIU_GAME_START                 = 0x3009    -- 广播游戏开始
P.SVR_QIUQIU_GAME_END_SHOW_CARD         = 0x3017    -- 亮牌
P.SVR_QIUQIU_END                        = 0x301A    -- 游戏结束
P.SVR_QIUQIU_DEAL_CARD                  = 0x3010    -- 发手牌
P.SVR_QIUQIU_BROADCAST_BET              = 0x3014    -- 广播用户下注
P.SVR_QIUQIU_ACTION                     = 0x2015    -- 用户操作
P.SVR_QIUQIU_FORTH_CARD                 = 0x3011    -- 发第四张牌
P.SVR_QIUQIU_BROADCAST_ACTION           = 0x3015    -- 广播用户操作
P.SVR_QIUQIU_DEALER_FEE                 = 0x2016    -- 小费
P.SVR_QIUQIU_BROADCAST_ROUND_END        = 0x3016    -- 广播一轮结束
P.SVR_QIUQIU_DIVIDE_POOL                = 0x3019    -- 分池
P.SVR_QIUQIU_REQUEST_SEAT               = 0x2010    -- 用户请求坐下
P.SVR_QIUQIU_SEND_PRO                   = 0x2017    -- 发互动道具
P.SVR_QIUQIU_PROP                       = 0x3023    -- 广播互动道具
P.SVR_QIUQIU_CHG_TABLE                  = 0x2006    -- 换桌
P.SVR_QIUQIU_REQ_STAND                  = 0x2014    --主动站起
P.SVR_QIUQIU_BROADCAST_SWITCH_CARD      = 0x3024    --广播提示用户选牌操作
P.SVR_QIUQIU_SWITCH_CARD                = 0x201A    -- 返回选牌结果
P.SVR_QIUQIU_BROADCAST_SWITCH_RESULT    = 0x3025    -- 广播其他用户选牌结果


--三公协议
P.CLI_SANGONG_LOGIN_ROOM                 = 0x2001    -- 进入房间
P.CLI_SANGONG_EXIT_ROOM                  = 0x2002    -- 登出房间
P.CLI_SANGONG_ACTION                     = 0x2015    -- 用户操作
P.CLI_SANGONG_DEALER_FEE                 = 0x2016    -- 小费
P.CLI_SANGONG_REQUEST_SEAT               = 0x2010    -- 用户请求坐下
P.CLI_SANGONG_SEND_PRO                   = 0x2017    -- 发互动道具
P.CLI_SANGONG_CHG_TABLE                  = 0x2006    -- 换桌
P.CLI_SANGONG_REQ_STAND                  = 0x2014    -- 主动站起
P.CLI_SANGONG_SWITCH_CARD                = 0x201A    -- 客户端发起选牌结果

P.SVR_SANGONG_LOGIN_ROOM                 = 0x2001    -- 进入房间返回
P.SVR_SANGONG_EXIT_ROOM                  = 0x2002    -- 退出房间
P.SVR_SANGONG_BROADCAST_LEAVE            = 0x200E    -- 广播用户退出
P.SVR_SANGONG_BROADCAST_DOWN             = 0x3002    -- 广播用户坐下
P.SVR_SANGONG_STAND_UP                   = 0x3001    -- 广播用户站起 
P.SVR_SANGONG_GAME_START                 = 0x3009    -- 广播游戏开始
P.SVR_SANGONG_GAME_END_SHOW_CARD         = 0x3017    -- 亮牌
P.SVR_SANGONG_END                        = 0x301A    -- 游戏结束
P.SVR_SANGONG_DEAL_CARD                  = 0x3010    -- 发手牌
P.SVR_SANGONG_BROADCAST_BET              = 0x3014    -- 广播用户下注
P.SVR_SANGONG_ACTION                     = 0x2015    -- 用户操作
P.SVR_SANGONG_THIRD_CARD                 = 0x3011    -- 发第三张张牌
P.SVR_SANGONG_BROADCAST_ACTION           = 0x3015    -- 广播用户操作
P.SVR_SANGONG_DEALER_FEE                 = 0x2016    -- 小费
P.SVR_SANGONG_BROADCAST_ROUND_END        = 0x3016    -- 广播一轮结束
P.SVR_SANGONG_DIVIDE_POOL                = 0x3019    -- 分池
P.SVR_SANGONG_REQUEST_SEAT               = 0x2010    -- 用户请求坐下
P.SVR_SANGONG_SEND_PRO                   = 0x2017    -- 发互动道具
P.SVR_SANGONG_PROP                       = 0x3023    -- 广播互动道具
P.SVR_SANGONG_CHG_TABLE                  = 0x2006    -- 换桌
P.SVR_SANGONG_REQ_STAND                  = 0x2014    --主动站起
P.SVR_SANGONG_BROADCAST_SWITCH_CARD      = 0x3024    --广播提示用户选牌操作
P.SVR_SANGONG_SWITCH_CARD                = 0x201A    -- 返回选牌结果
P.SVR_SANGONG_BROADCAST_SWITCH_RESULT    = 0x3025    -- 广播其他用户选牌结果



P.CONFIG = {
    --[[
        客户端包，对于空包体，可以永许不定义协议内容，将默认版本号为1， 包体长度为0
    ]]
    [P.CLISVR_HEART_BEAT] = {
        ver = 1,
        fmt = {
            {name="random",type=T.ARRAY,lengthType=T.BYTE,
               fmt = {
                   {name="value",type=T.INT},
               },
            }
        }
    },
    [P.CLI_COMMON_BROADCAST] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="msg",type=T.STRING},
        }
    },
    [P.CLI_UPDATE_USERINFO] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="userinfo",type=T.STRING},
        }
    },
    -- 骰子协议
    [P.CLI_DICE_LOGIN] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="token", type=T.STRING},
            {name="version", type=T.STRING},
            {name="channel", type=T.STRING},
            {name="deviceId", type=T.SHORT}
        }
    },
    [P.CLI_DICE_GET_TABLEID] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="gameId", type=T.INT},
            {name="level", type=T.INT}
        }
    },
    [P.CLI_DICE_LOGIN_ROOM] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="gameId", type=T.INT},
            {name="tid", type=T.INT},
            {name="userinfo", type=T.STRING}
        }
    },
    [P.CLI_DICE_EXIT_ROOM] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT}
        }
    },
    [P.CLI_DICE_SEND_CHAT] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="chatInfo", type=T.STRING}
        }
    },
    [P.CLI_DICE_SEND_FACE] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="info", type=T.STRING}
        }
    },
    [P.CLI_DICE_BET] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="type", type=T.INT},
            {name="param", type=T.INT},
            {name="money", type=T.LONG}
        }
    },
    [P.CLI_DICE_SITDOWN] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="seatId", type=T.INT}
        }
    },
    [P.CLI_DICE_SEND_PRO] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="duid", type=T.INT},
            {name="id", type=T.INT},
            {name="money", type=T.LONG}
        }
    },
    [P.CLI_DICE_DEALER_FEE] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="money", type=T.LONG}
        }
    },

    
    [P.CLI_DICE_FOLLOW] = {
        ver = 1,
        fmt = {
            {name="followId", type=T.INT},
            {name="key", type=T.STRING},
            {name="info", type=T.STRING},
            {name="followNick", type=T.STRING}
        }
    },
    [P.CLI_DICE_STANDUP] = {
        ver = 1,
        fmt = {
        }
    },
    [P.CLI_DICE_REBET] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT}
        }
    },
    [P.CLI_DICE_ADD_FRIEND] = {
        ver = 1,
        fmt = {
            {name="sendUid", type=T.INT},
            {name="toUid", type=T.INT},
        }
    },
}

P.SERVER_CONFIG = {
    [P.SVR_COMMON_BROADCAST] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="msg",type=T.STRING},
        }
    },
    [P.SVR_LAND_FALL] = {
        ver = 1,
        fmt = {

        }
    },

    [P.SVR_DICE_LOGIN] = {
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
    [P.SVR_DICE_GET_TABLE] = {
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
    [P.SVR_DICE_LOGIN_ROOM] = {
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
    [P.SVR_DICE_EXIT_ROOM] = {
        ver = 1,
        fmt = {
            {name="ret",type=T.BYTE},
            {name="money", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end}
        }
    },
    [P.SVR_DICE_SEND_CHAT] = {
        ver = 1, 
        fmt = {
            {name="uid",type=T.INT},
            {name="message", type=T.STRING}
        }
    },
    [P.SVR_DICE_DEND_FACE] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="info", type=T.STRING},
        }
    },
    [P.SVR_DICE_START] = {
        ver = 1,
        fmt = {
        }
    },
    [P.SVR_DICE_GAME_END] = {
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
    [P.SVR_DICE_START_BET] = {
        ver = 1,
        fmt = {
            {name="time", type=T.INT}
        }
    },
    [P.SVR_DICE_SIT_UP] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE},
            {name="seatId", type=T.INT},
            {name="type", type=T.INT},
            {name="money",type=T.LONG},
        }
    },
    [P.SVR_DICE_BET] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE},
            {name="type", type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="param", type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="money", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end},
            {name="allmoney", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end}
        }
    },
    [P.SVR_DICE_BROADCAST_STANDUP] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="seatId", type=T.INT}
        }
    },
    [P.SVR_DICE_SIT_DOWN] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE},
            {name="seatId", type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="money", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end}
        }
    },
    [P.SVR_DICE_BROADCAST_DOWN] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="seatId", type=T.INT},
            {name="money", type=T.LONG},
            {name="userinfo", type=T.STRING},
            {name="gameinfo", type=T.STRING}
        }
    },
    [P.SVR_HEART_BEAT] = {
        ver = 1,
        fmt = {
            {name="random", type=T.INT}
        }
    },
    [P.SVR_DICE_STOP] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.INT},
        }
    },
    [P.SVR_DICE_SEND_PRO] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE}
        }
    },
    [P.SVR_DICE_PROP] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="tuid", type=T.INT},
            {name="money", type=T.LONG},
            {name="id", type=T.INT}
        }
    },
    [P.SVR_DICE_OTHER_BET] = {
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
    [P.SVR_DICE_DEALER_FEE] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE},
            {name="uid", type=T.INT, depends = function(ctx) return ctx.ret == 0 end},
            {name="money", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end},
            {name="tips", type=T.LONG, depends = function(ctx) return ctx.ret == 0 end}
        }
    },
    [P.SVR_PHP_MESSAGE] = {
        ver = 1,
        fmt = {
            {name="msg", type=T.STRING},
            {name="phpType", type=T.INT}
        }
    },
    [P.SVR_DICE_OUT_ROOM] = {
        ver = 1,
        fmt = {
            {name="uid", type=T.INT},
            {name="seatId", type=T.INT}
        }
    },
    [P.SVR_REFRESH_MONEY] = {
        ver = 1,
        fmt = {
            {name="money", type=T.LONG},
            {name="gold", type=T.LONG},
            {name="safebox", type=T.LONG}
        }      
    },
    [P.SVR_REFRESH_MONEY_UID] = {
        ver = 1,
        fmt = {
             {name="uid", type=T.INT},
            {name="money", type=T.LONG},
            {name="gold", type=T.LONG},
            {name="safebox", type=T.LONG}
        }      
    },
    [P.SVR_DICE_REBET] = {
        ver = 1,
        fmt = {
            {name="ret", type=T.BYTE}
        }
    },

    [P.SVR_DICE_FOLLOW] = {
        ver = 1,
        fmt = {
            {name="code", type=T.INT}
        }
    },
    [P.SVR_DICE_FOLLOWED] = {
        ver = 1,
        fmt = {
            {name="code", type=T.INT},
            {name="uid", type=T.INT},
            {name="nick", type=T.STRING}
        }
    },
    [P.SVR_DICE_ADD_FRIEND] = {
        ver = 1,
        fmt = {
            {name="sendUid", type=T.INT},
            {name="toUid", type=T.INT},
        }
    },
}

return SocketProtocol