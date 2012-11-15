local M = {}

local level1 = require("level1")
local utilFuncs = require("utilFuncs")

function M:enemy1Create(x,y,name)
  local enemy1 = display.newRect(x,y, 50, 100)
  local enemy1Origin = display.newRect(enemy1.x,enemy1.y,5,5)
  local objGroup = display.newGroup() -- group for enemy and its origin rectangle
  objGroup:insert(enemy1)
  objGroup:insert(enemy1Origin)
  enemy1:setFillColor(255,0,0)
 -- enemy1.x = 800 enemy1.y = 400
  enemy1.status = "ballPops" -- ballPops means ball is removed when colliding with this object
  enemy1.health = 3 -- each ball collision is 1
  physics.addBody (enemy1, { friction =0.3, density =1.1})
  enemy1.myName = name
  enemy1.loop = "left"
  enemy1.isFixedRotation = true

  
  -- function enemy1:move()
    
    -- local vx, vy = self:getLinearVelocity()
	-- function enemy1:moveLeft()
	-- print (self.loop)
	  -- if self.loop == "left" then
	    --timer:performWithDelay(500, self:applyForce(3))
--		timer.performWithDelay(100, self:applyForce(100))

		--self.loop = "right"
 	    --self:moveRight()
	  -- end
    -- end
	-- function enemy1:moveRight()
	  -- for i = 1, 50 do
	    -- timer:performWithDelay(50, self:applyLinearImpulse(-3,0,self.x,self.y))
		-- i = i + 1
      -- end 
	  -- self:moveLeft()
    -- end
	-- self:moveLeft()
    -- if self.startx < 50 then
      -- self:applyLinearImpulse(3,0,self.x,self.y)
      -- self.startx = self.startx + 1
    -- else if self.startx == 50 then
      -- self.startx = 100
    -- else if self.startx > 50 then
	  -- self:applyLinearImpulse(-3,0,self.x,self.y)
      -- self.startx = self.startx - 1
	-- end end end
    	
  -- end
  
  return enemy1
  
  
end

return M