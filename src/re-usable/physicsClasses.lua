world = love.physics.newWorld(0, 0)

PhysicsBody = Class {
	--parent containing, initial x pos, initial y pos, type of body (static, kinematic, dynamic), shape, width/radius, height
	init = function(self, parent, init_x, init_y, bodytype, shape, wr, h)
		self.body = love.physics.newBody(world, init_x, init_y, bodytype)
		--additional options?
	end
}

PhysicsShape = Class{
	init = function(self, parent, shape, wr, h, off_x, off_y, isTrigger)
		if shape == "circle" then
			if off_x or off_y then self.shape = love.physics.newCircleShape(off_x, off_y, wr)
			else self.shape = love.physics.newCircleShape(wr) end
		elseif shape == "square" then
			if off_x or off_y then  self.shape = love.physics.newRectangleShape(off_x, off_y, wr, wr)
			else self.shape = love.physics.newRectangleShape(wr, wr) end
		elseif shape == "rectangle" then
			if off_x or off_y then  self.shape = love.physics.newRectangleShape(off_x, off_y, wr, h)
			else self.shape = love.physics.newRectangleShape(wr, h) end
		end
		self.fixture = love.physics.newFixture(parent.p_body.body, self.shape)
    if isTrigger then
      self.fixture:setSensor(true)
      --self.fixture:setCategory(layers.trigger)
      --self.fixture:setMask(layers.boundry, layers.wall)
    end
	end
}

PhysicsBoundry = Class{
	init = function(self, x, y, w, h)
		self.body = love.physics.newBody(world, x, y, "kinematic")
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
