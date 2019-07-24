local FriendListView = class("FriendListView", function ()
    return display.newNode()
end)

function FriendListView:ctor()    
    self:initialize()
end

function FriendListView:setCtrl(ctrl, createIfNull)
    self.ctrl = ctrl
    if ctrl == nil and createIfNull then
        self.ctrl = MoneyTreeCtrl.new()
    end
end

local LIST_WIDTH = 350
local LIST_HEIGHT = 620
function FriendListView:initialize()
    display.newScale9Sprite(g.Res.black, 0, 0, cc.size(LIST_WIDTH, LIST_HEIGHT + 16))
        :pos(-250, 0)
        :addTo(self)
    self._friendListView = g.myUi.UIListView.new(LIST_WIDTH, LIST_HEIGHT)
        :pos(-250, 0)
        :addTo(self)
end

function FriendListView:onUpdate(friendsData)
    friendsData = friendsData or {}
    self._friendListView:removeAllItems()

    if table.nums(friendsData) <= 0 then
        self:showNoFriendTips()
    else
        self:hideNoFriendTips()
    end

    local itemHeight = 100
    for k, v in pairs(friendsData) do
        local node = display.newNode()
        g.myUi.AvatarView.new({
            radius = 46,
            gender = v.gender,
            frameRes = g.Res.common_headFrame,
            avatarUrl = v.iconUrl,
            clickCallback = handler(self, function ()
                self:startChat(uid)
            end)
        })
            :addTo(node)
            :pos(50, 0)
            :setFrameScale(0.59)

        display.newTTFLabel({text = g.nameUtil:getLimitName(v.nickname, 14), size = 28, color = cc.c3b(237, 226, 201)})
            :setAnchorPoint(cc.p(0, 0.5))
            :pos(120, 0)
            :addTo(node)

        -- 横向分割线
        if k ~= 1 then
            local line = cc.DrawNode:create()
            line:drawSegment(cc.p(10, 0), cc.p(LIST_WIDTH - 10, 0), 1, cc.c4f(0.8, 0.8, 0.8, 0.8))
            line:pos(0, itemHeight/2):addTo(node)
        end

        node:pos(0, itemHeight/2)
        self._friendListView:addNode(node, LIST_WIDTH, itemHeight)
    end
end

function FriendListView:showNoFriendTips()
    if not self._noFriendTips then
        self._noFriendTips = display.newTTFLabel({text = g.lang:getText("FRIEND", "NO_FRIEND_TIPS"), size = 26, color = cc.c3b(137, 190, 224)})
            :pos(-250, 0)
            :addTo(self)
            :hide()
    end
    self._noFriendTips:show()
end

function FriendListView:hideNoFriendTips()
    if self._noFriendTips then
        self._noFriendTips:hide()
    end
end

return FriendListView
