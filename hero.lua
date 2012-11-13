local M = {}

local remote = require("remote")-- Load Corona Remote
remote.startServer( "8080" )-- Start The Remote On Port 8080
local physicsData = (require "shapedefs").physicsData() -- This is physicseditor
yGravity = remote.yGravity

--create hero function
function M:heroCreate(x,y, name)
	local hero = display.newImage("images/char.png")
	hero.name = name
	hero.x = x or 0 hero.y = y or 0
	physics.addBody( hero, physicsData:get("char") )
	hero.isFixedRotation = true
	
	function hero:move(event,yGravity)
      print(yGravity)
      self:applyForce(yGravity*-800)
	end
	
	return hero
end



return M