local RummyScene = class("RummyScene", function()
    return display.newScene("RummyScene")
end)

local RummyView = require("app.view.rummy.RummyView")

function RummyScene:ctor()
    self:initialize()
end

function RummyScene:initialize()
    self.rummyView = RummyView.new(self):pos(display.cx, display.cy):addTo(self)
end

function RummyScene:onEnter()
end

function RummyScene:onExit()
end

return RummyScene
