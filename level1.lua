module(..., package.seeall)
display.setStatusBar( display.HiddenStatusBar )
system.activate("multitouch")

new = function()

local localGroup = display.newGroup()

local director = require( "director" )
local loqsprite = require('loq_sprite')

--require("loq_profiler").createProfiler()
--local function createProfiler(	_onTop,_collect	)
--end

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
physics.addBody (enemy, { friction =0.3, density =1.1})
game:insert (enemy)
enemy.myName = "enemy"

-- map
local leftwall = display.newRect( 0 , -1000, 50, 1000 + screenH )
physics.addBody (leftwall, "static", { friction =0.3,})
game:insert( leftwall )

local floor = display.newRect( 0, screenH -20 , 5000, 50 )
physics.addBody (floor, "static", { friction =0.3,})
game:insert( floor )

-- Character move Function
local tiltMotionX = 0
local function onTilt(event)
tiltMotionX = 30*event.yGravity
end

local function charMove(event)
char.x = char.x - tiltMotionX
end

-- Character Jump Function
local function onMultitouch(event)
	char:applyLinearImpulse( 100, char.y )
end

--  On touch ball shoot function
local function ballShootOnTouch(event)
	if (event.phase == "began") then
		local dx=event.x-char.x-game.x
	    local dy=event.y-char.y-game.y
		local distance=math.sqrt(math.pow(dx,2)+math.pow(dy,2))
		local forceMagnitude = distance / 50
		print (dx,dy)
		ball2 = display.newImage("images/ball.png")
		physics.addBody( ball2, physicsData:get("ball") )
		ball2.myName = "ball2"
		if  balls == nil then
		balls = display.newGroup();
		game:insert(balls)
		end
		balls:insert( ball2 )
		
		--if statements for controlling which side of char the ball shoots from
		if (event.x-game.x >= char.x) then
			print ("x greater", event.x)
		  ball2.x = char.x + 40
		else
		print ("x less", event.x)
		  ball2.x = char.x-40
		end
		--controlling y axis of ball placement
		if (event.y <= char.y-80) then --80 is to compensate for chars center reference point
		  ball2.y = char.y - 80
		  print ("y greater", event.y)
		else
		  ball2.y = event.y - game.y
		  print ("y less", event.y)
		end
		
		--math formula for figuring out radians of touch compared to char location
		local deltaX = event.x - char.x - game.x -- the game.x is to compensate for camera movement.
		local deltaY = event.y - char.y - 40 -- the 40 is to compensate for char's reference point (center)
		local angle = math.atan2(deltaY, deltaX)
		forceX = math.cos(angle)*forceMagnitude 
		forceY = math.sin(angle)*forceMagnitude
		ball2:applyLinearImpulse( forceX, forceY, ball2.x, ball2.y )
		print (distance,"Distance")
		print (angle,"Angle Between")
    end
	return true
end



-- Move Camera Function (Switch from character to ball)
local function moveCamera() -- Camera switches from tracking char, then ball when tossed
--	game.y = -ball.y + screenH /2
	if ballShot == 0 then
	game.x = -char.x + screenW /2
	else if ballShot == 1 then
	game.x = -ball.x + screenW /2
	end end
end

-- Detect Ball Collision Functions
local function onBallCollide(event)
	if ( event.phase == "ended") then
		if event.object1.myName == "ball2" and event.object2.myName == "enemy" then
			timer.performWithDelay(500, event.object2:removeSelf())
			print ("touched")
		end
	end
end

--reset level
local function resetGame()
	display.remove(char) char=nil
	display.remove(balls) balls=nil
	char = display.newImage("images/char.png")
	char.x = 300 char.y = screenH -90
	physics.addBody( char, physicsData:get("char") )
	game:insert( char )
	char.myName = "char"
end

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