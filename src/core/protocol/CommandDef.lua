local CommandDef = {}
local C = CommandDef

-- CLIENT
C.CLI_HEART_BEAT                        = 0x0200 --心跳
C.CLI_HALL_LOGIN                        = 0x0202 -- 登录大厅
C.CLI_SEND_CHAT							= 0x0300 -- 发送聊天

-- SERVER
C.SVR_HEART_BEAT                        = 0x0201 --心跳返回
C.SVR_PUSH                        		= 0x0205 -- 服务器自定义推送
C.SVR_FORWARD_CHAT						= 0x0301 -- 转发聊天

return CommandDef
