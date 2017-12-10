--required src
--functions
local textFunctions = require("src.functions.textFunctions")
--objects
local gameObjects = require("src.objects.gameObjects")
local dialogueObjects = require("src.objects.dialogueObjects")

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
  hudebug.toggle()

  --Create objects
  --Create physics world
  local p_world = gameObjects.PhysicsWorld(0, 0, false)

  --create player
  local player = gameObjects.Player(screen_data.positions.center:unpack())
  player:initPhysics(p_world.world)

  --create window
  --[[local currentWindow = dialogueObjects.InformationWindow(
    screen_data.positions.bot_center.x,
    screen_data.positions.bot_left.y - screen_data.height/6,
    "Here is some information",
    screen_data.width/1.5,
    screen_data.height/5)]]
    
end

function area:update(dt)
  --update stuff
  gameObjects.Object.updateAll(dt)
  dialogueObjects.ObjectUI.updateAll(dt)
end

function area:draw()
  --draw stuff
  gameObjects.Object.drawAll()
  dialogueObjects.ObjectUI.drawAll()
  hudebug.draw()
  love.graphics.setColor(255, 255, 255)
end

function area:keyreleased(key)
  if (key == "tab") then
    hudebug.nextPage()
  end
end

function area:keypressed(key, scancode, isrepeat)

end

function area:mousereleased()

end

return area
