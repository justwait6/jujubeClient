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

return E
