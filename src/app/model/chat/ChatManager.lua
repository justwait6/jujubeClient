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
    -- 确保消息是: 我发出的消息 OR 我收到的消息
    if data.srcUid ~= g.user:getUid() and data.destUid ~= g.user:getUid() then
        return
    end

    local targetUid = data.srcUid
    if targetUid == g.user:getUid() then
        targetUid = data.destUid
    end

    for uid, view in pairs(self._chatViews) do
        if targetUid == uid and not tolua.isnull(view) then
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
