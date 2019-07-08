local Window = class("Window", function ()
	return display.newNode()
end)

local DefaulPanel = import(".DefaulPanel")

function Window:ctor(params)
	self:pos(display.cx, display.cy)
	self.panel = DefaulPanel.new(params):addTo(self)

	local isModal = params.isModal or false
	local isCoverClose = params.isCoverClose or false
	if isModal then
		-- 模态框点击背景透明遮罩区域不会关闭
		isCoverClose = false
	end
	local noShowAnim = false
	g.windowMgr:addWindow(self, isModal, isCoverClose, noShowAnim)
end

function Window:close()
	g.windowMgr:removeWindow(self)
	-- self:hide()
end

return Window
