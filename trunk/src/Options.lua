local addonName, a = ...
local u = BittensGlobalTables.GetTable("BittensUtilities")

local pairs = pairs

local addonTitle = select(2, GetAddOnInfo(addonName))
local panel = u.CreateOptionsPanel(addonTitle)
function panel.apply()
	for name, overlay in pairs(a.Overlays) do
		if panel.GetValue(overlay) then
			overlay.Frame:Show()
		else
			overlay.Frame:Hide()
		end
	end
end

function a.InitializeSettings()
	local x, y = 16, -16
	y = panel.AddCheckBoxGroup("Show Icon On:", a.Overlays, x, y)
	y = panel.AddCheckBoxGroup("Announce When:", a.AnnounceOptions, x, y - 10)
	y = panel.AddCheckBoxGroup("Announce To:", a.AnnounceTargets, x, y - 10)
	panel.Initialize("KnowYourLootSpecSettings")
end

function a.ToggleOptions()
	u.ToggleOptionsPanel(panel)
end

function a.IsOptionSelected(option)
	return panel.GetValue(option)
end

a.ToggleOptionsAction = { Name = "Toggle Options", Function = a.ToggleOptions }
