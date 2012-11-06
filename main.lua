screenW, screenH = display.contentWidth, display.contentHeight

local director = require("director")

local mainGroup = display.newGroup()

local function main()
	mainGroup:insert(director.directorView)
	director:changeScene("menu")
	return true
end

main()