local ChatManager = class("ChatManager")

local _store = import(".ChatStoreUtil")

function ChatManager:ctor()
	self._cacheSentMsg = {}

	self:initialize()
  self:addEventListeners()
end

function ChatManager:initialize()
    
end

function ChatManager:addEventListeners()
	g.event:on(g.eventNames.SEND_CHAT_RESP, handler(self, self.onSentChatResp), self)
end

function ChatManager.getInstance()
	if not ChatManager.singleInstance then
		ChatManager.singleInstance = ChatManager.new()
	end
	return ChatManager.singleInstance
end

function ChatManager:onSentChatResp(data)
	data = data or {}
	if data.ret ~= 0 then
		-- something wrong
	end

	-- 根据keyId取出消息, 之后置为空
	local cachedMsg = self:getSentMessage(data.keyId)
	-- 已被取出, 直接返回
	if not cachedMsg then return end
	
	table.merge(data, clone(cachedMsg))
	self:clearSentMessage(data.keyId)
	dump(data, 'data')

	local friendUid = data.destUid

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

function ChatManager:asyncFetchChatData(friendUid, callback)
	_store:fetchFriendChat(friendUid, callback)
end

function ChatManager:getSentMessage(keyId)
	return self._cacheSentMsg[keyId]
end

function getKeyIdIndex()
	ChatManager.CHACHE_SENT_MSG_IDX = (ChatManager.CHACHE_SENT_MSG_IDX or 0) + 1
	return ChatManager.CHACHE_SENT_MSG_IDX
end 

function ChatManager:cacheSentMessage(data)
	data = data or {}
	data.keyId = getKeyIdIndex()
	self._cacheSentMsg[data.keyId] = data
	return data.keyId
end

function ChatManager:clearSentMessage(keyId)
	self._cacheSentMsg[keyId] = nil
end

function ChatManager:XXXX()
    
end

function ChatManager:XXXX()
    
end

function ChatManager:XXXX()
    
end

return ChatManager
