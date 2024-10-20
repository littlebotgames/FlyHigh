-- Put your utilities and other helper functions here.
-- The "Utilities" table is already defined in "noble/Utilities.lua."
-- Try to avoid name collisions.

function Utilities.getZero()
	return 0
end

function Utilities.getCrankPositionRightIsZero()
	-- Minus 90 so the returns value has 0 going right instead of up.
	return playdate.getCrankPosition() - 90
end

function Utilities.getCrankDirectionRightIsZero()
	local moveDeg = Utilities.getCrankPositionRightIsZero()
    local moveRad = math.rad(moveDeg)
    local x = math.cos(moveRad)
    local y = math.sin(moveRad)
    return x, y
end

function Utilities.getKeyboardMaxWidth()
    -- You can only get the current width of the keyboard which is 0 if not shown so adding this const here.
	return 179
end