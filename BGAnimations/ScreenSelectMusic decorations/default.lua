local Screen = Def.ActorFrame{};

-- Current percent score
local function GetBestScoreByFilter(perc,CurRate)
	local rtTable = getRateTable()
	if not rtTable then return nil end
	
	local rates = tableKeys(rtTable)
	local scores, score
	
	if CurRate then
		local tmp = getCurRateString()
		if tmp == "1x" then tmp = "1.0x" end
		rates = {tmp}
		if not rtTable[rates[1]] then return nil end
	end
	
	table.sort(rates)
	for i=#rates,1,-1 do
		scores = rtTable[rates[i]]
		local bestscore = 0
		local index
		
		for ii=1,#scores do
			score = scores[ii]
			if score:ConvertDpToWife() > bestscore then
				index = ii
				bestscore = score:ConvertDpToWife()
			end
		end
		
		if index and scores[index]:GetWifeScore() == 0 and GetPercentDP(scores[index]) > perc * 100 then
			return scores[index]
		end
		
		if bestscore > perc then
			return scores[index]
		end
	end		
end

local function GetDisplayScore()
	local score
	score = GetBestScoreByFilter(0, true)
	
	if not score then score = GetBestScoreByFilter(0.9, false) end
	if not score then score = GetBestScoreByFilter(0.5, false) end
	if not score then score = GetBestScoreByFilter(0, false) end
	return score
end


Screen[#Screen+1] = LoadActor("ProfileCard");
Screen[#Screen+1] = LoadActor("RightPane");
Screen[#Screen+1] = LoadActor("Tab_MSD");
Screen[#Screen+1] = LoadActor("TopRightPane");

Screen[#Screen+1] = Def.ActorFrame{
	-- **frames/bars**
	Def.Quad{InitCommand=cmd(xy,frameX,frameY-76;zoomto,110,94;halign,0;valign,0;diffuse,color("#333333CC");diffusealpha,0.66)},			--Upper Bar
	Def.Quad{InitCommand=cmd(xy,frameX,frameY+18;zoomto,frameWidth+4,50;halign,0;valign,0;diffuse,color("#333333CC");diffusealpha,0.66)},	--Lower Bar
	Def.Quad{InitCommand=cmd(xy,frameX,frameY-76;zoomto,8,144;halign,0;valign,0;diffuse,getMainColor('highlight');diffusealpha,0.5)},		--Side Bar (purple streak on the left)
	
	-- **score related stuff** These need to be updated with rate changed commands
	-- Primary percent score
	LoadFont("Common Large")..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y);
        end;
		BeginCommand=cmd(queuecommand,"Set");
        SetCommand=function(self)
            local score = GetDisplayScore();
            if score then
                    self:settextf("%05.2f%%", notShit.floor(score:GetWifeScore()*10000)/100);
                    self:diffuse(getGradeColor(score:GetWifeGrade()));
                    self:xy(SCREEN_CENTER_X+40, SCREEN_BOTTOM-80);
                    self:zoom(0.8);
			else
                self:settext("");
                self:diffuse(color("#989898"));
			end
		end;
		CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set"),
		CurrentRateChangedMessageCommand=cmd(queuecommand,"Set"),
	},
	
	-- Rate for the displayed score
	LoadFont("Common Normal")..{
        InitCommand=function(self)
            self:xy(SCREEN_CENTER_X+40, SCREEN_BOTTOM-50);
        end;
		BeginCommand=cmd(queuecommand,"Set"),
        SetCommand=function(self)
            local score = GetDisplayScore();
			if score then 
				local rate = notShit.round(score:GetMusicRate(), 3)
				local notCurRate = notShit.round(getCurRateValue(), 3) ~= rate
				
				local rate = string.format("%.2f", rate)
				if rate:sub(#rate,#rate) == "0" then
					rate = rate:sub(0,#rate-1)
				end
				rate = rate.."x"
					
				if notCurRate then
					self:settext("("..rate..")")
				else
					self:settext(rate)
				end
			else
				self:settext("")
			end
		end;
		CurrentStepsP1ChangedMessageCommand=cmd(queuecommand,"Set");
		CurrentRateChangedMessageCommand=cmd(queuecommand,"Set");
	};
};

Screen[#Screen+1] = Def.StepsDisplayList {
	Name="StepsDisplayListRow";
	SetCommand=function(self)
		if not GAMESTATE:GetCurrentSong() then
			self:visible(false);
		else
			self:visible(true);
		end;
	end;
	CursorP1 = Def.Quad {
		InitCommand=function(self)
			self:xy(SCREEN_RIGHT-377,SCREEN_BOTTOM-264);
			-- effect
			self:diffuseshift();
			self:effectclock("beat");
			self:effectcolor1(color("1,1,1,1"));
            self:effectcolor2(color("1,1,1,0.0"));
			self:zoomto(120,20);
		end;
	};
	CursorP2 = Def.ActorFrame {}; -- no player 2
	CursorP1Frame = Def.Actor{
		ChangeCommand=cmd(stoptweening;decelerate,0.05)
	};
	CursorP2Frame = Def.Actor{}; -- none

	CurrentSongChangedMessageCommand=function(self)
		self:queuecommand("Set");
	end;
};

return Screen;