--required classes
--re-usable
local base = require("src.re-usable.baseClasses")
local window = require("src.re-usable.windowClasses")

--required resources
--constants
local screen_data = require("resources.constants.screen_data")

local dObj = {}

dObj.ObjectUI = base.ObjectUI

dObj.InformationWindow = Class {__includes = base.ObjectUI,
  init = function(self, x, y, text, w, h)
    base.ObjectUI.init(self, x, y, w, h)
    self.window = window.Window(x - w/2, y - h/2, w, h)
    self.text = text

    self.info = love.graphics.newText(window.text_font)

    --determine spacing
    self.horizontal_text_offset = 16
    self.vertical_text_offset = 16

    self.info:setf({window.text_color, self.text}, w - (self.horizontal_text_offset*2), "left")
  end
}

function dObj.InformationWindow:update(dt)
  --if there is no mouse inside the information window, it disappears
end

function dObj.InformationWindow:draw()
  self.window:draw()
  --draw text (if any)

  if self.info then
      --print text
      love.graphics.draw(self.info,
        self.window.pos.x + self.horizontal_text_offset,
        self.window.pos.y + self.vertical_text_offset)
  end
end

dObj.DialogueWindow = Class {__includes = base.ObjectUI,
  init = function(self, dialogue)
    base.ObjectUI.init(self, screen_data.positions.bot_center.x,
                             screen_data.positions.bot_center.y - screen_data.height/3,
                             screen_data.width/1.5,
                             screen_data.height/4)

    self.window = window.Window(self.pos.x - self.w/2, self.pos.y - self.h/2, self.w, self.h)

    --strings

    self.dialogue = dialogue
    self.title = love.graphics.newText(title_font, title)

    --current dialogue line index
    self.index = 1

    --text scrolling values
    self.count = 1
    self.current = string.char(self.dialogue[self.index]:byte())
    self.current_draw = love.graphics.newText(window.text_font, self.current)

    --determine spacing
    self.horizontal_text_offset = 16
    self.vertical_text_offset = 16

    self.info:setf({window.text_color, self.current}, self.w - (self.horizontal_text_offset*2), "left")
  end,

  --Static variables
  Speed = 10, DW_Current = nil

}

function dObj.DialogueWindow:update(dt)
  self:advanceText(dt)
end



function Window_Dialogue:advanceText(dt)
    if self.current ~= self.text[index] then
        self.count = self.count + (self.Speed * dt)
        self.current = self.text[index]:sub(1, math.floor(self.count))
        self.current_draw:setf({window.text_color, self.current}, self.w - (self.horizontal_text_offset*2), "left")
    end
end


function dObj.DialogueWindow:NextDialogue()
   if self.index < #self.text then
     self.index = self.index + 1
     self.count = 1
     self.current = ""
   elseif self.index == #self.text then
       self:clear()
   end
end

function dObj.DialogueWindow:clear()
    self.window:clear()
    dObj.DialogueWindow.DW_Current = nil
    self.current = ""
end

function dObj.DialogueWindow:draw()
  self.window:draw()
  if self.current_draw then
      --print text
      love.graphics.draw(self.current_draw,
        self.window.pos.x + self.horizontal_text_offset,
        self.window.pos.y + self.vertical_text_offset)
  end
end

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

return dObj
