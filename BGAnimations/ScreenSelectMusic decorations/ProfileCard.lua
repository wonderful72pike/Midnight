local ProfileCard = Def.ActorFrame{
    Def.Quad {
        InitCommand=function(self, params)
            self:diffuse(color("#1C1E2A"));
            self:x(SCREEN_LEFT + 276);
            self:y(SCREEN_BOTTOM - 60);
            self:zoomto(532,100);
        end
    };

    -- Avatar placeholder
    Def.Quad{
        InitCommand=function(self, params)
            self:x(SCREEN_LEFT + 61);
            self:y(SCREEN_BOTTOM - 60);
            self:zoomto(80, 80);
        end
    };
--[[
    LoadFont("Common Normal") .. {
        Text=PROFILEMAN:GetPlayerName(PLAYER_1);
        InitCommand=function(self, params)
            self:x(SCREEN_LEFT+50);
            self:y(SCREEN_BOTTOM-45);
            self:zoom(0.65);
        end
    }
]]
};

return ProfileCard;