local ChatOperateCtrl = class("ChatOperateCtrl")

function ChatOperateCtrl:ctor(viewObj)
    self.viewObj = viewObj
    self.httpIds = {}
    self:initialize()
end

function ChatOperateCtrl:initialize()
end

function ChatOperateCtrl:reqFriendList(successCallback, failCallback)
    local resetWrapHandler = handler(self, function ()
        self.httpIds['friendList'] = nil
    end)
    g.myUi.miniLoading:show()

    local reqParams = {}
    reqParams._interface    = '/friend/friendList'

    self.httpIds['friendList'] = g.http:simplePost(reqParams,
        successCallback, failCallback, resetWrapHandler)
end

function ChatOperateCtrl:bindChatUser(uid)
    self._chatUid = uid
end

function ChatOperateCtrl:sendChat(msg)
    local data = {srcUid = g.user:getUid(), destUid = self._chatUid, text = msg, time = os.time()}
    -- 发送给对方自己的消息
    g.mySocket:sendChat(data)

    -- 清空输入框
    if self.viewObj then
        self.viewObj:resetInput()
    end

    -- 显示我发送的消息
    g.event:emit(g.eventNames.CHAT_MSG, data)
end

function ChatOperateCtrl:XXXX()
    
end

function ChatOperateCtrl:XXXX()
    
end

function ChatOperateCtrl:XXXX()
    
end

function ChatOperateCtrl:dispose()
    g.http:cancelBatch(self.httpIds)
end

return ChatOperateCtrl
