local M = {}

local physicsData = (require "shapedefs").physicsData() -- This is physicseditor

--create hero function
local function heroCreate(x,y)
	local hero = display.newImage("images/char.png")
	hero.x = x or 0 hero.y = y or 0
	physics.addBody( hero, physicsData:get("char") )
	hero.isFixedRotation = true
	return hero
end

M.heroCreate = heroCreate



return M