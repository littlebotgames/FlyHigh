local StringBuilder = import "scripts/StringBuilder"

TextTypewriter = {}

function TextTypewriter.new(delaySecs, onTextChanged, onTextChangedContext)
	local textTypewriter = {}
	textTypewriter.text = nil
    textTypewriter.textPosition = 0
    textTypewriter.currentText = StringBuilder();

    function textTypewriter:start()
        self.textPosition = 0
        self.updateTimer:reset()
        self.updateTimer:start()
	end

	function textTypewriter:progressText()
        if self.text == nil or self.textPosition == #self.text then
            return
        end

        self.textPosition += 1
        local nextString = string.sub(self.text, self.currentText:getLength() + 1, self.textPosition)
		self.currentText:append(nextString)

        if self.textPosition == #self.text then
            self.updateTimer:pause()
        end

        if onTextChanged then
            onTextChanged(onTextChangedContext)
        end
	end

	function textTypewriter:getCurrentText()
        return self.currentText:toString()
	end

    function textTypewriter:skipToEnd()
        self.textPosition = #self.text - 1
        self:progressText()
	end

    function textTypewriter:setText(text)
        self.text = text
        self.currentText:clear()
        self:start()
	end

    function textTypewriter:hasFinished()
        return self.textPosition == #self.text
	end

    -- Create the update timer but pause it to begin with until start is called.
    local updateTimer = Timer.keyRepeatTimerWithDelay(0, delaySecs * 1000, textTypewriter.progressText, textTypewriter)
    updateTimer:pause()
    textTypewriter.updateTimer = updateTimer

	return textTypewriter
end