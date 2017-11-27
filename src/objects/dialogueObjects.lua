--required Libraries
--hump
local Class = require("libraries.hump.class")
local Gamestate = require("libraries.hump.gamestate")

--required classes
--re-usable
require("src.re-usable.baseClasses")
require("src.re-usable.windowClasses")

--put this in a dialouge object class later
--Window.img.default = love.graphics.newImage("resources/images/Windows/window_default.png")


--[[WINDOW DIALOGUE CLASS
Window_Dialogue = Class {
    init = function(self, t_text, title)
        --strings

        self.text = t_text
        --self.title = love.graphics.newText(title_font, title)

        --current dialogue
        self.index = 1

        --text scrolling values
        self.count = 1
        self.current = string.char(self.text[self.index]:byte())
        self.current_draw = love.graphics.newText(text_font, self.current)

        --string info
        self.textHeight = self.current_draw:getHeight()

        --Window creation (x, y, w, h, winImg, parent)
        self.window = Window(100, 600 - 160, 600, 128, nil, self)

        --make the player busy
        player.busy = true
    end,
    --Static variables
    Speed = 10, DW_Current = nil
}

function Window_Dialogue:update(dt)
    if love.keyboard.isDown('x') then
        Window_Dialogue.Speed = 30
    else
        Window_Dialogue.Speed = 10
    end
    self:advanceText(dt, self.index)
end

function Window_Dialogue:draw()
    --draw text (if any)

    local horizontal_text_offset
    local vertical_text_offset

    if self.text and self.title then --FIX

    else
        if self.text then
            --determine spacing
            horizontal_text_offset = 16 --+ 16 + 4
            vertical_text_offset = self.textHeight/4
            --print text
            love.graphics.draw(self.current_draw, self.window.pos.x + horizontal_text_offset, self.window.pos.y + 16 + (self.textHeight*(1-1)) + vertical_text_offset*1)
        end
        if self.title then -- FIX
            --determine spacing
            horizontal_text_offset = 16 --+ 16 + 4
            vertical_text_offset = self.textHeight/8
            --print title
            love.graphics.draw(self.title, self.window.pos.x + horizontal_text_offset, self.window.pos.y + 16 + (self.textHeight*(1-1)) + vertical_text_offset*1)
        end
    end
end

function Window_Dialogue:advanceText(dt, index)
    if self.current ~= self.text[index] then
        self.count = self.count + (self.Speed * dt)
        self.current = self.text[index]:sub(1, math.floor(self.count))
        self.current_draw = love.graphics.newText(text_font, self.current)
    elseif key_press.check("z") then
       if index < #self.text then
           self:loadNext()
       elseif index == #self.text then
           self:clear()
       end
    end
end

function Window_Dialogue:loadNext()
    self.index = self.index + 1
    self.count = 1
    self.current = ""
end

function Window_Dialogue:clear()
    self.window:clear()
    Window_Dialogue.DW_Current = nil
    self.current = ""
    player.busy = false
end
]]
