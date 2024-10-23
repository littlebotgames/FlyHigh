import "scripts/SpriteExtensions"

BackgroundLayer = {}

function BackgroundLayer.new(createSprite, amount, moveScalar, getSpawnY, width)
    local layer = {}
    layer.moveScalar = moveScalar
    layer.getSpawnY = getSpawnY
    layer.width = width
    layer.minX = 200 - width * 0.5
    layer.maxX = 200 + width * 0.5

    layer.sprites = {}
    for i = 1, amount, 1 do
        table.insert(layer.sprites, createSprite())
    end

    layer.add = function(self)
        for index, sprite in ipairs(self.sprites) do
            local spacing = (self.maxX - self.minX) / #self.sprites
            local moveToX = self.minX + (spacing * (index - 1))
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
            if sprite.x < self.minX then
                -- Sprite has gone off the side so spawn back at the other side.
                sprite:moveTo(self.maxX, self.getSpawnY())
            end
        end
    end

    return layer
end