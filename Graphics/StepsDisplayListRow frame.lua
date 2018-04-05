t = Def.ActorFrame{}

t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:zoomto(120,20):diffusealpha(0.7)
	end;
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
		self.steps=nil
	end;
    CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("MsdUpdate") end;
	-- Also, this doesn't work
	CurrentRateChangedMessageCommand=function(self)
		self:playcommand("MsdUpdate");
	end;
	-- This causes it to lag
	SetCommand=function(self, params)
		--Ignore if we're SetCommanded without params
		if params == nil or params.StepsType == nil or params.CustomDifficulty == nil then return end
		local song = GAMESTATE:GetCurrentSong();
		self.steps = song and song:GetOneSteps(params.StepsType, params.CustomDifficulty)
		self:playcommand("MsdUpdate");
	end;
	MsdUpdateCommand=function(self, params)
		if self.steps then
			local msd = self.steps:GetMSD(getCurRateValue(), 1)
			self:settextf("%05.2f", msd);
		else
			self:settext("");
		end
	end;
}

return t