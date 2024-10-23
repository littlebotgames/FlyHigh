LevelLine = {}
class("LevelLine").extends(NobleSprite)

function LevelLine:init(data, scene)
	LevelLine.super.init(self)

    self.data = data
    self.scene = scene
    self.currentIndex = 1

    self:setIgnoresDrawOffset(true)
    self:setSize(400, 240)
	self:setCenter(0, 0)
end

function LevelLine:update()
    self:markDirty()
end

function LevelLine:draw(x, y)
	LevelLine.super.draw(self, x, y)

    Graphics.pushContext()

    Graphics.setLineCapStyle(Graphics.kLineCapStyleRound)

    local xPos = self.scene.xPos
    local yPos = self.scene.yPos

    local lineToScreenX = xPos
    -- The 0 position is actually based on the bird sprite and all a bit screwy so just hard code this here.
    local lineToScreenY = yPos - 150

    local startIndex = self.currentIndex
    -- Add 1 as a line is 2 points and we want the start and end.
    for i = startIndex + 1, #self.data, 1 do
        local lineStart = self.data[i - 1]
        local lineEnd = self.data[i]

        -- Offset the pos so it is in the correct position as nothing really moves. This ignores draw offset so do x and y.
        local startX = lineStart[1] - lineToScreenX
        local startY = lineStart[2] - lineToScreenY
        local endX = lineEnd[1] - lineToScreenX
        local endY = lineEnd[2] - lineToScreenY

        if startX > 400 then
            -- Line is not onscreen yet.
            break
        end

        -- If the point is offscreen then we don't want to draw it.
        if endX < 0 then
            self.currentIndex += 1
        else
            -- Draw the line.
            Graphics.setColor(Graphics.kColorBlack)
            Graphics.setLineWidth(14)
            Graphics.drawLine(startX, startY, endX, endY)
            Graphics.setColor(Graphics.kColorWhite)
            Graphics.setLineWidth(8)
            Graphics.drawLine(startX, startY, endX, endY)
        end
    end

    Graphics.popContext()
end