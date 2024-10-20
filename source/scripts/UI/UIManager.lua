import "scripts/UI/DialogueBox"

UIManager = {}

UIPageID = 
{
    Dialogue = "Dialogue",
}

local Pages = 
{
    [UIPageID.Dialogue] = DialogueBox(),
}

UIManager.currentPages = {}
UIManager.imageCache = {}
UIManager.textImageCache = {}

function UIManager:showPage(pageID, showParams)
    local page = Pages[pageID]
    page:add(0, 0)
    if page["onShow"] then
        page:onShow(showParams)
    end
    table.insert(self.currentPages, pageID)
    return page
end

function UIManager:hidePage(pageID)
    local page = Pages[pageID]
    if page["onHide"] then
        page:onHide()
    end
    page:remove()
    table.removeValue(self.currentPages, pageID)
end

function UIManager:isShowing(pageID)
    return table.contains(self.currentPages, pageID)
end

function UIManager:getImage(path)
    local image = self.imageCache[path]
    if not image then
        image = Graphics.image.new(path)
        self.imageCache[path] = image
    end
    
    return image
end

function UIManager:getTextImage(text, font)
    font = font or Graphics.getFont()
    local image = self.textImageCache[text]
    if not image then
        local textWidth, textHeight = Graphics.getTextSize(text)
        Noble.Text.setFont(font)
        image = Graphics.imageWithText(text, textWidth, textHeight)
        self.textImageCache[text] = image
    end

    return image
end