-- Author      : Bobby
-- Create Date : 8/10/2012 5:40:46 PM

function BobsUnitFramePlayerTheme(frame)
	frame.Name:ClearAllPoints();
	frame.Name:SetPoint("BOTTOMLEFT", frame, 4, 4);
	frame.Name:SetTextColor(0.8, 0.8, 0.8, 1);
	frame.Level:ClearAllPoints();
	frame.Level:SetPoint("BOTTOMRIGHT", frame, -4, 4);
	frame.Level:SetTextColor(1, 1, 1, 1);
	frame.Class:Hide();
	frame.Icon:SetHeight(14);
	frame.Icon:SetWidth(14);
	frame.Icon:SetAlpha(0.6);
	frame.Icon:ClearAllPoints();
	frame.Icon:SetPoint("TOPLEFT", 2, -2);
	frame.Portrait:ClearAllPoints();
	frame.Portrait:SetAllPoints(frame);
	frame.PortraitOverlay:SetTexture(BobbyCode.Texture.UnitBorder);
	frame.PortraitOverlay:SetVertexColor(0, 0, 0, 1);
	frame.Power:SetStatusBarTexture(BobbyCode.Texture.HorizontalBar);
	frame.Power:SetBackdrop({bgFile = BobbyCode.Texture.HorizontalBar});
	frame.Power:SetStatusBarColor(0, 1, 0, 1);
	frame.Power:SetBackdropColor(1, 1, 1, 0);
	frame.Power:SetOrientation("HORIZONTAL");
	frame.Power:ClearAllPoints();
	frame.Power:SetPoint("BOTTOMLEFT", frame, 0, -1);
	frame.Power:SetPoint("BOTTOMRIGHT", frame, 0, -1);
	frame.Power:SetHeight(4);
	BobbyCode:ShadeFrame(frame.Power);
	frame.Health:SetStatusBarTexture(BobbyCode.Texture.HorizontalBar);
	frame.Health:SetBackdrop({bgFile = BobbyCode.Texture.HorizontalBar});
	frame.Health:SetStatusBarColor(0, 0, 1, 1);
	frame.Health:SetBackdropColor(1, 1, 1, 0);
	frame.Health:SetOrientation("HORIZONTAL");
	frame.Health:ClearAllPoints();
	frame.Health:SetPoint("BOTTOMLEFT", frame.Power, "TOPLEFT");
	frame.Health:SetPoint("BOTTOMRIGHT", frame.Power, "TOPRIGHT");
	frame.Health:SetHeight(4);
	BobbyCode:ShadeFrame(frame.Health);

	frame.UpdateClass = function(class, color)
		frame.Name:SetTextColor(color.r, color.g, color.b, 1);
	end
end

function BobsUnitFrameRoundBarTheme(frame)
	frame.Name:Hide();
	frame.Level:Hide();
	frame.Class:Hide();
	frame.Icon:Hide();
	frame.Portrait:Hide();
	frame.PortraitOverlay:Hide();
	frame.Power:SetStatusBarTexture(BobbyCode.Texture.RoundBarRight);
	frame.Power:SetBackdrop({bgFile = BobbyCode.Texture.RoundBarRight});
	frame.Power:SetStatusBarColor(0, 1, 0, 1);
	frame.Power:SetBackdropColor(0, 0, 0, 0.5);
	frame.Power:SetOrientation("VERTICAL");
	frame.Power:ClearAllPoints();
	frame.Power:SetPoint("TOPRIGHT", frame);
	frame.Power:SetPoint("BOTTOMLEFT", frame, "BOTTOMRIGHT",  -30, 0);
	frame.Health:SetStatusBarTexture(BobbyCode.Texture.RoundBarLeft);
	frame.Health:SetBackdrop({bgFile = BobbyCode.Texture.RoundBarLeft});
	frame.Health:SetStatusBarColor(0, 0, 1, 1);
	frame.Health:SetBackdropColor(0, 0, 0, 0.5);
	frame.Health:SetOrientation("VERTICAL");
	frame.Health:ClearAllPoints();
	frame.Health:SetPoint("TOPLEFT", frame);
	frame.Health:SetPoint("BOTTOMRIGHT", frame, "BOTTOMLEFT", 30, 0);
end

function BobsUnitFrameHideBars(frame)
	frame.Health:Hide();
	frame.Power:Hide();
end