import "CoreLibs/nineslice"
import "scripts/TextTypewriter"

DialogueBox = {}
class("DialogueBox").extends(NobleSprite)

local windowSlice
local typewriter

local padding = 10
local boxRect
local textRect

function DialogueBox:init()
	DialogueBox.super.init(self)

	self:setZIndex(30000)

	-- Nine slice must cache some stuff internally as using the same one to draw different sizes is terrible 
	-- for perf so make one for each instance.
    windowSlice = Graphics.nineSlice.new('assets/images/dialogueBoxSlice.png', 3, 3, 3, 3)

	typewriter = TextTypewriter.new(0.01, self.onTextChanged, self)

	boxRect = Geometry.rect.new(0, 0, 300, 80)
	textRect = boxRect:insetBy(padding, padding)

	self:setSize(300, 100)
    self:setCenter(0, 0)
end

function DialogueBox:draw(x, y)
	DialogueBox.super.draw(self, x, y)

	-- Draw the box background.
    windowSlice:drawInRect(boxRect)

	-- Draw the text with some padding away from the edge of the box.
	Noble.Text.setFont(Noble.Text.FONT_MEDIUM)
	local width, height, wasTruncated = Graphics.drawTextInRect(typewriter:getCurrentText(), textRect)
end

function DialogueBox:setText(text)
	typewriter:setText(text)
end

function DialogueBox:hasFinished()
	return typewriter:hasFinished()
end

function DialogueBox:onTextChanged()
	self:markDirty()
end