--required libraries
--hump
local vector = require("libraries.hump.vector")

local textFxn = {}

textFxn.drawTextOnOffset = function(textObj, position, pivotOffset)
  local offset = pivotOffset or vector.new(0, 0)
  local pos = position or vector.new(0, 0)
  pos = pos + offset
  love.graphics.draw(textObj, pos:unpack())
end

return textFxn
