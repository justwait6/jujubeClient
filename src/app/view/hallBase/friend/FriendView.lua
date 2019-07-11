local FriendView = class("FriendView", g.myUi.Window)

local FriendCtrl = require("app.controller.hallBase.friend.FriendCtrl")

local FriendSearchView = import(".FriendSearchView")
local FriendListView = import(".FriendListView")


FriendView.WIDTH = 1035
FriendView.HEIGHT = 643

local Tab = {}
Tab.LIST = 1
Tab.SEARCH = 2

function FriendView:ctor()    
    FriendView.super.ctor(self, {width = self.WIDTH, height = self.HEIGHT, monoBg = true, bgColor = cc.c3b(40, 41, 35), isCoverClose = true})

    self:initialize()
    self.ctrl = FriendCtrl.new()
end

function FriendView:setCtrl(ctrl, createIfNull)
    self.ctrl = ctrl
    if ctrl == nil and createIfNull then
        self.ctrl = MoneyTreeCtrl.new()
    end
end

function FriendView:onShow()
    if self.ctrl then
    end
end

function FriendView:initialize()
    -- Close
    self:addClose(cc.p(482, 288))

    -- 纵向分割线
    local line = cc.DrawNode:create()
    line:drawSegment(cc.p(0, 316), cc.p(0, -316), 2, cc.c4f(0.8, 0.8, 0.8, 0.8))
    line:pos(-430, 0):addTo(self)

    -- 侧边栏好友按钮
    g.myUi.ScaleButton.new({normal = g.Res.common_friendIcon, scale = 0.8})
        :onClick(handler(self, function () self:onTab(Tab.LIST) end))
        :pos(-476, 266)
        :addTo(self)

    -- 侧边栏搜索好友按钮
    g.myUi.ScaleButton.new({normal = g.Res.common_searchIcon, scale = 0.8})
        :onClick(handler(self, function () self:onTab(Tab.SEARCH) end))
        :pos(-476, 180)
        :addTo(self)

    self.friendListView = FriendListView.new():addTo(self)
    self.searchView = FriendSearchView.new(self):addTo(self):hide()
end

function FriendView:onTab(tab)
    if tab == Tab.LIST then
        if self.friendListView then self.friendListView:show() end
        if self.searchView then self.searchView:hide() end
    elseif tab == Tab.SEARCH then
        if self.friendListView then self.friendListView:hide() end
        if self.searchView then self.searchView:show() end
    end
end


function FriendView:onSearchClick(userName, callback)
    
end


function FriendView:XXXX()
end


function FriendView:onWindowRemove()
    if self.ctrl then
        self.ctrl:cancelRequestUserinfo()
    end
end

return FriendView
