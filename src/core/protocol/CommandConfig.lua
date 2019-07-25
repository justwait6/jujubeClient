local CommandConfig = {}

local C = import(".CommandDef")
local T = require("core.socket.PacketDataType")

CommandConfig.CLIENT = {
    --[[
        客户端包，对于空包体，可以永许不定义协议内容，将默认版本号为1， 包体长度为0
    ]]
    [C.CLI_HEART_BEAT] = {
        ver = 1,
        fmt = {
            {name = "uid", type = T.INT},
            {name = "random", type = T.ARRAY, lengthType = T.BYTE,
               fmt = {
                   {name = "value", type = T.INT},
               },
            }
        }
    },
    -- 骰子协议
    [C.CLI_HALL_LOGIN] = {
        ver = 1,
        fmt = {
            {name = "uid", type = T.INT},
            {name = "token", type = T.STRING},
            {name = "version", type = T.STRING},
            {name = "channel", type = T.STRING},
            {name = "deviceId", type = T.SHORT}
        }
    },
}

CommandConfig.SERVER = {
    [C.SVR_HEART_BEAT] = {
        ver = 1,
        fmt = {
            {name = "random", type = T.ARRAY, lengthType = T.BYTE,
               fmt = {
                   {name = "value", type = T.INT},
               },
            }
        }
    },
    [C.SVR_PUSH] = {
        ver = 1,
        fmt = {
            {name = "uid", type = T.INT},
            {name = "pushType", type = T.INT},
        }
    },
}

return CommandConfig
