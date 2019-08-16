local FriendManager = class("FriendManager")

function FriendManager:ctor()
	self.httpIds = {}
	self.friendList = {}
	self.friendUidIdxMap = {}
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

function FriendManager:resetFriendList()
	self.friendList = {}
	self.friendUidIdxMap = {}
end

function FriendManager:storeFriendList(friendList)
		self:resetFriendList()
		self.friendList = friendList

		for idx, frindInfo in pairs(friendList) do
			self.friendUidIdxMap[frindInfo.uid] = idx
		end
end

function FriendManager:asyncGetFriendInfo(uid, callback)
	-- 在内存中查找
	local infoInMeMIf = nil
	if self.friendUidIdxMap[uid] then
		infoInMeMIf = self.friendList[self.friendUidIdxMap[uid]]
	end

	-- 若内存中有, 返回
	if infoInMeMIf then
		if callback then callback(infoInMeMIf) end
		return
	end

	-- 在数据库中查找, 若有, 返回

end

function FriendManager:asyncGetFriendInfoBatch(uids, callback)
	-- 在内存中查找
	local infoListInMeMIf = {}
	for _, uid in pairs(uids) do
		if self.friendUidIdxMap[uid] then
			table.insert(infoListInMeMIf, self.friendList[self.friendUidIdxMap[uid]])
		end
	end

	-- 若内存中有, 返回
	if table.nums(infoListInMeMIf) > 0 then
		if callback then callback(infoListInMeMIf) end
		return
	end

	-- 在数据库中查找, 若有, 返回

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
