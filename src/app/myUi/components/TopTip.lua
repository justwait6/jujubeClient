-- Author: Jam
-- Date: 2015.04.09
--[[
    用法：
    1.纯文本：
    2.文本加图标：
]]

local TopTip = class("TopTip")

local scheduler = require(cc.PACKAGE_NAME..".scheduler")
local DEFAULT_STAY_TIME = 3
local Y_GAP = 0
local TIP_HEIGHT = 56
local LABEL_X_GAP = -10
local ICON_SIZE = 56
local LABEL_ROLL_VELOCITY = 80
local BG_CONTENT_SIZE = cc.size(display.width - 10 * 2, TIP_HEIGHT)
local Z_ORDER = 1001

local HIDE_Y = display.top + TIP_HEIGHT * 0.5
local SHOW_Y = display.top - Y_GAP - TIP_HEIGHT * 0.5
local PADDING_LEFT = 40
local MAX_SHOW_LABEL_WIDTH = BG_CONTENT_SIZE.width - 2 * PADDING_LEFT
local LABEL_LEFT_X = -MAX_SHOW_LABEL_WIDTH / 2

local MAX_STORAGE_TIPS = 10

function TopTip:ctor()
	self:checkCreateTopTip()
	-- 等待队列
	self.waitQueue_ = {}
end

function TopTip:checkCreateTopTip()
	local scene = display.getRunningScene()
	if not scene then return end
	if not self.container_ then
		self.container_ = self:createContainer()
			:pos(display.cx, HIDE_Y)
			:addTo(scene, 1001)

		display.newScale9Sprite(g.Res.common_topTipBg, 0, 0, BG_CONTENT_SIZE)
			:addTo(self.container_)

		local size = cc.size(MAX_SHOW_LABEL_WIDTH, BG_CONTENT_SIZE.height)
		local stencil = display.newScale9Sprite(g.Res.blank, 0, 0, size)
		-- local stencil = display.newScale9Sprite(g.Res.common_topTipBg, 0, 0, BG_CONTENT_SIZE)
		local clipNode = cc.ClippingNode:create():addTo(self.container_)
		clipNode:setStencil(stencil)
		clipNode:setAlphaThreshold(1)
		-- clipNode:setInverted(false)

		-- 文本
        self.label_ = display.newTTFLabel({size = 28}):addTo(clipNode)
	end
end

function TopTip:createContainer()
	-- 视图容器
	local node = display.newNode()
	node:setNodeEventEnabled(true)
	node.onCleanup = handler(self, function ()
		-- 移除图标
		if self.currentData_ then
			if self.currentData_.image and not tolua.isnull(self.currentData_.image) then
				self.currentData_.image:release()
            	g.myFunc:safeRemoveNode(self.currentData_.image)
        	end
		end
		-- 移除定时器
		if self.delayScheduleHandle_ then
			scheduler.unscheduleGlobal(self.delayScheduleHandle_)
			self.delayScheduleHandle_ = nil
		end
		print("TopTip container removed")
	end)

	return node
end

function TopTip:showTopTip(topTipData)
	assert(type(topTipData) == "table", "TopTipData should be a table!")

	-- 检查能否放入播放队列
	if self:canAddToPlayList(topTipData) then
		table.insert(self.waitQueue_, topTipData)
		-- 初次加入时对图像数据retain一次
		if topTipData.image and type(topTipData.image) == "userdata" then
			topTipData.image:retain()
		end
		-- 通知有新消息要播放
		self:checkPlayNext()
	end
end

function TopTip:canAddToPlayList(tipItem)
	-- 超过最大缓存限制限制, 丢弃
	if table.nums(self.waitQueue_) > MAX_STORAGE_TIPS then return false end

	-- 队列里已有该提示消息, 丢弃
	for _, v in pairs(self.waitQueue_) do
		if v.text == tipItem.text then
			return false
		end
	end

	return true
end

function TopTip:checkPlayNext(onPrint)
	if not noPrint then
		print("self.isPlaying_", self.isPlaying_)
		print("table.nums(self.waitQueue_) == 0", table.nums(self.waitQueue_) == 0)
	end
	-- 正在播放, 返回
	if self.isPlaying_ then return end

	-- 播放队列为空
	if table.nums(self.waitQueue_) == 0 then return end

	self:playNext_()
end

--[[
	播放下一条
--]]
function TopTip:playNext_()
	local currentPlayTip = table.remove(self.waitQueue_, 1)
	assert(type(currentPlayTip) == "table", "TopTipData should be a table!")
	self.currentData_ = currentPlayTip

	self:checkCreateTopTip()
	self.label_:setString(currentPlayTip.text)
	local labelWidth = self.label_:getContentSize().width
	local scrollWidth = labelWidth - MAX_SHOW_LABEL_WIDTH
	local scrollTime = self:calcScrollTime(scrollWidth, LABEL_ROLL_VELOCITY)
	if scrollTime > 0 then
		-- 居左, 左对齐
		self.label_:align(display.LEFT_CENTER)
		self.label_:setPositionX(LABEL_LEFT_X)
		local targetXPos = -scrollWidth + self.label_:getPositionX()
		transition.execute(self.label_, cc.MoveTo:create(scrollTime, cc.p(targetXPos, 0)), {delay = DEFAULT_STAY_TIME * 0.5})
	elseif scrollTime == 0 then
		-- 居中
		self.label_:setAnchorPoint(0.5, 0.5)
		self.label_:setPositionX(0)
	end
	self.delayScheduleHandle_ = scheduler.performWithDelayGlobal(handler(self, self.delayCallback_), DEFAULT_STAY_TIME + scrollTime)

    local scene = display.getRunningScene()
    if scene and self.container_:getParent() ~= scene then
    	if not tolua.isnull(self.container_) then
    		self.container_:retain()
	    	self.container_:addTo(scene, Z_ORDER)
		    self.container_:release()
    	else
    		self.container_ = self:createContainer()
    			:pos(display.cx, HIDE_Y)
				:addTo(scene)
    	end
    end
    -- 下滑动画
    self.isPlaying_ = true
    self.container_:moveTo(0.3, display.cx, SHOW_Y)
end

function TopTip:calcScrollTime(scrollWidth, velocity)
	local scrollTime = 0
	if scrollWidth > 0 then
		scrollTime = scrollWidth / velocity
	end

	return scrollTime
end

function TopTip:delayCallback_()
	self.delayScheduleHandle_ = nil
	self:playHideAnim(0.3)
end

function TopTip:playHideAnim(hideTime)
	if not self.container_ then return end
    if self.container_:getParent() then
		self.container_:stopAllActions()
		self.label_:stopAllActions()
		self.container_:runAction(cc.Sequence:create({
			cc.MoveTo:create(hideTime, cc.p(display.cx, HIDE_Y)),
			cc.DelayTime:create(hideTime),
			cc.CallFunc:create(handler(self, self.onHideComplete_))
		}))
		
	else
		self.container_:pos(display.cx, HIDE_Y)
		self:onHideComplete_()
	end
end

function TopTip:onHideComplete_()
    self.isPlaying_ = false
    
    -- 播放完一条, 检查播放队列
    self:checkPlayNext(true)
end


--------
-- interface begin
--------

function TopTip:getInstance()
	if not TopTip.singleInstance then
		TopTip.singleInstance = TopTip.new()
	end
	return TopTip.singleInstance
end

function TopTip:showText(textContent)
	self:showTopTip({text = textContent})
end

function TopTip:clearTipsQueue()
    self.waitQueue_ = {}
end

function TopTip:clearAll()
	self:clearTipsQueue()
	-- 移除定时器
	if self.delayScheduleHandle_ then
		scheduler.unscheduleGlobal(self.delayScheduleHandle_)
		self.delayScheduleHandle_ = nil
	end

	self:playHideAnim(0.02)
end

--------
-- interface end
--------

return TopTip
