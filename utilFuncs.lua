local M = {}

function M:distance(dx,dy)
print ("dx",dx)
print ("dy",dy)
local distance=math.sqrt(math.pow(dx,2)+math.pow(dy,2))
return distance
end


return M