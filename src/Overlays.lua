local addonName, a = ...
local u = BittensGlobalTables.GetTable("BittensUtilities")

local pairs = pairs

local overlays = { }

local function createOverlay(
	name, size, defaultVisibility, parent, anchor1, anchor2, xOffset, yOffset)
	
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetFrameStrata("HIGH")
	frame:SetSize(size, size)
	frame:SetPoint(anchor1, parent, anchor2, xOffset, yOffset)
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

local overlay = createOverlay(
	"Unit Frame", 20, true, 
	PlayerFrame, "LEFT", "LEFT", PlayerFrame:GetWidth() / 8, 7)
overlay.Frame:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		a.ToggleTooltip(self)
	elseif button == "RightButton" then
		a.ToggleOptions()
	end
end)
	
overlay = createOverlay(
	"Bonus Roll Frame", BonusRollFrame:GetHeight(), true, 
	BonusRollFrame, "LEFT", "RIGHT")
overlay.Frame:SetScript("OnEnter", a.ShowTooltip)
overlay.Frame:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" then
		ToggleEncounterJournal()
	elseif button == "RightButton" then
		a.ToggleOptions()
	end
end)

function a.RefreshOverlays(spec)
	for _, overlay in pairs(overlays) do
		overlay.Icon:SetTexture(spec.Icon)
	end
end

function a.GetOverlays()
	return overlays
end
