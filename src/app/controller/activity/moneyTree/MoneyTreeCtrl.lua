local MoneyTreeCtrl = class("MoneyTreeCtrl")

function MoneyTreeCtrl:ctor(viewObj)
	self.viewObj = viewObj
	self.httpIds = {}
	self:initialize()
end

function MoneyTreeCtrl:initialize()
end

function MoneyTreeCtrl:onHelpClick()
	self:showMoneyTreeInvitePopup()
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
    self:showMoneyTreeInvitePopup()
end

function MoneyTreeCtrl:showMoneyTreeInvitePopup()
	if self.viewObj then
        self.viewObj:showMoneyTreeInvitePopup()
    end
end

function MoneyTreeCtrl:requestBaseInfo(successCallback, failCallback, noLoading)
    if self.httpIds['baseInfo'] then return end
    local resetWrapHandler = handler(self, function ()
        self.httpIds['baseInfo'] = nil
    end)

    if not noLoading then
        g.myUi.miniLoading:show()
    end

    local param = {}
    param._interface = "/moneyTree/basicInfo"
    param.param = {}
    param.param.type = self.treeType
    param.param.gid = g.Const.GID
    
    self.httpIds['baseInfo'] = g.http:simplePost(param,
        successCallback, failCallback, resetWrapHandler)
end

function MoneyTreeCtrl:requestInviteCodeInfo(successCallback, failCallback, noLoading)
    if self.httpIds['inviteCodeInfo'] then return end
    local resetWrapHandler = handler(self, function ()
        self.httpIds['inviteCodeInfo'] = nil
    end)

    if not noLoading then
        g.myUi.miniLoading:show()
    end

    local param = {}
    param._interface = "/MoneyTree/inviteCodeInfo"
    param.param = {}
    param.param.type = self.treeType
    param.param.gid = g.Const.GID
    self.httpIds['inviteCodeInfo'] = g.http:simplePost(param,
        successCallback, failCallback, resetWrapHandler)
end

function MoneyTreeCtrl:XXXX()
    
end

function MoneyTreeCtrl:XXXX()
    
end

function MoneyTreeCtrl:XXXX()
    
end

function MoneyTreeCtrl:dispose()
    g.http:cancelBatch(self.httpIds)
end

return MoneyTreeCtrl
