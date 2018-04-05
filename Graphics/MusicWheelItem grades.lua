return Def.ActorFrame{
	-- Grade text, commented out to put it on the song info card
	--[[
	LoadFont("Common Normal")..{
		InitCommand=cmd(NoStroke;zoom,0.65;halign,1;shadowlength,1;x,-165);
		SetGradeCommand=function(self,params)
			local sGrade = params.Grade or 'Grade_None';
			local gradeString = THEME:GetString("Grade",ToEnumShortString(sGrade))
			self:settext(gradeString)
			self:diffuse(getGradeColor(sGrade))
			self:zoom(0.65);
		end;
	};
	]]
	-- Grade color quad
	Def.Quad{
		InitCommand=function(self, params)
			self:diffuse(color("#171717"));
			self:diffusealpha(0.5);
			self:x(-3);
			self:zoomto(306,25);
		end;
		SetGradeCommand=function(self,params)
			local song = params.Song
			local sGrade = params.Grade or 'Grade_None';

			--local gradeString = THEME:GetString("Grade",ToEnumShortString(sGrade))
			self:diffuse(getGradeColor(sGrade))
			--self:diffuse(color(tostring(math.random(1,100)/100)..','..tostring(math.random(1,100)/100)..','..tostring(math.random(1,100)/100)..','..tostring(math.random(50,100)/100)))
		end;
	};
	-- Now for the darker quad on top, to make it darker to see the song text
	Def.Quad{
		InitCommand=function(self)
			self:diffuse(color("#000000"));
			self:diffusealpha(0.7);
			self:zoomto(300,25);
		end
	};
	-- Now the song text
	LoadFont("Common Normal")..{
		Text="Hello",
		InitCommand=cmd(x,-145;y,-4;horizalign,"left";diffuse,color("#ffffff");maxwidth,550;zoom,0.5;shadowlength,1),
		SetCommand=function(self,params)
			local song = params.Song
			local name = song:GetDisplayMainTitle()
			self:settext(name)
		end;
	};
	-- Subtitle
	LoadFont("Common Normal")..{
		Text="Hello",
		InitCommand=cmd(x,-145;y,6;horizalign,"left";diffuse,color("#ffffff");maxwidth,550;zoom,0.3;shadowlength,1),
		SetCommand=function(self,params)
			local song = params.Song
			local name = song:GetDisplaySubTitle();
			self:settext(name)
		end;
	};
}