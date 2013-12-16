--[[
A generic button class

This code is MIT licensed, see http://www.opensource.org/licenses/mit-license.php
(C) 2010 - 2011 Gideros Mobile 
]]

SoundButton = gideros.class(Sprite)

function SoundButton:init(panel)
	self.upState = Bitmap.new(Texture.new("images/glossy_red30.png"))
	self.downState = Bitmap.new(Texture.new("images/glossy_green30.png"))
	self.disabledState = Bitmap.new(Texture.new("images/glossy_grey30.png"))
	
	self.disableClick = false	
	self.focus = false
	self.panel = panel
	self.panel:addEventListener("disableButtonClicks", self.disable_click, self)
	self.panel:addEventListener("enableButtonClicks", self.enable_click, self)

	self:updateVisualState("up")

	self:addEventListener(Event.MOUSE_DOWN, self.onMouseDown, self)
	self:addEventListener(Event.MOUSE_MOVE, self.onMouseMove, self)
	self:addEventListener(Event.MOUSE_UP, self.onMouseUp, self)

	self:addEventListener(Event.TOUCHES_BEGIN, self.onTouchesBegin, self)
	self:addEventListener(Event.TOUCHES_MOVE, self.onTouchesMove, self)
	self:addEventListener(Event.TOUCHES_END, self.onTouchesEnd, self)
	self:addEventListener(Event.TOUCHES_CANCEL, self.onTouchesCancel, self)
end

function SoundButton:onMouseDown(event)
	if self:hitTestPoint(event.x, event.y) and not self.disableClick then
		self.focus = true
		self:updateVisualState("down")
		event:stopPropagation()
	end
end

function SoundButton:onMouseMove(event)
	if self.focus then
		if not self:hitTestPoint(event.x, event.y) then
			self.focus = false;
			--self:updateVisualState(false)
		end
		event:stopPropagation()
	end
end

function SoundButton:onMouseUp(event)
	if self.focus then
		self.focus = false;
		--self:updateVisualState(false)
		if(not self.disableClick) then
			self:dispatchEvent(Event.new("click"))
		end
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function SoundButton:onTouchesBegin(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function SoundButton:onTouchesMove(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if button is on focus, stop propagation of touch events
function SoundButton:onTouchesEnd(event)
	if self.focus then
		event:stopPropagation()
	end
end

-- if touches are cancelled, reset the state of the button
function SoundButton:onTouchesCancel(event)
	if self.focus then
		self.focus = false;
		self:updateVisualState("up")
		event:stopPropagation()
	end
end

-- if state is true show downState else show upState
function SoundButton:updateVisualState(state)
	if state == "down" then
		if self:contains(self.upState) then
			self:removeChild(self.upState)
		end

		if self:contains(self.disabledState) then
			self:removeChild(self.disabledState)
		end
		
		if not self:contains(self.downState) then
			self:addChild(self.downState)
		end
	elseif state == "up" then
		if self:contains(self.downState) then
			self:removeChild(self.downState)
		end
		
		if self:contains(self.disabledState) then
			self:removeChild(self.disabledState)
		end		
		
		if not self:contains(self.upState) then
			self:addChild(self.upState)
		end
	else
		if self:contains(self.downState) then
			self:removeChild(self.downState)
		end
		
		if self:contains(self.upState) then
			self:removeChild(self.upState)
		end	

		if not self:contains(self.disabledState) then
			self:addChild(self.disabledState)
			self.disableClick = true
			print("Time to disable")
			if(self.panel:hasEventListener("enableButtonClicks")) then
				print("Has enable clicks")
			else
				print("Doesn't have enable clicks")
			end
			
			self.panel:removeEventListener("disableButtonClicks", self.disable_click, self)
			self.panel:removeEventListener("enableButtonClicks", self.enable_click, self)
		end

	end
end

function SoundButton:disable_click()
	self.disableClick = true
end

function SoundButton:enable_click()
	self.disableClick = false
end

