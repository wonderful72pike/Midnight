local CardX = SCREEN_RIGHT - 168;
local CardY = SCREEN_BOTTOM - 68;

local Profile = GetPlayerOrMachineProfile(PLAYER_1);
local Name = Profile:GetDisplayName();
local Rating = Profile:GetPlayerRating();
local PlayCount = Profile:GetTotalNumSongsPlayed();
local ArrowsSmashed = Profile:GetTotalTapsAndHolds();
local PlayTime = Profile:GetTotalSessionSeconds();

local Card = Def.ActorFrame{
	InitCommand=function(self)
		self:xy(CardX, CardY);
	end;
};

Card[#Card+1] = Def.Quad {
	InitCommand=function(self)
		self:diffuse(color("#1C1E2A"));
		self:shadowlength(2);
		self:zoomto(300, 100);
	end;
};

-- Avatar placeholder
Card[#Card+1] = Def.Sprite {
	Texture=THEME:GetPathG("","../"..getAvatarPath(PLAYER_1));
	InitCommand=function(self)
		self:x(-99)
		self:zoomto(80, 80);
	end;
}

-- Player name
Card[#Card+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:halign(0);
		self:maxwidth(330);
		self:settextf("%s: %5.2f",Name,Rating);
		self:xy(-50, -30);
		self:zoom(0.5);
	end;
};
-- Play count
Card[#Card+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:halign(0);
		self:maxwidth(330);
		self:settext(PlayCount.." Songs Played");
		self:xy(-50, -15);
		self:zoom(0.5);
	end;
};
-- Arrows smashed
Card[#Card+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:halign(0);
		self:maxwidth(330);
		self:settext(ArrowsSmashed.." Circles Clicked");
		self:xy(-50, 0);
		self:zoom(0.5);
	end;
};
-- Time Played
Card[#Card+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:halign(0);
		self:maxwidth(330);
		self:settext(SecondsToHHMMSS(PlayTime).." Wasted");
		self:xy(-50, 15);
		self:zoom(0.5);
	end;
};
-- Etterna version
Card[#Card+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		self:halign(0);
		self:maxwidth(330);
		self:settext("Etterna "..GAMESTATE:GetEtternaVersion());
		self:xy(-50, 30);
		self:zoom(0.5);
	end;
};

return Card;