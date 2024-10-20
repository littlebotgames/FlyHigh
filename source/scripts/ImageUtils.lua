ImageUtils = {}

-- Return a new image which is the baseImage with an outline.
function ImageUtils.createOutlinedImage(baseImage, outlineWidth)
    local outlineWidth = outlineWidth or 3
    local baseImageRect = Geometry.rect.new(0, 0, baseImage:getSize())
    -- Scale the image to create an outline that will be drawn 1st.
    local tempOutlineImage = baseImage:scaledImage((baseImageRect.height + outlineWidth) / baseImageRect.height)
    -- Add the outline width to the rect to get the size for the final image.
    baseImageRect:inset(-outlineWidth, -outlineWidth)
    -- Offset so x, y is 0, 0
    baseImageRect:offset(-baseImageRect.x, -baseImageRect.y)

    -- Create the final image by drawing the outline image and the normal image on top.
    local baseImage = Graphics.image.new(baseImageRect.width, baseImageRect.height)
    Graphics.pushContext(baseImage)
    Graphics.setImageDrawMode(Graphics.kDrawModeFillWhite)
    tempOutlineImage:drawCentered(baseImageRect.width / 2, baseImageRect.height / 2)
    Graphics.setImageDrawMode(Graphics.kDrawModeCopy)
    baseImage:drawCentered(baseImageRect.width / 2, baseImageRect.height / 2)
    Graphics.popContext()

    return tempOutlineImage
end