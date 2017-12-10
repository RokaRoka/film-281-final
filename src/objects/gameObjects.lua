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

gObj.PhysicsWorld = Class{__includes = base.Object,
	init = function(self, xGrav, yGrav, isAbleToSleep)
		base.Object.init(self, 0, 0, 0, 0)
		self.world = love.physics.newWorld(xGrav, yGrav, isAbleToSleep)
	end
}

function gObj.PhysicsWorld:update(dt)
	self.world:update(dt)
end

gObj.Player = Class{__includes = base.Object,
	init = function(self, x, y)
		base.Object.init(self, x, y, 32, 32)

		self.image = love.graphics.newImage("resources/images/Characters/innuk_v1.png")
		self.imageOffset = vector.new(self.image:getDimensions())
		self.imageOffset = -0.5 * self.imageOffset
		self.imageOffset.y = self.imageOffset.y - 16

		self.currentSpeed = vector.new(0, 0)
	end,

	--player default values
  acceleration = 4,
  maxVelocity = 10
}

function gObj.Player:initPhysics(world)
	self.p_body = physics.PhysicsBody(world, self.pos.x, self.pos.y, "kinematic")
	self.p_shape = physics.PhysicsShape(self.p_body, "circle", 32)
end

function gObj.Player:update(dt)
	self:walk(dt)
	--self:checkAction(dt)

	if self.debug then
		self:updateDebug()
		self.debug:updateText()
	end
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
	local delta = vector.new(dx, dy)
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

	if self.p_body == nil then
		self.pos = self.pos + ((dt * 80) * self.currentSpeed)
	else --fit dt in?
		self.p_body.body:setLinearVelocity(self.currentSpeed:unpack())
		local newPx, newPy = self.p_body.body:getPosition()
		newPx = math.floor(newPx)
		newPy = math.floor(newPy)

		self.pos = vector.new(newPx, newPy)
	end
	--self.p_body.body:setLinearVelocity(, delta.y * (dt * 100))
end

function gObj.Player:checkAction(dt)
	--if self.in_range_of[1] then
		--self.debug.text = "Player talking!"
		--self.in_range_of[1].interact:response()
	--end
end

function gObj.Player:draw()
	--draw player img, if applicable
	if self.image then
		love.graphics.draw(self.image, self.pos.x + self.imageOffset.x, self.pos.y + self.imageOffset.y)
	end
end

return gObj
