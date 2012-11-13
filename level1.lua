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
Runtime:addEventListener ( "enterFrame", function(event) hero1:move(event,remote.yGravity) print (remote.yGravity) end)


local char = display.newImage("images/char.png")
char.x = 300 char.y = screenH -90
physics.addBody( char, physicsData:get("char") )
game:insert(char)
char.myName = "char"
char.isFixedRotation = true

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

--Character move Function
local function onTilt(event)
--	if char.jumping == false then
	local yGravity = remote.yGravity
	char:applyForce(yGravity*-800)
	
--	end
end

-- Max Velocity function for char
char.maxVelocity = 400
function char:enterFrame(event)
 
        local vx, vy = self:getLinearVelocity()
        local m = math.sqrt((vx*vx)+(vy*vy))
        if (m>self.maxVelocity) then
                vx=(vx/m)*self.maxVelocity
                vy=(vy/m)*self.maxVelocity
                self:setLinearVelocity(vx,vy)
        end     
end
Runtime:addEventListener( "enterFrame", char )

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

char.collision = jumpTest
char:addEventListener("collision", char )
char:addEventListener("touch", charJump)

-- Distance Function
local function distance(dx,dy)
local distance=math.sqrt(math.pow(dx,2)+math.pow(dy,2))
return distance
end

-- CharSpeed function calculates how fast char is moving in order to alter power of ball shoot
local charSpeedIs = 0
local function charSpeed()
	local vx, vy = char:getLinearVelocity()
	if yGravity >= 0 then
	charSpeedIs = 0
	else if yGravity < 0 and yGravity >= -.2 then 
	charSpeedIs = yGravity*-20
	else if yGravity < -.2 then 
	charSpeedIs = yGravity*-30
	end end end

end


-- On touch ball shoot function
local function ballShootOnTouch(event)
	if (event.phase == "began" and charJump ~= true) then
	--getting velocity of char to add to force of ball linear impulse
	local vx, vy = char:getLinearVelocity()
	--getting distance of event from char to calculate power of ball linear impulse
	local dx=event.x-char.x-game.x
	local dy=event.y-char.y-game.y
	local touchDistance = distance(dx,dy)
	charSpeed()
--	print (charSpeedIs)
	local forceMagnitude = (touchDistance / 50) + (charSpeedIs)
	ball = display.newImage("images/ball.png")
	ball.status = "ballPops"
	physics.addBody( ball, physicsData:get("ball") )
	ball.myName = "ball"
	if balls == nil then
	balls = display.newGroup();
	game:insert(ball)
	end
	balls:insert(ball)

	--if statements for controlling which side of char the ball shoots from
	if (event.x-game.x >= char.x) then
	ball.x = char.x + 60
	else
	ball.x = char.x-60
	end
	--controlling y axis of ball placement
	if (event.y <= char.y-80) then --80 is to compensate for chars center reference point
	ball.y = char.y - 80
	else
	ball.y = char.y - game.y
	end

	--math formula for figuring out radians of touch compared to char location
	local deltaX = event.x - char.x +vx - game.x -- the game.x is to compensate for camera movement.
	local deltaY = event.y - char.y - 40 -- the 40 is to compensate for char's reference point (center)
	local angle = math.atan2(deltaY, deltaX)
	forceX = math.cos(angle)*forceMagnitude
	forceY = math.sin(angle)*forceMagnitude
	ball:applyLinearImpulse( forceX, forceY, ball.x, ball.y )
    end
	return true
	end

-- Move Camera Function
local function moveCamera()
game.x = -char.x + screenW /2
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
Runtime:addEventListener("collision", onBallCollide)
Runtime:addEventListener("enterFrame", moveCamera )
Runtime:addEventListener("enterFrame", onTilt)
Runtime:addEventListener("touch", ballShootOnTouch)


return localGroup

end

return level1