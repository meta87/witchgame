local M = {}

local remote = require("remote")-- Load Corona Remote
local level1 = require("level1")-- Load Corona Remote
local utilFuncs = require("utilFuncs")

remote.startServer( "8080" )-- Start The Remote On Port 8080
local physicsData = (require "shapedefs").physicsData() -- This is physicseditor
yGravity = remote.yGravity

--create hero function
function M:heroCreate(x,y, name)
	local hero = display.newImage("images/char.png")
	hero.name = name
	ballShootPause = true
	hero.x = x or 0 hero.y = y or 0
	physics.addBody( hero, physicsData:get("char") )
	hero.isFixedRotation = true
	hero.jumping = false
	
	function hero:move(event)
	  local yGravity = remote.yGravity
      self:applyForce(yGravity*-2600)
	end
	
	function hero:jumpTest(event)
	  local vx, vy = self:getLinearVelocity()
      if (event.phase == "began" and event.other.jumpable == "yes") then
      --print ("Remote Jumptest",event.other.myName)
	  self.jumping = false
	  return true
	  end
    end
	
	
	function hero:jump(event)
	  if (event.phase == "began" and self.jumping ~= true) then
	    local 	vx, vy = self:getLinearVelocity()
	    self:setLinearVelocity(vx,0)
        local jump = function() self:applyForce( 0, -4000, self.x, self.y) end
		timer.performWithDelay(1, jump, 4)
		self.jumping = true
		return true
	  end
    end
	

	
	function hero:limitSpeed(event)
	  self.maxVelocity = 400
      local vx, vy = self:getLinearVelocity()
      local m = math.sqrt((vx*vx)+(vy*vy))
      if (m>self.maxVelocity) then
        vx=(vx/m)*self.maxVelocity
        vy=(vy/m)*self.maxVelocity
        self:setLinearVelocity(vx,vy)
      end     
    end
	
    function hero:speed()-- CharSpeed function calculates how fast char is moving in order to alter power of ball shoot
	  local heroSpeed = 0
	  local yGravity = remote.yGravity
	  local vx, vy = self:getLinearVelocity()
	  if yGravity >= 0 then
	  heroSpeed = 0
	  else if yGravity < 0 and yGravity >= -.2 then 
	  heroSpeed = yGravity*-20
	  else if yGravity < -.2 then 
	  heroSpeed = yGravity*-30
	  end end end
	  return heroSpeed
    end

	local function ballShootPauser()
	  ballShootPause = true  
	  print("TIS TRUE") 
	end
	
    function hero:ballShoot(event,gamex,gamey)
	  if (event.phase == "began" and ballShootPause == true) then
	    ballShootPause = false
	    local vx, vy = self:getLinearVelocity()--getting distance of event from char to calculate power of ball linear impulse
	    local dx=event.x-self.x-gamex
	    local dy=event.y-self.y-gamey
	    print ("dx",dx)
	    local touchDistance = utilFuncs:distance(dx,dy)
	    local heroSpeed = hero:speed()--	print (charSpeedIs)
	    local forceMagnitude = (touchDistance / 15) + (heroSpeed)
	    ball = display.newImage("images/ball.png")
	    ball.status = "ballPops"
	    physics.addBody( ball, physicsData:get("ball") )
	    ball.myName = "ball"
		ball.jumpable = "no"
        if (event.x-gamex >= self.x) then--if statements for controlling which side of char the ball shoots from
	      ball.x = self.x+50
	    else
	      ball.x = self.x-50
	    end
	     ball.y = self.y - 80

	    local deltaX = event.x - self.x +vx - gamex --math formula for figuring out radians of touch compared to char location the game.x is to compensate for camera movement.
	    local deltaY = event.y - self.y - 40 -- the 40 is to compensate for char's reference point (center)
	    local angle = math.atan2(deltaY, deltaX)
	    forceX = math.cos(angle)*forceMagnitude
	    forceY = math.sin(angle)*forceMagnitude
	    ball:applyLinearImpulse( forceX, forceY, ball.x, ball.y )
		timer.performWithDelay(500, ballShootPauser)
      end
	  return ball
    end
	
	return hero
end 



return M