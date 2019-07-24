local E = {}

E.index = 1
function E.getIndex()
	E.index = E.index + 1
	return E.index
end
function E.getName()
	return tostring(E.getIndex())
end

E.LOBBY_UPDATE = E.getName()
E.USER_INFO_UPDATE = E.getName()
E.SERVER_PUSH = E.getName()
E.PACKET_RECEIVED = E.getName()

E.FRIEND_REDDOT = E.getName()

return E
