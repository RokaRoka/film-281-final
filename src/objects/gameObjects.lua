--required Libraries
--hump
local Class = require("libraries.hump.class")
local Gamestate = require("libraries.hump.gamestate")
local vector = require("libraries.hump.vector")
local Signal = require("libraries.hump.signal")

--required classes
--re-usable
local base = require("src.re-usable.baseClasses")
local physics = require("src.re-usable.physicsClasses")
local graphics = require("src.re-usable.graphicsClasses")
local window = require("src.re-usable.windowClasses")

Player = Class{__includes = base.Object,
	init = function(self, x, y)
		base.Object.init(self, x, y, 32, 32)

		self.in_range_of = {}

		self.drawable = true
	end,

  currentSpeed = vector(0, 0),

	--player default values
  acceleration = 10,
  maxVelocity = 15
}

function Player:update(dt)
	if not player.busy then
		self:walk(dt)
		self:checkAction(dt)
	end
end

function Player:walk(dt)
	local dx, dy = 0, 0
	if love.keyboard.isDown('left') then
        dx = -1 * maxVelocity
    elseif love.keyboard.isDown('right') then
        dx = maxVelocity
    end
    if love.keyboard.isDown('up') then
        dy = -1 * maxVelocity
    elseif love.keyboard.isDown('down') then
        dy = maxVelocity
    end
    self:move(dt, dx, dy)
end

function Player:move(dt, dx, dy)
	local delta = vector(dx, dy)
	--work on this a bit more
  currentSpeed.x = currentSpeed.x + (delta.x - currentSpeed.x)
	self.p_body.body:setLinearVelocity(, delta.y * (dt * 100))
	local newPx, newPy = self.p_body.body:getPosition()
	newPx = math.floor(newPx)
	newPy = math.floor(newPy)

	self.pos = vector.new(newPx, newPy)
end

function Player:checkAction(dt)
	if self.in_range_of[1] and key_press.check("z") then
		self.debug.text = "Player talking!"
		self.in_range_of[1].interact:response()
	end
end

function Player:draw()
	if self.debug_img and self.debug.drawable then
		self.debug_img:draw()
	elseif self.currentAnim then
		self.currentAnim:draw()
	end
	love.graphics.print(self.debug.text, 600, 10)
end
