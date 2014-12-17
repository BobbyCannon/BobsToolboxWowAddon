-- Author      : bobby.cannon
-- Create Date : 12/30/2011 11:55:04 AM

local texturePath = "Interface\\AddOns\\BobsToolbox\\Textures\\";

BobsUnitButtonBadgeTemplate = {
	-- Initialization Function: Set Size and other properties of the Unit Button.
	-- Variables from addons are not accessible when this function is called.
	SecureInitFunction = [[
		local header = self:GetParent();
		header:CallMethod('InitializeButton', self:GetName());
				
		-- Set width and height;
		self:SetWidth(180);
		self:SetHeight(65);
	]],
	Name = "Badge",
	Width = 180,
	Height = 65,
}

function BobsUnitButtonBadgeTemplate:Layout(button)
	-- Set the default template values.
	button.Width = BobsUnitButtonBadgeTemplate.Width;
	button.Height = BobsUnitButtonBadgeTemplate.Height;
	
	-- Set the width and height of the button.
	button:SetWidth(button.Width);
	button:SetHeight(button.Height);
	
	-- Setup the cast bar.
	button.CastBar:SetPoint("BOTTOM", 0, 4);
	
	-- Graphics.
	local Graphics = button.Graphics;
	Graphics:ClearAllPoints();
    Graphics:SetAllPoints();
	Graphics:SetScale(1);
	Graphics:SetAlpha(1);
	Graphics:Show();

	-- Hide all the graphics.
	Graphics.Background:Hide();
	Graphics.Health:Hide();
	Graphics.IncomingHealth:Hide();
	Graphics.Power:Hide();
	
	-- Anchor the overlay.
	Graphics.OverlayAnchor:ClearAllPoints();
	Graphics.OverlayAnchor:SetAllPoints();
	
	-- Position the text labels.
	BobbyCode:SetLabelFont(Graphics.Name, BobbyCode.Color.White, 10, true);
	Graphics.Name:ClearAllPoints();
	Graphics.Name:SetPoint("TOP", 0, -10);
	Graphics.Name:Show();
	
	BobbyCode:SetLabelFont(Graphics.Class, BobbyCode.Color.White, 10, true);
	Graphics.Class:ClearAllPoints();
	Graphics.Class:SetPoint("TOP", Graphics.Name, "BOTTOM", 0, -4);
	Graphics.Class:Show();

	BobbyCode:SetLabelFont(Graphics.Level, BobbyCode.Color.White, 10, true);
	Graphics.Level:ClearAllPoints();
	Graphics.Level:SetPoint("RIGHT", Graphics.Class, "LEFT");
	Graphics.Level:Show();

	BobbyCode:SetLabelFont(Graphics.Guild, BobbyCode.Color.White, 8, true);
	Graphics.Guild:ClearAllPoints();
	Graphics.Guild:SetPoint("TOP", Graphics.Class, "BOTTOM", 0, -4);
	Graphics.Guild:Show();

	-- Hide the remaining unused labels.
	Graphics.HealthLabel:Hide();
	Graphics.PowerLabel:Hide();

	-- Role, ReadyCheck, Raid Icon.
	Graphics.Icon:SetHeight(16);
	Graphics.Icon:SetWidth(16);
	Graphics.Icon:SetAlpha(1);
	Graphics.Icon:ClearAllPoints();
	Graphics.Icon:SetPoint("RIGHT", Graphics.Level, "LEFT", -4, -2);
	Graphics.Icon:Hide();

	-- Hide overlay images.
	Graphics.Overlay:SetTexture();
	Graphics.Overlay:Hide();
	Graphics.Border:SetTexture();
	Graphics.Border:Hide();
	Graphics.Aggro:SetTexture();
	Graphics.Aggro:Hide();
end

function BobsUnitButtonBadgeTemplate:UpdateName(button)
	-- Set the name label.
	button.Graphics.Name:SetText(BobbyCode:GetUnitName(button.Unit, true));
end

function BobsUnitButtonBadgeTemplate:UpdateRange(button)
	-- No range support for this template.
end