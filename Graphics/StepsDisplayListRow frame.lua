t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
	InitCommand=cmd(zoomto,120,20;diffusealpha,0.7);
};

t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:diffuse(color("#00000"));
		self:diffusealpha(0.7);
		self:zoomto(114,20);
		self:x(3);
	end;
};

t[#t+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:zoom(0.6);
	end;
	-- This causes it to lag
	--[[
	SetCommand=function(self, param)
		local song = GAMESTATE:GetCurrentSong();
		local msd = song:GetOneSteps(param.StepsType, param.CustomDifficulty):GetMSD(getCurRateValue(), 1);
		self:settextf("%05.2f", msd);
	end;
	-- Also, this doesn't work
	CurrentRateChangedMessageCommand=function(self)
		self:queuecommand("Set");
	end;
	]]
}

return t