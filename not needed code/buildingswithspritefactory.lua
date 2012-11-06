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