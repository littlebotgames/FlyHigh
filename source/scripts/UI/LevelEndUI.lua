import "CoreLibs/nineslice"
import "scripts/UI/UIPageID"

LevelEndUI = {}
class("LevelEndUI").extends(NobleSprite)

local windowSlice

local padding = 10
local boxRect
local textRect
local OptionWidth = 100
local OptionHeight = 55

function LevelEndUI:init()
	LevelEndUI.super.init(self)

	self:setZIndex(30000)

	-- Nine slice must cache some stuff internally as using the same one to draw different sizes is terrible 
	-- for perf so make one for each instance.
    windowSlice = Graphics.nineSlice.new('assets/images/dialogueBoxSlice.png', 3, 3, 3, 3)

	boxRect = Geometry.rect.new(50, 20, 400 - (50 * 2), 240 - (20 * 2))
	textRect = boxRect:insetBy(padding, padding)
	textRect.height = 80

	self:setSize(400, 240)
    self:setCenter(0, 0)

	self.inputHandler =
	{
		leftButtonDown = function()
			self.selected = math.repeatIndex(self.selected - 1, #self.options)
		end,
		rightButtonDown = function()
			self.selected = math.repeatIndex(self.selected + 1, #self.options)
		end,
		AButtonDown = function()
			local selectedOption = self.options[self.selected]
			selectedOption.onSelected()
			UIManager:hidePage(UIPageID.LevelEnd)
		end,
	}
end

function LevelEndUI:draw(x, y)
	LevelEndUI.super.draw(self, x, y)

	Graphics.pushContext()

	-- Draw the box background.
    windowSlice:drawInRect(boxRect)

	-- Draw the text with some padding away from the edge of the box.
	Noble.Text.setFont(Noble.Text.FONT_MEDIUM)
	Graphics.drawTextInRect(string.format("Level Complete\nScore: %i", self.score), textRect, nil, nil, kTextAlignment.center)

	for index, option in ipairs(self.options) do
		local optionBoxRect = Geometry.rect.new(option.x, option.y, OptionWidth, OptionHeight)
		local optionTextRect = optionBoxRect:insetBy(padding, padding)

		if self.selected == index then
			Graphics.setLineWidth(6)
		else
			Graphics.setLineWidth(3)
		end
		Graphics.drawRect(optionBoxRect)
		Graphics.drawTextInRect(option.text, optionTextRect, nil, nil, kTextAlignment.center)
	end

	Graphics.popContext()
end

function LevelEndUI:onShow(showParams)
	self.score = showParams.score

	self.prevInputHandler = Noble.Input.getHandler()
	Noble.Input.setHandler(self.inputHandler)

	self.options = {}
	if GlobalData.levelIndex == #Levels then
		-- Finished all levels.
		local menuOption =
		{
			text = "Menu",
			onSelected = function()
				Noble.transition(MainMenuScene)
			end,
			x = 200 - OptionWidth / 2,
			y = 150 - OptionHeight / 2
		}
		table.insert(self.options, menuOption)
	else
		-- Can go to next level or menu.
		local nextOption =
		{
			text = "Next",
			onSelected = function()
				-- Go to next level.
				GlobalData.levelIndex += 1
				Noble.transition(GameScene)
			end,
			x = 200 - OptionWidth - padding,
			y = 150 - OptionHeight / 2
		}
		table.insert(self.options, nextOption)

		local menuOption =
		{
			text = "Menu",
			onSelected = function()
				Noble.transition(MainMenuScene)
			end,
			x = 200 + padding,
			y = 150 - OptionHeight / 2
		}
		table.insert(self.options, menuOption)
	end
	self.selected = 1
end

function LevelEndUI:onHide()
	Noble.Input.setHandler(self.prevInputHandler)
	self.prevInputHandler = nil
end
