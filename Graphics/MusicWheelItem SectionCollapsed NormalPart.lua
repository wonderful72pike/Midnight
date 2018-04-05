return Def.ActorFrame {

	Def.Quad{
		InitCommand=cmd(diffuse,color("#1C1E2A");x,-3;zoomto,306,25)
	},

	LoadFont("Common Normal")..{
		Text="Hello",
		InitCommand=cmd(x,-151;horizalign,"left";diffuse,color("#ffffff");maxwidth,450;zoom,0.55;shadowlength,1),
		SetCommand=function(self, params)
			self:settext(params.Text)
		end;
	}
};