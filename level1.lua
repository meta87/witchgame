module(..., package.seeall)
display.setStatusBar( display.HiddenStatusBar )
system.activate("multitouch")

new = function()

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
localGroup:insert(background)
background:toBack()

-- Character Object
local char = display.newImage("images/char.png")
char.x = 300 char.y = screenH -90
physics.addBody( char, physicsData:get("char") )
game:insert(char)
char.myName = "char"
char.isFixedRotation = true

-- Ball Object
local function ballcreate()
local ball = display.newImage("images/ball.png")
ball.x = char.x + 40 ball.y = char.y + 40
physics.addBody( ball, physicsData:get("ball") )
game:insert( ball )
ball.myName = "ball"
end

-- enemy object
local enemy = display.newRect(500, 200, 50, 250)
enemy:setFillColor(255,0,0)
enemy.status = "ballPops" -- ballPops means ball is removed when colliding with this object
enemy.health = 3 -- each ball collision is 1 
physics.addBody (enemy, { friction =0.3, density =1.1})
game:insert (enemy)
enemy.myName = "enemy"

-- enemy ai
local function enemyPace ()
end

-- map
local leftwall = display.newRect( 0 , -1000, 50, 1000 + screenH )
physics.addBody (leftwall, "static", { friction =0.3,})
game:insert( leftwall )

local floor = display.newRect( 0, screenH -20 , 5000, 50 )
physics.addBody (floor, "static", { friction =0.3,})
floor.myName = "floor"
game:insert( floor )

-- Character move Function
local tiltMotionX = 0
local function onTilt(event)
	if event.yGravity <=.10 then
		tiltMotionX = 10
	else if event.yGravity >=-.10 then
		tiltMotionX = -10
	end end	
end
-- This is just to display the accelerometer text on screen
local function updateAccel()
accelData.text = gravity
print("Updated", accelData)
end
accelData = display.newText("data",200,200,"Arial",40)
accelData:setTextColor(0,0,0)
local function printAccel(event)
	gravity = event.yGravity
	timer.performWithDelay(5, updateAccel())
	print (event.yGravity,"WHAHAHA")
end
Runtime:addEventListener ("accelerometer", printAccel);

local function charMove(event)
char:setLinearVelocity(tiltMotionX, 0)
end

-- Character Jump Function
charJumping = 0
local function charJump(event)
	if charJumping == 0 then
	char:setLinearVelocity( 0,0 )
	timer.performWithDelay(10, char:applyLinearImpulse( 0, -200, char.x, char.y ))
	charJumping = 1
	end
	return true
end
Runtime:addEventListener("enterFrame", charMove)

local function jumpTest(event)
        if (event.phase == "ended") then
                if (event.other.myName == "floor") then
				charJumping = 0
				print ("touching Ground")
				return
                end
        end
end

char:addEventListener("collision", jumpTest)
char:addEventListener("touch", charJump)    

-- Distance Function
local function distance(dx,dy)
	local distance=math.sqrt(math.pow(dx,2)+math.pow(dy,2))
	return distance
end

--  On touch ball shoot function
local function ballShootOnTouch(event)
	if (event.phase == "began" and charJump ~= true) then
	print (event.target)
		local dx=event.x-char.x-game.x
	    local dy=event.y-char.y-game.y
		local touchDistance = distance(dx,dy)
		local forceMagnitude = touchDistance / 50
		ball = display.newImage("images/ball.png")
		ball.status = "ballPops"
		physics.addBody( ball, physicsData:get("ball") )
		ball.myName = "ball"
		if  balls == nil then
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
		local deltaX = event.x - char.x - game.x -- the game.x is to compensate for camera movement.
		local deltaY = event.y - char.y - 40 -- the 40 is to compensate for char's reference point (center)
		local angle = math.atan2(deltaY, deltaX)
		forceX = math.cos(angle)*forceMagnitude 
		forceY = math.sin(angle)*forceMagnitude
		char:setLinearVelocity( 0,0 )

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
			print "Hit!"
		if (obj1.health == 0) then
			obj1:removeSelf()
		end end
		if (obj2.health ~= nil) then
			obj2.health = obj2.health - 1
			print "Hit!"
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
Runtime:addEventListener("enterFrame", charMove)
Runtime:addEventListener("collision", onBallCollide)
Runtime:addEventListener("enterFrame", moveCamera )
Runtime:addEventListener("touch", ballShootOnTouch)
Runtime:addEventListener ("accelerometer", onTilt);


return localGroup

end