local FriendCtrl = class("FriendCtrl")

function FriendCtrl:ctor()
	self.httpIds = {}
	self:initialize()
end

function FriendCtrl:initialize()
end

function FriendCtrl:reqFriendList(successCallback, failCallback)
	local resetWrapHandler = handler(self, function ()
        self.httpIds['friendList'] = nil
    end)
	g.myUi.miniLoading:show()

	local reqParams = {}
	reqParams._interface 	= '/friend/friendList'

	self.httpIds['friendList'] = g.http:simplePost(reqParams,
        successCallback, failCallback, resetWrapHandler)
end

function FriendCtrl:reqReqAddList(successCallback, failCallback)
	local resetWrapHandler = handler(self, function ()
        self.httpIds['reqAddList'] = nil
    end)
	g.myUi.miniLoading:show()

	local reqParams = {}
	reqParams._interface 	= '/friend/reqAddList'

	self.httpIds['reqAddList'] = g.http:simplePost(reqParams,
        successCallback, failCallback, resetWrapHandler)
end

function FriendCtrl:reqSendFriendRequest(params, successCallback, failCallback)
	params = params or {}
	local resetWrapHandler = handler(self, function ()
        self.httpIds['friendAdd'] = nil
    end)
	g.myUi.miniLoading:show()

	local reqParams = {}
	reqParams._interface 	= '/friend/reqAdd'
	reqParams.friendUid 	= params.friendUid

	self.httpIds['friendAdd'] = g.http:simplePost(reqParams,
        successCallback, failCallback, resetWrapHandler)
end

function FriendCtrl:reqAcceptFriend(params, successCallback, failCallback)
	params = params or {}
	local resetWrapHandler = handler(self, function ()
        self.httpIds['acceptFriend'] = nil
    end)
    g.myUi.miniLoading:show()

    local reqParams = {}
    reqParams._interface 	= '/friend/accpetFriend'
    reqParams.requestUid 	= params.requestUid

    self.httpIds['acceptFriend'] = g.http:simplePost(reqParams,
        successCallback, failCallback, resetWrapHandler)
end

function FriendCtrl:reqDeleteFriend(friendUid, successCallback, failCallback)
	params = params or {}
	local resetWrapHandler = handler(self, function ()
        self.httpIds['friendDelete'] = nil
    end)
	g.myUi.miniLoading:show()

	local reqParams = {}
	reqParams._interface 	= '/friend/deleteOne'
	reqParams.friendUid 	= params.friendUid

	self.httpIds['friendDelete'] = g.http:simplePost(reqParams,
        successCallback, failCallback, resetWrapHandler)
end

function FriendCtrl:XXXX()
	
end

function FriendCtrl:XXXX()
	
end

function FriendCtrl:dispose()
	g.http:cancelBatch(self.httpIds)
end

return FriendCtrl
