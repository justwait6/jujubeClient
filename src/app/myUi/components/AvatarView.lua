-- --[[--[[--[[
-- @params params: a lua table
-- params.shape: the shape of avatar view
-- params.picUrl: the head image of avatar view, if not provided use defaultImage
-- params.gender: the gender of user, default MALE
-- params.defaultImage: if picUrl not provided or load url image fail, use this
-- params.avatarSize: the avatar size of avatar view
-- params.mask: the mask adding to avatar view after clipping
-- params.clickCallback: the callback when click avatar
-- --]]
-- local AvatarView = class("AvatarView", function ()
-- 	return display.newNode()
-- end)

-- local Gender = require("app.model.baseDef.Gender")
-- AvatarView.Gender = Gender
-- local Shape = require("app.model.baseDef.Shape")
-- AvatarView.Shape = Shape

-- function AvatarView:ctor(params)
-- 	params = params or {}
-- 	self.shape = params.shape or Shape.SQUARE
-- 	self.picUrl = params.picUrl
-- 	self.gender = params.gender or Gender.MALE
-- 	self.defaultImage = params.defaultImage or DEFAULT_IMAGE
-- 	self.avatarSize = params.avatarSize or cc.size(88, 88)
-- 	self.clickCallback = params.clickCallback
-- 	self.roundCorner = params.roundCorner -- Judge whether corner is square or round

-- 	if self.shape == Shape.CIRCLE then
-- 		self.radius = params.radius or 48
-- 		self.mask = params.mask or "#base_head_frame_circle.png"
-- 		self:createCircleAvatar()
-- 	elseif self.shape == Shape.SQUARE then
-- 		self.mask = params.mask or "#base_head_frame_b.png"
-- 		self:createSquareAvatar()
-- 	end
-- end

-- function AvatarView:createCircleAvatar()
-- 	local stencil = display.newCircle(self.radius, {x = 0, y = 0, borderColor = cc.c4f(0, 0, 0, 0), borderWidth = 0})
-- 	self._clippingNode = cc.ClippingNode:create():addTo(self)
-- 	self._clippingNode:setStencil(stencil)

-- 	self._avatar = g.ImageLoader.new():addTo(self._clippingNode)

-- 	local defaultImg = self:getDefaultImage(self.gender)
-- 	self._avatar:setData({url = g.util.func.getRealUrl(self.picUrl), defaultImage = defaultImg, size = self.avatarSize})
-- 	cc.ui.UIPushButton.new({normal = "#base_transparent.png"}, {scale9 = true})
-- 		:setButtonSize(self.avatarSize.width, self.avatarSize.height)
-- 		:onButtonClicked(handler(self, self._onAvatarClicked))
-- 		:addTo(self)

-- 	self.maskSprite = display.newSprite(self.mask):addTo(self)
-- end

-- function AvatarView:createSquareAvatar()
-- 	self._clippingNode = cc.ClippingNode:create():addTo(self)

-- 	local stencil = nil
-- 	if not self.roundCorner then
-- 		stencil = g.util.func.getScale9Stencil("#base_transparent.png", self.avatarSize.width - 2, self.avatarSize.height - 2)
-- 		-- stencil = display.newScale9Sprite("#base_transparent.png", 0, 0, cc.size(self.avatarSize.width - 2, self.avatarSize.height - 2))
-- 	else
-- 		-- stencil = self:createNodeRoundRect(cc.rect(-self.avatarSize.width/2, -self.avatarSize.height/2, self.avatarSize.width, self.avatarSize.height))
-- 		stencil = g.util.func.getScale9Stencil("#base_button_bg.png", self.avatarSize.width - 2, self.avatarSize.height - 2)
-- 		self._clippingNode:setAlphaThreshold(0)
-- 	end
-- 	self._clippingNode:setStencil(stencil)

-- 	self._avatar = g.ImageLoader.new():addTo(self._clippingNode)

-- 	local defaultImg = self:getDefaultImage(self.gender)
-- 	self._avatar:setData({url = g.util.func.getRealUrl(self.picUrl), defaultImage = defaultImg, size = self.avatarSize})
-- 	cc.ui.UIPushButton.new({normal = "#base_transparent.png"}, {scale9 = true})
-- 		:setButtonSize(self.avatarSize.width, self.avatarSize.height)
-- 		:onButtonClicked(handler(self, self._onAvatarClicked))
-- 		:addTo(self)

-- 	self.maskSprite = display.newSprite(self.mask):addTo(self, 2)
-- end

-- function AvatarView:scaleAvatarFrame(scaleFactor)
-- 	if self.maskSprite then
-- 		self.maskSprite:setScale(scaleFactor)
-- 	end
-- end

-- function AvatarView:_onAvatarClicked()
-- 	if self.clickCallback then
-- 		self.clickCallback()
-- 	end
-- end

-- function AvatarView:updateAvatarView(gender)
-- 	self.gender = gender or self.gender
-- 	local defaultImg = self:getDefaultImage(self.gender)
-- 	self._avatar:setData({url = g.util.func.getRealUrl(self.picUrl), defaultImage = defaultImg, size = self.avatarSize})
-- end

-- function AvatarView:updateAvatarViewUrl(url)
-- 	self.picUrl = url or self.picUrl
-- 	local defaultImg = self:getDefaultImage(self.gender)
-- 	self._avatar:setData({url = g.util.func.getRealUrl(self.picUrl), defaultImage = defaultImg, size = self.avatarSize})
-- end

-- function AvatarView:getDefaultImage(gender)
-- 	local defaultImage
-- 	if gender == Gender.MALE or gender == "m" then
-- 		defaultImage = "#base_avatar_m_b.png"
-- 	else
-- 		defaultImage = "#base_avatar_f_b.png"
-- 	end

-- 	return defaultImage
-- end

-- --更换头像
-- function AvatarView:setData( data )
-- 	-- body
-- 	self._data = data or {}
-- 	if self._data and self._data.size == nil  then
-- 		--如果没有设置size参数,默认使用 89*89
-- 		self._data.size = self.avatarSize
-- 	end

-- 	self._avatar:setData(self._data)
-- end

-- return AvatarView
--]]--]]