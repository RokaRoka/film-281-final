--required Libraries
--hump
local vector = require("libraries.hump.vector")

local width, height = love.graphics.getDimensions()

local s_d = {}

s_d.positions = {}
s_d.positions.top_left = vector.new(0, 0)
s_d.positions.top_center = vector.new(width/2, 0)
s_d.positions.top_right = vector.new(width, 0)
s_d.positions.center = vector.new(width/2, height/2)

return s_d
