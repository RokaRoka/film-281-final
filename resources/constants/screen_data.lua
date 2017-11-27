--required Libraries
--hump
local vector = require("libraries.hump.vector")

local width, height = love.graphics.getDimensions()

local s_d = {}

s_d.positions = {}
s_d.positions.top_left = vector.new(0, 0)
s_d.positions.top_center = vector.new(width/2, 0)
s_d.positions.top_right = vector.new(width, 0)

s_d.positions.left = vector.new(0, height/2)
s_d.positions.center = vector.new(width/2, height/2)
s_d.positions.right = vector.new(width, height/2)

s_d.positions.bot_left = vector.new(0, height)
s_d.positions.bot_center = vector.new(width/2, height)
s_d.positions.bot_right = vector.new(width, height)

return s_d
