local M = {}

function M:distance(dx,dy)
print ("dx",dx)
print ("dy",dy)
local distance=math.sqrt(math.pow(dx,2)+math.pow(dy,2))
return distance
end

local function M:onBallCollide(event)
  if ( event.phase == "ended") then
    local obj1 = event.object1
    local obj2 = event.object2
  if (obj1.health ~= nil) then
  obj1.health = obj1.health - 1
  if (obj1.health == 0) then
  obj1:removeSelf()
  end end
  if (obj2.health ~= nil) then
  obj2.health = obj2.health - 1
  if (obj2.health == 0) then
  obj2:removeSelf()
end 
end

return M