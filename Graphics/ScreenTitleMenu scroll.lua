local gc = Var("GameCommand")

return Def.ActorFrame {
	LoadFont("Common Large") .. {
		Text=THEME:GetString("ScreenTitleMenu",gc:GetText()),
		OnCommand=cmd(halign,0.5;y,90;zoom,0.4;shadowlength,2;),
		GainFocusCommand=cmd(stoptweening;drop,0.4;diffusealpha,1;diffuse,color("#FFFFFF")),
		LoseFocusCommand=cmd(stoptweening;diffuse,color("#d35400"))
 	}
}