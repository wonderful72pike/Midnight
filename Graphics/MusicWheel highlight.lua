return Def.ActorFrame{
	Def.Quad {
		InitCommand=function(self, params)
			self:diffuseshift();
			self:effectclock("beat");
			self:effectcolor1(color("1,1,1,0.1"));
			self:effectcolor2(color("1,1,1,0"));
			self:x(117);
			self:zoomto(300,25);
		end
	}
};