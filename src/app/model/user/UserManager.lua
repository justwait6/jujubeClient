local UserManager = class("UserManager")

UserManager.VIEW_DIR_PATH = "app.view.user"

function UserManager:ctor()
	self:initialize()
end

function UserManager:initialize()
    
end

function UserManager.getInstance()
    if not UserManager.singleInstance then
        UserManager.singleInstance = UserManager.new()
    end
    return UserManager.singleInstance
end

function UserManager:showUserInfoView(uid)
    require("app.view.user.UserInfoView").new(uid)
end

function UserManager:uploadUserinfo(updFields)
    self:requestModifyUserinfo({fields = updFields},
    	function (updatedData)
    		g.user:updateUserInfo(updatedData)
    		g.event:emit(g.eventNames.USER_INFO_UPDATE, updatedData)
    	end,
    	function ()
    		
    	end, true)
end

function UserManager:requestModifyUserinfo(params, successCallback, failCallback, noLoading)
	if self.httpModifyUserId then return end
    local resetWrapHandler = handler(self, function ()
        self.httpModifyUserId = nil
    end)

    if not noLoading then
        g.myUi.miniLoading:show()
    end

    local reqParams = {}
    reqParams._interface = "/users/modifyBaseInfo"
    reqParams.fields = params.fields or {}
    
    self.httpModifyUserId = g.http:simplePost(reqParams,
        successCallback, failCallback, resetWrapHandler)
end

function UserManager:XXXX()
    
end

return UserManager
