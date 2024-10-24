import "scripts/BackgroudLayer"
import "scripts/Enums/FlapPosition"
import "scripts/Enums/WingDirection"
import "scripts/MathExtensions"
import "scripts/LevelLine"
import "scripts/UI/ScoreUI"
import 'scenes/MainMenuScene'

import "assets/data/Level01"

GameScene = {}
class("GameScene").extends(NobleScene)
local scene = GameScene

scene.baseColor = Graphics.kColorWhite

-- Constants.
local BaseDrag = -60
local WingDirDragOffset =
{
	[WingDirection.Down] = 0,
	[WingDirection.Back] = 20,
	[WingDirection.Forward] = -20
}
local OnGroundDragOffset = -80

local Gravity = 200
local BirdFlapStrength = 4000
local RunAccel = 150
local MaxRunSpeed = 150
local MaxFlySpeed = 400

function scene:createLevel()
	self.levelLine = LevelLine(Level01, self)
end

function scene:init()
	scene.super.init(self)

	self:createLevel()
	self.scoreUI = ScoreUI(self)

	local function createTree()
		local sprite = NobleSprite("assets/images/tree01")
        sprite:setCenter(0.5, 1)
        return sprite
	end
	local function getTreeSpawnY()
		return math.random(0, 100)
	end
	self.treeLayer = BackgroundLayer.new(createTree, 4, 0.5, getTreeSpawnY, 800)

	local function getTreeForegroundSpawnY()
		return math.random(215, 300)
	end
	self.treeForegroundLayer = BackgroundLayer.new(createTree, 1, 1.2, getTreeForegroundSpawnY, 800)

	--self.house = NobleSprite("assets/images/house01")
	--self.house:setCenter(0.5, 1)

	local function createFoliage()
		local random = math.random(3)
		local sprite = nil
		if random == 1 then
			sprite = NobleSprite("assets/images/rocks01")
		elseif random == 2 then
			sprite = NobleSprite("assets/images/grass01")
		elseif random == 3 then
			sprite = NobleSprite("assets/images/leaves01")
		end
		if sprite then
			sprite:setCenter(0.5, 1)
		end
        return sprite
	end
	local function getFoliageSpawnY()
		return math.random(120, 145)
	end
	self.foliageLayer1 = BackgroundLayer.new(createFoliage, 5, 0.9, getFoliageSpawnY, 800)

	local function getFoliageForegroundSpawnY()
		return math.random(185, 210)
	end
	self.foliageLayer2 = BackgroundLayer.new(createFoliage, 5, 1.1, getFoliageForegroundSpawnY, 800)

	local function createCloud()
		local index = math.random(3)
		if index == 1 then
			return NobleSprite("assets/images/cloud01")
		elseif index == 2 then
			return NobleSprite("assets/images/cloud02")
		else
			return NobleSprite("assets/images/cloud03")
		end
	end
	local function getCloudSpawnY()
		return math.random(-1000, -500)
	end
	self.cloudLayer = BackgroundLayer.new(createCloud, 4, 0.3, getCloudSpawnY, 800)

	self.birdHead = NobleSprite("assets/images/head", true)
	self.birdHead:setSize(64, 64)
	self.birdHead:setIgnoresDrawOffset(true)

	self.birdHead.animation:addState("default", 1, 1, nil, true)
	self.birdHead.animation:addState("blink", 1, self.birdHead.animation.imageTable:getLength(), "default", false, nil, 0.3)

	self.birdBody = NobleSprite("assets/images/Body")
	self.birdBody:setIgnoresDrawOffset(true)

	self.birdLegs = NobleSprite("assets/images/legs", true)
	self.birdLegs:setSize(80, 64)
	self.birdLegs:setIgnoresDrawOffset(true)

	self.birdLegs.animation:addState("default", 1, 1, nil, true)
	self.birdLegs.animation:addState("run", 2, 3, nil, true, nil, 0.1)
	self.birdLegs.animation:addState("tuck", 4, 4, nil, true)
	self.birdRunningSound = playdate.sound.sampleplayer.new("assets/audio/running-bird-footsteps")

	self.birdWings = NobleSprite("assets/images/wings", true)
	self.birdWings:setSize(80, 80)
	self.birdWings:setIgnoresDrawOffset(true)

	self.birdWings.animation:addState("default", 1, 1, nil, true)
	self.birdWings.animation:addState("flapUp", 1, 1)
	self.birdWings.animation:addState("flapDown", 2, 2)
	self.birdWingFlapSound = playdate.sound.sampleplayer.new("assets/audio/wing-flap-1")

	-- Get rotated images for the wings for when the direction is set.
	self.birdWingsImageTables = {}
	for i = 1, WingDirection.length, 1 do
		local dirX, dirY = self.wingDirectionToVec(i)
		local angleDeg = math.dirToDeg(dirX, dirY) - 90
		local imageTable = Graphics.imagetable.new("assets/images/wings")
		for imageIndex = 1, #imageTable, 1 do
			local image = imageTable:getImage(imageIndex)
			image = image:rotatedImage(angleDeg)
			imageTable:setImage(imageIndex, image)
			self.birdWingsImageTables[i] = imageTable
		end
	end

	self.grounded = true

	-- Initialise anims.
	self.birdWings.animation:setState(self.birdWings.animation.flapUp)
	self.birdLegs.animation:setState(self.birdLegs.animation.run)
	--self.birdRunningSound:play(0)

	self.xPos = 0
	self.yPos = 0

	-- Bird flight vars.
	self.birdFlapPos = FlapPosition.Down

	self.birdVelX = 0
	self.birdVelY = 0

	self.birdLift = 0
	self.birdThrust = 0

	self:setWingDirection(WingDirection.Down)

	self.score = 0

	self.inputHandler = {
		downButtonDown = function()
			self:setWingDirection(WingDirection.Down)
		end,
		rightButtonDown = function()
			self:setWingDirection(WingDirection.Forward)
		end,
		leftButtonDown = function()
			self:setWingDirection(WingDirection.Back)
		end,
		cranked = function(change, acceleratedChange)
			local crankPos = playdate.getCrankPosition()
			if self.birdFlapPos == FlapPosition.Up and crankPos > 135 and crankPos < 225 then
				self:doFlap(FlapPosition.Down)
			elseif self.birdFlapPos == FlapPosition.Down and crankPos > 315 or crankPos < 45 then
				self:doFlap(FlapPosition.Up)
			end
		end,
		AButtonDown = function()
			if self.birdFlapPos == FlapPosition.Down then
				self:doFlap(FlapPosition.Up)
			elseif self.birdFlapPos == FlapPosition.Up then
				self:doFlap(FlapPosition.Down)
			end
		end,
		--[[
		BButtonDown = function()
			if self.birdFlapPos == FlapPosition.Up then
				doFlap(FlapPosition.Down)
			end
		end
		--]]
	}
end

function scene:enter()
	scene.super.enter(self)

	self.cloudLayer:add()
	self.treeLayer:add()
	self.foliageLayer1:add()

	--self.house:add(10, 240)

	self.levelLine:add()

	self.birdBody:add(200, 120)
	self.birdHead:add(245, 75)
	self.birdLegs:add(200, 148)
	self.birdWings:add(195, 110)

	self.foliageLayer2:add()
	self.treeForegroundLayer:add()

	self.scoreUI:add(10, 10)
end

function scene:exit()
	self.scoreUI:remove()
	self.levelLine:remove()

	self.treeForegroundLayer:remove()
	self.foliageLayer2:remove()

	self.birdHead:remove()
	self.birdBody:remove()
	self.birdLegs:remove()
	self.birdWings:remove()

	--self.house:remove()

	self.foliageLayer1:remove()
	self.cloudLayer:remove()
	self.treeLayer:remove()

	scene.super.exit(self)
end

function scene:start()
	scene.super.start(self)
end

function scene:finish()
	scene.super.finish(self)
end

function scene:drawBackground()
	scene.super.drawBackground(self)
end

function scene:update()
	scene.super.update(self)
	
	local accelX = self.birdThrust
	if self.grounded and self.birdVelX < MaxRunSpeed then
		-- Running on the ground.
		accelX += RunAccel
	end
	self.birdVelX += accelX * Noble.elapsedTime

	-- Get current drag to use.
	local drag = BaseDrag + WingDirDragOffset[self.wingDirection]
	if self.grounded and self.birdVelX > MaxRunSpeed then
		-- Add additional drag to slow down to max running speed.
		drag += OnGroundDragOffset
	end

	if not self.grounded and self.birdVelX > MaxFlySpeed then
		-- Add additional drag to slow down to max speed.
		drag += OnGroundDragOffset * 4
	end

	self.birdVelX = math.max(self.birdVelX + drag * Noble.elapsedTime, 0)
	-- Rise due to going fast.
	self.birdLift -= self.birdVelX * Noble.elapsedTime
	local accelY = self.birdLift + Gravity
	self.birdVelY += accelY * Noble.elapsedTime

	local moveXDelta = self.birdVelX * Noble.elapsedTime
	self.xPos += moveXDelta
	self.yPos += self.birdVelY * Noble.elapsedTime

	-- Clamp to ground position.
	local newGrounded = false
	if self.yPos > 0 then
		self.yPos = 0
		self.birdVelY = 0
		newGrounded = true
	else
		newGrounded = false
	end

	-- Start / stop running depending on if we are on the ground.
	if self.grounded ~= newGrounded then
		self.grounded = newGrounded
		if self.grounded then
			self.birdLegs.animation:setState(self.birdLegs.animation.run)
			--self.birdRunningSound:play(0)
		else
			self.birdLegs.animation:setState(self.birdLegs.animation.tuck)
			self.birdRunningSound:stop()
		end
	end

	-- Move in the X.
	self.treeLayer:move(moveXDelta)
	self.cloudLayer:move(moveXDelta)
	self.treeForegroundLayer:move(moveXDelta)
	self.foliageLayer1:move(moveXDelta)
	self.foliageLayer2:move(moveXDelta)

	-- Move in the Y.
	Graphics.setDrawOffset(0, -self.yPos)

	local blinkChance = 50
	if not self.birdBlinking and math.random(blinkChance) == 1 then
		-- Blink.
		self.birdHead.animation:setState(self.birdHead.animation.blink)
	end

	self.birdThrust = 0
	self.birdLift = 0

	-- Add to the score based on the distance from the score line. 
	-- Score is added based on distance traveled so it should be frame rate independant.
	local distanceFromLine = self.levelLine:getDistance()
	if distanceFromLine then
		local minDistance = 50
		local maxDistance = 300
		local minScore = 0
		local maxScore = 0.02

		local scoreToAdd = math.remap(minDistance, maxDistance, maxScore, minScore, distanceFromLine)
		self.score += scoreToAdd * moveXDelta
	else
		-- Level is finished.
		self.levelFinished = true
		-- Restart.
		playdate.timer.new(3 * 1000, function() Noble.transition(MainMenuScene) end)
	end
end

function scene:setWingDirection(wingDirection)
	self.wingDirection = wingDirection
	self.birdWingDirX, self.birdWingDirY = self.wingDirectionToVec(wingDirection)
	self.birdWings:setAnimationImageTable(self.birdWingsImageTables[wingDirection])
end

function scene.wingDirectionToVec(wingDirection)
	if wingDirection == WingDirection.Down then
		return math.degToDir(90 + 10)
	elseif wingDirection == WingDirection.Back then
		return math.degToDir(90 + 50)
	elseif wingDirection == WingDirection.Forward then
		return math.degToDir(90 - 50)
	end
end

function scene:doFlap(flapPos)
	self.birdFlapPos = flapPos
	if self.birdFlapPos == FlapPosition.Up then
		-- Flap up.
		self.birdWings.animation:setState(self.birdWings.animation.flapUp)
	elseif self.birdFlapPos == FlapPosition.Down then
		-- Flap down.
		self.birdWings.animation:setState(self.birdWings.animation.flapDown)
		-- We get thrust in the opposite direction to the wing.
		self.birdThrust += BirdFlapStrength * 0.5 * -self.birdWingDirX
		self.birdLift += BirdFlapStrength * -self.birdWingDirY
		self.birdWingFlapSound:play(1)
	end
end