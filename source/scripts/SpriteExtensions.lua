function Graphics.sprite:drawChildImage(image, x, y)
	local width, height = self:getSize()
	local imageWidth, imageHeight = image:getSize()

	local centerX, centerY = self:getCenter()

	local drawX = (width * centerX) - (imageWidth * centerX) + x
	local drawY = (height * centerY) - (imageHeight * centerY) + y

	image:draw(drawX, drawY)
end

function Graphics.sprite:drawChildAnimationFrame(animation, frameNumber, x, y, imageOffsets)
	local width, height = self:getSize()
	local animWidth, animHeight = animation.imageTable[frameNumber]:getSize()

	local centerX, centerY = self:getCenter()

	local drawX = (width * centerX) - (animWidth * centerX) + x
	local drawY = (height * centerY) - (animHeight * centerY) + y

	imageOffsetX = 0
	imageOffsetY = 0
	if imageOffsets then
		local imageOffsetData = imageOffsets[frameNumber]
		-- imageOffset if an offset from the center of the image so we want to get it relative to the center point instead.
		imageOffsetX = (imageOffsetData[1] + 0.5 - centerX) * animWidth
		imageOffsetY = (imageOffsetData[2] + 0.5 - centerY) * animHeight
	end

	animation:drawFrame(frameNumber, nil, drawX - imageOffsetX, drawY - imageOffsetY)
	return imageOffsetX, imageOffsetY
end

function Graphics.sprite:getLocalBoundsRect()
	local boundsRect = self:getBoundsRect()
	boundsRect:offset(-boundsRect.x, -boundsRect.y)
	return boundsRect
end