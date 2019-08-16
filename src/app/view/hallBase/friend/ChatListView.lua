local ChatListView = class("ChatListView", function ()
  return display.newNode()
end)

local ChatScreenView = require("app.view.chat.ChatScreenView")
local ChatOperateView = require("app.view.chat.ChatOperateView")

local ChatListCtrl = require("app.controller.chat.ChatListCtrl")

local LIST_WIDTH = 350
local LIST_HEIGHT = 620
local itemHeight = 100

local Tag = {}
Tag.SEP_LINE = 1

function ChatListView:ctor(mainViewObj)
	self.mainViewObj = mainViewObj
	self:setNodeEventEnabled(true)
	self.ctrl = ChatListCtrl.new()
  self:initialize()
  self:addEventListeners()
end

function ChatListView:initialize()
  display.newScale9Sprite(g.Res.black, 0, 0, cc.size(LIST_WIDTH, LIST_HEIGHT + 16))
    :pos(-250, 0)
    :addTo(self)
  self._chatListView = g.myUi.UIListView.new(LIST_WIDTH, LIST_HEIGHT)
    :pos(-250, 0)
    :addTo(self)

	self._chatViews = {}
	self.friendSelLbls = {}
end

function ChatListView:addEventListeners()
  -- g.event:on(g.eventNames.XXXX, handler(self, self.XXXX), self)
end

function ChatListView:checkAndStickTop(uid)
	local selNodeIf = self._chatListView:getAddedNodeByTag(uid)

	-- 先删除(如果存在)再置顶(简单粗暴)
	if selNodeIf then
		self._chatListView:removeAddedNode(selNodeIf)
	end
	-- 如果原来存在第一个item, 要将该item的seprate line显示
	local beginNode = self._chatListView:getAddedBeginNode()
	if not tolua.isnull(beginNode) then beginNode:getChildByTag(Tag.SEP_LINE):show() end

	local data = self:getFriendInfo(uid) or {}
	self:_addItem(data, false, true) -- 新加item置顶

	-- 模拟点击
	self:onFriendItemClick(nil, g.myUi.TouchHelper.CLICK, uid)

end

function ChatListView:onUpdate(friendsData)
	friendsData = friendsData or {}
	self._chatListView:removeAllItems()

	if table.nums(friendsData) <= 0 then
		self:showNoFriendTips()
	else
		self:hideNoFriendTips()
	end

	for i, v in pairs(friendsData) do
		self:_addItem(v, listId ~= 1)
	end
end

function ChatListView:_addItem(v, isSepLine, isStickTop)
  	local friendItem = self:_newFriendItem(v, isSepLine)
			:pos(0, itemHeight/2)
			:setTag(v.uid)
		if not isStickTop then
			self._chatListView:addNode(friendItem, LIST_WIDTH, itemHeight, v.uid) -- third parameter is tag
		else
			self._chatListView:addNodeInBegin(friendItem, LIST_WIDTH, itemHeight, v.uid)
		end
end

function ChatListView:_newFriendItem(v, isSepLine)
	local node = display.newNode()

	local itemBg = display.newScale9Sprite(g.Res.blank, 0, 0, cc.size(LIST_WIDTH - 2, 94))
		:pos(LIST_WIDTH/2, 0):addTo(node)
	g.myUi.TouchHelper.new(itemBg, function (target, evt)
		self:onFriendItemClick(target, evt, v.uid)
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

	-- 备注(无备注则显示昵称)
	display.newTTFLabel({text = g.nameUtil:getLimitName(v.remark or v.nickname, 14), size = 28, color = cc.c3b(237, 226, 201)})
		:setAnchorPoint(cc.p(0, 0.5))
		:pos(120, 0)
		:addTo(node)
	
	self.friendSelLbls[v.uid] = display.newScale9Sprite(g.Res.moneytree_selected, 0, 0, cc.size(LIST_WIDTH + 2, 100))
		:pos(LIST_WIDTH/2, 0):addTo(node):hide()

	-- 横向分割线
	local line = cc.DrawNode:create()
	line:drawSegment(cc.p(10, 0), cc.p(LIST_WIDTH - 10, 0), 1, cc.c4f(0.8, 0.8, 0.8, 0.8))
	line:pos(0, itemHeight/2):addTo(node):setTag(Tag.SEP_LINE):hide()
	if isSepLine then
		line:show()
	end

	return node
end

function ChatListView:onFriendItemClick(target, evt, uid)
	if evt ~= g.myUi.TouchHelper.CLICK then return end

	self:changeSelectLbl(uid, self.lastSelectedUid)
	self:changeChatView(uid, self.lastSelectedUid)
	self:checkAndBindOprateView(uid)
	self.lastSelectedUid = uid
end

function ChatListView:changeSelectLbl(uid, lastUid)
	if lastUid then
		if self.friendSelLbls and not tolua.isnull(self.friendSelLbls[lastUid]) then
			self.friendSelLbls[lastUid]:hide()
		end
	end

	if self.friendSelLbls and not tolua.isnull(self.friendSelLbls[uid]) then
		self.friendSelLbls[uid]:show()
	end
end

function ChatListView:changeChatView(uid, lastUid)
	-- 若当前uid对应的chatView没有创建, 重新创建并初始化
	if not self._chatViews[uid] then
		local chatView = ChatScreenView.new():pos(220, 50):addTo(self)
		self._chatViews[uid] = chatView
		if self.ctrl then
			self.ctrl:asyncFetchChatData(uid, function(data) chatView:onUpdate(data) end)
		end
	end

	if lastUid then
		if self._chatViews and not tolua.isnull(self._chatViews[lastUid]) then
			self._chatViews[lastUid]:hide()
		end
	end

	if self._chatViews and not tolua.isnull(self._chatViews[uid]) then
		self._chatViews[uid]:show()
	end
end

function ChatListView:checkAndBindOprateView(uid)
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

function ChatListView:getFriendInfo(...)
	if self.mainViewObj then
		return self.mainViewObj:getFriendInfo(...)
	end
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
