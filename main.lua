--Required Libraries
--hump
--local Class = require("libraries.hump.class")
local Gamestate = require("libraries.hump.gamestate")
--local vector = require("libraries.hump.vector")
--local Signal = require("libraries.hump.signal")

--hudebug
local hudebug = require("libraries.hudebug.hudebug")

function love.load()
  --GameStates set up here
  local Gamestates = {
      title = require("src.states.title"),
      area = require("src.states.area"),
      pause = require("src.states.pause")
  }

  Gamestate.registerEvents()
  Gamestate.switch(Gamestates.title, Gamestates)
end

function love.update(dt)

end

function love.draw()

end

function love.focus(inFocus)
  --pause game
end

function love.quit()

end
