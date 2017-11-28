--required library
--hump
local Gamestate = require("libraries.hump.gamestate")
local vector = require("libraries.hump.vector")

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
  local Gamestates = args.GameStates

end

function area:update(dt)
  --update stuff
end

function area:draw()
  --draw stuff
  end

function area:keyreleased()

end

function area:keypressed(key, scancode, isrepeat)

end

function area:mousereleased()

end

return area
