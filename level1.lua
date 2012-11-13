level1 = {}
level1.new = function()

local hero = require("hero")
local remote = require("remote")-- Load Corona Remote
remote.startServer( "8080" )-- Start The Remote On Port 8080
local yGravity = remote.yGravity


local localGroup = display.newGroup()
local director = require( "director" )

local physics = require "physics"
physics.start();

local physicsData = (require "shapedefs").physicsData() -- This is physicseditor

local game = display.newGroup();
local balls = display.newGroup();
game:insert(balls)
localGroup:insert(game)
game.x = 0

local background = display.newImage("images/background.png")
game:insert(background)
background:toBack()

-- Hero Object
local hero1 = hero:heroCreate(600,400,'hero1')
game:insert(hero1)
local function hero1Funcs() 
hero1:limitSpeed(event)
hero1:move(event)
end
local function hero1Touch(event) 
hero1:ballShoot(event,game.x,game.y)
end

Runtime:addEventListener ( "enterFrame", hero1Funcs)
Runtime:addEventListener ( "touch", hero1Touch)

-- enemy object
local enemy = display.newRect(500, 200, 50, 250)
enemy:setFillColor(255,0,0)
enemy.status = "ballPops" -- ballPops means ball is removed when colliding with this object
enemy.health = 3 -- each ball collision is 1
physics.addBody (enemy, { friction =0.3, density =1.1})
game:insert (enemy)
enemy.myName = "enemy"

-- map
local leftwall = display.newRect( 0 , -1000, 50, 1000 + screenH )
physics.addBody (leftwall, "static", { friction =0.3,})
game:insert( leftwall )

local floor = display.newRect( 0, screenH -20 , 5000, 50 )
physics.addBody (floor, "static", { friction =0.3,})
floor.myName = "floor"
game:insert( floor )


-- Max Velocity function for char


-- Character Jump and Jump Test Functions
local function jumpTest(self, event)
        if (event.phase == "ended") then
            if (event.other.myName == "floor") then
				self.jumping = false
			end
		end
end

local function charJump(event)
	local 	vx, vy = char:getLinearVelocity()
--	print (char.jumping)
	if char.jumping == false then
	    char:setLinearVelocity(vx,0)
		timer.performWithDelay(10, char:applyLinearImpulse( 0, -200, char.x, char.y ))
		char.jumping = true
	end
	return true
end

-- char.collision = jumpTest
-- char:addEventListener("collision", char )
-- char:addEventListener("touch", charJump)

-- Distance Function







-- Move Camera Function
local function moveCamera()
game.x = -hero1.x + screenW /2
end

-- Detect Ball Collision Functions
local function onBallCollide(event)
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
end end

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