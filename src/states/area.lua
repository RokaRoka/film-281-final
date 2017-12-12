--required src
--functions
local textFunctions = require("src.functions.textFunctions")
local dialogueManager = require("src.functions.dialogueManager")
local mathFunctions = require("src.functions.mathFunctions")
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
  --hudebug.toggle()

  --Create objects
  --Create physics world
  local p_world = gameObjects.PhysicsWorld(0, 0, false)

  --create player
  local player = gameObjects.Player(screen_data.positions.center:unpack())
  player:registerInputs()
  player:initPhysics(p_world.world)

  local firstNPC = gameObjects.NPC(64, screen_data.positions.center.y, dialogueManager.dialogueLines[1])
  firstNPC:initPhysics(p_world.world)

  bgImg = gameObjects.BackgroundImage("resources/images/Environment/tempBG.png")
  --local secondNPC = gameObjects.NPC(screen_data.width - 64, screen_data.positions.center.y, dialogueManager.dialogueLines[2])
  --secondNPC:initPhysics(p_world.world)

end

function area:update(dt)
  --update stuff
  gameObjects.Object.updateAll(dt)
end

function area:draw()
  --draw stuff
  bgImg:specialDraw()
  gameObjects.Object.drawAll()
  hudebug.draw()
  love.graphics.setColor(255, 255, 255)
end

function area:keyreleased(key)
  if key == "tab" then
    hudebug.nextPage()
  end
  if key == "z" then
    Signal.emit('player-check')
  end
end

function area:keypressed(key, scancode, isrepeat)

end

function area:mousereleased()

end

return area
