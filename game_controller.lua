GameController = Core.class()

function GameController:init()
	self.sound_channel = nil
	self.first_button = nil
	self.second_button = nil
	self:setup_db()
	self.num_rows = 5
	self.num_columns = 8
	self:initialise_matrix()
	
	local num_sounds = table.getn(self.sound_db)
	local num_elements = self.num_rows * self.num_columns / 2, r1, c1, r2, c2, sound_file, rand, db_row

	for i = 1, num_elements do
		rand = math.random(1, table.getn(self.sound_db))
		db_row = table.remove(self.sound_db, rand)
		sound_file = db_row.file
		
		r1, c1 = self:get_random_free_position()
		--Have to assign something to this position otherwise next call to get_random_free_position might return same cell
		self.sound_matrix[r1][c1] = { sound = Sound.new(sound_file), file = sound_file, played_count = 0, match = { r = r2, c = c2 } }
		r2, c2 = self:get_random_free_position()
		self.sound_matrix[r2][c2] = { sound = Sound.new(sound_file), file = sound_file, played_count = 0, match = { r = r1, c = c1 } }
		
		--Have to rassign match for first element as the co-ordinates weren't available previously
		self.sound_matrix[r1][c1].match.r = r2
		self.sound_matrix[r1][c1].match.c = c2
		--print("(" .. r1 .. "," .. c1 ..") " .. " (" .. r2 .. "," .. c2 ..") " .. sound_file)
	end
	--self:print_matrix()
end

function GameController:button_pressed(r, c)
	if(self.first_button) then
		--When clicking the second button, must wait till sound finishes before clicking another one
		sceneManager.current_scene:dispatchEvent(Event.new("disableButtonClicks"))
		self.second_button = { r = r, c = c }
		
		--Stop first sound if it is still playing
		if(self.sound_channel) then
			self.sound_channel:stop()
		end		
	else
		self.first_button = {  r = r, c = c }
	end
	
	--Play sound associated with button
	self.sound_channel = self.sound_matrix[r][c].sound:play()
	
	--If we're on the second button then set up event for when sound is finished to reset buttons and enable clicking
	if(self.second_button) then
		local match = self:isMatch()
		self.sound_channel:addEventListener(Event.COMPLETE, function() sceneManager.current_scene:second_sound_finished(match) end)
	end
end

function GameController:isMatch()
	local match = self.sound_matrix[self.first_button.r][self.first_button.c].match
	if(match.r == self.second_button.r and match.c == self.second_button.c) then
		return true
	else
		return false
	end
end

function GameController:get_random_free_position()
	local r, c, sr, sc
	c = math.random(1, self.num_columns)
	r = math.random(1, self.num_rows)
	
	if(not self.sound_matrix[r]) then
		self.sound_matrix[r] = {}
	end
	--print("First try: " .. "(" .. r .. "," .. c ..") ")
	--If there is already an element in this position, then keep searching until finding an empty one
	--print(self.sound_matrix[r][c])
	if(self.sound_matrix[r][c] ~= nil) then
		--print("not nil")
		local done = false
		sr, sc = r, c
		while not done do
			for i = sr, self.num_rows do
				for j = sc, self.num_columns do
					if(self.sound_matrix[i][j] == nil) then
						--print("Next free: " .. "(" .. i .. "," .. j ..") ")
						done = true
						r, c = i, j
						break
					end
				end
				if(done) then break end
			end
			if(not done) then sr, sc = 1, 1 end
		end
	end
	return r, c
end

function GameController:initialise_matrix()
	self.sound_matrix = {}
	for r = 1,self.num_rows do
		self.sound_matrix[r] = {}
		for c = 1, self.num_columns do
			self.sound_matrix[r][c] = nil
		end
	end
end

function GameController:setup_db()
	self.sound_db = {}
	self.sound_db[1] = { description = "Applause", file = "audio/effects/applause_d2t14.wav", category = "fx" }
	self.sound_db[2] = { description = "Baby Crying", file = "audio/effects/baby_crying_d1t43.wav", category = "fx" }
	self.sound_db[3] = { description = "Birds Twittering", file = "audio/effects/birds_twittering_d2t41.wav", category = "fx" }
	self.sound_db[4] = { description = "Car Horn", file = "audio/effects/car_horn_d2t1.wav", category = "fx" }
	self.sound_db[5] = { description = "Cat Meow", file = "audio/effects/cat_meow_d4t64.wav", category = "animal" }
	self.sound_db[6] = { description = "Church Bells", file = "audio/effects/church_bells_d1t31.wav", category = "fx" }
	self.sound_db[7] = { description = "Crickets", file = "audio/effects/crickets_d3t47.wav", category = "animal" }
	self.sound_db[8] = { description = "Explosion", file = "audio/effects/explosion_d2t29.wav", category = "fx" }
	self.sound_db[9] = { description = "Fog Horn", file = "audio/effects/fog_horn_d2t51.wav", category = "fx" }
	self.sound_db[10] = { description = "Footsteps", file = "audio/effects/footsteps_man_d6t76.wav", category = "fx" }
	self.sound_db[11] = { description = "Gong", file = "audio/effects/gong_d6t32.wav", category = "fx" }
	self.sound_db[12] = { description = "Heartbeat", file = "audio/effects/heartbeat_d1t47.wav", category = "fx" }
	self.sound_db[13] = { description = "Helicopter", file = "audio/effects/helicopter_d4t66.wav", category = "fx" }
	self.sound_db[14] = { description = "Jack hammer", file = "audio/effects/jack_hammer_d3t22.wav", category = "fx" }
	self.sound_db[15] = { description = "Kookaburra", file = "audio/effects/kookaburra_d2t38.wav", category = "animal" }
	self.sound_db[16] = { description = "Man Scream", file = "audio/effects/man_scream_d6t81.wav", category = "fx" }
	self.sound_db[17] = { description = "Rain1", file = "audio/effects/rain_d2t13.wav", category = "fx" }
	self.sound_db[18] = { description = "Rain2", file = "audio/effects/rain_d2t57.wav", category = "fx" }
	self.sound_db[19] = { description = "Seagulls", file = "audio/effects/seagulss_d2t36.wav", category = "animal" }
	self.sound_db[20] = { description = "Telephone", file = "audio/effects/telephone_siemens_d6t59.wav", category = "fx" }
	self.sound_db[21] = { description = "Thunder", file = "audio/effects/thunder_d3t33.wav", category = "fx" }
	self.sound_db[22] = { description = "Ticking Clock", file = "audio/effects/ticking_clock_d1t12.wav", category = "fx" }
	self.sound_db[23] = { description = "Train Horn", file = "audio/effects/train_horn_d4t28.wav", category = "fx" }
	self.sound_db[24] = { description = "Train Whistle", file = "audio/effects/train_whistle_d4t29.wav", category = "fx" }
	self.sound_db[25] = { description = "Wind Chimes", file = "audio/effects/windchimes_d1t35.wav", category = "fx" }
	
	self.num_sounds = table.getn(self.sound_db)
	--table.save(sound_db, "|D|database.db")
end

function GameController:print_matrix()
	for r = 1,self.num_rows do
		for c = 1, self.num_columns do
			if(self.sound_matrix[r][c]) then
				print("(" .. r .. "," .. c ..") " .. self.sound_matrix[r][c].file)
			else
				print("(" .. r .. "," .. c ..") empty")
			end
		end
	end
end