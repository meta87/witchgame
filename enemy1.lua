local M = {}

local level1 = require("level1")
local utilFuncs = require("utilFuncs")

function M:create(x,y, name)
  local enemy = display.newRect(500, 200, 50, 250)
  enemy:setFillColor(255,0,0)
  enemy.status = "ballPops" -- ballPops means ball is removed when colliding with this object
  enemy.health = 3 -- each ball collision is 1
  physics.addBody (enemy, { friction =0.3, density =1.1})
  enemy.myName = "enemy1"
end

return M