import 'libraries/noble/Noble'
import 'utilities/Utilities'
import 'scenes/GameScene'

Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({

})

GlobalData = {}

Noble.showFPS = true
Noble.Text.FONT_MEDIUM = Graphics.font.new("assets/fonts/Roobert-20-Medium")
Noble.Text.FONT_LARGE = Graphics.font.new("assets/fonts/Roobert-24-Medium")
Noble.Text.FONT_SMALL = Graphics.font.new("assets/fonts/Roobert-11-Medium")

Noble.new(GameScene, 1.5)
Graphics.sprite.setAlwaysRedraw(false)

local function saveCurrentScene()
	local currentScene = Noble.currentScene()
	if currentScene and currentScene["save"] then
		currentScene:save()
	end
end

function playdate.gameWillTerminate()
	saveCurrentScene()
end

function playdate.deviceWillSleep()
	saveCurrentScene()
end