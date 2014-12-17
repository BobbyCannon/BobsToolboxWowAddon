-- Author      : bobby.cannon
-- Create Date : 1/7/2012 2:10:50 PM

BobsUnitButtonTargetHudTemplate = {
	-- Initialization Function: Set Size and other properties of the Unit Button.
	-- Variables from addons are not accessible when this function is called.
	SecureInitFunction = [[
		local header = self:GetParent();
		header:CallMethod('InitializeButton', self:GetName());
				
		-- Set width and height;
		self:SetWidth(322);
		self:SetHeight(190);
	]],
	Name = "TargetHud",
	Width = 322,
	Height = 190,
}

function BobsUnitButtonTargetHudTemplate:Layout(button)
	-- Set template specific values.
	button.Width = BobsUnitButtonTargetHudTemplate.Width;
	button.Height = BobsUnitButtonTargetHudTemplate.Height;
	
	-- Set the width and height of the button.
	button:SetWidth(button.Width);
	button:SetHeight(button.Height);

	-- Set the settings defaults for this template.
	button.BuffAnchor.OffsetX = 42;
	button.BuffAnchor.OffsetY = -6;
	button.DebuffAnchor.OffsetX = -42
	button.DebuffAnchor.OffsetY = -6;

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
	Graphics.HealthLabel:SetPoint("BOTTOMRIGHT", Graphics.Background, "BOTTOMLEFT", 10, 0);

	BobbyCode:SetLabelFont(Graphics.PowerLabel, BobbyCode.Color.White, 10, true);
	Graphics.PowerLabel:ClearAllPoints();
	Graphics.PowerLabel:SetPoint("BOTTOMLEFT", Graphics.Power, "BOTTOMRIGHT", -10, 0);

	if (button.Settings.ShowValues) then
		Graphics.HealthLabel:Show();
		Graphics.PowerLabel:Show();
	else
		Graphics.HealthLabel:Hide();
		Graphics.PowerLabel:Hide();
	end
	
	-- Role, ReadyCheck, Raid Icon.
	Graphics.Icon:SetHeight(16);
	Graphics.Icon:SetWidth(16);
	Graphics.Icon:SetAlpha(1);
	Graphics.Icon:ClearAllPoints();
	Graphics.Icon:SetPoint("BOTTOMLEFT", Graphics, "BOTTOMLEFT", 70, 0);
	Graphics.Icon:Hide();
	
	-- Hide the remaining unused resources.
	Graphics.Name:Hide()
	Graphics.Level:Hide();
	Graphics.Guild:Hide();
	Graphics.Class:Hide();
	Graphics.Overlay:Hide();
	Graphics.Border:Hide();
	Graphics.Aggro:Hide();
end

function BobsUnitButtonTargetHudTemplate:UpdateHealth(button)
	-- Update the dead or ghost state.
	button.IsDeadOrGhost = UnitIsDeadOrGhost(button.Unit) or (UnitHealth(button.Unit) <= 0);
	
	-- See if the unit is dead or disconnected.
	if (button.IsDeadOrGhost) or (button.IsDisconnected) then
		button.Graphics.Background:SetBackdropColor(0.5, 0.5, 0.5, 1);
		button.Graphics.Power:SetBackdropColor(0.5, 0.5, 0.5, 1);
		button.Graphics.Health:SetValue(0);
		button.Graphics.HealthLabel:SetText("0");
		button.Graphics.IncomingHealth:SetValue(0);
		button.Graphics.Power:SetValue(0);
		button.Graphics.PowerLabel:SetText("0");
		return;
	end

	-- Updating the background color.
	button.Graphics.Background:SetBackdropColor(0.05, 0.05, 0.05, 0.5);

	-- Update the health values.
	button.Graphics.Health:SetMinMaxValues(0, UnitHealthMax(button.Unit));
	button.Graphics.Health:SetValue(UnitHealth(button.Unit));
	button.Graphics.Health:SetStatusBarColor(BobbyCode:GetHealthColor(button.Unit));
	button.Graphics.Health:SetAlpha(1);
	button.Graphics.HealthLabel:SetText(BobbyCode:FormatNumbers(UnitHealth(button.Unit), UnitHealthMax(button.Unit), button.Settings.ValuesAsPercent));

	-- Update the incoming health values.
	button.Graphics.IncomingHealth:SetMinMaxValues(0, UnitHealthMax(button.Unit));
	button.Graphics.IncomingHealth:SetValue(UnitHealth(button.Unit) + (UnitGetIncomingHeals(button.Unit) or 0));
	button.Graphics.IncomingHealth:SetStatusBarColor(0.2, 0.8, 1);
	button.Graphics.IncomingHealth:SetAlpha(1);
end

function BobsUnitButtonTargetHudTemplate:UpdatePower(button)
	-- See if the unit is dead or disconnected.
	if (button.IsDeadOrGhost) or (button.IsDisconnected) then
		return;
	end

	-- Update the power values.
	button.Graphics.Power:SetMinMaxValues(0, UnitPowerMax(button.Unit));
	button.Graphics.Power:SetValue(UnitPower(button.Unit));
	local color = PowerBarColor[select(1, UnitPowerType(button.Unit))];
	button.Graphics.Power:SetStatusBarColor(color.r, color.g, color.b);
	button.Graphics.Power:SetBackdropColor(0.05, 0.05, 0.05, 0.5);
	button.Graphics.Power:SetAlpha(1);
	button.Graphics.PowerLabel:SetText(BobbyCode:FormatNumbers(UnitPower(button.Unit), UnitPowerMax(button.Unit), button.Settings.ValuesAsPercent));
end

function BobsUnitButtonTargetHudTemplate:UpdateRange(button)
	-- See if we should check range.
	if (not button.Settings.RangeCheck) then
		return;
	end

	-- Get any information we need quickly.
	if (BobbyCode:RangeCheck(button.Unit, button.Settings.RangeCheckSpell)) then
		button.Graphics:SetAlpha(1);
	else
		button.Graphics:SetAlpha(button.Settings.RangeCheckAlpha);
	end
end

function BobsUnitButtonTargetHudTemplate:UpdateTargeted(button)
	button.HasTarget = (button.Unit == "player") and (UnitExists("target"));
	BobsUnitButtonTargetHudTemplate:UpdateHealth(button);
	BobsUnitButtonTargetHudTemplate:UpdatePower(button);
end