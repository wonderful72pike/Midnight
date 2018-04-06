local Frame = Def.ActorFrame{
    InitCommand=function(self)
        self:x(SCREEN_RIGHT-377);
        self:y(SCREEN_BOTTOM-224);
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:visible(GAMESTATE:GetCurrentSong() ~= nil);
    end;
};

-- Y coordinates that we can use as anchors
-- Offset by 10 for the difficulty bars
local frameTop = -110;
local frameBottom = 100;

local Difficulties = {
    "Difficulty_Beginner",
    "Difficulty_Easy",
    "Difficulty_Medium",
    "Difficulty_Hard",
    "Difficulty_Challenge",
    "Difficulty_Edit"
}

-- First we define the background for the ActorFrame
Frame[#Frame+1] = Def.Quad {
    InitCommand=function(self, params)
        self:diffuse(color("#1C1E2A"));
        self:zoomto(130,200);
    end;
}

for index, diff in ipairs(Difficulties) do
    -- One ActorFrame per grade
    local frame = Def.ActorFrame{
        InitCommand=function(self)
            self:y(frameTop+45+index*25);
        end;
    };

    -- Regular color quad
    frame[#frame+1] = Def.Quad {
        Name=diff;
        InitCommand=function(self, params)
            self:diffuse(color("#08090c"));
            self:zoomto(120,20);
        end;
    }

    -- Dark quad
    frame[#frame+1] = Def.Quad {
        InitCommand=function(self)
            self:diffuse(color("#000000"));
            self:diffusealpha(0.7);
            self:zoomto(114,20);
            self:x(3);
        end;
    }

    Frame[#Frame+1] = frame;
end

-- Song length
Frame[#Frame+1] = LoadFont("Common Normal") .. {
    BeginCommand=function(self)
        self:zoom(0.75);
        self:y(frameTop+28);
        self:queuecommand("Set");
    end;
    SetCommand=function(self)
        local song = GAMESTATE:GetCurrentSong();
		if song then
			local playabletime = GetPlayableTime()
			self:settext(SecondsToMMSS(playabletime))
			self:diffuse(ByMusicLength(playabletime))
		else
			self:settext("")
		end
	end;
    CurrentRateChangedMessageCommand=function(self)
        self:queuecommand("Set");
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:queuecommand("Set");
    end;
};

-- Rate
Frame[#Frame+1] = LoadFont("Common Normal") .. {
    InitCommand=function(self)
        self:y(frameTop+43);
		self:zoom(0.6);
	end;
	BeginCommand=function(self)
		self:settext(string.gsub(getCurRateDisplayString(), "Music", ""));
	end;
	CodeMessageCommand=function(self,params)
		local rate = getCurRateValue()
		ChangeMusicRate(rate,params)
		self:settext(string.gsub(getCurRateDisplayString(), "Music", ""));
	end;
};

return Frame;