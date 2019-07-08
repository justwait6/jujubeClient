local HeaderNode = class("HeaderNode", function() 
		return display.newNode()
	end) 

local RESERVE_TAG = 1
function HeaderNode:ctor(sprite, bg, w, h)
	self.bg = bg
	self.w = w
	self.h = h	
    self.sprite = sprite
	local viewClipNode = cc.ClippingNode:create():pos(0, 0):addTo(self)
	-- 图片
    local size =  sprite:getContentSize()
    local width = size.width
    local height = size.height
    local mr = math.min(width, height)
    local r = math.min(w, h)
    if r > 0 then
    	if r > mr then
    		r = mr
    	end
        local stencil
    	--遮罩
        stencil = display.newDrawNode()
        stencil:drawSolidCircle(cc.p(0, 0), math.floor(r/2), 360, 360, cc.c4f(0, 0, 0, 0))
	    viewClipNode:setStencil(stencil)
	    viewClipNode:addChild(sprite)
	    viewClipNode:setScale(w/r, h/r)
    end
    if self.bg then
        self.bgSprite = display.newSprite(self.bg):pos(0, 0):addTo(self)
    end
    self.mask = display.newSprite(g.Res.common_headMask):addTo(self):hide()

    self.backGround_ = display.newScale9Sprite(g.Res.transparent, 0, 0, cc.size(w, r))
        :addTo(self)
        :scale(w/r)
    self.backGround_:setTag(RESERVE_TAG)
end
function HeaderNode:setDark()
    self.mask:show()
end
function HeaderNode:setBright()
    self.mask:hide()
end
function HeaderNode:showFrame()
    if self.bg then
        self.bgSprite:show()
    end
end
function HeaderNode:hideFrame()
    if self.bg then
        self.bgSprite:hide()
    end
end
function HeaderNode:setTexture(sprite)
    local children = self:getChildren()
	for i, v in pairs(children) do
        if v and v:getTag() ~= RESERVE_TAG then
            v:removeFromParent()
            v = nil
        end
    end

    self.sprite = sprite
	local viewClipNode = cc.ClippingNode:create():pos(0, 0):addTo(self)
	-- 图片
    local size =  sprite:getBoundingBox()
    local width = size.width
    local height = size.height

    local widthRate = self.w/width
    local heightRate = self.h/height
    if widthRate > heightRate then
        sprite:scale(widthRate)
    else
        sprite:scale(heightRate)
    end

    local mr = math.min(width, height)
    local r = math.min(self.w, self.h)
    if r > 0 then
    	if r > mr then
    		r = mr
    	end
    	--遮罩
	    local stencil = display.newDrawNode()
	    stencil:drawSolidCircle(cc.p(0, 0), math.floor(r/2), 360, 360, cc.c4f(0, 0, 0, 0))
	    viewClipNode:setStencil(stencil)
	    viewClipNode:addChild(sprite)
	    viewClipNode:setScale(self.w/r, self.h/r)
    end
    if self.bg then
       self.bgSprite = display.newSprite(self.bg):pos(0, 0):addTo(self)
    end  
end

function HeaderNode:getBgSprite()
    return self.backGround_
end

return HeaderNode
