local ChatManager = class("ChatManager")

local _store = import(".ChatStoreUtil")

function ChatManager:ctor()
	self:initialize()
    self:addEventListeners()
end

function ChatManager:initialize()
    
end

function ChatManager:initChatView(uid, view)
    self._chatViews = self._chatViews or {}
    self._chatViews[uid] = view

    self:fetchFriendChat(uid, function (data)
        view:onUpdate(data)
    end)
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

    local friendUid = data.srcUid
    if friendUid == g.user:getUid() then
        friendUid = data.destUid
    end

    -- 存入数据库
    self:storeFriendChat(friendUid, data)

    for uid, view in pairs(self._chatViews) do
        if friendUid == uid and not tolua.isnull(view) then
            view:addChatItem(data)
        end
    end
end

function ChatManager:storeFriendChat(friendUid, data)
    _store:storeFriendChat(friendUid, data)
end

function ChatManager:fetchFriendChat(friendUid, callback)
    _store:fetchFriendChat(friendUid, callback)
end

function ChatManager:XXXX()
    
end

function ChatManager:XXXX()
    
end

return ChatManager
