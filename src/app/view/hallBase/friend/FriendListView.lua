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

function FriendListView:initialize()
    -- 搜索按钮
    g.myUi.ScaleButton.new({normal = g.Res.button2})
        :setButtonLabel(display.newTTFLabel({size = 24, text = g.lang:getText("FRIEND", "SEARCH")}))
        :onClick(nil)
        :pos(0, -20)
        :addTo(self)
end

return FriendListView
