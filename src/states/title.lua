--required src
--functions
local textFunctions = require("src.functions.textFunctions")
--required resources
--constants
local screen_data = require("resources.constants.screen_data")
--fonts
local titleFont = love.graphics.newFont("/resources/fonts/Postamt.ttf", 48)
local instructionsFont = love.graphics.newFont("/resources/fonts/Postamt.ttf", 18)

--title callbacks
local title = {}

title.name = "Title"

function title:init()

end

function title:enter(previous, args)
  --temp title object
  titleText = love.graphics.newText(titleFont, "ayurnarman")
  titleWidth = titleText:getWidth()
  titleHeight = titleText:getHeight()

  titlePosition = screen_data.positions.top_center:clone()
  titlePosition.y = titlePosition.y + 64

  instructionsText = love.graphics.newText(instructionsFont, "Press Space to play!")
  instructionsPosition = screen_data.positions.center:clone()
  instructionsWidth = instructionsText:getWidth()
  instructionsHeight = instructionsText:getHeight()

  dialogueDebugText = love.graphics.newText(instructionsFont, dialogueLines[1][1])
  dialogueDebugWidth = dialogueDebugText:getWidth()
  dialogueDebugHeight = dialogueDebugText:getHeight()
end

function title:update(dt)
  --update stuff
end

function title:draw()
  --draw stuff
  --textFunctions.drawTextOnOffset(dialogueDebugText, screen_data.positions.bot_center, vector.new(dialogueDebugWidth/-2, dialogueDebugHeight * - 4))
  --temp title
  textFunctions.drawTextOnOffset(titleText, titlePosition, vector.new(titleWidth/-2, titleHeight/-2))
  textFunctions.drawTextOnOffset(instructionsText, instructionsPosition, vector.new(instructionsWidth/-2, instructionsHeight/-2))
end

function title:keyreleased(key)
  if (key == "escape") then
    love.event.quit()
  end
  if (key == "space") then
    --load level
    Gamestate.switch(Gamestates.area)
  end
end

function title:keypressed(key, scancode, isrepeat)
  if (key == "space") then
    --change color, user feedback
  end
end

function title:mousereleased()

end

return title
