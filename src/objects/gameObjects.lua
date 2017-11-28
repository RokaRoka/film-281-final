--required classes
--re-usable
local base = require("src.re-usable.baseClasses")
local physics = require("src.re-usable.physicsClasses")
local graphics = require("src.re-usable.graphicsClasses")
local window = require("src.re-usable.windowClasses")

local gObj = {}

--ref to base classes
gObj.Debug = base.Debug
gObj.Object = base.Object
gObj.ObjectUI = base.ObjectUI

gObj.Player = Class{__includes = base.Object,
	init = function(self, x, y)
		base.Object.init(self, x, y, 32, 32)

		

		self.currentSpeed = vector.new(0, 0)
	end,

	--player default values
  acceleration = 4,
  maxVelocity = 10
}

function gObj.Player:update(dt)
	self:walk(dt)
	--self:checkAction(dt)
end

function gObj.Player:walk(dt)
	local dx, dy = 0, 0
	if love.keyboard.isDown('left') then
      dx = -1 * self.maxVelocity
  elseif love.keyboard.isDown('right') then
      dx = self.maxVelocity
  end
  if love.keyboard.isDown('up') then
      dy = -1 * self.maxVelocity
  elseif love.keyboard.isDown('down') then
      dy = self.maxVelocity
  end
  self:move(dt, dx, dy)
end

function gObj.Player:move(dt, dx, dy)
	local delta = vector(dx, dy)
	local direction = vector.new(0, 0)
	if delta.x - self.currentSpeed.x == math.abs(delta.x - self.currentSpeed.x) then
		direction.x = 1
	else
		direction.x = -1
	end

	if delta.y - self.currentSpeed.y == math.abs(delta.y - self.currentSpeed.y) then
		direction.y = 1
	else
		direction.y = -1
	end

  self.currentSpeed = self.acceleration *	direction

	if delta.x - self.currentSpeed.x == math.abs(delta.x - self.currentSpeed.x) then
		if direction.x == -1 then
			self.currentSpeed.x = delta.x
		end
	elseif direction.x == 1 then
		self.currentSpeed.x = delta.x
	end

	if delta.y - self.currentSpeed.y == math.abs(delta.y - self.currentSpeed.y) then
		if direction.y == -1 then
			self.currentSpeed.x = delta.y
		end
	elseif direction.y == 1 then
		self.currentSpeed.y = delta.y
	end

	self.pos = self.pos + self.currentSpeed
	--self.p_body.body:setLinearVelocity(, delta.y * (dt * 100))
	--local newPx, newPy = self.p_body.body:getPosition()
	--newPx = math.floor(newPx)
	--newPy = math.floor(newPy)

	--self.pos = vector.new(newPx, newPy)
end

function gObj.Player:checkAction(dt)
	--if self.in_range_of[1] then
		--self.debug.text = "Player talking!"
		--self.in_range_of[1].interact:response()
	--end
end

function gObj.Player:draw()
	--draw player img, if applicable

end

return gObj
