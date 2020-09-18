local CommandDef = {}
local C = CommandDef

-- CLIENT
C.CLI_HEART_BEAT                        = 0x0200 --心跳
C.CLI_HALL_LOGIN                        = 0x0202 -- 登录大厅
C.CLI_SEND_CHAT                         = 0x0300 -- 发送聊天
C.CLI_FORWARD_CHAT                      = 0x0302 -- 转发聊天(占位, 未使用)
C.CLI_GET_TABLE                         = 0x0400 -- 获取桌子信息
C.CLI_ENTER_ROOM                        = 0x0402 -- 登录房间

-- SERVER
C.SVR_HEART_BEAT                        = 0x0201 --心跳返回
C.SVR_PUSH                              = 0x0205 -- 服务器自定义推送
C.SVR_SEND_CHAT_RESP                    = 0x0301 -- 聊天返回
C.SVR_FORWARD_CHAT                      = 0x0303 -- 转发聊天
C.SVR_GET_TABLE                         = 0x0401 -- 返回桌子信息
C.SVR_ENTER_ROOM                        = 0x0403 -- 返回登录房间信息

return CommandDef
