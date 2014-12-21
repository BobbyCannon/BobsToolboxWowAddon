-- Author      : Bobby Cannon
-- Create Date : 12/14/2014 08:59:29 PM

BobsCurrencyFrame = BobbyCode:CreateFrame("BobsCurrencyFrame", UIParent);
	
local UnitEventHandlers = {}
local frame = BobsCurrencyFrame;

function BobsCurrencyFrame:Initialize()
	frame:SetWidth(20);
	frame:SetHeight(20);
	frame:ClearAllPoints();
	frame:SetPoint("BOTTOMLEFT", UIParent, 12, 6);
	
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
	
	frame.ConquestIcon = frame:CreateTexture();
	frame.ConquestIcon:SetDrawLayer("OVERLAY");
	frame.ConquestIcon:SetVertexColor(1, 1, 1, 1);
	frame.ConquestIcon:ClearAllPoints();
	frame.ConquestIcon:SetPoint("LEFT", frame.HonorLabel, "RIGHT", 12, 0);
	frame.ConquestIcon:SetHeight(20);
	frame.ConquestIcon:SetWidth(20);
	
	frame.ConquestLabel = BobbyCode:CreateLabel(frame, "ConquestLabel", "0", BobbyCode.Color.White, 12, true);
	frame.ConquestLabel:ClearAllPoints();
	frame.ConquestLabel:SetPoint("LEFT", frame.ConquestIcon, "RIGHT", 2, 0);
	
	frame.GoldLabel = BobbyCode:CreateLabel(frame, "GoldLabel", "0", BobbyCode.Color.White, 12, true);
	frame.GoldLabel:ClearAllPoints();
	frame.GoldLabel:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -12, 8);
	
	frame.GoldIcon = frame:CreateTexture();
	frame.GoldIcon:SetDrawLayer("OVERLAY");
	frame.GoldIcon:SetTexture(BobbyCode.Texture.GoldCoin);
	frame.GoldIcon:SetVertexColor(1, 1, 1, 1);
	frame.GoldIcon:SetAlpha(0.75);
	frame.GoldIcon:ClearAllPoints();
	frame.GoldIcon:SetPoint("RIGHT", frame.GoldLabel, "LEFT", 0, 1);
	frame.GoldIcon:SetHeight(20);
	frame.GoldIcon:SetWidth(20);
	
	for eventname, _ in pairs(UnitEventHandlers) do 
		BobsCurrencyFrame:RegisterEvent(eventname);
	end
end

function BobsCurrencyFrame:ApplySettings()
	BobsCurrencyFrame:Update();
end

function BobsCurrencyFrame:Update()
	local name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(392);
	frame.HonorIcon:SetTexture(texture);
	frame.HonorLabel:SetText(currentAmount);
	
	local name, currentAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(390);
	frame.ConquestIcon:SetTexture(texture);
	frame.ConquestLabel:SetText(currentAmount);
	
	frame.GoldLabel:SetText(math.floor(GetMoney() / 100 / 100));
end

UnitEventHandlers.CURRENCY_DISPLAY_UPDATE = BobsCurrencyFrame.Update;
UnitEventHandlers.HONOR_CURRENCY_UPDATE = BobsCurrencyFrame.Update;
UnitEventHandlers.TRADE_CURRENCY_CHANGED = BobsCurrencyFrame.Update;
UnitEventHandlers.TRADE_MONEY_CHANGED = BobsCurrencyFrame.Update;
UnitEventHandlers.PLAYER_TRADE_MONEY = BobsCurrencyFrame.Update;
UnitEventHandlers.PLAYER_MONEY = BobsCurrencyFrame.Update;
UnitEventHandlers.CHAT_MSG_MONEY = BobsCurrencyFrame.Update;

function BobsCurrencyFrame:OnEvent(event, ...)
	UnitEventHandlers[event](self, ...);
end

BobsCurrencyFrame:SetScript("OnEvent", BobsCurrencyFrame.OnEvent);