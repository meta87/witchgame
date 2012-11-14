level1 = {}
level1.new = function()

local director = require( "director" )
local hero = require("hero")
local utilFuncs = require("utilFuncs")
local remote = require("remote")-- Load Corona Remote
remote.startServer( "8080" )-- Start The Remote On Port 8080
local yGravity = remote.yGravity

local localGroup = display.newGroup()

local physics = require "physics"
physics.start();

local physicsData = (require "shapedefs").physicsData() -- This is physicseditor


local game = display.newGroup(); -- Creating Local Groups. Game group is used by the moveCamera function
local balls = display.newGroup(); 
game:insert(balls)
localGroup:insert(game)
game.x = 0

local background = display.newImage("images/background.png")
game:insert(background)
background:toBack()

-- map
local leftwall = display.newRect( 0 , -1000, 50, 1000 + screenH )
physics.addBody (leftwall, "static", { friction =0.3,})
game:insert( leftwall )

local floor = display.newRect( 0, screenH -20 , 5000, 50 )
physics.addBody (floor, "static", { friction =0.3,})
floor.myName = "floor"
floor.jumpable = "yes"
game:insert( floor )

-- Hero Object
local hero1 = hero:heroCreate(600,400,'hero1')
game:insert(hero1)
local function hero1Funcs() 
  hero1:limitSpeed(event)
  hero1:move(event)
end
local function hero1Touch(event)
  if event.phase == "began" and hero1selfTouch ~= true then
    local ball = hero1:ballShoot(event,game.x,game.y)
    balls:insert(ball)
  end
end

local function hero1SelfTouch(event)
  hero1:jump(event)
end

local function hero1Collisions(event)
  print ("jumpTest")
  hero1:jumpTest(event)
end

hero1:addEventListener ( "touch", hero1SelfTouch)
hero1:addEventListener ( "collision", hero1Collisions)
Runtime:addEventListener ( "enterFrame", hero1Funcs)
Runtime:addEventListener ( "touch", hero1Touch)

local function moveCamera()
game.x = -hero1.x + screenW /2
end

-- enemy object
local enemy = display.newRect(500, 200, 50, 250)
enemy:setFillColor(255,0,0)
enemy.status = "ballPops" -- ballPops means ball is removed when colliding with this object
enemy.health = 3 -- each ball collision is 1
physics.addBody (enemy, { friction =0.3, density =1.1})
game:insert (enemy)
enemy.myName = "enemy"




-- Detect Ball Collision Functions
if event.object1.myName == "ball" and event.object2.status == "ballPops" then
event.object1:removeSelf()
else if event.object2.myName == "ball" and event.object1.status == "ballPops" then
event.object2:removeSelf()
end
end
end
end

--reset level
local resetButton = display.newRect(0, 0, 200, 50)
resetButton:setFillColor(255,0,0)
resetButton.scene = "menu"
resetButton:addEventListener("touch", changeScene)


-- Runtimes ETC
--Runtime:addEventListener("collision", onBallCollide)
Runtime:addEventListener("enterFrame", moveCamera )
--Runtime:addEventListener("touch", ballShootOnTouch)


return localGroup

end

return level1