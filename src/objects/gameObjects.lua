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

	beginContact = function(fixtureA, fixtureB, contact)
		--callback stuff here!
		Signal.emit('begin-contact', fixtureA, fixtureB, contact)
	end,
	endContact = function(fixtureA, fixtureB, contact)
		--callback stuff here!
		Signal.emit('end-contact', fixtureA, fixtureB, contact)
	end
}

function gObj.PhysicsWorld:update(dt)
	self.world:update(dt)
end

gObj.Player = Class{__includes = base.Object,
	init = function(self, x, y)
		base.Object.init(self, x, y, 32, 32)

		self.name = 'Player'

		self.image = love.graphics.newImage("resources/images/Characters/innuk_v1.png")
		self.imageOffset = vector.new(self.image:getDimensions())
		self.imageOffset = -0.5 * self.imageOffset
		self.imageOffset.y = self.imageOffset.y - 16

		self.currentSpeed = vector.new(0, 0)

		self.NPCinRange = false
		self.inputCooldown = 0
	end,

	--player default values
  acceleration = 0.8,
  maxVelocity = 140
}

function gObj.Player:initPhysics(world)
	self.p_body = physics.PhysicsBody(self, world, self.pos.x, self.pos.y, "dynamic")
	self.p_shape = physics.PhysicsShape(self, self.p_body, "circle", self.w/2)
	self.p_shape.fixtures[1]:setUserData(self)

end

function gObj.Player:updateDebug()
	self.debug.text = "Player of Object "..self.obj_i.." position is "..self.pos.x..", "..self.pos.y..". Name is and "..self.name.." and NPC detection "
	if self.NPCinRange then
		self.debug.text = self.debug.text.." true!"
	else
		self.debug.text = self.debug.text.." false!"
	end
end

function gObj.Player:update(dt)
	self:walk(dt)
	--self:checkAction(dt)

	if self.debug then
		self:updateDebug()
		self.debug:updateText()
	end
end

--PLAYER HANDLING

function gObj.Player:registerInputs()
	Signal.register('player-check', function() self:checkAction() end)
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

function gObj.Player:checkAction()
	if self.NPCinRange and self.inputCooldown <= 0 then
		Signal.emit('player-talk')
	end
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
	init = function(self, x, y, dialogue)
		base.Object.init(self, x, y, 32, 32)

		self.name = 'NPC'
		self.dialogue = dialogue or {"I'm the default inuit NPC dialogue!",
																 "If you see this, something may be wrong. OR right, if you are Sam and debugging this."}

		self.canTalkImage = love.graphics.newImage("resources/images/Characters/notice.png")
		self.canTalk = false

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

	Signal.register('begin-contact', function (fixtureA, fixtureB, contact) self:onBeginContact(fixtureA, fixtureB, contact) end)
	Signal.register('end-contact', function (fixtureA, fixtureB, contact) self:onEndContact(fixtureA, fixtureB, contact) end)
end

function gObj.NPC:update(dt)
	if self.debug then
		self:updateDebug()
		self.debug:updateText()
	end
end

function gObj.NPC:onPlayerTalk()
	--load dialogue
	self.canTalk = false
	Gamestate.push(Gamestates.talking, self.dialogue)
end

--NPC PHYSICS CALLBACKS

function gObj.NPC:onBeginContact(fixtureA, fixtureB, contact)
	--anything
	if fixtureA:getUserData().name == 'Player' then
		local player = fixtureA:getUserData()
		if not player.NPCinRange then
			self.canTalk = true
			player.NPCinRange = true
			Signal.register('player-talk', function() self:onPlayerTalk() end)
		end
	end
	if fixtureB:getUserData().name == 'Player' then
		local player = fixtureB:getUserData()
		if not player.NPCinRange then
			self.canTalk = true
			player.NPCinRange = true
			Signal.register('player-talk', function() self:onPlayerTalk() end)
		end
	end
end

function gObj.NPC:onEndContact(fixtureA, fixtureB, contact)
	--anything else
	if fixtureA:getUserData().name == 'Player' then
		local player = fixtureA:getUserData()
		self.canTalk = false
		if player.NPCinRange then
			self.canTalk = false
			player.NPCinRange = false
			Signal.remove('player-talk', function() self:onPlayerTalk() end)
		end
	end
	if fixtureB:getUserData().name == 'Player' then
		local player = fixtureB:getUserData()
		self.canTalk = false
		if player.NPCinRange then
			self.canTalk = false
			player.NPCinRange = false
			Signal.remove('player-talk', function() self:onPlayerTalk() end)
		end
	end
end

function gObj.NPC:draw()
	--draw player img, if applicable
	if self.image then
		love.graphics.draw(self.image, self.pos.x + self.imageOffset.x, self.pos.y + self.imageOffset.y)
	end
	if self.canTalk then
		love.graphics.draw(self.canTalkImage, self.pos.x + self.imageOffset.x, self.pos.y - 104)
	end
end

gObj.PhysicsBoundryObject = Class {__includes = base.Object,
	init = function(self, parent, world,  x, y, w, h)
		base.Object.init(x, y, w, h)
		p_boundry = physics.PhysicsBoundry(parent, world, x, y, w, h)
	end
}

return gObj
