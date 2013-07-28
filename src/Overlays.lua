local addonName, a = ...
local u = BittensGlobalTables.GetTable("BittensUtilities")

local pairs = pairs

local overlays = { }

local function createOverlay(
	name, size, defaultVisibility, 
	mouseoverFunction, leftClickAction, rightClickAction, 
	parent, anchor1, anchor2, xOffset, yOffset)
	
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetFrameStrata("HIGH")
	frame:SetSize(size, size)
	frame:SetPoint(anchor1, parent, anchor2, xOffset, yOffset)
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
	
	local overlay = {
		Name = name,
		Text = "Show on " .. name,
		Frame = frame,
		Icon = icon,
		Default = defaultVisibility,
	}
	overlays[name] = overlay
	return overlay 
end

function a.InitializeOverlays()
	local hideTooltip = a.CreateAction("Toggle This Menu", a.HideTooltip)
	local showTooltip = a.CreateAction(
		"Toggle Tooltip", function(anchor)
			a.ToggleTooltip(anchor, hideTooltip, a.ToggleOptionsAction)
		end)
	createOverlay(
		"Unit Frame", 20, true, 
		nil, showTooltip, a.ToggleOptionsAction,
		PlayerFrame, "LEFT", "LEFT", PlayerFrame:GetWidth() / 8, 7)
	
	createOverlay(
		"Bonus Roll Window", BonusRollFrame:GetHeight(), true, 
		a.ToggleTooltip, a.ToggleJournalAction, a.ToggleOptionsAction,
		BonusRollFrame, "LEFT", "RIGHT")
end

function a.RefreshOverlays(spec)
	for _, overlay in pairs(overlays) do
		overlay.Icon:SetTexture(spec.Icon)
	end
end

function a.GetOverlays()
	return overlays
end