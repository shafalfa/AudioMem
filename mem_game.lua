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
	self.startXPos = 22
	self.startYPos = 22
	self.xGap = 57
	self.yGap = 57
	
	local xPos, yPos = self.startXPos, self.startYPos
	
	self.buttons = {}

	for r = 1,game_controller.num_rows do
		self.buttons[r] = {}
		for c =  1,game_controller.num_columns do
			self.buttons[r][c] = SoundButton.new(self)
			self.buttons[r][c]:setPosition(xPos,yPos)
			self.buttons[r][c]:addEventListener("click", function() game_controller:button_pressed(r,c) end)

			self:addChild(self.buttons[r][c])
			xPos = xPos + self.xGap
		end
		xPos = self.startXPos
		yPos = yPos + self.yGap
	end
end

function sound_panel:disableButtons(b1, b2)
	self.buttons[b1.r][b1.c]:updateVisualState("disable")
	self.buttons[b2.r][b2.c]:updateVisualState("disable")
end

function sound_panel:disableClick(event) 
	event.self.buttons[event.r][event.c].disableClick = true 
end


function sound_panel:second_sound_finished(match)
	local b1 = self.buttons[game_controller.first_button.r][game_controller.first_button.c]
	local b2 = self.buttons[game_controller.second_button.r][game_controller.second_button.c]
	
	self:dispatchEvent(Event.new("enableButtonClicks"))
	local state
	if(match) then
		state = "disabled"
	else 
		state = "up" 
	end
	
	b1:updateVisualState(state)
	b2:updateVisualState(state)
	game_controller.first_button = nil
	game_controller.second_button = nil
end
