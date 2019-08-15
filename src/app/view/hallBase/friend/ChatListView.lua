local ChatListView = class("ChatListView", function ()
    return display.newNode()
end)

local ChatScreenView = require("app.view.chat.ChatScreenView")
local ChatOperateView = require("app.view.chat.ChatOperateView")
local chatMgr = require("app.model.chat.ChatManager").getInstance()

function ChatListView:ctor()    
    self:setNodeEventEnabled(true)
    self:initialize()
    self:addEventListeners()
end

function ChatListView:setCtrl(ctrl, createIfNull)
    self.ctrl = ctrl
    if ctrl == nil and createIfNull then
        self.ctrl = MoneyTreeCtrl.new()
    end
end

local LIST_WIDTH = 350
local LIST_HEIGHT = 620
function ChatListView:initialize()
    display.newScale9Sprite(g.Res.black, 0, 0, cc.size(LIST_WIDTH, LIST_HEIGHT + 16))
        :pos(-250, 0)
        :addTo(self)
    self._ChatListView = g.myUi.UIListView.new(LIST_WIDTH, LIST_HEIGHT)
        :pos(-250, 0)
        :addTo(self)

    self._chatViews = {}
end

function ChatListView:addEventListeners()
    -- g.event:on(g.eventNames.XXXX, handler(self, self.XXXX), self)
end

function ChatListView:onUpdate(friendsData)
    friendsData = friendsData or {}
    self._ChatListView:removeAllItems()

    if table.nums(friendsData) <= 0 then
        self:showNoFriendTips()
    else
        self:hideNoFriendTips()
    end
    self.friendSelLbls = {}

    local itemHeight = 100
    for i, v in pairs(friendsData) do
        local friendItem = self:newFriendItem(v, i)
        self.friendSelLbls[i] = display.newScale9Sprite(g.Res.moneytree_selected, 0, 0, cc.size(LIST_WIDTH + 2, 100))
            :pos(LIST_WIDTH/2, 0):addTo(friendItem):hide()

        -- 横向分割线
        if i ~= 1 then
            local line = cc.DrawNode:create()
            line:drawSegment(cc.p(10, 0), cc.p(LIST_WIDTH - 10, 0), 1, cc.c4f(0.8, 0.8, 0.8, 0.8))
            line:pos(0, itemHeight/2):addTo(friendItem)
        end

        friendItem:pos(0, itemHeight/2)
        self._ChatListView:addNode(friendItem, LIST_WIDTH, itemHeight)
    end
end

function ChatListView:newFriendItem(v, listId)
    local node = display.newNode()

    local itemBg = display.newScale9Sprite(g.Res.blank, 0, 0, cc.size(LIST_WIDTH - 2, 94))
        :pos(LIST_WIDTH/2, 0):addTo(node)
    g.myUi.TouchHelper.new(itemBg, function (target, evt)
        self:onFriendItemClick(target, evt, listId, v.uid)
    end)
        :enableTouch()
        :setTouchSwallowEnabled(false)
        :setMoveNoResponse(true)

    g.myUi.AvatarView.new({
        radius = 46,
        gender = v.gender,
        frameRes = g.Res.common_headFrame,
        avatarUrl = v.iconUrl,
        clickCallback = handler(self, function () self:showOtherUserinfo(uid) end)
    })
        :addTo(node)
        :pos(50, 0)
        :setFrameScale(0.59)

    display.newTTFLabel({text = g.nameUtil:getLimitName(v.nickname, 14), size = 28, color = cc.c3b(237, 226, 201)})
        :setAnchorPoint(cc.p(0, 0.5))
        :pos(120, 0)
        :addTo(node)

    return node
end

function ChatListView:onFriendItemClick(target, evt, id, uid)
    if evt ~= g.myUi.TouchHelper.CLICK then return end
    if self.lastItemSelected then
        if self.friendSelLbls and self.friendSelLbls[self.lastItemSelected] then
            self.friendSelLbls[self.lastItemSelected]:hide()
        end
    end
    if self.friendSelLbls and self.friendSelLbls[id] then
        self.friendSelLbls[id]:show()
    end
    self.lastItemSelected = id

    self:showUserChatView(uid)
end

function ChatListView:showUserChatView(uid)
    if self.lastChatSelected then
        if self._chatViews and self._chatViews[self.lastChatSelected] then
            self._chatViews[self.lastChatSelected]:hide()
        end
    end
    if self._chatViews and self._chatViews[uid] then
        self._chatViews[uid]:show()
    end
    self.lastChatSelected = uid

    if not self._chatViews[uid] then
        self._chatViews[uid] = ChatScreenView.new():pos(220, 50):addTo(self)
        chatMgr:initChatView(uid, self._chatViews[uid])
    end

    if not self._chatOpView then
        self._chatOpView = ChatOperateView.new():pos(220, -270):addTo(self)
    end
    self._chatOpView:bindChatUser(uid)
end

function ChatListView:showNoFriendTips()
    if not self._noFriendTips then
        self._noFriendTips = display.newTTFLabel({text = g.lang:getText("FRIEND", "NO_FRIEND_TIPS"), size = 26, color = cc.c3b(137, 190, 224)})
            :pos(-250, 0)
            :addTo(self)
            :hide()
    end
    self._noFriendTips:show()
end

function ChatListView:hideNoFriendTips()
    if self._noFriendTips then
        self._noFriendTips:hide()
    end
end

function ChatListView:showOtherUserinfo(uid)
    print("待完成")
end

function ChatListView:onCleanUp(uid)
    g.event:removeByTag(self)
end

return ChatListView