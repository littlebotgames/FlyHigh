ScoreUI = {}
class("ScoreUI").extends(NobleSprite)

function ScoreUI:init(scene)
	ScoreUI.super.init(self)

    self.scene = scene
    self:setSize(100, 50)
    self:setCenter(0, 0)
    self:setIgnoresDrawOffset(true)
end

function ScoreUI:update()
    self:markDirty()
end

function ScoreUI:draw(x, y)
	ScoreUI.super.draw(self, x, y)

    Graphics.pushContext()
    Graphics.setColor(Graphics.kColorWhite)
    Graphics.fillRect(0, 0, 100, 50)

    Graphics.setColor(Graphics.kColorBlack)
    Graphics.setLineWidth(3)
    Graphics.drawRect(0, 0, 100, 50)

    Noble.Text.setFont(Noble.Text.FONT_LARGE)
    Graphics.drawTextInRect(tostring(math.round(self.scene.score)), 10, 10, 90, 40, nil, nil, kTextAlignment.center)
    Graphics.popContext()
end