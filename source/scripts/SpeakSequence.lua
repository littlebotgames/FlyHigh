SpeakSequence = {}

SpeakSequence.EmIndex = 1
SpeakSequence.OhIndex = 2
SpeakSequence.EhIndex = 3

local soundToIndex =
{
	Em = SpeakSequence.EmIndex,
	Oh = SpeakSequence.OhIndex,
	Eh = SpeakSequence.EhIndex
}

function SpeakSequence.new(sequence, onFrameChanged, onFrameChangedContext)
	local speakSequence = {}
	speakSequence.sequence = sequence
	speakSequence.frame = 0
	speakSequence.mouthFrame = 1
	speakSequence.playing = false

	function speakSequence:setFrame(frame)
		self.frame = frame
		local frameData = self.sequence.frames[self.frame]
		self.mouthFrame = soundToIndex[frameData.mouthFrame]

		if onFrameChanged then
			onFrameChanged(onFrameChangedContext)
		end
	end

	function speakSequence:progressSequence()
		local nextFrame = self.frame + 1
		if nextFrame > #self.sequence.frames then
			if self.sequence.loop then
				nextFrame = 1
			else
				-- Sequence has finished.
				self.playing = false
				return
			end
		end
        
		self:setFrame(nextFrame)
        if self.playing then
			self:playCurrentFrame()
		end
	end

	function speakSequence:playCurrentFrame()
		if self.frame < #self.sequence.frames or self.sequence.loop then
			local frameData = self.sequence.frames[self.frame]
			self.timer = playdate.timer.performAfterDelay(frameData.delay * 1000, self.progressSequence, self)
		end
	end

	function speakSequence:start()
		self.playing = true
		self:playCurrentFrame()
	end

	function speakSequence:stop()
		self.playing = false
		if self.timer then
			self.timer:remove()
		end
	end

	-- Setup 1st frame.
	speakSequence:setFrame(1)
	return speakSequence
end