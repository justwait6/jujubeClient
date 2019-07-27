local ChatStoreUtil = class("ChatStoreUtil")

function ChatStoreUtil:ctor()
	self:initialize()
    self:addEventListeners()
end

function ChatStoreUtil:initialize()
    
end

function ChatStoreUtil:addEventListeners()
    -- g.event:on(g.eventNames.XXXX, handler(self, self.XXXX), self)
end

function ChatStoreUtil:storeFriendChat(friendUid, data)
    data = data or {}

    local tableName = self:getFriendChatTableName(friendUid)

    -- test begin
    --[[
	if data.msg == '1' then
    	local t_search_sql = string.format([=[
			SELECT * FROM %s;
		]=], tableName);

		g.dbMgr:query(t_search_sql, 'search_' .. tableName, function (data)
			dump(data, 'query data')
		end)
    	return
    elseif data.msg == '2' then
    	g.dbMgr:dropTable(tableName);
    	return
    end
    --]]
    -- test end

    local function insert()
    	local changedMsg = self:replaceString(data.msg)
    	local t_insert_sql = string.format([=[
			INSERT INTO %s (ID, SRCUID, DESTUID, TIME, MSG) VALUES ( NULL, %d, %d, %d, '%s' );
		]=], tableName, data.srcUid, data.destUid, data.time, changedMsg);

    	print(t_insert_sql);
		g.dbMgr:executeSql(t_insert_sql, function (isOk)
			if isOk then print("insert success") end
		end)
    end

    g.dbMgr:isTableExist(tableName, function (isExist)
    	if not isExist then
    		print("table not exist, try creating: ", tableName)
    		self:createFriendChatTable(tableName, function (isOk)
    			if isOk then insert() end
    		end)
    	else
    		insert()
    	end
    end)
end

function ChatStoreUtil:createFriendChatTable(tableName, callback)
    local template = 
	[=[
		CREATE TABLE $tableName (
			ID INTEGER PRIMARY KEY AUTOINCREMENT,
			SRCUID INT NOT NULL,
			DESTUID INT NOT NULL,
			TIME INT NOT NULL,
			MSG TEXT
		);
	]=]

	t_friend_chat_sql = string.gsub(template, '$tableName', tableName)
	g.dbMgr:executeSql(t_friend_chat_sql, callback)
end

function ChatStoreUtil:fetchFriendChat(friendUid, callback)
	local tableName = self:getFriendChatTableName(friendUid)

	-- query (at most) last 20 messages
    local t_search_sql = string.format([=[
		SELECT * FROM (SELECT * FROM %s ORDER BY ID DESC LIMIT 20) AA ORDER BY ID
	]=], tableName);

	g.dbMgr:query(t_search_sql, 'search_' .. tableName, function (data)
		local retData = {}
		for _, v in pairs(data) do
			local changedMsg = self:unreplaceString(v[5]);			
			table.insert(retData, {
				srcUid = tonumber(v[2]),
				destUid = tonumber(v[3]),
				time = tonumber(v[4]),
				msg = changedMsg,
			})
		end
		if callback then callback(retData) end
	end)
end

function ChatStoreUtil:getFriendChatTableName(friendUid)
    return "ChatFriend" .. g.user:getUid() .. "_" .. friendUid .. "test"
end

function ChatStoreUtil:replaceString(msg)
    local changedMsg = string.gsub(msg, "\'", "&lquote;");
	changedMsg = string.gsub(changedMsg, "\"", "&quote;");
	changedMsg = string.gsub(changedMsg, '\\', "&\\\\;");

	return changedMsg
end

function ChatStoreUtil:unreplaceString(enmsg)
    local changedMsg = string.gsub(enmsg, "&lquote;", "\'");
	changedMsg = string.gsub(changedMsg, "&quote;", "\"");
	changedMsg = string.gsub(changedMsg, '&\\\\;', "\\");

	return changedMsg
end

function ChatStoreUtil:XXXX()
    
end

function ChatStoreUtil:XXXX()
    
end

function ChatStoreUtil:XXXX()
    
end

function ChatStoreUtil:XXXX()
    
end

return ChatStoreUtil
