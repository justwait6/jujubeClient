local FriendManager = class("FriendManager")

function FriendManager:ctor()
	self.httpIds = {}
	self:initialize()
end

function FriendManager:initialize()
    
end

function FriendManager.getInstance()
    if not FriendManager.singleInstance then
        FriendManager.singleInstance = FriendManager.new()
    end
    return FriendManager.singleInstance
end

function FriendManager:storeFriendList(friendList)
    self.friendList = friendList
end

function FriendManager:getFriendInfo(uid)
	local info = {}
	if type(self.friendList) == "table" then
		for _, v in pairs(self.friendList) do
			if v.uid == uid then
				info = v
				break
			end
		end
	end
	return info
end

function FriendManager:updateFriendRemarkList(something)
	print("todo")
end

function FriendManager:requestModifyFriendsRemark(params, successCallback, failCallback, noLoading)
	if self.httpIds["modifyFriendsRemark"] then return end
    local resetWrapHandler = handler(self, function ()
        self.httpIds["modifyFriendsRemark"] = nil
    end)

    if not noLoading then
        g.myUi.miniLoading:show()
    end

    local reqParams = {}
	reqParams._interface = "/friend/modifyFriendRemark"
	reqParams.pairList = params.pairList
    
    self.httpIds["modifyFriendsRemark"] = g.http:simplePost(reqParams,
        successCallback, failCallback, resetWrapHandler)
end

function FriendManager:uploadFriendRemarkList(friendRemarkPairList)
	self:requestModifyFriendsRemark({pairList = friendRemarkPairList},
    	function (updatedData)
    		self:updateFriendRemarkList(updatedData)
    		g.event:emit(g.eventNames.FRIENDS_REMARKS_UPDATE, updatedData)
    	end,
    	function ()
    		g.myUi.topTip:showText(g.lang:getText("COMMON", "UPDATE_FAIL"))
    	end, true)
end

return FriendManager
