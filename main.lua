--Required Libraries
--hump
Class = require("libraries.hump.class")
Gamestate = require("libraries.hump.gamestate")
vector = require("libraries.hump.vector")
Signal = require("libraries.hump.signal")

--hudebug
hudebug = require("libraries.hudebug.hudebug")

function love.load()
  --Gamestates set up here
  Gamestates = {
      title = require("src.states.title"),
      area = require("src.states.area"),
      pause = require("src.states.pause")
  }

  Gamestate.registerEvents()
  Gamestate.switch(Gamestates.title)
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
