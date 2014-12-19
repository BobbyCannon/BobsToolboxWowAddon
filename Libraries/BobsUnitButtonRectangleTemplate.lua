-- Author      : bobby.cannon
-- Create Date : 12/30/2011 11:52:27 AM

local texturePath = "Interface\\AddOns\\BobsToolbox\\Textures\\";

BobsUnitButtonRectangleTemplate = {
	-- Initialization Function: Set Size and other properties of the Unit Button.
	-- Variables from addons are not accessible when this function is called.
	SecureInitFunction = [[
		local header = self:GetParent();
		header:CallMethod('InitializeButton', self:GetName());
				
		-- Set width and height;
		self:SetWidth(108);
		self:SetHeight(24);
	]],
	Name = "Rectangle",
	Width = 108,
	Height = 24,
}

function BobsUnitButtonRectangleTemplate:Layout(button)
	-- Set the default template values.
	button.Width = BobsUnitButtonRectangleTemplate.Width;
	button.Height = BobsUnitButtonRectangleTemplate.Height;
	
	-- Set the width and height of the button.
	button:SetWidth(button.Width);
	button:SetHeight(button.Height);

	-- Set the settings defaults for this template.
	button.Settings.PowerSize = 2;

	-- Graphics
	local Graphics = button.Graphics;
	Graphics:ClearAllPoints();
    Graphics:SetPoint("CENTER");
	Graphics:SetWidth(128);
	Graphics:SetHeight(64);
	Graphics:SetScale(1);
	Graphics:SetAlpha(1);
	Graphics:Show();

	-- Button Background
	local r, g, b, a = Graphics.Background:GetBackdropColor();
	Graphics.Background:SetBackdrop({bgFile = BobbyCode.Texture.SolidBar});
	Graphics.Background:SetBackdropColor(r, g, b, a);
	Graphics.Background:ClearAllPoints();
	Graphics.Background:SetPoint("CENTER", button);
	Graphics.Background:SetWidth(100);
	Graphics.Background:SetHeight(16);
	Graphics.Background:Show();

	-- Health Bar
	Graphics.Health:SetStatusBarTexture(BobbyCode.Texture.SolidBar);
	Graphics.Health:SetOrientation("HORIZONTAL");
	Graphics.Health:ClearAllPoints();
	Graphics.Health:SetPoint("CENTER");
	Graphics.Health:SetWidth(100);
	Graphics.Health:SetHeight(16);
	Graphics.Health:Show();

	-- Incoming Health Bar
	Graphics.IncomingHealth:SetStatusBarTexture(BobbyCode.Texture.SolidBar);
	Graphics.IncomingHealth:SetOrientation("HORIZONTAL");
	Graphics.IncomingHealth:ClearAllPoints();
	Graphics.IncomingHealth:SetAllPoints(Graphics.Health);
	Graphics.IncomingHealth:Show();

	-- Power Bar
	r, g, b, a = Graphics.Power:GetBackdropColor();
	Graphics.Power:SetStatusBarTexture(BobbyCode.Texture.SolidBar);
	Graphics.Power:SetBackdrop({bgFile = BobbyCode.Texture.SolidBar});
	Graphics.Power:SetBackdropColor(r, g, b, a);
	Graphics.Power:SetOrientation("HORIZONTAL");
	Graphics.Power:ClearAllPoints();
	Graphics.Power:SetPoint("BOTTOM", 0, 24);
	Graphics.Power:SetHeight(button.Settings.PowerSize);
	Graphics.Power:SetWidth(100);

	if (button.Settings.ShowPower) then
		Graphics.Power:Show();
	else
		Graphics.Power:Hide();
	end

	-- Anchor the overlay.
	Graphics.OverlayAnchor:ClearAllPoints();
	Graphics.OverlayAnchor:SetAllPoints();
	
	-- Position the text labels.
	BobbyCode:SetLabelFont(Graphics.Name, BobbyCode.Color.White, 11, true);
	Graphics.Name:ClearAllPoints();
	Graphics.Name:SetPoint("TOPLEFT", 16, -24);
	Graphics.Name:SetHeight(16);
	Graphics.Name:SetWidth(96);
	Graphics.Name:Show();

	-- Hide the remaining text labels.
	Graphics.Level:Hide();
	Graphics.Guild:Hide();
	Graphics.Class:Hide();
	Graphics.HealthLabel:Hide();
	Graphics.PowerLabel:Hide();

	-- Icon
	Graphics.Icon:SetHeight(14);
	Graphics.Icon:SetWidth(14);
	Graphics.Icon:SetAlpha(1);
	Graphics.Icon:ClearAllPoints();
	Graphics.Icon:SetPoint("RIGHT", -14, 0);
	if (not Graphics.Icon:IsShown()) then
		Graphics.Icon:Hide();
	end

	-- Overlay
	Graphics.Overlay:SetTexture(BobbyCode.Texture.RectangleOverlay);
	Graphics.Overlay:ClearAllPoints();
	Graphics.Overlay:SetAllPoints(Graphics);
	Graphics.Overlay:Show();

	-- Border 
	Graphics.Border:SetTexture(BobbyCode.Texture.RectangleSelect);
	Graphics.Border:ClearAllPoints();
	Graphics.Border:SetAllPoints();
	if (not Graphics.Border:IsShown()) then
		Graphics.Border:Hide();
	end

	-- Aggro 
	Graphics.Aggro:SetTexture(BobbyCode.Texture.RectangleSelect);
	Graphics.Aggro:ClearAllPoints();
	Graphics.Aggro:SetAllPoints();
	if (not Graphics.Aggro:IsShown()) then
		Graphics.Aggro:Hide();
	end

	-- Indicators
	for index = 1, 4 do 
		Graphics.Indicators[index]:SetTexture(BobbyCode.Texture.SolidBar);
		Graphics.Indicators[index]:SetSize(4, 4);
		Graphics.Indicators[index]:ClearAllPoints();

		-- Check to see if we are the first indicator.
		if (index == 1) then
			Graphics.Indicators[index]:SetPoint("CENTER", 46, 4);
		else
			Graphics.Indicators[index]:SetPoint("RIGHT", Graphics.Indicators[index - 1], "LEFT", -2, 0);
		end		

		-- Hide the indicator.
		Graphics.Indicators[index]:Hide();
	end
end

function BobsUnitButtonRectangleTemplate:UpdateClass(button)
	-- Update the name to the class color.
	local _, color = BobbyCode:GetUnitClass(button.Unit);
	button.Graphics.Name:SetTextColor(color.r, color.g, color.b, 1);
end

function BobsUnitButtonRectangleTemplate:UpdateReactionColor(button)
	-- Ignore this function.
end