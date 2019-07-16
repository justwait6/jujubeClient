local CommandDef = {}
local C = CommandDef

-- COMMOM
C.CLISVR_HEART_BEAT                     = 0x0200     --心跳

-- 客户端请求
C.CLI_COMMON_BROADCAST                  = 0x2200     --客户端广播给其他客户端
C.CLI_UPDATE_USERINFO                   = 0x2201     --更新用户信息

-- 骰子协议
C.CLI_DICE_LOGIN                        = 0x0201    -- 登录大厅
C.CLI_DICE_GET_TABLEID                  = 0x0110    -- 请求分配桌子ID
C.CLI_DICE_LOGIN_ROOM                   = 0x2001    -- 进入房间
C.CLI_DICE_EXIT_ROOM                    = 0x2002    -- 登出房间
C.CLI_DICE_SEND_CHAT                    = 0x2003    -- 发送聊天
C.CLI_DICE_SEND_FACE                    = 0x2004    -- 发送表情
C.CLI_DICE_BET                          = 0x2012    -- 请求下注
C.CLI_DICE_SITDOWN                      = 0x2010    -- 请求坐下
C.CLI_DICE_SEND_PRO                     = 0x2014    -- 互动表情
C.CLI_DICE_DEALER_FEE                   = 0x2013    -- 荷官小费
C.CLI_DICE_REBET                        = 0x2015    -- 重复投
C.CLI_DICE_FOLLOW                       = 0x123     -- 跟踪玩家
C.CLI_DICE_STANDUP                      = 0x1033    -- 玩家站起
C.CLI_DICE_ADD_FRIEND                   = 0x2007    -- 加好友


-- 刷新金币
C.SVR_REFRESH_MONEY                     = 0x2100     --刷新money
C.SVR_REFRESH_MONEY_UID                 = 0x2101     --刷新钱
C.SVR_COMMON_BROADCAST                  = 0x2200     --客户端广播给其他客户端
C.SVR_LAND_FALL                         = 0x10f      -- 异地登陆

-- 骰子协议
C.SVR_HEART_BEAT                        = 0x0200     --心跳
C.SVR_DICE_LOGIN                        = 0x0101    -- 登录成功
C.SVR_DICE_GET_TABLE                    = 0x0110    -- 分桌返回
C.SVR_DICE_LOGIN_ROOM                   = 0x2001    -- 进入房间返回
C.SVR_DICE_EXIT_ROOM                    = 0x2002    -- 退出房间
C.SVR_DICE_SEND_CHAT                    = 0x2003    -- 发送聊天
C.SVR_DICE_DEND_FACE                    = 0x2004    -- 发送表情
C.SVR_DICE_START                        = 0x4001    -- 开始比赛
C.SVR_DICE_GAME_END                     = 0x4004    -- 游戏结束
C.SVR_DICE_START_BET                    = 0x4005    -- 可以开始下注
C.SVR_DICE_SIT_UP                       = 0x2011    -- 玩家站起
C.SVR_DICE_BET                          = 0x2012    -- 下注
C.SVR_DICE_BROADCAST_STANDUP            = 0x4006    -- 广播站起
C.SVR_DICE_SIT_DOWN                     = 0x2010    -- 玩家入座
C.SVR_DICE_BROADCAST_DOWN               = 0x4002    -- 广播坐下
C.SVR_DICE_STOP                         = 0x200F    -- 服务器退休
C.SVR_DICE_SEND_PRO                     = 0x2014    -- 互动表情
C.SVR_DICE_PROP                         = 0x4007    -- 发送道具
C.SVR_DICE_OTHER_BET                    = 0x4003    -- 其他用户下注
C.SVR_DICE_DEALER_FEE                   = 0x2013    -- 荷官小费
C.SVR_PHP_MESSAGE                       = 0x7001    -- php广播
C.SVR_DICE_OUT_ROOM                     = 0x200E    -- 用户退出房间
C.SVR_DICE_REBET                        = 0x2015    -- 重复投
C.SVR_DICE_FOLLOW                       = 0x214     -- 跟踪玩家
C.SVR_DICE_FOLLOWED                     = 0x215     -- 被跟踪玩家
C.SVR_DICE_LOGIN_ERROR                  = 0x1005    -- 登录失败
C.SVR_DICE_RELOGIN                      = 0x1009    -- 重登游戏
C.SVR_DICE_ADD_FRIEND                   = 0x2007    -- 加好友

return CommandDef
