-- Author      : bobby.cannon
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
	Name = "PlayerHud",
	Width = 292,
	Height = 190,
}

function BobsUnitButtonPlayerHudTemplate:Layout(button)
	-- Set template specific values.
	button.HasTarget = false;
	button.Width = BobsUnitButtonPlayerHudTemplate.Width;
	button.Height = BobsUnitButtonPlayerHudTemplate.Height;
	
	-- Set the width and height of the button.
	button:SetWidth(button.Width);
	button:SetHeight(button.Height);

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
	Graphics.Background:SetPoint("LEFT", button, -45, 0);
	Graphics.Background:SetWidth(96);
	Graphics.Background:SetHeight(button.Height);
	Graphics.Background:Show();

	-- Health Bar
	Graphics.Health:SetStatusBarTexture(BobbyCode.Texture.RoundBarLeft);
	Graphics.Health:SetOrientation("VERTICAL");
	Graphics.Health:ClearAllPoints();
	Graphics.Health:SetAllPoints(Graphics.Background);
	Graphics.Health:SetWidth(96);
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
	Graphics.Power:SetPoint("RIGHT", button, 45, 0);
	Graphics.Power:SetWidth(96);
	Graphics.Power:SetHeight(button.Height);
	Graphics.Power:Show();

	-- Anchor the overlay.
	Graphics.OverlayAnchor:ClearAllPoints();
	Graphics.OverlayAnchor:SetAllPoints();

	-- Position the text labels.
	BobbyCode:SetLabelFont(Graphics.HealthLabel, BobbyCode.Color.White, 10, true);
	Graphics.HealthLabel:ClearAllPoints();
	Graphics.HealthLabel:SetPoint("BOTTOMLEFT", Graphics.Background, "BOTTOMRIGHT", 0, 0);

	BobbyCode:SetLabelFont(Graphics.PowerLabel, BobbyCode.Color.White, 10, true);
	Graphics.PowerLabel:ClearAllPoints();
	Graphics.PowerLabel:SetPoint("BOTTOMRIGHT", Graphics.Power, "BOTTOMLEFT", 0, 0);
	
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
	button.IsDeadOrGhost = UnitIsDeadOrGhost(button.Unit) or (UnitHealth(button.Unit) <= 0);
	
	-- See if the unit is dead or (does not have target and full health)
	if (button.IsDeadOrGhost) or ((not button.HasTarget) and ((UnitHealth(button.Unit) == UnitHealthMax(button.Unit)))) then
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
	button.Graphics.Health:SetMinMaxValues(0, UnitHealthMax(button.Unit));
	button.Graphics.Health:SetValue(UnitHealth(button.Unit));
	button.Graphics.Health:SetStatusBarColor(BobbyCode:GetHealthColor(button.Unit));
	button.Graphics.Health:SetAlpha(1);
	button.Graphics.Health:Show();
	
	-- Update the health label values.
	button.Graphics.HealthLabel:SetText(BobbyCode:FormatNumbers(UnitHealth(button.Unit), UnitHealthMax(button.Unit), button.Settings.ValuesAsPercent));
	if (button.Settings.ShowValues) then
		button.Graphics.HealthLabel:Show();
	end

	-- Update the incoming health values.
	button.Graphics.IncomingHealth:SetMinMaxValues(0, UnitHealthMax(button.Unit));
	button.Graphics.IncomingHealth:SetValue(UnitHealth(button.Unit) + (UnitGetIncomingHeals(button.Unit) or 0));
	button.Graphics.IncomingHealth:SetStatusBarColor(0.2, 0.8, 1);
	button.Graphics.IncomingHealth:SetAlpha(1);
	button.Graphics.IncomingHealth:Show();
end

function BobsUnitButtonPlayerHudTemplate:UpdatePower(button)
	-- See if the unit is dead.
	if (button.IsDeadOrGhost) or ((not button.HasTarget) and ((UnitPower(button.Unit) == UnitPowerMax(button.Unit)) or (UnitPower(button.Unit) == 0))) then
		button.Graphics.Power:Hide();
		button.Graphics.PowerLabel:Hide();
		return;
	end

	-- Update the power values.
	button.Graphics.Power:SetMinMaxValues(0, UnitPowerMax(button.Unit));
	button.Graphics.Power:SetValue(UnitPower(button.Unit));
	local color = PowerBarColor[select(1, UnitPowerType(button.Unit))];
	button.Graphics.Power:SetStatusBarColor(color.r, color.g, color.b);
	button.Graphics.Power:SetBackdropColor(0.05, 0.05, 0.05, 0.5);
	button.Graphics.Power:SetAlpha(1);
	button.Graphics.Power:Show();

	-- Update the power label values.
	button.Graphics.PowerLabel:SetText(BobbyCode:FormatNumbers(UnitPower(button.Unit), UnitPowerMax(button.Unit), button.Settings.ValuesAsPercent));
	if (button.Settings.ShowValues) then
		button.Graphics.PowerLabel:Show();
	end
end

function BobsUnitButtonPlayerHudTemplate:UpdateRange(button)
	-- Get any information we need quickly.
	if (BobbyCode:UnitIsInRange(button.Unit)) then
		button.Graphics:SetAlpha(1);
	else
		button.Graphics:SetAlpha(0.4);
	end
end

function BobsUnitButtonPlayerHudTemplate:UpdateTargeted(button)
	button.HasTarget = (button.Unit == "player") and (UnitExists("target"));
	BobsUnitButtonPlayerHudTemplate:UpdateHealth(button);
	BobsUnitButtonPlayerHudTemplate:UpdatePower(button);
end