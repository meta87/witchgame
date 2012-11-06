display.setStatusBar( display.HiddenStatusBar )

local loqsprite = require('loq_sprite')
--require("loq_profiler").createProfiler()

local function createProfiler(	_onTop,_collect	)
end

local physics = require "physics"
physics.start(); 

local physicsData = (require "shapedefs").physicsData() -- This is physicseditor

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local game = display.newGroup();
game.x = 0

local background = display.newImage("images/background.png")
background:toBack()



	

-- Character Object

local char = display.newImage("images/char.png")
char.x = 300 char.y = screenH -90
physics.addBody( char, physicsData:get("char") )
game:insert( char )
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

local enemy = display.newRect(2500, 200, 50, 250)
enemy:setFillColor(255,0,0)
physics.addBody (enemy, { friction =0.3, density =1.1})
game:insert (enemy)
enemy.myName = "enemy"

local enemy2 = display.newRect(2500, 0, 50, 250)
enemy2:setFillColor(255,255,0)
physics.addBody (enemy2, { friction =0.3, density =0.4})
game:insert (enemy2)

-- Buildings

local function populate()
	local spriteFactory = loqsprite.newFactory('sheet')
	local buildingTable = {}
	local buildingXLocation = 800

	for i = 1,100 do
	local ranBuild = math.random(6)
	local building = spriteFactory:newSpriteGroup("building"..ranBuild)
	buildingTable[i] = building
	buildingTable[i].x = buildingXLocation
	buildingXLocation = buildingXLocation + buildingTable[i].contentWidth + 20
	buildingTable[i].y= screenH - buildingTable[i].contentHeight
	buildingTable[i]:addPhysics(physics, "static", { friction =0.3,})
	buildingTable[i].myName = "building"

	game:insert (buildingTable[i])
	end
end

populate()

-- ball toss gui

local arrow = display.newImage("images/arrow.png")
arrow.y = screenH - 50; arrow.x = 200
arrow:setReferencePoint (display.BottomLeftReferencePoint)

local powerGauge = display.newRect (40, screenH - 40, 50, 1)
powerGauge:setReferencePoint (display.BottomCenterReferencePoint)
powerGauge.yScale = 200

-- map

local leftwall = display.newRect( 0 , -1000, 20, 1000 + screenH )
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



-- Arrow Rotation Function
rotationDirection = 1
arrowStop = 0
local function arrowRotate() 
	if (arrow.rotation < 90 and arrowStop==0) then
	arrow.rotation = arrow.rotation - 2 * rotationDirection
	end
	if (arrow.rotation == -90 and arrowStop==0) then
	rotationDirection = -1
	else if (arrow.rotation == 0 and arrowStop==0) then
	rotationDirection = 1
	end end
end



-- Ball Shoot uses arrow Touch and stopButton Functions

local ballShot = 0
local ball
function ballShoot()
	if (powerGaugeStop == 1 and arrowStop == 1 and ballShot == 0) then
	print (forceY)
	ball = display.newImage("images/ball.png")
	ball.x = char.x + 40 ball.y = char.y + 40
	physics.addBody( ball, physicsData:get("ball") )
	game:insert( ball )
	ball.myName = "ball"
	local angle = math.rad(arrow.rotation)
	forceMagnitude = powerGaugeNum
	forceX = math.cos(angle)*forceMagnitude 
	forceY = math.sin(angle)*forceMagnitude
	ball:applyLinearImpulse( forceX, forceY, ball.x, ball.y )
	ballShot = 1
	end
	return true
end
--  On touch ball shoot function
local function ballShootOnTouch(event)
	if (event.phase == "began") then
		local dx=event.x-char.x-game.x
	    local dy=event.y-char.y-game.y
		local distance=math.sqrt(math.pow(dx,2)+math.pow(dy,2))
		local forceMagnitude = distance / 50
		
		ball2 = display.newImage("images/ball.png")
		physics.addBody( ball2, physicsData:get("ball") )
		ball2.myName = "ball2"
		game:insert( ball2 )
		
		-- Shoots ball from left or right of character depending on touch location
		if event.x-game.x < char.x  then
			ball2.x = char.x ball2.y = char.y - 100
			print ("neg")
		else 
			ball2.x = char.x ball2.y = char.y - 100
			print ("pos")
		end
		
		local deltaX = event.x - char.x - game.x
		local deltaY = event.y - char.y - game.x
		local angle = math.atan2(deltaY, deltaX)
--		local xDist = event.x-char.x ; local yDist = event.y-char.y
--        local angleBetween = math.deg( math.atan( yDist/xDist ) )
 --       if ( event.x < char.x ) then angleBetween = angleBetween+90 else angleBetween = angleBetween-90 end
		forceX = math.cos(angle)*forceMagnitude 
		forceY = math.sin(angle)*forceMagnitude
		ball2:applyLinearImpulse( forceX, forceY, ball2.x, ball2.y )
		print (distance,"Distance")
		print (angle,"Angle Between")
	
    end
	return true
end

-- Arrow Touch Function
powerGaugeNum = 0
function arrowSelect(event)
	arrowStop = 1
    arrow = event.target 
	arrowAngle = arrow.rotation
	print (arrowAngle)
	if (arrowStop == 1) then
	ballShoot()
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



-- Power Gauge Function
local powerGaugeMove
local powerGaugeMoveBack

powerGaugeMoveBack = function()
	moveUp = transition.to( powerGauge, { time=1000, yScale=200, onComplete=powerGaugeMove } )
end

powerGaugeMove = function()
	moveDown = transition.to( powerGauge, { time=1000, yScale=1, onComplete=powerGaugeMoveBack } )
end

powerGaugeMove()
powerGaugeStop = 0
local function stopButton(event)
	powerGaugeStop = 1
	local powerGauge = event.target
	powerGaugeNum = powerGauge.yScale /12
	print ( powerGauge.yScale )
	transition.cancel(moveDown)
	transition.cancel(moveUp)
	if (arrowStop == 1) then
	ballShoot()
	end
end

-- Detect Ball Collision Functions

local function onBallCollide(event)
	if ( event.phase == "ended") then
		if event.object1.myName == "ball" and event.object2.myName == "building" then
			timer.performWithDelay(500, event.object2:removeSelf())
			print ("touched")
		end
	end
end

--reset game
local function resetGame()
	display.remove(char) char=nil
	char = display.newImage("images/char.png")
	char.x = 300 char.y = screenH -90
	physics.addBody( char, physicsData:get("char") )
	game:insert( char )
	char.myName = "char"
end

local resetButton = display.newRect(0, 0, 200, 50)
resetButton:setFillColor(255,0,0)
resetButton:addEventListener("tap", resetGame)    


-- Runtimes ETC

powerGauge:addEventListener("tap", stopButton)
Runtime:addEventListener("enterFrame", charMove)
Runtime:addEventListener("collision", onBallCollide)
Runtime:addEventListener("enterFrame", moveCamera )
Runtime:addEventListener("touch", ballShootOnTouch)
Runtime:addEventListener("enterFrame", arrowRotate)
arrow:addEventListener("tap", arrowSelect)
Runtime:addEventListener ("accelerometer", onTilt);