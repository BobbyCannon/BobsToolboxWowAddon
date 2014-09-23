-- Author      : bobby.cannon
-- Create Date : 12/30/2011 11:52:27 AM

local texturePath = "Interface\\AddOns\\BobsToolbox\\Textures\\";

BobsUnitButtonSquareTemplate = {
	-- Initialization Function: Set Size and other properties of the Unit Button.
	-- Variables from addons are not accessible when this function is called.
	SecureInitFunction = [[
		local header = self:GetParent();
		header:CallMethod('InitializeButton', self:GetName());
				
		-- Set width and height;
		self:SetWidth(44);
		self:SetHeight(44);
	]],
	Width = 44,
	Height = 44,
}

function BobsUnitButtonSquareTemplate:Layout(button)
	-- Set the default template values.
	button.Width = BobsUnitButtonSquareTemplate.Width;
	button.Height = BobsUnitButtonSquareTemplate.Height;

	-- Set the settings defaults for this template.
	button.Settings.PowerSize = 3;

	-- Graphics
	local Graphics = button.Graphics;
	Graphics:ClearAllPoints();
    Graphics:SetPoint("CENTER");
	Graphics:SetWidth(64);
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
	Graphics.Background:SetWidth(36);
	Graphics.Background:SetHeight(36);
	Graphics.Background:Show();

	-- Health Bar
	Graphics.Health:SetStatusBarTexture(BobbyCode.Texture.SolidBar);
	Graphics.Health:SetOrientation("VERTICAL");
	Graphics.Health:ClearAllPoints();
	Graphics.Health:SetPoint("CENTER");
	Graphics.Health:SetWidth(36);
	Graphics.Health:SetHeight(36);
	Graphics.Health:Show();

	-- Incoming Health Bar
	Graphics.IncomingHealth:SetStatusBarTexture(BobbyCode.Texture.SolidBar);
	Graphics.IncomingHealth:SetOrientation("VERTICAL");
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
	Graphics.Power:SetPoint("BOTTOM", 0, 14);
	Graphics.Power:SetHeight(button.Settings.PowerSize);
	Graphics.Power:SetWidth(36);

	if (button.Settings.ShowPower) then
		Graphics.Power:Show();
	else
		Graphics.Power:Hide();
	end

	-- Anchor the overlay.
	Graphics.OverlayAnchor:ClearAllPoints();
	Graphics.OverlayAnchor:SetAllPoints();
	
	-- Position the text labels.
	BobbyCode:SetFont(Graphics.Name, { fontOutline = true, fontSize = 11 });
	Graphics.Name:ClearAllPoints();
	Graphics.Name:SetPoint("BOTTOM", 0, 18);
	Graphics.Name:Show();

	-- Hide the remaining text labels.
	Graphics.Level:Hide();
	Graphics.Guild:Hide();
	Graphics.Class:Hide();
	Graphics.HealthLabel:Hide();
	Graphics.PowerLabel:Hide();

	-- Icon
	Graphics.Icon:SetHeight(16);
	Graphics.Icon:SetWidth(16);
	Graphics.Icon:SetAlpha(1);
	Graphics.Icon:ClearAllPoints();
	Graphics.Icon:SetPoint("TOP", 0, -17);
	if (not Graphics.Icon:IsShown()) then
		Graphics.Icon:Hide();
	end

	-- Overlay
	Graphics.Overlay:SetTexture(texturePath .. "SquareButtonOverlay");
	Graphics.Overlay:ClearAllPoints();
	Graphics.Overlay:SetAllPoints(Graphics);
	Graphics.Overlay:Show();

	-- Border 
	Graphics.Border:SetTexture(texturePath .. "SquareButtonSelect");
	Graphics.Border:ClearAllPoints();
	Graphics.Border:SetAllPoints();
	if (not Graphics.Border:IsShown()) then
		Graphics.Border:Hide();
	end

	-- Aggro 
	Graphics.Aggro:SetTexture(texturePath .. "SquareButtonSelect");
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
			Graphics.Indicators[index]:SetPoint("CENTER", -14, 14);
		elseif (index == 3) then
			Graphics.Indicators[index]:SetPoint("CENTER", 14, 14);
		else
			Graphics.Indicators[index]:SetPoint("TOP", Graphics.Indicators[index - 1], "BOTTOM", 0, -2);
		end		

		-- Hide the indicator.
		Graphics.Indicators[index]:Hide();
	end
end

function BobsUnitButtonSquareTemplate:UpdateName(button)
	-- Update the unit name with only first three characters.
	button.Graphics.Name:SetText(strsub(UnitName(button.UnitID), 0, 3));
end

function BobsUnitButtonSquareTemplate:UpdateClass(button)
	-- Update the name to the class color.
	local _, color = BobbyCode:GetUnitClass(button.UnitID);
	button.Graphics.Name:SetTextColor(color.r, color.g, color.b, 1);
end

function BobsUnitButtonSquareTemplate:UpdateReactionColor(button)
	-- Ignore this function.
end