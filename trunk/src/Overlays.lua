local addonName, a = ...
local u = BittensGlobalTables.GetTable("BittensUtilities")

local pairs = pairs

local overlays = { }

local function createOverlay(
	name, size, parent, anchor, xOffset, yOffset, defaultVisibility)
	
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetFrameStrata("HIGH")
	frame:SetSize(size, size)
	frame:SetPoint(anchor, xOffset, yOffset)
	local icon = frame:CreateTexture()
	icon:SetAllPoints(frame)
	overlays[name] = {
		Name = name,
		Text = "Show Icon on " .. name,
		Frame = frame,
		Icon = icon,
		DefaultVisibility = defaultVisibility,
	}
end

createOverlay(
	"Unit Frame", 20, PlayerFrame, "LEFT", PlayerFrame:GetWidth() / 8, 8, false)

function a.RefreshOverlays(spec)
	for _, overlay in pairs(overlays) do
		overlay.Icon:SetTexture(spec.Icon)
	end
end

function a.GetOverlays()
	return overlays
end
