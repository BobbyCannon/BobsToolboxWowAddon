-- Author      : bobby.cannon
-- Create Date : 1/13/2012 2:14:03 PM

BobsCastingBarDefaultTemplate = {
}

function BobsCastingBarDefaultTemplate:Layout(bar)
	-- Set the bar settings.
	bar:SetWidth(193);
	bar:SetHeight(13);

	-- Reset the graphics settings.
	local Graphics = bar.Graphics;
	Graphics:ClearAllPoints();
    Graphics:SetAllPoints();
	Graphics:SetScale(1);
	Graphics:SetAlpha(1);
	Graphics:Show();

	-- Setup the resources
	Graphics.Bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Graphics.Bar:SetBackdrop({bgFile = BobbyCode.Texture.SolidBar});
	Graphics.Bar:SetBackdropColor(0, 0, 0, 0.5);
	Graphics.Bar:SetStatusBarColor(1, 0.7, 0, 1);
	Graphics.Bar:ClearAllPoints();
	Graphics.Bar:SetAllPoints();
	Graphics.Bar:Show();

	BobbyCode:SetFont(Graphics.Text, { fontOutline = false, fontSize = 11 });
	Graphics.Text:SetJustifyH("CENTER");
	Graphics.Text:ClearAllPoints();
	Graphics.Text:SetPoint("TOPLEFT", 0, 0);
	Graphics.Text:SetPoint("BOTTOMRIGHT", 0, 0);
	Graphics.Text:Show();

	Graphics.Icon:SetWidth(16);
	Graphics.Icon:SetHeight(16);
	Graphics.Icon:ClearAllPoints();
	Graphics.Icon:SetPoint("RIGHT", bar, "LEFT", -5, 0);
	Graphics.Icon:Hide();

	Graphics.Border:SetTexture("Interface\\CastingBar\\UI-CastingBar-Border-Small");
	Graphics.Border:SetWidth(256);
	Graphics.Border:SetHeight(64);
	Graphics.Border:ClearAllPoints();
	Graphics.Border:SetPoint("CENTER");
	Graphics.Border:Show();

	Graphics.BorderShield:SetTexture("Interface\\CastingBar\\UI-CastingBar-Small-Shield");
	Graphics.BorderShield:SetWidth(256);
	Graphics.BorderShield:SetHeight(64);
	Graphics.BorderShield:ClearAllPoints();
	Graphics.BorderShield:SetPoint("CENTER");
	Graphics.BorderShield:Hide();

	Graphics.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark");
	Graphics.Spark:SetBlendMode("ADD");
	Graphics.Spark:SetWidth(32);
	Graphics.Spark:SetHeight(32);
	Graphics.Spark:ClearAllPoints();
	Graphics.Spark:SetPoint("CENTER");
	Graphics.Spark:Hide();

	Graphics.Flash:SetTexture("Interface\\CastingBar\\UI-CastingBar-Flash-Small");
	Graphics.Flash:SetWidth(256);
	Graphics.Flash:SetHeight(64);
	Graphics.Flash:ClearAllPoints();
	Graphics.Flash:SetPoint("CENTER");
	Graphics.Flash:Hide();
end