module(..., package.seeall)


new = function()

	print("Menu")
	local localGroup = display.newGroup()
	
	playButton = display.newRect(screenW/2,screenH/2,200,50)
	playButton:setFillColor(255,0,0)
	playButton.scene = "level1"
	localGroup:insert(playButton)
	
--	playButton:addEventListener("touch", changeScene)    

--	function changeScene(e)
--		if(e.phase=="ended") then
--		  director:changeScene(e.target.scene)
--	    end
--	end
	
	return localGroup
	
end