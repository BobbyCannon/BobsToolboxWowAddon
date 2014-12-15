-- Author      : Bobby Cannon
-- Create Date : 12/14/2014 08:59:29 PM

BobsCurrencyFrame = BobbyCode:CreateFrame("BobsCurrencyFrame", UIParent);
	
local UnitEventHandlers = {}
local frame = BobsCurrencyFrame;

function BobsCurrencyFrame:Initialize()
	frame:SetWidth(20);
	frame:SetHeight(20);
	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMLEFT", UIParent, 12, 2);
	
	frame.HonorIcon = frame:CreateTexture();
	frame.HonorIcon:SetDrawLayer("OVERLAY");
	frame.HonorIcon:SetVertexColor(1, 1, 1, 1);
	frame.HonorIcon:ClearAllPoints();
	frame.HonorIcon:SetPoint("LEFT", frame, "LEFT", 0, 0);
	frame.HonorIcon:SetHeight(20);
	frame.HonorIcon:SetWidth(20);
	
	frame.HonorLabel = BobbyCode:CreateLabel(frame, "HonorLabel", "0", BobbyCode.Color.White, 12, true);
	frame.HonorLabel:ClearAllPoints();
	frame.HonorLabel:SetPoint("LEFT", frame.HonorIcon, "RIGHT", 2, 0);
	
	frame.GoldIcon = frame:CreateTexture();
	frame.GoldIcon:SetDrawLayer("OVERLAY");
	frame.GoldIcon:SetTexture(BobbyCode.Texture.GoldCoin);
	frame.GoldIcon:SetVertexColor(1, 1, 1, 1);
	frame.GoldIcon:SetAlpha(0.75);
	frame.GoldIcon:ClearAllPoints();
	frame.GoldIcon:SetPoint("LEFT", frame.HonorLabel, "Right", 4, 0);
	frame.GoldIcon:SetHeight(20);
	frame.GoldIcon:SetWidth(20);
	
	frame.GoldLabel = BobbyCode:CreateLabel(frame, "GoldLabel", "0", BobbyCode.Color.White, 12, true);
	frame.GoldLabel:ClearAllPoints();
	frame.GoldLabel:SetPoint("LEFT", frame.GoldIcon, "RIGHT", 2, 0);
end

function BobsCurrencyFrame:ApplySettings()
	BobsCurrencyFrame:Update();
end

function BobsCurrencyFrame:Update()
	local name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(392);
	frame.HonorIcon:SetTexture(texture);
	frame.HonorLabel:SetText(currentAmount);
	frame.GoldLabel:SetText(math.floor(GetMoney() / 100 / 100));
end