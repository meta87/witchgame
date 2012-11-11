menu = {}
menu.new = function()
	print("Menu")
	local localGroup = display.newGroup()
		
	playButton = display.newRect(0,0,200,50)
	playButton:setReferencePoint(display.CenterReferencePoint);
	playButton.x = screenW/2 playButton.y = screenH/2
	playButton:setFillColor(255,0,0)
	playButton.scene = "level1"
	localGroup:insert(playButton)
	
	playTxt = display.newText("Play", 0,0,"Helvetica",20)
	playTxt:setReferencePoint(display.CenterReferencePoint);
	playTxt.x = screenW/2 playTxt.y = screenH/2
	playTxt:setTextColor(255,255,255)
	localGroup:insert(playTxt)
	
	function changeScene(e)
		if(e.phase=="ended") then
		  director:changeScene(e.target.scene)
	    end
	end
	
	playButton:addEventListener("touch", changeScene)    

	
	return localGroup
	
end

return menu