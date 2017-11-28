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

local gObj = {}

gObj.Player = Class{__includes = Object,
	init = function(self, x, y)
		base.Object.init(self, x, y, 32, 32)

		self.in_range_of = {}

		self.drawable = true

		self.currentSpeed = vector.new(0, 0)
	end,

	--player default values
  acceleration = 10,
  maxVelocity = 15
}

function gObj.Player:update(dt)
	if not self.busy then
		self:walk(dt)
		self:checkAction(dt)
	end
end

function gObj.Player:walk(dt)
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

function gObj.Player:move(dt, dx, dy)
	local delta = vector(dx, dy)
	--work on this a bit more
  --self.currentSpeed.x = self.currentSpeed.x + (delta.x - self.currentSpeed.x)
	--self.p_body.body:setLinearVelocity(, delta.y * (dt * 100))
	--local newPx, newPy = self.p_body.body:getPosition()
	newPx = math.floor(newPx)
	newPy = math.floor(newPy)

	self.pos = vector.new(newPx, newPy)
end

function gObj.Player:checkAction(dt)
	if self.in_range_of[1] then
		--self.debug.text = "Player talking!"
		--self.in_range_of[1].interact:response()
	end
end

function gObj.Player:draw()
	if self.debug_img and self.debug.drawable then
		self.debug_img:draw()
	elseif self.currentAnim then
		self.currentAnim:draw()
	end
	love.graphics.print(self.debug.text, 600, 10)
end

return gObj
