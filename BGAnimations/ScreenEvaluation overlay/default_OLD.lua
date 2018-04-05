-- TODO
-- Add banner too
--- WAY TOO MANY TABLES
--- NOTE: The script to contain these in is "Texts.lua", do this tomorrow

-- Yes this file is long, but it's much neater than Til Death's, just Ctrl+F for what you want

local Judgements = {
	"TapNoteScore_W1",
	"TapNoteScore_W2",
	"TapNoteScore_W3",
	"TapNoteScore_W4",
	"TapNoteScore_W5",
	"TapNoteScore_Miss",
}

local TextJudgements = {
	"Marvelous",
	"Perfect",
	"Great",
	"Good",
	"Bad",
	"Miss"
}

-- most of this should go into a script, and it will in the finished theme
grades = {
	Grade_Tier01	= "4A", -- AAAA
	Grade_Tier02	= "3A", -- AAA
	Grade_Tier03	= "2A", -- AA
	Grade_Tier04	= "A", -- A
	Grade_Tier05	= "B", -- B
	Grade_Tier06	= "C", -- C
	Grade_Tier07	= "D", -- D
	Grade_Tier08	= "?", -- ITG PLS
	Grade_Tier09	= "?", -- ITG PLS
	Grade_Tier10	= "?", -- ITG PLS
	Grade_Tier11	= "?", -- ITG PLS
	Grade_Tier12	= "?", -- ITG PLS
	Grade_Tier13	= "?", -- ITG PLS
	Grade_Tier14	= "?", -- ITG PLS
	Grade_Tier15	= "?", -- ITG PLS
	Grade_Tier16	= "?", -- ITG PLS
	Grade_Tier17	= "?", -- ITG PLS
	Grade_Failed	= "F", -- F
};

function shortGrade(grade)
	return grades[grade];
end;

-- Main container, takes up the entire screen
local Screen = Def.ActorFrame{};

-- Coordinates for the huge judgments container
local judgmentX = SCREEN_LEFT + 170; -- Former SCREEN_LEFT+160 and 330 in the center layout;
local judgmentY = SCREEN_BOTTOM - 180;

-- Coordinates for the small Holds/Rolls/Lifts/Mines pane
local altJudgeX = SCREEN_CENTER_X - 20; -- previously SCREEN_CENTER_X+150;
local altJudgeY = SCREEN_CENTER_Y + 19;

-- Coordinates for the Wife/MSD pane
local wifeX = SCREEN_LEFT + 170;
local wifeY = SCREEN_TOP + 120;

-- Coordinates for that huge grade letter box
local gradeX = SCREEN_CENTER_X - 20; -- previously SCREEN_CENTER_X+150;
local gradeY = SCREEN_CENTER_Y - 61;

-- Frame that contains judgments
local JudgmentFrame = Def.ActorFrame{
	InitCommand=function(self)
		-- coordinates for this entire frame
		self:x(judgmentX);
		self:y(judgmentY);
	end;
	-- Background for this frame
	Def.Quad{
		InitCommand=function(self, params)
			self:diffuse(color("#1C1E2A"));
			self:shadowlength(2);
			self:zoomto(300,300);
		end
	};
};

local song = GAMESTATE:GetCurrentSong();
local stageStats = STATSMAN:GetCurStageStats():GetPlayerStageStats(PLAYER_1)
local score = SCOREMAN:GetMostRecentScore()

-- First we do the judgements
for index, judgement in ipairs(Judgements) do
	local stat = stageStats:GetTapNoteScores(judgement);
	local percentage = stageStats:GetPercentageOfTaps(judgement);
	local textStat = TextJudgements[index];

	-- Background bar
	--[[
	JudgmentFrame[#JudgmentFrame+1] = Def.Quad{
		InitCommand=function(self)
			self:diffuse(color("#08090c"));
			self:y(-185 + 30*index);
			self:zoomto(290,20);
		end;
	};
	--]]

	-- First, we create the text judgement name
	JudgmentFrame[#JudgmentFrame+1] = LoadFont("Common Large")..{
		InitCommand=function(self, params)
			self:diffuse(byJudgment(judgement)); -- judgement AND judgment are both valid spellings, check Wikipedia
			self:halign(0);
			self:settext(textStat);
			self:shadowlength(2);
			self:x(-140); -- originally 25
			self:y(-165 + 30*index);
			self:zoom(0.35);
		end
	}

	-- Then we show how many the player got!
	JudgmentFrame[#JudgmentFrame+1] = LoadFont("Common Large")..{
		InitCommand=function(self, params)
			self:diffuse(byJudgment(judgement));
			self:halign(1); -- halign 1 = right alignment btw, I spent 2 hours figuring this out the first time I used it
			self:settext(stat);
			self:shadowlength(2);
			self:x(140);
			self:y(-165 + 30*index);
			self:zoom(0.35);
		end
	}

	-- Little line underneath each judgment
	JudgmentFrame[#JudgmentFrame+1] = Def.Quad {
		InitCommand=function(self, params)
			self:diffuse(byJudgment(judgement));
			self:y(-155 + 30*index)
			self:zoomto(290,1);
		end
	}

	-- Now for some math
	-- We take the percentage and multiply it by 290 to scale the bar to it
	-- Then we cut that in half to offset the bar back to the left
	local barLength = 290 * percentage;
	local offset = barLength/2 - 145;

	-- Now we do the bar underneath to visualize the percentage
	JudgmentFrame[#JudgmentFrame+1] = Def.Quad {
		InitCommand=function(self, params)
			self:diffuse(byJudgment(judgement));
			self:diffusealpha(0.2);
			self:x(offset);
			self:y(-165 + 30*index);
			self:zoomto(barLength,20);
		end;
	};
end;

JudgmentFrame[#JudgmentFrame+1] = LoadActor("OffsetPlot");

-- Now we do grading/wife, here's the ActorFrame for that
local WifeFrame = Def.ActorFrame{
	InitCommand=function(self)
		self:x(wifeX);
		self:y(wifeY);
	end;
	
	-- The background for this frame
	Def.Quad {
		InitCommand=function(self)
			self:diffuse(color("#1C1E2A"));
			self:shadowlength(2);
			self:zoomto(300,35);
		end;
	};

	-- Wife%
	LoadFont("Common Large")..{
		-- Where's InitCommand???
		-- Well it turns out that this BeginCommand will completely override it with SetCommand so we don't need it
		BeginCommand=function(self)
			self:queuecommand("Set");
		end;
		SetCommand=function(self)
			self:diffuse(getGradeColor(stageStats:GetWifeGrade()));
			self:halign(1);
			self:settext((notShit.floor(stageStats:GetWifeScore()*10000)/100).."%");
			self:x(140);
			self:zoom(0.5);
		end;
	};

	-- MSD
	LoadFont("Common Large")..{
		BeginCommand=function(self)
			self:queuecommand("Set");
		end;
		SetCommand=function(self, params)
			local meter = score:GetSkillsetSSR("Overall");
			self:settextf("%5.2f", meter)
			self:diffuse(ByMSD(meter));
			self:halign(0);
			self:x(-140);
			self:zoom(0.5);
		end;
	};
};

local GradeFrame = Def.ActorFrame{
	InitCommand=function(self)
		self:x(gradeX);
		self:y(gradeY);
	end;

	-- Big huge grade letter background
	Def.Quad {
		InitCommand=function(self)
			self:diffuse(color("#1C1E2A"));
			self:shadowlength(2);
			self:zoomto(150,150);
		end;
	};

	-- Difficulty

	LoadFont("Common Large")..{
		InitCommand=function(self)
			local diff = GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty();
			self:diffuse(getDifficultyColor(diff));
			self:settext(getDifficulty(diff));
			self:y(50);
			self:zoom(0.5);
		end;
	};

	-- The big huge grade letter (OLD text version)
	--[[
	LoadFont("Common Large")..{
		BeginCommand=function(self)
			self:queuecommand("Set");
		end;
		SetCommand=function(self, params)
			local grade = stageStats:GetWifeGrade();
			self:diffuse(getGradeColor(grade));
			self:maxwidth(100);
			self:settext(shortGrade(grade));
			self:zoom(1.25);
		end;
	};
	--]]
	-- Grade image
	Def.Sprite {
		Texture=THEME:GetPathG("Grade",shortGrade(stageStats:GetWifeGrade()));
		InitCommand=function(self)
			local grade = stageStats:GetWifeGrade();
			self:diffuse(getGradeColor(grade));
			self:y(-15);
			self:zoom(0.5);
		end;
	};

};

-- Holds/Rolls/Mines
local altJudgeFrame = Def.ActorFrame {
	InitCommand=function(self)
		self:x(altJudgeX);
		self:y(altJudgeY);
	end;

	-- Background for holds
	Def.Quad {
		InitCommand=function(self)
			self:diffuse(color("#1C1E2A"));
			self:shadowlength(2);
			self:y(10);
			self:zoomto(150,20);
		end;
	};
	-- Background for mines
	Def.Quad {
		InitCommand=function(self)
			self:diffuse(color("#1C1E2A"));
			self:shadowlength(2);
			self:y(35);
			self:zoomto(150,20);
		end;
	};
	-- Background for judge difficulty
	Def.Quad {
		InitCommand=function(self)
			self:diffuse(color("#1C1E2A"));
			self:shadowlength(2);
			self:y(60);
			self:zoomto(150,20);
		end;
	};
	-- Background for life difficulty
	Def.Quad {
		InitCommand=function(self)
			self:diffuse(color("#1C1E2A"));
			self:shadowlength(2);
			self:y(85);
			self:zoomto(150,20);
		end;
	};

	-- Text for holds
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:halign(0);
			self:settext("Holds:");
			self:x(-70);
			self:y(10);
			self:zoom(0.5);
		end;
	};
	-- # of holds text
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			local held = stageStats:GetHoldNoteScores("HoldNoteScore_Held");
			local letGo = stageStats:GetHoldNoteScores("HoldNoteScore_LetGo")
			local total = held + letGo;
			if total == held then
				self:diffuse(color("#ffd000"));
			end;
			self:halign(1);
			self:settext(held.."/"..total);
			self:x(70);
			self:y(10);
			self:zoom(0.5);
		end;
	};
	-- Text for mines
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:halign(0);
			self:settext("Mines:");
			self:x(-70);
			self:y(35);
			self:zoom(0.5);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			local mines = stageStats:GetTapNoteScores("TapNoteScore_HitMine");
			if mines == 0 then
				self:diffuse(color("#ffd000"));
			end;
			self:halign(1);
			self:settext(mines);
			self:x(70);
			self:y(35);
			self:zoom(0.5);
		end;
	};
	-- Text for judge difficulty
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:halign(0);
			self:settext("Timing Difficulty:");
			self:x(-70);
			self:y(60);
			self:zoom(0.5);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:halign(1);
			self:settext(GetTimingDifficulty());
			self:x(70);
			self:y(60);
			self:zoom(0.5);
		end;
	};
	-- Text for life difficulty
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:halign(0);
			self:settext("Life Difficulty:");
			self:x(-70);
			self:y(85);
			self:zoom(0.5);
		end;
	};
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:halign(1);
			self:settext(GetLifeDifficulty());
			self:x(70);
			self:y(85);
			self:zoom(0.5);
		end;
	};
};

-- Song infobar, still positioned globally because I don't expect it to be moving
Screen[#Screen+1] = Def.ActorFrame{
	-- background
	Def.Quad {
		InitCommand=function(self)
			self:diffuse(color("#1C1E2A"));
			self:diffusetopedge(color("#0A0D19"));
			self:x(SCREEN_CENTER_X);
			self:y(37);
			self:zoomto(SCREEN_WIDTH,74);
		end;	
	};

	-- Song title
	LoadFont("Common Large")..{
		InitCommand=function(self)
			self:diffusebottomedge(color("#A9A9A9"));
			self:settext(song:GetDisplayMainTitle());
			self:x(SCREEN_CENTER_X)
			self:y(20);
			self:zoom(0.6);
		end;
	};

	-- Song subtitle
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:diffusebottomedge(color("#A9A9A9"));
			self:settext(song:GetDisplaySubTitle());
			self:x(SCREEN_CENTER_X);
			self:y(45);
			self:zoom(0.5);
		end;
	};

	-- Rate
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:diffuse(color("#ffd000"));
			self:diffusebottomedge(color("#ffb600"));
			self:settext(getCurRateDisplayString());
			self:x(SCREEN_CENTER_X);
			self:y(60);
			self:zoom(0.5);
		end;
	};

	-- Bottom bar
	Def.Quad {
		InitCommand=function(self)
			self:diffuse(color("#435068"));
			self:x(SCREEN_CENTER_X);
			self:y(75);
			self:zoomto(SCREEN_WIDTH, 2);
		end;
	};
};

-- Add all these frames we just created to the screen
Screen[#Screen+1] = JudgmentFrame;
Screen[#Screen+1] = WifeFrame;
Screen[#Screen+1] = GradeFrame;
Screen[#Screen+1] = altJudgeFrame;
--Screen[#Screen+1] = LoadActor("ScreenEvaluation OffsetPlot");
Screen[#Screen+1] = LoadActor("Scoreboard");
Screen[#Screen+1] = LoadActor("ProfileCard");

return Screen;