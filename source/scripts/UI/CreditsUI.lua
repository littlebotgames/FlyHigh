import "CoreLibs/nineslice"
import "scripts/UI/UIPageID"

CreditsUI = {}
class("CreditsUI").extends(NobleSprite)

local windowSlice

local padding = 10
local boxRect
local textRect

function CreditsUI:init()
	CreditsUI.super.init(self)

	self:setZIndex(30001)

	-- Nine slice must cache some stuff internally as using the same one to draw different sizes is terrible 
	-- for perf so make one for each instance.
    windowSlice = Graphics.nineSlice.new('assets/images/dialogueBoxSlice.png', 3, 3, 3, 3)

	boxRect = Geometry.rect.new(50, 20, 400 - (50 * 2), 240 - (20 * 2))
	textRect = boxRect:insetBy(padding, padding)

	self:setSize(400, 240)
    self:setCenter(0, 0)

	self.inputHandler =
	{
        AButtonDown = function()
			UIManager:hidePage(UIPageID.Credits)
		end,
		BButtonDown = function()
			UIManager:hidePage(UIPageID.Credits)
		end,
	}
end

function CreditsUI:draw(x, y)
	CreditsUI.super.draw(self, x, y)

	Graphics.pushContext()

	-- Draw the box background.
    windowSlice:drawInRect(boxRect)

	-- Draw the text with some padding away from the edge of the box.
	Noble.Text.setFont(Noble.Text.FONT_MEDIUM)
    local creditsText = string.format("Credits\n\nLillie Treadgold\nBowie Treadgold\nDuncan Treadgold")
	Graphics.drawTextInRect(creditsText, textRect, nil, nil, kTextAlignment.center)

	Graphics.popContext()
end

function CreditsUI:onShow(showParams)
	self.prevInputHandler = Noble.Input.getHandler()
	Noble.Input.setHandler(self.inputHandler)
end

function CreditsUI:onHide()
	Noble.Input.setHandler(self.prevInputHandler)
	self.prevInputHandler = nil
end
