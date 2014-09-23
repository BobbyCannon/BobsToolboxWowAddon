-- Author      : bobby.cannon
-- Create Date : 08/12/2012 01:18:17 PM

function BobsCastingBar_Create(name, parent, unit)
    local bar = CreateFrame("StatusBar", name, parent);
	bar:SetAttribute("unit", unit);

	-- Set all the default values.
	bar.Name = bar:GetName();
	bar.UnitID = bar:GetAttribute("unit");
	
	-- Just storage for optimization. Less memory garbage the better.
	bar.Elapsed = 0;
	bar.Duration = 0;
	bar.Casting = nil;
	bar.Channeling = nil;
	bar.HoldTime = 0;
	bar.ShowingSpark = nil;
	bar.Flashing = nil;
	bar.FadingOut = nil;
	
	-- Create the resources.
	bar.Text = bar:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	bar.Icon = bar:CreateTexture(nil, "ARTWORK");
	bar.Border = bar:CreateTexture(nil, "ARTWORK");
	bar.BorderShield = bar:CreateTexture(nil, "ARTWORK");
	bar.Spark = bar:CreateTexture(nil, "OVERLAY");
	bar.Flash = bar:CreateTexture(nil, "OVERLAY");
			
	-- Set the bar to initialized.
	return bar;
end