local FriendCtrl = class("FriendCtrl")

function FriendCtrl:ctor()
	self:initialize()
end

function FriendCtrl:initialize()
end

function FriendCtrl:requestUserinfo(params, successCallback, failCallback, noLoading)
    if self.httpSearchUserId then return end
    local resetWrapHandler = handler(self, function ()
        self.httpSearchUserId = nil
    end)

    if not noLoading then
        g.myUi.miniLoading:show()
    end

    local reqParams = {}
    reqParams._interface = "/users/userinfo"
    reqParams.name = params.name
    reqParams.fields = params.fields or {'name'}
    
    self.httpSearchUserId = g.http:simplePost(reqParams,
        successCallback, failCallback, resetWrapHandler)
end

function FriendCtrl:cancelRequestUserinfo()
    g.http:cancel(self.httpSearchUserId)
    self.httpSearchUserId = nil
end

function FriendCtrl:XXXX()
	
end

function FriendCtrl:XXXX()
	
end

function FriendCtrl:XXXX()
	
end

return FriendCtrl
