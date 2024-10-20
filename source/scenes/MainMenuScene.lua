import 'scenes/GameScene'

MainMenuScene = {}
class("MainMenuScene").extends(NobleScene)
local scene = MainMenuScene

scene.baseColor = Graphics.kColorWhite

local sequence

local padding = 10

function scene:init()
	scene.super.init(self)

	local blackImage = Graphics.image.new(400, 240, Graphics.kColorBlack)
	local whiteImage = Graphics.image.new(400, 240, Graphics.kColorWhite)
	local testBackground = blackImage:blendWithImage(whiteImage, 0.5, Graphics.image.kDitherTypeDiagonalLine)
	self.background = testBackground

	-- Add a background to the logo image.
	local logoImage = Graphics.image.new("assets/images/LBIconSmall")
	local yOffscreenOffset = 20
	local logoWidth, logoHeight = logoImage:getSize()
	local logoBGWidth = logoWidth + padding * 2
	local logoBGHeight = logoHeight + padding * 2 + yOffscreenOffset

	local wholeLogoImage = Graphics.image.new(logoBGWidth, logoBGHeight)
	Graphics.pushContext(wholeLogoImage)

	Graphics.setColor(Graphics.kColorWhite)
	Graphics.fillRoundRect(0, 0, logoBGWidth, logoBGHeight, 15)
	logoImage:draw(padding, padding)

	Graphics.popContext()

	self.logoSprite = NobleSprite(wholeLogoImage)
	self.logoSprite:setCenter(0, 0)

	-- Create menu options background sprite.
	local menuBGWidth = 280
	local menuBGHeight = 130

	local menuBGImage = Graphics.image.new(menuBGWidth, menuBGHeight)
	Graphics.pushContext(menuBGImage)

	Graphics.setColor(Graphics.kColorBlack)
	Graphics.fillRoundRect(0, 0, menuBGWidth, menuBGHeight, 15)
	Graphics.setColor(Graphics.kColorWhite)
	Graphics.setLineWidth(3)
	Graphics.drawRoundRect(0, 0, menuBGWidth, menuBGHeight, 15)

	Graphics.popContext()
	self.menuBGSprite = NobleSprite(menuBGImage)
	self.menuBGSprite:setCenter(0, 0)

	local crankTick = 0

	-- Add bird sprite.
	self.birdSprite = NobleSprite("assets/images/birb")

	self.defaultInputHandler = {
		upButtonDown = function()
			self.menu:selectPrevious()
		end,
		downButtonDown = function()
			self.menu:selectNext()
		end,
		cranked = function(change, acceleratedChange)
			crankTick = crankTick + change
			if (crankTick > 30) then
				crankTick = 0
				self.menu:selectNext()
			elseif (crankTick < -30) then
				crankTick = 0
				self.menu:selectPrevious()
			end
		end,
		AButtonDown = function()
			self.menu:click()
		end
	}
end

function scene:enter()
	scene.super.enter(self)

	-- Add the logo sprite.
	local yOffscreenOffset = 20
	local logoWidth, logoHeight = self.logoSprite:getSize()
	local logoBGX = 400 - logoWidth - padding
	local logoBGY = 240 - logoHeight - padding + yOffscreenOffset
	self.logoSprite:add(logoBGX, logoBGY)

	-- Add the menuBG sprite.
	local startX = -200
	local startY = 105
	sequence = Sequence.new():from(startX):to(padding, 0.5, Ease.inSine)
	sequence:start();
	self.menuBGSprite:add(startX, startY)

	self.birdSprite:add(300, 50)

	local menu = playdate.getSystemMenu()
	menu:addCheckmarkMenuItem(
        "Show FPS",
        Noble.showFPS,
        function(value)
            Noble.showFPS = value
        end
    )
end

function scene:start()
	scene.super.start(self)
end

function scene:drawBackground()
	scene.super.drawBackground(self)

	self.background:draw(0, 0)
end

function scene:update()
	scene.super.update(self)

	Graphics.pushContext()

	-- Draw menu.
	Graphics.setColor(Graphics.kColorBlack)
	local menuBGX = sequence:get()
	self.menuBGSprite:moveTo(menuBGX, self.menuBGSprite.y)

	Graphics.popContext()
end

function scene:exit()
	sequence = Sequence.new():from(100):to(-200, 0.25, Ease.inSine)
	sequence:start();

	self.birdSprite:remove()
	self.menuBGSprite:remove()
	self.logoSprite:remove()

	scene.super.exit(self)
end

function scene:finish()
	local menu = playdate.getSystemMenu()
    menu:removeAllMenuItems()

	scene.super.finish(self)
end