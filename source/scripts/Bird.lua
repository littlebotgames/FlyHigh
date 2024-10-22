Bird = {}
class("Bird").extends(NobleSprite)

function Bird:init()
	Bird.super.init(self)
end

function Bird:draw(x, y)
	Bird.super.draw(self, x, y)
end