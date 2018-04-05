local t = Def.ActorFrame{};

t[#t+1] = LoadFont("Common Normal") .. {
	InitCommand=function(self)
        self:x(SCREEN_RIGHT-377);
		self:y(SCREEN_BOTTOM-310);
		self:zoom(0.6);
	end;
	BeginCommand=function(self)
		self:settext(getCurRateDisplayString())
	end;
	CodeMessageCommand=function(self,params)
		local rate = getCurRateValue()
		ChangeMusicRate(rate,params)
		self:settext(getCurRateDisplayString())
	end;
};

return t;