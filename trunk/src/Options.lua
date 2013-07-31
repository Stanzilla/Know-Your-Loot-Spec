local addonName, a = ...
local u = BittensGlobalTables.GetTable("BittensUtilities")

local pairs = pairs

local addonTitle = select(2, GetAddOnInfo(addonName))
local panel = u.CreateOptionsPanel(addonTitle, nil, nil)
function panel.apply()
	for name, overlay in pairs(a.Overlays) do
		if panel.IsCheckBoxSelected(overlay) then
			overlay.Frame:Show()
		else
			overlay.Frame:Hide()
		end
	end
end

local y = -16
local function addCheckBox(definition, name, text, default)
	if not definition then
		definition = { Name = name, Text = text, Default = default}
	end
	panel.AddCheckBox(definition, "TOPLEFT", 16, y)
	y = y - 25
end

function a.InitializeSettings()
	local x, y = 16, -16
	y = panel.AddCheckBoxGroup("Show Icon On:", a.Overlays, x, y)
	y = panel.AddCheckBoxGroup("Announce When:", a.AnnounceOptions, x, y - 10)
	y = panel.AddCheckBoxGroup("Announce To:", a.AnnounceTargets, x, y - 10)
	panel.Initialize("KnowYourLootSpecSettings")
end

function a.ToggleOptions()
	if not InterfaceOptionsFrame:IsVisible() then
		InterfaceOptionsFrame_Show()
		InterfaceOptionsFrame_OpenToCategory(panel)
	elseif panel:IsVisible() then
		panel.cancel()
		InterfaceOptionsFrame:Hide()
	else
		InterfaceOptionsFrame_OpenToCategory(panel)
	end
end

function a.IsOptionSelected(option)
	return panel.IsCheckBoxSelected(option)
end

a.ToggleOptionsAction = { Name = "Toggle Options", Function = a.ToggleOptions }
