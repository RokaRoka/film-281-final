local base = {}

base.Debug = Class{
	init = function(self, text, index, page)
		self.text = text
		self.index = index or 1
		self.page = page or 2

		self.drawable = true

		self:updateText()
	end,
	color = {75, 75, 200, 255},
	Toggle = function()
		hudebug.toggle()
	end
}

function base.Debug:updateText()
	hudebug.updateMsg(self.page, self.index, self.text)
end

--BASE CLASS - Object
--PURPOSE - A base class for all  objects that appear in the world
base.Object = Class{
	init = function(self, x, y, w, h)
		self.pos = vector.new(x, y)
		self.w = w
		self.h = h

		--bool for if the function can be drawn or not
		self.drawable = true

		self.obj_i = base.Object.obj_i + 1
		base.Object.all[self.obj_i] = self
		base.Object.obj_i = self.obj_i

		self.debug = base.Debug("Object "..self.obj_i.." Spawned!", self.obj_i)
	end,
	all = {}, obj_i = 0,

	updateAll = function(dt)
		for i = 1, base.Object.obj_i do
			local current = base.Object.all[i]
			current:update(dt)
		end
	end,

	drawAll = function()
		for i = 1, base.Object.obj_i do
			local current = base.Object.all[i]
			--do this later, for now, draw hitboxes
			if current.drawable then
				current:draw()
			end
			if current.debug.drawable then
				love.graphics.setColor(current.debug.color)
				love.graphics.rectangle("line", current.pos.x - (current.w/2), current.pos.y - (current.h/2), current.w, current.h)
				if current.p_trigger then
					love.graphics.circle("line", current.pos.x, current.pos.y, current.p_trigger.shape:getRadius())
				end
				love.graphics.setColor(255, 255, 255)
			end
		end
	end
}

--create empty update and draw function
function base.Object:update(dt)
  --bark bark bark
	if self.debug then
		self.debug:updateText()
	end
end

function base.Object:draw()
  --moew meow meow
end

--BASE CLASS - ObjectUI
--PURPOSE - A base class for all  objects that appear in the world
base.ObjectUI = Class{
	init = function(self, x, y, w, h)
		self.pos = vector.new(x, y)
		self.w = w
		self.h = h

		--bool for if the function can be drawn or not
		self.drawable = true

		self.obj_i = base.ObjectUI.obj_i + 1
		base.ObjectUI.all[self.obj_i] = self
		base.ObjectUI.obj_i = self.obj_i

		self.debug = base.Debug("UI Object "..self.obj_i.." Spawned!", self.obj_i)
	end,
	all = {}, obj_i = 0,

	updateAll = function(dt)
		for i = 1, base.ObjectUI.obj_i do
			local current = base.ObjectUI.all[i]
			current:update(dt)
		end
	end,

	drawAll = function()
		for i = 1, base.ObjectUI.obj_i do
			local current = base.ObjectUI.all[i]
			--do this later, for now, draw hitboxes
			if current.drawable then
				current:draw()
			end
			if current.debug.drawable then
				love.graphics.setColor(current.debug.color)
				love.graphics.rectangle("line", current.pos.x - (current.w/2), current.pos.y - (current.h/2), current.w, current.h)
				love.graphics.setColor(255, 255, 255)

				if current.p_trigger then
					love.graphics.circle("line", current.pos.x, current.pos.y, current.p_trigger.shape:getRadius())
				end
			end
		end
	end
}

--create empty update and draw function
  function base.ObjectUI:update(dt)
    --barko barko barko
		if self.debug then
			self.debug:updateText()
		end
  end

  function base.ObjectUI:draw()
    --moewo meowo meowo
  end

return base
