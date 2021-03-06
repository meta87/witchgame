display.setStatusBar( display.HiddenStatusBar )

local loqsprite = require('loq_sprite')
require("loq_profiler").createProfiler()

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

local ball = display.newImage("images/ball.png")
ball.x = screenW / 2; ball.y = screenH / 2
physics.addBody( ball, physicsData:get("ball") )
game:insert( ball )
ball.myName = "ball"

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
ball:toFront()


-- banana toss gui

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

-- block tower 

local dispObj_1 = display.newImageRect( "images/building.png", 44, 44 )
dispObj_1.x = 2722
dispObj_1.y = 174
game:insert (dispObj_1)
physics.addBody( dispObj_1, { density=1, friction=0.3, bounce=0.2 } )


local dispObj_2 = display.newImageRect( "images/building.png", 44, 44 )
dispObj_2.x = 2782
dispObj_2.y = 222
game:insert (dispObj_2)
physics.addBody( dispObj_2, { density=1, friction=0.3, bounce=0.2 } )


local dispObj_3 = display.newImageRect( "images/building.png", 44, 44 )
dispObj_3.x = 2780
dispObj_3.y = 180
game:insert (dispObj_3)
physics.addBody( dispObj_3, { density=1, friction=0.3, bounce=0.2 } )


local dispObj_4 = display.newImageRect( "images/building.png", 44, 44 )
dispObj_4.x = 2780
dispObj_4.y = 264
game:insert (dispObj_4)
physics.addBody( dispObj_4, { density=1, friction=0.3, bounce=0.2 } )


local dispObj_5 = display.newImageRect( "images/building.png", 44, 44 )
dispObj_5.x = 2720
dispObj_5.y = 214
game:insert (dispObj_5)
physics.addBody( dispObj_5, { density=1, friction=0.3, bounce=0.2 } )


local dispObj_6 = display.newImageRect( "images/building.png", 44, 44 )
dispObj_6.x = 2720
dispObj_6.y = 254
game:insert (dispObj_6)
physics.addBody( dispObj_6, { density=1, friction=0.3, bounce=0.2 } )

-- Char move Function

local function onTilt(event)
 
char.x = 30*event.xGravity

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

-- banana Shoot uses arrow Touch and stopButton Functions
local bananaShot = 0
local function bananaShoot()
	if (powerGaugeStop == 1 and arrowStop == 1 and bananaShot == 0) then
	print (forceY)
	local angle = math.rad(arrow.rotation)
	forceMagnitude = powerGaugeNum
	forceX = math.cos(angle)*forceMagnitude 
	forceY = math.sin(angle)*forceMagnitude
	ball:applyLinearImpulse( forceX, forceY, ball.x, ball.y )
	bananaShot = 1
	end
	return true
end

-- Arrow Touch Function
powerGaugeNum = 0
function arrowSelect(event)
	arrowStop = 1
	local arrow = event.target 
	arrowAngle = arrow.rotation
	print (arrowAngle)
	if (arrowStop == 1) then
	bananaShoot()
	end
	return true
end

-- Move Camera Function
function moveCamera()
--	game.y = -ball.y + screenH /2
	game.x = -ball.x + screenW /2
end

-- Power Gauge Function
local powerGaugeMove
local powerGaugeMoveBack

powerGaugeMoveBack = function()
	moveUp = transition.to( powerGauge, { time=1000, yScale=200, onComplete=powerGaugeMove } )
	print ("2")

end

powerGaugeMove = function()
	moveDown = transition.to( powerGauge, { time=1000, yScale=1, onComplete=powerGaugeMoveBack } )
	print ("1")
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
	bananaShoot()
	end
end

-- Detect Banana Collision Functions

local function onBananaCollide(event)
	if ( event.phase == "ended") then
		if event.object1.myName == "ball" and event.object2.myName == "building" then
			timer.performWithDelay(500, event.object2:removeSelf())
			print ("touched")
		end
	end
end


-- Runtimes ETC

powerGauge:addEventListener("tap", stopButton)
Runtime:addEventListener("collision", onBananaCollide)
Runtime:addEventListener("enterFrame", moveCamera )
Runtime:addEventListener("enterFrame", arrowRotate)
arrow:addEventListener("tap", arrowSelect)
Runtime:addEventListener ("accelerometer", onTilt);