--require("loq_profiler").createProfiler()
--local function createProfiler(	_onTop,_collect	)
--end
local loqsprite = require('loq_sprite')
-- ball toss gui
local arrow = display.newImage("images/arrow.png")
arrow.y = screenH - 50; arrow.x = 200
arrow:setReferencePoint (display.BottomLeftReferencePoint)

local powerGauge = display.newRect (40, screenH - 40, 50, 1)
powerGauge:setReferencePoint (display.BottomCenterReferencePoint)
powerGauge.yScale = 200

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

powerGauge:addEventListener("tap", stopButton)
arrow:addEventListener("tap", arrowSelect)
Runtime:addEventListener("enterFrame", arrowRotate)