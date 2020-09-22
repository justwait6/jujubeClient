local CommandDef = {}
local C = CommandDef

--[[
RULE:
Client始终发[偶数协议号], Server单播返回发[Client协议号 + 1]
单播协议[0x0XXX]格式, 广播协议[0x1XXX]格式
0x02XX, 单播, 大厅(房间外逻辑)
0x03XX, 单播, 房间, 功能逻辑(聊天, 表情, 打赏)
0x04XX, 单播, 房间, 玩法逻辑

0x04XX, 广播, 房间, 玩法逻辑
--]]

-- CLIENT
C.CLI_HEART_BEAT                        = 0x0200 -- 心跳
C.CLI_HALL_LOGIN                        = 0x0202 -- 登录大厅
C.CLI_SEND_CHAT                         = 0x0300 -- 发送聊天
C.CLI_FORWARD_CHAT                      = 0x0302 -- 转发聊天(占位, 未使用)
C.CLI_GET_TABLE                         = 0x0400 -- 获取桌子信息
C.CLI_ENTER_ROOM                        = 0x0402 -- 登录房间
C.CLI_EXIT_ROOM                         = 0x0404 -- 主动请求退出房间
C.CLI_REQ_SIT                           = 0x0406 -- 主动请求坐下

-- SERVER
C.SVR_HEART_BEAT                        = 0x0201 -- 心跳返回
C.SVR_PUSH                              = 0x0205 -- 服务器自定义推送
C.SVR_SEND_CHAT_RESP                    = 0x0301 -- 聊天返回
C.SVR_FORWARD_CHAT                      = 0x0303 -- 转发聊天
C.SVR_GET_TABLE                         = 0x0401 -- 返回桌子信息
C.SVR_ENTER_ROOM                        = 0x0403 -- 返回登录房间信息
C.SVR_EXIT_ROOM                         = 0x0405 -- 返回退出房间信息
C.SVR_CAST_EXIT_ROOM                    = 0x1405 -- 广播用户退出
C.SVR_REQ_SIT                           = 0x0407 -- 返回请求坐下信息
C.SVR_CAST_USER_SIT                     = 0x1407 -- 广播用户坐下

return CommandDef
