﻿-- Author      : bobby.cannon
-- Create Date : 1/7/2012 2:10:50 PM

local TexturePath = "Interface\\AddOns\\BobsToolbox\\Textures\\";

BobsUnitButtonPlayerHudTemplate = {
	-- Initialization Function: Set Size and other properties of the Unit Button.
	-- Variables from addons are not accessible when this function is called.
	SecureInitFunction = [[
		local header = self:GetParent();
		header:CallMethod('InitializeButton', self:GetName());
				
		-- Set width and height;
		self:SetWidth(292);
		self:SetHeight(190);
	]],
	Width = 292,
	Height = 190,
}

function BobsUnitButtonPlayerHudTemplate:Layout(button)
	-- Set template specific values.
	button.HasTarget = false;
	button.Width = BobsUnitButtonPlayerHudTemplate.Width;
	button.Height = BobsUnitButtonPlayerHudTemplate.Height;

	-- Graphics.
	local Graphics = button.Graphics;
	Graphics:ClearAllPoints();
    Graphics:SetAllPoints();
	Graphics:SetScale(1);
	Graphics:SetAlpha(1);
	Graphics:Show();

	-- Button Background
	Graphics.Background:SetBackdrop({bgFile = BobbyCode.Texture.RoundBarLeft});
	Graphics.Background:ClearAllPoints();
	Graphics.Background:SetPoint("LEFT");
	Graphics.Background:SetWidth(28);
	Graphics.Background:SetHeight(button.Height);
	Graphics.Background:Show();

	-- Health Bar
	Graphics.Health:SetStatusBarTexture(BobbyCode.Texture.RoundBarLeft);
	Graphics.Health:SetOrientation("VERTICAL");
	Graphics.Health:ClearAllPoints();
	Graphics.Health:SetAllPoints(Graphics.Background);
	Graphics.Health:SetWidth(28);
	Graphics.Health:SetHeight(button.Height);
	Graphics.Health:Show();

	-- Incoming Health Bar
	Graphics.IncomingHealth:SetStatusBarTexture(BobbyCode.Texture.RoundBarLeft);
	Graphics.IncomingHealth:SetOrientation("VERTICAL");
	Graphics.IncomingHealth:ClearAllPoints();
	Graphics.IncomingHealth:SetAllPoints(Graphics.Health);
	Graphics.IncomingHealth:Show();

	-- Power Bar
	Graphics.Power:SetStatusBarTexture(BobbyCode.Texture.RoundBarRight);
	Graphics.Power:SetBackdrop({bgFile = BobbyCode.Texture.RoundBarRight});
	Graphics.Power:SetOrientation("VERTICAL");
	Graphics.Power:ClearAllPoints();
	Graphics.Power:SetPoint("RIGHT");
	Graphics.Power:SetWidth(28);
	Graphics.Power:SetHeight(button.Height);
	Graphics.Power:Show();

	-- Anchor the overlay.
	Graphics.OverlayAnchor:ClearAllPoints();
	Graphics.OverlayAnchor:SetAllPoints();

	-- Position the text labels.
	BobbyCode:SetFont(Graphics.HealthLabel, { fontOutline = true, fontSize = 10 });
	Graphics.HealthLabel:ClearAllPoints();
	Graphics.HealthLabel:SetPoint("BOTTOMLEFT", Graphics.Background, "BOTTOMRIGHT", 10, 0);

	BobbyCode:SetFont(Graphics.PowerLabel, { fontOutline = true, fontSize = 10 });
	Graphics.PowerLabel:ClearAllPoints();
	Graphics.PowerLabel:SetPoint("BOTTOMRIGHT", Graphics.Power, "BOTTOMLEFT", -10, 0);

	if (button.Settings.ShowValues) then
		Graphics.HealthLabel:Show();
		Graphics.PowerLabel:Show();
	else
		Graphics.HealthLabel:Hide();
		Graphics.PowerLabel:Hide();
	end
		
	-- Hide the remaining unused resources.
	Graphics.Name:Hide()
	Graphics.Level:Hide();
	Graphics.Guild:Hide();
	Graphics.Class:Hide();
	Graphics.Icon:Hide();
	Graphics.Overlay:Hide();
	Graphics.Border:Hide();
	Graphics.Aggro:Hide();
end

function BobsUnitButtonPlayerHudTemplate:UpdateHealth(button)
	-- Update the dead or ghost state.
	button.IsDeadOrGhost = UnitIsDeadOrGhost(button.UnitID) or (UnitHealth(button.UnitID) <= 0);
	
	-- See if the unit is dead or (does not have target and full health)
	if (button.IsDeadOrGhost) or ((not button.HasTarget) and ((UnitHealth(button.UnitID) == UnitHealthMax(button.UnitID)))) then
		button.Graphics.Background:Hide();
		button.Graphics.Health:Hide();
		button.Graphics.IncomingHealth:Hide();
		button.Graphics.HealthLabel:Hide();
		return;
	end

	-- Updating the background color.
	button.Graphics.Background:SetBackdropColor(0.05, 0.05, 0.05, 0.5);
	button.Graphics.Background:Show();

	-- Update the health values.
	button.Graphics.Health:SetMinMaxValues(0, UnitHealthMax(button.UnitID));
	button.Graphics.Health:SetValue(UnitHealth(button.UnitID));
	button.Graphics.Health:SetStatusBarColor(BobbyCode:GetHealthColor(UnitHealth(button.UnitID) / UnitHealthMax(button.UnitID)));
	button.Graphics.Health:SetAlpha(1);
	button.Graphics.Health:Show();
	
	-- Update the health label values.
	button.Graphics.HealthLabel:SetText(BobbyCode:FormatNumbers(UnitHealth(button.UnitID), UnitHealthMax(button.UnitID), button.Settings.ValuesAsPercent));
	if (button.Settings.ShowValues) then
		button.Graphics.HealthLabel:Show();
	end

	-- Update the incoming health values.
	button.Graphics.IncomingHealth:SetMinMaxValues(0, UnitHealthMax(button.UnitID));
	button.Graphics.IncomingHealth:SetValue(UnitHealth(button.UnitID) + (UnitGetIncomingHeals(button.UnitID) or 0));
	button.Graphics.IncomingHealth:SetStatusBarColor(0.2, 0.8, 1);
	button.Graphics.IncomingHealth:SetAlpha(1);
	button.Graphics.IncomingHealth:Show();
end

function BobsUnitButtonPlayerHudTemplate:UpdatePower(button)
	-- See if the unit is dead.
	if (button.IsDeadOrGhost) or ((not button.HasTarget) and ((UnitPower(button.UnitID) == UnitPowerMax(button.UnitID)))) then
		button.Graphics.Power:Hide();
		button.Graphics.PowerLabel:Hide();
		return;
	end

	-- Update the power values.
	button.Graphics.Power:SetMinMaxValues(0, UnitPowerMax(button.UnitID));
	button.Graphics.Power:SetValue(UnitPower(button.UnitID));
	local color = PowerBarColor[select(1, UnitPowerType(button.UnitID))];
	button.Graphics.Power:SetStatusBarColor(color.r, color.g, color.b);
	button.Graphics.Power:SetBackdropColor(0.05, 0.05, 0.05, 0.5);
	button.Graphics.Power:SetAlpha(1);
	button.Graphics.Power:Show();

	-- Update the power label values.
	button.Graphics.PowerLabel:SetText(BobbyCode:FormatNumbers(UnitPower(button.UnitID), UnitPowerMax(button.UnitID), button.Settings.ValuesAsPercent));
	if (button.Settings.ShowValues) then
		button.Graphics.PowerLabel:Show();
	end
end

function BobsUnitButtonPlayerHudTemplate:UpdateRange(button)
	-- Get any information we need quickly.
	if (BobbyCode:RangeCheck(button.UnitID)) then
		button.Graphics:SetAlpha(1);
	else
		button.Graphics:SetAlpha(0.4);
	end
end

function BobsUnitButtonPlayerHudTemplate:UpdateTargetted(button)
	button.HasTarget = (button.UnitID == "player") and (UnitExists("target"));
	BobsUnitButtonPlayerHudTemplate:UpdateHealth(button);
	BobsUnitButtonPlayerHudTemplate:UpdatePower(button);
end