screenW, screenH = display.contentWidth, display.contentHeight
display.setStatusBar( display.HiddenStatusBar )

local director = require("director")

local mainGroup = display.newGroup()

local function main()
	mainGroup:insert(director.directorView)
	director:changeScene("menu")
	return true
end

function changeScene(e)
		if(e.phase=="ended") then
		  Runtime._functionListeners = nil
		  director:changeScene(e.target.scene)
	    end
	end

main()