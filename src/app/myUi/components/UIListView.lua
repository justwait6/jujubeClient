local UIListView = class("UIListView", function()
    return display.newNode()
end)

function UIListView:ctor(width, height)

    self.width = width
    -- create listview, or get listview from csb
    self.lv = ccui.ListView:create()
    self.lv:setContentSize(cc.size(width, height))
    -- self.lv:center():addTo(self)
    self.lv:addTo(self)
    -- self.lv:setBackGroundColorType(1)
    self.lv:setBackGroundColorType(0)
    self.lv:setBackGroundColor(cc.c3b(0, 0, 0))
    self.lv:setAnchorPoint(cc.p(0.5, 0.5))
    self.lv:setItemsMargin(0)
end

function UIListView:addScrollViewEventListener(callback)
    self.lv:addScrollViewEventListener(function(ref, type)
            if callback and type == 1 then
                callback()
            end
        end)
end

function UIListView:getItems()
	return self.lv:getItems()
end

function UIListView:removeAllItems()
	self.lv:removeAllItems()
end

function UIListView:addNode(node, width, height)
	local layer = ccui.Layout:create()
    node:addTo(layer)
    layer:setContentSize(cc.size(width, height))
	self.lv:pushBackCustomItem(layer)
end

function UIListView:addNodeInBegin(node, width, height)
    local layer = ccui.Layout:create()
    node:addTo(layer)
    layer:setContentSize(cc.size(width, height))
    self.lv:insertDefaultItem(layer)
end

function UIListView:setInnerSize(width, height)
	self.lv:setInnerContainerSize(cc.size(width, height))
end

function UIListView:getInnerSize()
    return self.lv:getInnerContainerSize()
end

function UIListView:requestRefreshView()
    self.lv:requestRefreshView()
end

function UIListView:refreshView()
    self.lv:refreshView()
end

function UIListView:jumpToBottom()
    self.lv:jumpToBottom()
end

function UIListView:scrollToBottom(time, attenuated)
    self.lv:scrollToBottom(time or 0.01, attenuated or false)
end

return UIListView
