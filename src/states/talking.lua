--required src
--objects
local dialogueObjects = require("src.objects.dialogueObjects")

-- talking callbacks
local talking = {}

function talking:init()
  self.previousState = {}
  self.currentDialogue = {}
  self.currentWindow = {}
end

function talking:enter(previous, args)
  --last states
  self.previousState = previous
  self.currentDialogue = args


  --create dialogue window
  self.currentWindow = dialogueObjects.DialogueWindow(self.currentDialogue)
  --[[local currentWindow = dialogueObjects.InformationWindow(
    screen_data.positions.bot_center.x,
    screen_data.positions.bot_left.y - screen_data.height/6,
    "Here is some information",
    screen_data.width/1.5,
    screen_data.height/5)]]
end

function talking:leave()
  self.previousState = nil
end

function talking:update(dt)
  self.previousState:update(dt)
  dialogueObjects.ObjectUI.updateAll(dt)
end

function talking:draw()
  self.previousState:draw()
  dialogueObjects.ObjectUI.drawAll()
  love.graphics.setColor(255, 255, 255)
end

function talking:keyreleased(key)
  if key == "z" then
    self.currentWindow:NextDialogue()
  end
end

function talking:keypressed(key, scancode, isrepeat)

end

function talking:mousereleased()

end

return talking
