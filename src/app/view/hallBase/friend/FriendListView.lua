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
    -- test
    display.newScale9Sprite(g.Res.black, 0, 0, cc.size(LIST_WIDTH, LIST_HEIGHT))
        :pos(-250, 0)
        :addTo(self)
    self.friendListView = g.myUi.UIListView.new(LIST_WIDTH, LIST_HEIGHT)
        :pos(-250, 0)
        :addTo(self)

    self:onUpdate()
end

function FriendListView:onUpdate(friendsData)
    local friendsData = friendsData or {
        {
            gender = 0,
            iconUrl = '',
            nickname = 'xiao sh anonymous',
        }, 
        {
            gender = 1,
            iconUrl = '',
            nickname = 'jima mama',
        },
    }
    self.friendListView:removeAllItems()

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
        self.friendListView:addNode(node, LIST_WIDTH, itemHeight)
    end
end

function startChat(uid)
    -- body
end

return FriendListView
