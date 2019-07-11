local FriendSearchView = class("FriendSearchView", function ()
    return display.newNode()
end)

function FriendSearchView:ctor(mainViewObj)    
    self.mainViewObj = mainViewObj
    self:initialize()
end

function FriendSearchView:setCtrl(ctrl, createIfNull)
    self.ctrl = ctrl
    if ctrl == nil and createIfNull then
        self.ctrl = MoneyTreeCtrl.new()
    end
end

function FriendSearchView:initialize()
    -- 搜索好友
    display.newTTFLabel({
            text = g.lang:getText("FRIEND", "SEARCH_FRIEND"), size = 28, color = cc.c3b(0, 128, 128)})
        :pos(0, 160)
        :addTo(self)

    -- 好友输入框
    self.nameEditBox = g.myUi.EditBox.new({
            image = g.Res.moneytreeinvite_codeBg,
            imageOffset = cc.p(94, 0),
            size = cc.size(180, 54),
            fontColor = cc.c3b(254, 255, 151),
            fontSize = 20,
            maxLength = 20,
            placeHolder = g.lang:getText("FRIEND", "NAME_TIPS"),
            holderColor = cc.c3b(64, 97, 179)
        })
        :pos(-94, 80)
        :addTo(self)

    -- 搜索按钮
    g.myUi.ScaleButton.new({normal = g.Res.button2})
        :setButtonLabel(display.newTTFLabel({size = 24, text = g.lang:getText("FRIEND", "SEARCH")}))
        :onClick(handler(self, self.onSearchClick))
        :pos(0, -22)
        :addTo(self)
end

function FriendSearchView:onSearchClick()
    if self.ctrl then
        local params = {}
        params.name = self.nameEditBox:getText()
        params.fields = {'nickname', 'gender', 'iconUrl'}
        self.ctrl:requestUserinfo(params, handler(self, self.onSearchOk))
    end
end

function FriendSearchView:onSearchOk(data)
    dump(data, "searched user data")
end

return FriendSearchView
