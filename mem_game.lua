--[[
*************************************************************
 * This is the main memory game scene
**************************************************************
]]--
sound_panel = gideros.class(Sprite)

function sound_panel:init()
	--here we'd probably want to set up a background picture
	local bg = Bitmap.new(Texture.new("images/game_bg.png"))
	self:addChild(bg)
	self.startXPos = 27
	self.startYPos = 85
	self.xGap = 56
	self.yGap = 45
	self.game_controller = GameController.new(self)
	
	local xPos, yPos = self.startXPos, self.startYPos
	
	self.buttons = {}

	--Add all the buttons to the grid
	for r = 1,self.game_controller.num_rows do
		self.buttons[r] = {}
		for c =  1,self.game_controller.num_columns do
			self.buttons[r][c] = SoundButton.new(self)
			self.buttons[r][c]:setPosition(xPos,yPos)
			self.buttons[r][c]:addEventListener("click", function() self.game_controller:button_pressed(r,c) end)

			self:addChild(self.buttons[r][c])
			xPos = xPos + self.xGap
		end
		xPos = self.startXPos
		yPos = yPos + self.yGap
	end
	
	--Add time output box
	self.timeBox = Bitmap.new(Texture.new("images/output_box.png"))
	self.timeBox:setPosition(27,34)
	self:addChild(self.timeBox)
	
	--Add time label
	self.timeLabel = TextField.new(nil, "Time")
	self.timeLabel:setTextColor(0xabb1b5)
	self.timeLabel:setPosition(69,30)
	self:addChild(self.timeLabel)
	
	--Add time text
	self:setOutputBoxText(self.timeBox, "00:00")
	
	--Add score output box
	self.scoreBox = Bitmap.new(Texture.new("images/output_box.png"))
	self.scoreBox:setPosition(173,34)
	self:addChild(self.scoreBox)
	
	--Add score label
	self.scoreLabel = TextField.new(nil, "Score")
	self.scoreLabel:setTextColor(0xabb1b5)
	self.scoreLabel:setPosition(217,30)
	self:addChild(self.scoreLabel)
	
	--Add score text
	self:setOutputBoxText(self.scoreBox, "0")
	
	--Add quit button
	self.quitButton = Button.new(Bitmap.new(Texture.new("images/quit_button.png")), Bitmap.new(Texture.new("images/quit_button.png")))
	self.quitButton:setPosition(327,34)
	self.quitButton:addEventListener("click", self.quit, self)
	self:addChild(self.quitButton)	
	
end

function sound_panel:disableButtons(b1, b2)
	self.buttons[b1.r][b1.c]:updateVisualState("disable")
	self.buttons[b2.r][b2.c]:updateVisualState("disable")
end

function sound_panel:disableClick(event) 
	event.self.buttons[event.r][event.c].disableClick = true 
end

function sound_panel:setOutputBoxText(box, text)
	local centreX, centreY, textField, x, y
	--Get centre point of box
	centreX = math.floor(box:getWidth() / 2)
	centreY = math.floor(box:getHeight() / 2)
	textField = TextField.new(nil, text)
	textField:setTextColor(0x0)
	textField:setScale(3)
	x = centreX - math.floor(textField:getWidth() / 2)
	--I don't understand why the y co-ordinate has its origin at -Height
	y = textField:getHeight() + centreY - math.floor(textField:getHeight() / 2)
	textField:setPosition(x, y)
	
	--Remove any existing text
	if(box:getNumChildren() > 0) then
		box:removeChildAt(1)
	end
	
	--print("box: " .. self:posString(box:getX(), box:getY()) .. " centre: " .. self:posString(centreX, centreY) .. " text dim: " .. self:posString(textField:getWidth(), textField:getHeight()) .. " pos: " .. self:posString(x, y))
	box:addChild(textField)
end

function sound_panel:second_sound_complete(match, b1, b2, complete)
	
	self:dispatchEvent(Event.new("enableButtonClicks"))
	local state
	if(match) then
		state = "disabled"
	else 
		state = "up" 
	end
	
	self.buttons[b1.r][b1.c]:updateVisualState(state)
	self.buttons[b2.r][b2.c]:updateVisualState(state)
	
	if(complete)then
		self:display_congrats_screen()
	end

end

function sound_panel:popup_buttons(b1, b2)
	self.buttons[b1.r][b1.c]:updateVisualState("up")
	self.buttons[b2.r][b2.c]:updateVisualState("up")
end

function sound_panel:quit()
	self.game_controller:quit()
	sceneManager:changeScene("start", 1, transition, easing.outBack)
end

function sound_panel:display_congrats_screen()
	local congrats = Bitmap.new(Texture.new("images/congrats_panel.png"))
	congrats:setPosition(115, 85)
	
	local font = Font.new("fonts/Computerfont24.txt", "fonts/Computerfont24.png")
	--Congratulations
	local textCongrats = TextField.new(font, "CONGRATULATIONS")
	textCongrats:setPosition(35,25) --26
	textCongrats:setTextColor(0xa90000)
	congrats:addChild(textCongrats)	
	
	--Time
	local textTimeLabel = TextField.new(font, "Time: ")
	textTimeLabel:setPosition(50,55) --26
	textTimeLabel:setTextColor(0x204ec2)
	congrats:addChild(textTimeLabel)

	local textTimeValue = TextField.new(font, self:get_time(self.game_controller.timer:getCurrentCount()))
	textTimeValue:setPosition(125,55) --26
	congrats:addChild(textTimeValue)
	
	--Score
	local textScoreLabel = TextField.new(font, "Score:")
	textScoreLabel:setPosition(50,80) --26
	textScoreLabel:setTextColor(0x204ec2)
	congrats:addChild(textScoreLabel)

	local textScoreValue = TextField.new(font, self.game_controller.score)
	textScoreValue:setPosition(125,80) --26
	congrats:addChild(textScoreValue)
	
	--Quit button
	local quitButton = Button.new(Bitmap.new(Texture.new("images/quit_button_old.png")), Bitmap.new(Texture.new("images/quit_button_old.png")))
	quitButton:setPosition(68,109) --30
	quitButton:addEventListener("click", self.quit, self)
	congrats:addChild(quitButton)	
	
	self:addChild(congrats)
	
end

function sound_panel:timer_tick(count)
	--print(count .. " " .. minutes .. " " .. seconds .. " " .. string.format("%02d", minutes))
	self:setOutputBoxText(self.timeBox, self:get_time(count))
end

function sound_panel:get_time(count)
	--Calculate minutes and seconds
	local minutes, seconds
	minutes = math.floor(count / 60)
	if(minutes > 0) then
		seconds = count % (minutes * 60)
	else
		seconds = count
	end
	return string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds)
end
function sound_panel:score_changed()
	self:setOutputBoxText(self.scoreBox, self.game_controller.score)
end

function sound_panel:posString(x, y)
	return "(" .. x .. "," .. y ..")"
end


