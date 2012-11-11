local M = {}

local remote = require("remote")-- Load Corona Remote
remote.startServer( "8080" )-- Start The Remote On Port 8080
local physicsData = (require "shapedefs").physicsData() -- This is physicseditor
yGravity = remote.yGravity

--create hero function
function M:heroCreate(x,y)
	local hero = display.newImage("images/char.png")
	hero.x = x or 0 hero.y = y or 0
	physics.addBody( hero, physicsData:get("char") )
	hero.isFixedRotation = true
	return hero
end
	

--hero move function
function M:heroMove()
	if yGravity ~= nil then
--	self:applyForce(yGravity*-800)
	local cheese = "good"
	print (yGravity)
	return cheese
end

end
return M