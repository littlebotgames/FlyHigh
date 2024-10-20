function Graphics.imagetable:copy()
    local copy = Graphics.imagetable.new(#self)
    for i = 1, #self, 1 do
        copy:setImage(i, self[i]:copy())
    end
    return copy
end

function Graphics.imagetable:scaledImageTable(scale)
    local copy = Graphics.imagetable.new(#self)
    for i = 1, #self, 1 do
        copy:setImage(i, self[i]:scaledImage(scale))
    end
    return copy
end

function Graphics.imagetable:rotatedImageTable(degrees)
    local copy = Graphics.imagetable.new(#self)
    for i = 1, #self, 1 do
        copy:setImage(i, self[i]:rotatedImage(degrees))
    end
    return copy
end