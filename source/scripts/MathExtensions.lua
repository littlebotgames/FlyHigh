function math.round(x)
    return math.floor(x + 0.5)
end

function math.clamp(x, min, max)
    if x < min then return min end
    if x > max then return max end
    return x
end

-- Repeat the value but starting from 1 so it can be used for indicies.
function math.repeatIndex(x, length)
    -- Get it in 0 based indicies for the % and then add the 1 back on at the end.
    return ((x - 1) % length) + 1
end

function math.sign(x)
    return (x > 0 and 1) or (x == 0 and 0) or -1
end

function math.invLerp(a, b, v)
    return math.clamp(math.invLerpUnclamped(a, b, v), 0, 1)
end

function math.invLerpUnclamped(a, b, v)
    return (v - a) / (b - a)
end

function math.remap(inMin, inMax, outMin, outMax, v)
    local t = math.invLerp(inMin, inMax, v)
    return math.lerp(outMin, outMax, t)
end

function math.remapUnclamped(inMin, inMax, outMin, outMax, v)
    local t = math.invLerpUnclamped(inMin, inMax, v)
    return math.lerp(outMin, outMax, t)
end

function math.roundToNearestMultiple(x, factor)
    return math.floor(x / factor + 0.5) * factor
end

function math.length(x, y)
    return math.sqrt(x * x + y * y)
end

function math.distance(x1, y1, x2, y2)
    return math.sqrt(math.distanceSq(x1, y1, x2, y2))
end

function math.distanceSq(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return dx * dx + dy * dy
end

function math.normalise(x, y)
    local length = math.length(x, y)
    if length == 0 then
        return 0, 0
    end
    
    return x / length, y / length
end

function math.toPolar(x, y)
    local radius = math.length(x, y)
    local angleRad = math.dirToRad(x, y)
    return radius, angleRad
end

function math.toCartesian(radius, angleRad)
    local dirX, dirY = math.radToDir(angleRad)
    return dirX * radius, dirY * radius
end

function math.degToDir(angleDeg)
    return math.radToDir(math.rad(angleDeg))
end

function math.radToDir(angleRad)
    local x = math.cos(angleRad)
    local y = math.sin(angleRad)
    return x, y
end

function math.dirToDeg(x, y)
    return math.deg(math.dirToRad(x, y))
end

function math.dirToRad(x, y)
    return math.atan(y, x)
end

-- isValid is a function to check if the an entry should be included, can be nil.
function math.randomSelect(values, isValid)
    local valuesToUse = values
    if isValid then
        valuesToUse = table.shallowcopy(values)
        for i = #valuesToUse, 1, -1 do
            if not isValid(valuesToUse[i]) then
                table.remove(valuesToUse, i)
            end
        end
    end
    return valuesToUse[math.random(1, #valuesToUse)]
end

function math.randomPositionOnCircle(radius, minDeg, maxDeg)
    minDeg = minDeg or 0
    maxDeg = maxDeg or 359

    local angleDeg = math.random(minDeg, maxDeg)
    local angleRad = math.rad(angleDeg)
    local x = math.cos(angleRad) * radius
    local y = math.sin(angleRad) * radius
    return x, y
end

function math.repeatValue(t, length)
	return math.clamp(t - math.floor(t / length) * length, 0, length)
end

function math.deltaAngle(current, target)
    local num = math.repeatValue(target - current, 360)
    if num > 180 then
        num -= 360;
    end

    return num
end

-- options needs to be a table of { x = 0, y = 0 } values.
function math.getClosestTo(targetX, targetY, checkList)
    local closestDistanceSq = 99999
    local closest = nil

    for _, check in ipairs(checkList) do
        local distanceSq = math.distanceSq(targetX, targetY, check.x, check.y)
        if distanceSq < closestDistanceSq then
            closestDistanceSq = distanceSq
            closest = check
        end
    end

    return closest
end

-- Returns angle between vecs in degrees.
function math.angleBetween(x1, y1, x2, y2)
    local dot = math.dot(x1, y1, x2, y2)
    local length1 = math.length(x1, y1)
    local length2 = math.length(x2, y2)
    return math.deg(math.acos(dot / (length1 * length2)))
end

function math.dot(x1, y1, x2, y2)
    return (x1 * x2) + (y1 * y2)
end

function math.reflect(dirX, dirY, normalX, normalY)
    local projection = math.dot(dirX, dirY, normalX, normalY)
    local reflectX = dirX - (2 * normalX * projection)
    local reflectY = dirY - (2 * normalY * projection)

    return reflectX, reflectY
end

function math.getDeg0To360(degrees)
    return (degrees % 360 + 360) % 360;
end