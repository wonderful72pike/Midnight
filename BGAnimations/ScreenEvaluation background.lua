return Def.Sprite {
	InitCommand=function(self)
		self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y)
	end;
	OnCommand=function(self)
		if GAMESTATE:GetCurrentSong():GetBackgroundPath() then
			self:visible(true);
			self:diffuse(color("#394159"));
			self:LoadBackground(GAMESTATE:GetCurrentSong():GetBackgroundPath());
			self:stretchto(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
		end;
	end;
};