-- Author      : Bobby Cannon
-- Create Date : 07/18/11 09:25:22 PM

function BobsTimerBar_Create(name, parent)
	local timer = BobbyCode:CreateStatusBar(name, parent);
	local color = { r = 1, g = 1, b = 1, a = 1 };

	timer:SetWidth(parent:GetWidth());
	timer:SetHeight(16);

	timer.Text = timer:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	BobbyCode:SetLabelFont(timer.Text, color, 10, true);
	timer.Text:SetPoint("LEFT", timer, "LEFT", 2, 0);

	timer.Time = timer:CreateFontString(nil, "ARTWORK", "BobsToolboxFont");
	BobbyCode:SetLabelFont(timer.Time, color, 8, true);
	timer.Time:SetPoint("RIGHT", timer, "RIGHT", 0, 0);

	timer.Icon = timer:CreateTexture(nil, "ARTWORK");
	timer.Icon:SetPoint("RIGHT", timer, "LEFT", -1, 0);
	timer.Icon:SetHeight(16);
	timer.Icon:SetWidth(16);
	
	timer.Cooldown = 0;
	timer.Started = nil;
	timer.Remove = nil;

	--timer:EnableMouse(false);
	--timer:SetScript("OnClick", BobsTimerBar_OnClick);
	timer:SetScript("OnUpdate", BobsTimerBar_OnUpdate);
	
	--BobsToolbox:RegisterTask(timer:GetName(), BobsTimerBar_OnUpdate, 1/60, timer);

	return timer;
end

function BobsTimerBar_Initialize(timer, text, icon)
	timer.Text:ClearAllPoints();
	
	if (BobbyCode:CheckStringForDescender(text)) then
		timer.Text:SetPoint("LEFT", timer, "LEFT", 2, 0);
	else
		timer.Text:SetPoint("LEFT", timer, "LEFT", 2, -1);
	end
	
	timer.Text:SetText(text);
	timer.Icon:SetTexture(icon);

	return timer;
end

function BobsTimerBar_OnClick(timer, button, down)
	if (not IsShiftKeyDown()) then
		return;
	end
	
	if (button == "LeftButton") then
		BobbyCode:Print(timer.Text:GetText() .. " has " .. timer.Time:GetText() .. " remaining.");
	elseif (button == "RightButton") then
		timer.Remove = true;
	end
end

function BobsTimerBar_Resize(timer, height, width)
	if (width ~= nil) then
		timer:SetWidth(width);
	end
	
	if (height ~= nil) then
		timer:SetHeight(height);
	end
	
	timer.Icon:SetWidth(height);
	timer.Icon:SetHeight(height);

	if (BobsToolbox.db.profile.cooldownframe.enableIcon) then
		timer.Icon:Show();
	else
		timer.Icon:Hide();
	end
end

function BobsTimerBar_AttemptToStartTimer(timer)
	local started, cooldown, enabled = GetSpellCooldown(timer:GetID());
	
	if (enabled == 1) and (cooldown > 1.5) then
		BobsTimerBar_Start(timer, cooldown, started);
		return true;
	end
	
	return nil;
end

function BobsTimerBar_Start(timer, cooldown, started)
    timer.Cooldown = cooldown;
	
	if (started == nil) then
		timer.Started = GetTime();
	else
		timer.Started = started;
	end
end

function BobsTimerBar_GetTimeLeft(timer)
    local remaining = timer.Cooldown - (GetTime() - (timer.Started or 0));
	if (remaining < 0) then
		remaining = 0;
	end

	return remaining;
end

function BobsTimerBar_OnUpdate(timer)
	if (timer.Remove) then
		return;
	end

	local timeLeft = BobsTimerBar_GetTimeLeft(timer);
	local percent = timeLeft / timer.Cooldown;
	
	-- Get the color based on health and/or debuffs
	local color = BobbyCode:GetColorAsTable(BobbyCode:GetHealthColorByPercent(percent));
	timer:SetStatusBarColor(color.r, color.g, color.b, 0.75);
	timer:SetMinMaxValues(0, timer.Cooldown);
	timer:SetValue(timeLeft);
	timer.Time:SetText(BobsTimerBar_TimeToString(timeLeft));
	
	if (timeLeft <= 0) then
		timer.Remove = true;
	end
end

function BobsTimerBar_TimeToString(elapsed)
	if (elapsed <= 60) then
		return string.format("%.1f", elapsed);
	else
		return string.format("%d:%0.2d", elapsed / 60, elapsed % 60);
	end
end