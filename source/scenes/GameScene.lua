import "scripts/BackgroudLayer"

GameScene = {}
class("GameScene").extends(NobleScene)
local scene = GameScene

scene.baseColor = Graphics.kColorWhite

function scene:init()
	scene.super.init(self)

	local function createTree()
		local sprite = NobleSprite("assets/images/tree01")
        sprite:setCenter(0.5, 1)
        return sprite
	end
	local function getTreeSpawnY()
		return math.random(300, 400)
	end
	self.treeLayer = BackgroundLayer.new(createTree, 3, 0.5, getTreeSpawnY)

	local function getTreeForegroundSpawnY()
		return math.random(240, 260)
	end
	self.treeForegroundLayer = BackgroundLayer.new(createTree, 1, 1.2, getTreeForegroundSpawnY)

	--self.house = NobleSprite("assets/images/house01")
	--self.house:setCenter(0.5, 1)

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
		return math.random(0, 80)
	end
	self.cloudLayer = BackgroundLayer.new(createCloud, 3, 0.3, getCloudSpawnY)

	self.birdHead = NobleSprite("assets/images/head", true)
	self.birdHead:setSize(64, 64)

	self.birdHead.animation:addState("default", 1, 1, nil, true)
	self.birdHead.animation:addState("blink", 1, self.birdHead.animation.imageTable:getLength(), "default", false, nil, 0.3)

	self.birdBody = NobleSprite("assets/images/Body")
	self.birdLegs = NobleSprite("assets/images/legs", true)
	self.birdLegs:setSize(80, 64)

	self.birdLegs.animation:addState("default", 1, 1, nil, true)
	self.birdLegs.animation:addState("run", 2, 3, nil, true, nil, 0.1)
	self.birdLegs.animation:addState("tuck", 4, 4, nil, true)

	self.birdWings = NobleSprite("assets/images/wings", true)
	self.birdWings:setSize(80, 80)

	self.birdWings.animation:addState("default", 1, 1, nil, true)
	self.birdWings.animation:addState("fly", 1, self.birdWings.animation.imageTable:getLength(), nil, true, nil, 0.1)

	self.birdIsRunning = false
	self.birdIsFlying = false

	-- Test start flying.
	self.birdIsFlying = true
	self.birdWings.animation:setState(self.birdWings.animation.fly)
	self.birdLegs.animation:setState(self.birdLegs.animation.tuck)

	self.inputHandler = {
		upButtonDown = function()
			--self.birdIsFlying = true
			--self.birdWings.animation:setState(self.birdWings.animation.fly)
		end,
		upButtonUp = function()
			--self.birdIsFlying = false
			--self.birdWings.animation:setState(self.birdWings.animation.default)
		end,
		downButtonDown = function()
		end,
		rightButtonDown = function()
			--self.birdIsRunning = true
			--self.birdLegs.animation:setState(self.birdLegs.animation.run)
		end,
		rightButtonUp = function()
			--self.birdIsRunning = false
			--self.birdLegs.animation:setState(self.birdLegs.animation.default)
		end,
		cranked = function(change, acceleratedChange)
		end,
		AButtonDown = function()
		end
	}
end

function scene:enter()
	scene.super.enter(self)

	self.cloudLayer:add()
	self.treeLayer:add()

	--self.house:add(10, 240)

	self.birdBody:add(200, 120)
	self.birdHead:add(245, 75)
	self.birdLegs:add(200, 148)
	self.birdWings:add(195, 110)

	self.treeForegroundLayer:add()
end

function scene:exit()
	self.treeForegroundLayer:remove()

	self.birdHead:remove()
	self.birdBody:remove()
	self.birdLegs:remove()
	self.birdWings:remove()

	--self.house:remove()

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

	local moveSpeed = 50
	local moveDelta = moveSpeed * Noble.elapsedTime

	self.treeLayer:move(moveDelta)
	self.cloudLayer:move(moveDelta)
	self.treeForegroundLayer:move(moveDelta)

	local blinkChance = 50
	if not self.birdBlinking and math.random(blinkChance) == 1 then
		-- Blink.
		self.birdHead.animation:setState(self.birdHead.animation.blink)
	end
end



