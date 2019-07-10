local AvatarView = class("AvatarView", function() 
	return display.newNode()
end)

local Gender = require("app.model.baseDef.Gender")
AvatarView.Gender = Gender
local Shape = require("app.model.baseDef.Shape")
AvatarView.Shape = Shape

function AvatarView:ctor(params)
    local params = params or {}
    self.shape = params.shape or Shape.CIRCLE
    self.gender = params.gender or Gender.MALE
    self.avatarUrl = params.avatarUrl or self:getDefaultImage(self.gender)
	self.frameRes = params.frameRes
    self.clickCallback = params.clickCallback
    if self.shape == Shape.CIRCLE then
        self.radius = params.radius or 48
        self.avatarSize = cc.size(self.radius * 2, self.radius * 2)
    else
        self.length = params.length or 88
        self.avatarSize = cc.size(self.length, self.length)
    end

    self:initialize()
end

function AvatarView:initialize()
    if self.shape == Shape.CIRCLE then
        self:_createCircleAvatar()
    else
        self:_createSquareAvatar()
    end

    g.myUi.ScaleButton.new({normal = g.Res.blank})
        :onClick(handler(self, self._onAvatarClick))
        :setButtonSize(self.avatarSize)
        :addTo(self)

    if self.frameRes then
        self.frame = display.newSprite(self.frameRes):addTo(self)
    end
end

function AvatarView:_createCircleAvatar()
    local stencil = display.newCircle(self.radius, {x = 0, y = 0, borderColor = cc.c4f(0, 0, 0, 0), borderWidth = 0})
    
    self._clippingNode = cc.ClippingNode:create():addTo(self)
    self._clippingNode:setStencil(stencil)

    self:_recreateAvatarSpriteIf()
end

function AvatarView:_createSquareAvatar()
    local stencil = cc.DrawNode:create()
    local w, h = self.avatarSize.width - 2, self.avatarSize.height - 2
    stencil:drawSolidRect(cc.p(-w/2, -h/2), cc.p(w/2, h/2), cc.c4f(0, 0, 0, 0))

    self._clippingNode = cc.ClippingNode:create():addTo(self)
    self._clippingNode:setStencil(stencil)

    self:_recreateAvatarSpriteIf()
end

function AvatarView:_recreateAvatarSpriteIf()
    if not self._avatarSprite then
        self._avatarSprite = display.newSprite(g.Res.blank):addTo(self._clippingNode)
    end

    self:_asyncGetAvatarSprite(self.avatarUrl, function (sprite)
        local size = sprite:getContentSize()
        local minImageLength = math.min(size.width, size.height)
        self._avatarSprite:setSpriteFrame(sprite:getSpriteFrame())
        self._avatarSprite:scale(self.avatarSize.width/minImageLength)
    end)
end

function AvatarView:setAvatarUrl(avatarUrl)
    if self.avatarUrl ~= avatarUrl then
        self.avatarUrl = avatarUrl or self:getDefaultImage(self.gender)
        self:_recreateAvatarSpriteIf()
    end
end

function AvatarView:_onAvatarClick()
    self:_playClickAnim()
    if self.clickCallback then
        self.clickCallback()
    end
end

function AvatarView:_playClickAnim()
    self:stopAllActions()
    self:scale(1)
    self:runAction(cc.Sequence:create({
        cc.ScaleTo:create(0.06, 0.96),
        cc.ScaleTo:create(0.06, 1),
    }))
end

function AvatarView:_asyncGetAvatarSprite(url, callback)
    if url == g.Res.common_defaultMan or
        url == g.Res.common_defaultWoman then
        if callback then
            callback(display.newSprite(url))
        end
    else
        local imageId = g.imageLoader:nextLoaderId()
        g.imageLoader:loadAndCacheImage(imageId, g.myFunc:calcIconUrl(url), function(success, sprite)
            if success and sprite then
                if callback then
                    callback(sprite)
                end
            else
                if callback then
                    callback(display.newSprite(self:getDefaultImage(self.gender)))
                end
            end
        end, g.imageLoader.CACHE_TYPE_USER_HEAD_IMG)
    end
end

function AvatarView:getDefaultImage(gender)
    local defaultImage
    if gender == Gender.MALE or gender == "m" then
        defaultImage = g.Res.common_defaultMan
    else
        defaultImage = g.Res.common_defaultWoman
    end

    return defaultImage
end

function AvatarView:setFrameScale(scale)
    if self.frame then
        self.frame:scale(scale)
    end
end

return AvatarView
