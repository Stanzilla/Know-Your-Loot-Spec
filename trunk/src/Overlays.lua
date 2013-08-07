local addonName, a = ...
local L = a.Localize
local u = BittensGlobalTables.GetTable("BittensUtilities")

local tinsert = tinsert

a.Overlays = { }

local function createOverlay(
	name, size, defaultVisibility, 
	mouseoverFunction, leftClickAction, rightClickAction, 
	parent, overlayAnchor, parentAnchor, xOffset, yOffset)
	
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetFrameStrata("HIGH")
	frame:SetSize(size, size)
	frame:SetPoint(overlayAnchor, parent, parentAnchor, xOffset, yOffset)
	if mouseoverFunction then
		frame:SetScript("OnEnter", function()
			mouseoverFunction(frame, leftClickAction, rightClickAction)
		end)
	end
	if leftClickAction or rightClickAction then
		frame:SetScript("OnMouseDown", function(_, button)
			if button == "LeftButton" then
				u.Call(u.GetFromTable(leftClickAction, "Function"), frame)
			elseif button == "RightButton" then
				u.Call(u.GetFromTable(rightClickAction, "Function"), frame)
			end
		end)
	end
	
	local icon = frame:CreateTexture()
	icon:SetAllPoints(frame)
	
	local definition = u.CreateCheckBoxOption(name, L[name], defaultVisibility)
	definition.Frame = frame
	definition.Icon = icon
	tinsert(a.Overlays, definition)
end

function a.InitializeOverlays()
	local hideTooltip = a.CreateAction(L["Toggle This Menu"], a.HideTooltip)
	local showTooltip = a.CreateAction(
		L["Toggle Tooltip"], function(anchor)
			a.ToggleTooltip(anchor, hideTooltip, a.ToggleOptionsAction)
		end)
	createOverlay(
		"Unit Frame", 20, true, 
		nil, showTooltip, a.ToggleOptionsAction,
		PlayerFrame, "CENTER", "LEFT", PlayerFrame:GetWidth() / 6, 7)
	
	createOverlay(
		"Bonus Roll Window", BonusRollFrame:GetHeight(), true, 
		a.ToggleTooltip, a.ToggleJournalAction, a.ToggleOptionsAction,
		BonusRollFrame, "LEFT", "RIGHT")
end

function a.RefreshOverlays(spec)
	for overlay in u.Values(a.Overlays) do
		overlay.Icon:SetTexture(spec.Icon)
	end
end
