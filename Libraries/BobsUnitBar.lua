-- Author      : Bobby Cannon
-- Create Date : 3/19/2009 10:36:18 PM

function BobsUnitBar_Create(parent, unit, side, offset)
    local frame = CreateFrame("Frame", null, parent)
    frame:SetAttribute("unit", unit);
    
    if (unit ~= "player") then
        RegisterUnitWatch(frame, false);
    end

	local width = 32;
	local height = 200;    

    frame:SetWidth(width);
    frame:SetHeight(height);

 	frame.Border = frame:CreateTexture(nil, "ARTWORK");
    frame.Border:SetTexture("Interface\\AddOns\\BobsToolbox\\Textures\\RoundBar");
    frame.Border:SetVertexColor(0.05, 0.05, 0.05, 0.5);
	frame.Border:SetPoint("BOTTOM");
	frame.Border:SetWidth(width);
    frame.Border:SetHeight(height);
   
	frame.Percent = frame:CreateTexture(nil, "OVERLAY");
    frame.Percent:SetTexture("Interface\\AddOns\\BobsToolbox\\Textures\\RoundBar");
    frame.Percent:SetVertexColor(0, 1, 0);
    frame.Percent:SetPoint("BOTTOM");
	frame.Percent:SetWidth(width);
    frame.Percent:SetHeight(height);
    
    frame.Incoming = frame:CreateTexture(nil, "OVERLAY");
    frame.Incoming:SetTexture("Interface\\AddOns\\BobsToolbox\\Textures\\RoundBar");
    frame.Incoming:SetVertexColor(0.2, 0.8, 1);
	frame.Incoming:SetPoint("BOTTOM", frame.Percent, "TOP");
	frame.Incoming:SetWidth(width);
    frame.Incoming:SetHeight(height);
    
    if (side == "LEFT") then
        frame.Border:SetTexCoord(1, 0, 0, 1);
        frame.Percent:SetTexCoord(1, 0, 0, 1);
        frame.Incoming:SetTexCoord(1, 0, 0, 1);
        frame:SetPoint("RIGHT", parent, "LEFT", offset, 0);
    else
        frame.Border:SetTexCoord(0, 1, 0, 1);
        frame.Percent:SetTexCoord(0, 1, 0, 1);
        frame.Incoming:SetTexCoord(0, 1, 0, 1);
        frame:SetPoint("LEFT", parent, "RIGHT", offset, 0);
    end
    
    frame.UpdateHealth = BobsUnitBar_UpdateHealthBar;
    frame.UpdatePower = BobsUnitBar_UpdatePowerBar;
    
    return frame;
end

function BobsUnitBar_SetValue(bar, percent, incoming, color)
	if (percent == nil) or (percent > 1) then
		percent = 1;
	end

	local barHeight = bar:GetHeight();
	local percentHeight = barHeight * percent;
	local percentTop = 1 - percent;
	local incomingHeight = barHeight * (incoming or 0);
	local incomingTop = 1 - (percent + (incoming or 0));
	
	if (percentHeight > 0) then
		local ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = bar.Percent:GetTexCoord();
		bar.Percent:SetTexCoord(ULx, percentTop, LLx, LLy, URx, percentTop, LRx, LRy);
		bar.Percent:SetHeight(percentHeight);
		bar.Percent:Show();
	else
		bar.Percent:Hide();
	end
	
	if (incoming ~= nil) and (incoming > 0) and (incomingTop > 0) then
		ULx, ULy, LLx, LLy, URx, URy, LRx, LRy = bar.Incoming:GetTexCoord();
		bar.Incoming:SetTexCoord(ULx, incomingTop, LLx, percentTop, URx, incomingTop, LRx, percentTop);
		bar.Incoming:SetHeight(incomingHeight);
		bar.Incoming:Show();
	elseif (bar.Incoming:IsShown()) then
		bar.Incoming:Hide();
	end
	
	if (color ~= nil) then
		bar.Percent:SetVertexColor(color.r, color.g, color.b);
	end
end

function BobsUnitBar_UpdateHealthBar(bar)
    local unit = bar:GetAttribute("unit");
	local health = UnitHealth(unit);
	local maxHealth = UnitHealthMax(unit);
	local healthText = "-";
	local percent = 0;
	local healthColor = BobbyCode.Color.Gray;
	
	if (health > 0) and (maxHealth > 0) then
		percent = health / maxHealth;
		healthColor = BobbyCode:GetColorAsTable(BobbyCode:GetHealthColor(percent));
	end
	
	local incoming = (UnitGetIncomingHeals(unit) or 0) / maxHealth;
	BobsUnitBar_SetValue(bar, percent, incoming, healthColor);
	
	if (unit == "player") then
		if (UnitIsDeadOrGhost("player")) then
			bar:Hide();
		elseif (not UnitExists("target") and (percent == 1)) then 
			bar:Hide();
		elseif (UnitExists("target") or (percent < 1)) then 
			bar:Show();
		end
	end
end

function BobsUnitBar_UpdatePowerBar(bar)
    local unit = bar:GetAttribute("unit");
	local power, maxPower = UnitPower(unit), UnitPowerMax(unit);
	local powerType, powerTypeString = UnitPowerType(unit);
	local powerText = "-";
	local percent = 0;
    
    local info = PowerBarColor[powerType];
	bar.Percent:SetVertexColor(info.r, info.g, info.b);
	
	-- Only calculate power if we have power.
	if (power > 0) and (maxPower > 0) then
		percent = power / maxPower;
	end
	
	BobsUnitBar_SetValue(bar, percent);
	
	if (unit == "player") then
		if (UnitIsDeadOrGhost("player")) then
			bar:Hide();
		elseif (not UnitExists("target") and (percent == 1)) then 
			bar:Hide();
		elseif (not UnitExists("target") and (percent == 0) and (powerType == 1)) then
			bar:Hide();
		elseif (UnitExists("target") or (percent < 1)) then 
			bar:Show();
		end
		
		if (unit == "player") then
			BobsPlayerFrame.PlayerPowerNotFull = bar:IsShown();
		elseif (unit == "pet") then
			BobsPlayerFrame.PetPowerNotFull = bar:IsShown();
		end
	elseif (unit == "target") then
		BobsPlayerFrame.TargetPowerNotFull = bar:IsShown();
	end
end