local Frame = Def.ActorFrame{
    InitCommand=function(self)
        self:x(SCREEN_RIGHT-377);
        self:y(SCREEN_TOP+77);
    end;
    CurrentSongChangedMessageCommand=function(self)
        self:visible(GAMESTATE:GetCurrentSong() ~= nil);
    end;
};

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
        self:zoomto(130,134);
    end;
}

return Frame;