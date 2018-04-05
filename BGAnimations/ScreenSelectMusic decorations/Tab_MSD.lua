local skillsets = ms.SkillSets;

local Frame = Def.ActorFrame {
    InitCommand=function(self)
        self:x(SCREEN_LEFT+204); -- Stolen from metrics.ini, this is BannerX
        self:y(SCREEN_BOTTOM-244);
    end;
    -- Command to change all children
    -- This function manually updates ALL actors
    SetCommand=function(self)
        local steps = GAMESTATE:GetCurrentSteps(PLAYER_1); -- steps
        for i=1, #skillsets do
            local SSR = skillsets[i];
            local Meter = steps:GetMSD(getCurRateValue(), i);
            local SkillsetFrame = self:GetChild(skillsets[i]);
            -- Update the title color
            SkillsetFrame:GetChild("Title"):diffuse(ByMSD(Meter));
            local MeterUI = SkillsetFrame:GetChild("Meter");
            MeterUI:settextf("%05.2f", Meter);
            MeterUI:diffuse(ByMSD(Meter));
            local BarUI = SkillsetFrame:GetChild("Bar");
            BarUI:finishtweening();
            BarUI:smooth(0.1);
            BarUI:diffuse(ByMSD(Meter));
            local percentage = (Meter/35 <= 1) and Meter/35 or 1;
            BarUI:zoomto(360*percentage,2);
        end;
    end;
    
    CurrentRateChangedMessageCommand=function(self) self:queuecommand("Set") end;
    CurrentStepsP1ChangedMessageCommand=function(self) self:queuecommand("Set") end;
};

-- Pane background, may not be staying
Frame[#Frame+1] = Def.Quad {
    InitCommand=function(self)
        self:diffuse(color("#1C1E2A"));
        self:zoomto(388,240);
    end;
};

-- The commented lines attempted to access the steps before they were available resulting in the entire screen not loading
for i=1, #skillsets do
    -- Get the SSR and the meter for it
    local SSR = skillsets[i];

    -- A frame to contain each one
    local SSR = Def.ActorFrame{Name=SSR;InitCommand=function(self) self:y(-121 + 27*i); end;};
    Frame[#Frame+1] = SSR;

    -- Skillset background
    SSR[#SSR+1] = Def.Quad {
        Name="Background";
        InitCommand=function(self)
            self:diffuse(color("#08090c"));
            self:zoomto(360,23);
        end;
    };
    -- Skillset name
    SSR[#SSR+1] = LoadFont("Common Normal")..{
        Name="Title";
        InitCommand=function(self)
            self:halign(0);
            self:xy(-175, 0);
            self:zoom(0.6);
        end;
        OnCommand=function(self)
            --self:diffuse(ByMSD(Meter));
            self:settext(skillsets[i]);
        end;
    }
    -- Meter
    SSR[#SSR+1] = LoadFont("Common Normal")..{
        Name="Meter";
        InitCommand=function(self)
            self:halign(1);
            self:xy(175, 0);
            self:zoom(0.6);
        end;
        OnCommand=function(self)
            --self:diffuse(ByMSD(Meter));
            --self:settextf("%05.2f", Meter);
        end;
    }
    -- The bar at the bottom
    SSR[#SSR+1] = Def.Quad {
        Name="Bar";
        InitCommand=function(self)
            self:halign(0);
            self:xy(-180, 10);
        end;
        OnCommand=function(self)
           -- local percentage = (Meter/35 <= 1) and Meter/35 or 1;
            --self:diffuse(ByMSD(Meter));
            --self:zoomto(360*percentage,2);
        end;
    }
end;

return Frame;