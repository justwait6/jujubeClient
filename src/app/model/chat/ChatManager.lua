local ChatManager = class("ChatManager")

function ChatManager:ctor()
	self:initialize()
    self:addEventListeners()
end

function ChatManager:initialize()
    
end

function ChatManager:registerChatView(uid, view)
    self._chatViews = self._chatViews or {}
    self._chatViews[uid] = view
end

function ChatManager:addEventListeners()
    g.event:on(g.eventNames.CHAT_MSG, handler(self, self.onChatMsg), self)
end

function ChatManager.getInstance()
    if not ChatManager.singleInstance then
        ChatManager.singleInstance = ChatManager.new()
    end
    return ChatManager.singleInstance
end

function ChatManager:onChatMsg(data)
    data = data or {}

    for uid, view in pairs(self._chatViews) do
        if (uid == data.uid) and not tolua.isnull(view) then
            view:addChatItem(data)
        end
    end
end

function ChatManager:XXXX()
    
end

function ChatManager:XXXX()
    
end

function ChatManager:XXXX()
    
end

return ChatManager
