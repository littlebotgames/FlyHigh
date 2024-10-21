BackgroundLayer = {}

function BackgroundLayer.new(createSprite, amount, moveScalar, getSpawnY)
    local layer = {}
    layer.moveScalar = moveScalar
    layer.getSpawnY = getSpawnY

    layer.sprites = {}
    for i = 1, amount, 1 do
        table.insert(layer.sprites, createSprite())
    end

    layer.add = function(self)
        for index, sprite in ipairs(self.sprites) do
            local centerX, _ = sprite:getCenter()
            local minX = -(centerX * sprite.width)
            local maxX = 400 + (centerX * sprite.width)
            local spacing = (maxX - minX) / #self.sprites
            local moveToX = minX + (spacing * (index - 1))
            sprite:add(moveToX, self.getSpawnY())
        end
    end

    layer.remove = function(self)
        for index, sprite in ipairs(self.sprites) do
            sprite:remove()
        end
    end

    layer.move = function(self, cameraDelta)
        for _, sprite in ipairs(self.sprites) do
            sprite:moveBy(-cameraDelta * self.moveScalar, 0)
            if sprite:getBoundsRect().right < 0 then
                -- Sprite has gone off the side so spawn back at the other side.
                local centerX, _ = sprite:getCenter()
                sprite:moveTo(400 + centerX * sprite.width, self.getSpawnY())
            end
        end
    end

    return layer
end