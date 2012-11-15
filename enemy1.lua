local M = {}

local level1 = require("level1")
local utilFuncs = require("utilFuncs")

function M:enemy1Create(x,y,name)
  local enemy1 = display.newRect(x,y, 50, 100)
  local enemy1RightBox = display.newRect(x+25,y,5,5)
  local objGroup = display.newGroup() -- group for enemy and its origin rectangle
  objGroup:insert(enemy1)
  objGroup:insert(enemy1RightBox)
  enemy1:setFillColor(255,0,0)
 -- enemy1.x = 800 enemy1.y = 400
  enemy1.status = "ballPops" -- ballPops means ball is removed when colliding with this object
  enemy1.health = 3 -- each ball collision is 1
  physics.addBody (enemy1, { friction =0.3, density =1.1})
  enemy1.myName = name
  enemy1.loop = "left"
  enemy1.isFixedRotation = true

  
  -- function enemy1:move()
 --   local direction = 500
    --self:setLinearImpulse(direction,0)
	--self.pathfinding = enemy1:pathfinding(event)
  -- end
  
  return enemy1
  
  
end

return M