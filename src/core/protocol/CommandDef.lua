local CommandDef = {}
local C = CommandDef

-- CLIENT
C.CLI_HEART_BEAT                        = 0x0200     --心跳
C.CLI_HALL_LOGIN                        = 0x0202    -- 登录大厅

-- SERVER
C.SVR_HEART_BEAT                        = 0x0201     --心跳返回
C.SVR_PUSH                        		= 0x0205    -- 服务器自定义推送

return CommandDef
