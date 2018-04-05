local gc = Var("GameCommand")

return Def.ActorFrame {
	LoadFont("Common Large") .. {
		Text=THEME:GetString("ScreenTitleMenu",gc:GetText()),
		OnCommand=function(self)
			self:halign(0.5):y(90):zoom(0.4):shadowlength(2)
		end,
		GainFocusCommand=function(self)
			self:stoptweening():drop(0.4):diffusealpha(1):diffuse(color("#FFFFFF"))
		end,
		LoseFocusCommand=function(self)
			self:stoptweening():diffuse(color("#d35400"))
		end
 	}
}