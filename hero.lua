local M = {}

local remote = require("remote")-- Load Corona Remote
remote.startServer( "8080" )-- Start The Remote On Port 8080
local physicsData = (require "shapedefs").physicsData() -- This is physicseditor

--create hero function
function M:heroCreate(x,y)
	local hero = display.newImage("images/char.png")
	hero.x = x or 0 hero.y = y or 0
	physics.addBody( hero, physicsData:get("char") )
	hero.isFixedRotation = true
	
	function self:move()
	if yGravity ~= nil then
--	self:applyForce(yGravity*-800)
	print (yGravity)
	end
	
	end
	
	return hero

end

--hero move function



return M