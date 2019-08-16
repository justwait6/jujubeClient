local ChatListCtrl = class("ChatListCtrl")

local chatMgr = require("app.model.chat.ChatManager").getInstance()

function ChatListCtrl:ctor()
    self:initialize()
end

function ChatListCtrl:initialize()
end

function ChatListCtrl:asyncFetchChatData(...)
    chatMgr:asyncFetchChatData(...)
end

function ChatListCtrl:XXXX()
    
end

function ChatListCtrl:XXXX()
    
end

function ChatListCtrl:dispose()
end

return ChatListCtrl
