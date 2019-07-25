local FriendView = class("FriendView", g.myUi.Window)

local FriendSearchView = import(".FriendSearchView")
local FriendListView = import(".FriendListView")
local FriendAddView = import(".FriendAddView")

local FriendCtrl = require("app.controller.hallBase.friend.FriendCtrl")
local UserCtrl = require("app.controller.user.UserCtrl")

FriendView.WIDTH = 1035
FriendView.HEIGHT = 643

local Tab = {}
Tab.LIST = 1
Tab.SEARCH = 2
Tab.ADD = 3

function FriendView:ctor()    
    self.ctrl = FriendCtrl.new()
    self.userCtrl = UserCtrl.new()
    FriendView.super.ctor(self, {width = self.WIDTH, height = self.HEIGHT, monoBg = true, bgColor = cc.c3b(40, 41, 35), isCoverClose = false})
    self:initialize()
end

function FriendView:onShow()
    if self.ctrl then
        self.ctrl:reqFriendList(handler(self, self.onFriendListSucc), handler(self, self.onFriendListFail))
        self.ctrl:reqReqAddList(handler(self, self.onReqAddListSucc))
    end
end

function FriendView:initialize()
    -- 纵向分割线
    local line = cc.DrawNode:create()
    line:drawSegment(cc.p(0, 316), cc.p(0, -316), 2, cc.c4f(0.8, 0.8, 0.8, 0.8))
    line:pos(-430, 0):addTo(self)

    -- 关闭按钮
    g.myUi.ScaleButton.new({normal = g.Res.common_back, scale = 0.8})
        :onClick(handler(self, self.close))
        :pos(-476, 266)
        :addTo(self)

    -- 侧边栏好友按钮
    g.myUi.ScaleButton.new({normal = g.Res.common_friendIcon, scale = 0.8})
        :onClick(handler(self, function () self:onTab(self.views[Tab.LIST]) end))
        :pos(-476, 180)
        :addTo(self)

    -- 侧边栏搜索好友按钮
    g.myUi.ScaleButton.new({normal = g.Res.common_searchIcon, scale = 0.8})
        :onClick(handler(self, function () self:onTab(self.views[Tab.SEARCH]) end))
        :pos(-476, 94)
        :addTo(self)

    -- 侧边栏添加好友按钮
    g.myUi.ScaleButton.new({normal = g.Res.common_friendAddIcon, scale = 0.8})
        :onClick(handler(self, function () self:onTab(self.views[Tab.ADD]) end))
        :pos(-476, 8)
        :addTo(self)

    self.views = {}
    self.views[Tab.LIST] = FriendListView.new(self):addTo(self):hide()
    self.views[Tab.SEARCH] = FriendSearchView.new(self):addTo(self):hide()
    self.views[Tab.ADD] = FriendAddView.new(self):addTo(self):hide()
    self:onTab(self.views[Tab.LIST])
end

function FriendView:onTab(view)
    if self._curView == view then return end
    if self._curView then
        self._curView:hide()
    end
    view:show()
    self._curView = view
end

function FriendView:reqUserinfo(...)
    if self.userCtrl then
        self.userCtrl:reqUserinfo(...)
    end
end

function FriendView:reqAcceptFriend(...)
    if self.ctrl then
        self.ctrl:reqAcceptFriend(...)
    end
end

function FriendView:onFriendListSucc(data)
    data = data or {}
    if self.views[Tab.LIST] then
        self.views[Tab.LIST]:onUpdate(data.friendList)
    end
end

function FriendView:onFriendListFail()
    g.myUi.topTip:showText(g.lang:getText("FRIEND", "GET_FRIEND_LIST_FAIL"))
end

function FriendView:onReqAddListSucc(data)
    data = data or {}
    if self.views[Tab.ADD] then
        self.views[Tab.ADD]:onUpdate(data.reqAddList)
    end
end

function FriendView:onAddFriendClick(friendUid)
    if self.ctrl then
        self.ctrl:reqSendFriendRequest({friendUid = friendUid}, 
            handler(self, self.onSendFriendRequestSucc),
            handler(self, self.onSendFriendRequestFail))
    end
end

function FriendView:onSendFriendRequestSucc()
    g.myUi.topTip:showText(g.lang:getText("FRIEND", "REQ_SEND_SUCC"))
end

function FriendView:onSendFriendRequestFail(data)
    if type(data) == "table" and data.ret == -100 then
        g.myUi.topTip:showText(g.lang:getText("FRIEND", "CAN_NOT_ADD_SELF"))
    else
        g.myUi.topTip:showText(g.lang:getText("FRIEND", "REQ_SEND_FAIL"))
    end
end

function FriendView:XXXX()
end

function FriendView:XXXX()
end

function FriendView:onWindowRemove()
    if self.userCtrl then
        self.userCtrl:dispose()
    end
    if self.ctrl then
        self.ctrl:dispose()
    end
end

return FriendView
