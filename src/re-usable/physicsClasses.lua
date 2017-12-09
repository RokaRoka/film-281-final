local physics = {}

--physics classes give a parent object either a body or a shape and a fixture.
--The body is stored in p_body
--The shape is stored in p_shapes[]
--The fixture is stored in p_fixtures[]

physics.PhysicsBody = Class {
	--parent containing, initial x pos, initial y pos, type of body (static, kinematic, dynamic), shape, width/radius, height
	init = function(self, world, init_x, init_y, bodytype)
		self.body = love.physics.newBody(world, init_x, init_y, bodytype)
		--additional options?
	end
}

physics.PhysicsShape = Class{
	init = function(self, p_body, shape, wr, h, off_x, off_y, isTrigger)
		self.shapes = {}
		self.fixtures = {}

		self:addShape(p_body.body, shape, wr, h, off_x, off_y, isTrigger)
	end
}

function physics.PhysicsShape:addShape(body, shape, wr, h, off_x, off_y, isTrigger)
	if shape == "circle" then
		if off_x or off_y then
			newShape = love.physics.newCircleShape(off_x, off_y, wr)
		else
			newShape = love.physics.newCircleShape(wr) end
	elseif shape == "square" then
		if off_x or off_y then
			newShape = love.physics.newRectangleShape(off_x, off_y, wr, wr)
		else
			newShape = love.physics.newRectangleShape(wr, wr) end
	elseif shape == "rectangle" then
		if off_x or off_y then
			newShape = love.physics.newRectangleShape(off_x, off_y, wr, h)
		else
			newShape = love.physics.newRectangleShape(wr, h) end
	end

	newFixture = love.physics.newFixture(body, newShape)

	if isTrigger then
		self.fixture:setSensor(true)
		--self.fixture:setCategory(layers.trigger)
	end

	self.shapes[#self.shapes + 1] = newShape
	self.fixtures[#self.fixtures + 1] = newFixture
end

--do some work on the physics boundry to match the above classes (specifically PhysicsBody)
physics.PhysicsBoundry = Class{
	init = function(self, x, y, w, h)
		self.body = love.physics.newBody(physics.world, x, y, "kinematic")
		self.edges = {}

		--norhtmost
		self.edges[1] = love.physics.newEdgeShape(x, y, x + w, y)
		--eastmost
		self.edges[2] = love.physics.newEdgeShape(x + w, y, x + w, y + h)
		--southmost
		self.edges[3] = love.physics.newEdgeShape(x + w, y + h, x, y + h)
		--westmost
		self.edges[4] = love.physics.newEdgeShape(x, y + h, x, y)

		self.fixtures = {}
		self.fixtures[1] = love.physics.newFixture(self.body, self.edges[1])
		self.fixtures[2] = love.physics.newFixture(self.body, self.edges[2])
		self.fixtures[3] = love.physics.newFixture(self.body, self.edges[3])
		self.fixtures[4] = love.physics.newFixture(self.body, self.edges[4])
	end
}

return physics
