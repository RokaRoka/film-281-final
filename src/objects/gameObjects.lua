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

		self.world:setCallbacks(self.beginContact, self.endContact)
	end,

	onBeginContact = {}, onEndContact = {}
}

function gObj.PhysicsWorld:addBeginContactFunction(beginFunction)
	onBeginContact[#onBeginContact + 1] = beginFunction
end

function gObj.PhysicsWorld:addEndContactFunction(endFunction)
	onEndContact[#onEndContact + 1] = endFunction
end

function gObj.PhysicsWorld:beginContact(fixtureA, fixtureB, contact)
	--callback stuff here!
	if #gObj.PhysicsWorld.onBeginContact > 0 then
		for i, v in ipairs(gObj.PhysicsWorld.onBeginContact) do
			gObj.PhysicsWorld.onBeginContact[i](fixtureA, fixtureB, contact)
		end
	end
end

function gObj.PhysicsWorld:endContact(fixtureA, fixtureB, contact)
	--callback stuff here!
	if #gObj.PhysicsWorld.onEndContact > 0 then
		for i, v in ipairs(gObj.PhysicsWorld.onEndContact) do
			gObj.PhysicsWorld.onEndContact[i](fixtureA, fixtureB, contact)
		end
	end
end

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
  acceleration = 0.8,
  maxVelocity = 100
}

function gObj.Player:initPhysics(world)
	self.p_body = physics.PhysicsBody(self, world, self.pos.x, self.pos.y, "dynamic")
	self.p_shape = physics.PhysicsShape(self, self.p_body, "circle", self.w/2)
	self.p_shape.fixtures[1]:setUserData(self)
end

function gObj.Player:update(dt)
	self:walk(dt)
	--self:checkAction(dt)

	if self.debug then
		self:updateDebug()
		self.debug:updateText()
	end
end

--PLAYER MECHANICS

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

  self.currentSpeed = lerp(self.currentSpeed, delta, self.acceleration)

	if self.p_body == nil then
		self.pos = self.pos + ((dt * 10) * self.currentSpeed)
	else
		newVelocity = vector.new(math.clamp(self.maxVelocity * -1, self.currentSpeed.x, self.maxVelocity),
		 												 math.clamp(self.maxVelocity * -1, self.currentSpeed.y, self.maxVelocity))
		self.p_body.body:setLinearVelocity(newVelocity:unpack())
	end
end

function gObj.Player:checkAction(dt)
	--if self.in_range_of[1] then
		--self.debug.text = "Player talking!"
		--self.in_range_of[1].interact:response()
	--end
end

--PLAYER PHYSICS CALLBACKS

function gObj.Player:beginContact(fixtureA, fixtureB, contact)
	--anything
end

function gObj.Player:draw()
	--draw player img, if applicable
	if self.p_body then
		local newPx, newPy = self.p_body.body:getPosition()
		newPx = math.floor(newPx)
		newPy = math.floor(newPy)
		self.pos = vector.new(newPx, newPy)
	end

	if self.image then
		love.graphics.draw(self.image, self.pos.x + self.imageOffset.x, self.pos.y + self.imageOffset.y)
	end
end

gObj.NPC = Class{__includes = base.Object,
	init = function(self, x, y)
		base.Object.init(self, x, y, 32, 32)

		self.image = love.graphics.newImage("resources/images/Characters/innuk_v1.png")
		self.imageOffset = vector.new(self.image:getDimensions())
		self.imageOffset = -0.5 * self.imageOffset
		self.imageOffset.y = self.imageOffset.y - 16

	end
}

function gObj.NPC:initPhysics(world)
	self.p_body = physics.PhysicsBody(self, world, self.pos.x, self.pos.y, "static")
	self.p_shape = physics.PhysicsShape(self, self.p_body, "circle", self.w/2)
	self.p_shape.fixtures[1]:setUserData(self)
end

function gObj.NPC:update(dt)
	if self.debug then
		self:updateDebug()
		self.debug:updateText()
	end
end

--PLAYER PHYSICS CALLBACKS

function gObj.NPC:beginContact(fixtureA, fixtureB, contact)
	--anything
end

function gObj.NPC:draw()
	--draw player img, if applicable
	if self.image then
		love.graphics.draw(self.image, self.pos.x + self.imageOffset.x, self.pos.y + self.imageOffset.y)
	end
end

gObj.PhysicsBoundryObject = Class {__includes = base.Object,
	init = function(self, parent, world,  x, y, w, h)
		base.Object.init(x, y, w, h)
		p_boundry = physics.PhysicsBoundry(parent, world, x, y, w, h)
	end
}

return gObj
