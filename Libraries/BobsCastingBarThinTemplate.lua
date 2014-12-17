-- Author      : bobby.cannon
-- Create Date : 1/13/2012 7:41:32 PM

BobsCastingBarThinTemplate = {
}

function BobsCastingBarThinTemplate:Layout(bar)
	-- Set the bar settings.
	bar:SetWidth(bar.Settings.Width);
	bar:SetHeight(bar.Settings.Height);
	
	-- Reset the graphics settings.
	local Graphics = bar.Graphics;
	Graphics:ClearAllPoints();
    Graphics:SetPoint("BOTTOM");
	Graphics:SetWidth(bar.Settings.Width);
	Graphics:SetHeight(16);
	Graphics:SetScale(1);
	Graphics:SetAlpha(1);
	Graphics:Show();

	-- Setup the resources
	Graphics.Bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar");
	Graphics.Bar:SetBackdrop({bgFile = BobbyCode.Texture.SolidBar});
	Graphics.Bar:SetBackdropColor(0, 0, 0, 0.5);
	Graphics.Bar:SetStatusBarColor(1, 0.7, 0, 1);
	Graphics.Bar:SetHeight(4);
	Graphics.Bar:ClearAllPoints();
	Graphics.Bar:SetPoint("BOTTOMLEFT");
	Graphics.Bar:SetPoint("BOTTOMRIGHT");
	Graphics.Bar:Show();

	BobbyCode:SetFont(Graphics.Text, { fontOutline = true, fontSize = bar.Settings.FontSize });
	Graphics.Text:SetJustifyH("LEFT");
	Graphics.Text:ClearAllPoints();
	Graphics.Text:SetPoint("TOPLEFT");
	Graphics.Text:Show();

	Graphics.Icon:SetWidth(16);
	Graphics.Icon:SetHeight(16);
	Graphics.Icon:ClearAllPoints();
	Graphics.Icon:SetPoint("TOPRIGHT");
	Graphics.Icon:Hide();

	Graphics.Spark:SetTexture("");
	Graphics.Spark:Hide();
	Graphics.Border:SetTexture("");
	Graphics.Border:Hide();
	Graphics.BorderShield:SetTexture("");
	Graphics.BorderShield:Hide();
	Graphics.Flash:SetTexture("");
	Graphics.Flash:Hide();
end