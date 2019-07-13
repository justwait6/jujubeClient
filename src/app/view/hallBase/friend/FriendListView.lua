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

local LIST_WIDTH = 100
local LIST_HEIGHT = 200
function FriendListView:initialize()
    self.friendListView = g.myUi.UIListView.new(LIST_WIDTH, LIST_HEIGHT)
        :pos(0, 0)
        :addTo(self)

    -- self:onUpdate()
end

function FriendListView:onUpdate(friendsData)
    local friendsData = friendsData or {
        {
            gender = 0,
            iconUrl = '',
            nickname = 'xiao shan anonymous',
        }, 
        {
            gender = 1,
            iconUrl = '',
            nickname = 'da si nimama',
        }
    }
    self.friendListView:removeAllItems()

    for k, v in pairs(friendsData) do
        local node = display.newNode()
        g.myUi.AvatarView.new({
            radius = 52,
            gender = data.gender,
            frameRes = g.Res.common_headFrame,
            avatarUrl = data.icon,
            clickOptions = {default = true, uid = v.uid},
        })
            :addTo(self.userFoundNode)
            :pos(-170, 0)
            :setFrameScale(0.67)

        display.newTTFLabel({text = g.nameUtil:getLimitName(data.nickname, 14), size = 28, color = cc.c3b(237, 226, 201)})
            :setAnchorPoint(cc.p(0, 0.5))
            :pos(-70, 20)
            :addTo(self.userFoundNode)
    end
end

return FriendListView
