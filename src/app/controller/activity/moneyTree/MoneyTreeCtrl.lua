local MoneyTreeCtrl = class("MoneyTreeCtrl")

function MoneyTreeCtrl:ctor()
	self:initialize()
end

function MoneyTreeCtrl:initialize()
end

function MoneyTreeCtrl:onHelpClick()
	print("点击了帮助")
	-- self:showMoneyTreeInvitePopup()
end

function MoneyTreeCtrl:onInviteClick()
	print("点击了邀请")
	-- g.user:requestInvite("tree", handler(self, self.requestCallback))
end

function MoneyTreeCtrl:onWaterButtonClick()
    if self:getCurTreeShowUid() == tonumber(g.User:getUid()) then
        self:requestWaterMyTree(handler(self, self.onRequestWaterMyTreeSucc))
    else
        local params = {}
        params.uid = self:getCurTreeShowUid()
        self:requestWaterOtherTree(params, handler(self, function (self, data)
            self:onRequestWaterOtherTreeSucc(data, params.uid)
        end))
    end
end

function MoneyTreeCtrl:onInviteGuideButtonClick()
    print("点击了邀请")
    -- self:showMoneyTreeInvitePopup()
end

function MoneyTreeCtrl:XXXX()
	
end

function MoneyTreeCtrl:XXXX()
	
end

return MoneyTreeCtrl
