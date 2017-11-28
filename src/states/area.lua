--required src
--functions
local textFunctions = require("src.functions.textFunctions")
--objects
local gameObjects = require("src.objects.gameObjects")

--required resources
--constants
local screen_data = require("resources.constants.screen_data")

--area callbacks
local area = {}

function area:init()

end

function area:enter(previous, args)
  --set up hudebug
  hudebug.pageName(1, "Master Debug")
  hudebug.pageName(2, "Objects")
  hudebug.updateMsg(1, 1, "Test")
  hudebug.setPosition(screen_data.positions.top_left:unpack())
  hudebug.toggle()

  --create player
  local player = gameObjects.Player(screen_data.positions.center:unpack())
end

function area:update(dt)
  --update stuff
end

function area:draw()
  --draw stuff
  hudebug.draw()
end

function area:keyreleased()

end

function area:keypressed(key, scancode, isrepeat)

end

function area:mousereleased()

end

return area
