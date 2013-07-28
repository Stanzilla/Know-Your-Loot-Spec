local addonName, a = ...
local u = BittensGlobalTables.GetTable("BittensUtilities")

local pairs = pairs

local addonTitle = select(2, GetAddOnInfo(addonName))
local panel = u.CreateOptionsPanel(addonTitle, nil, nil)
function panel.apply()
	for name, overlay in pairs(a.GetOverlays()) do
		if panel.IsCheckBoxSelected(overlay) then
			overlay.Frame:Show()
		else
			overlay.Frame:Hide()
		end
	end
end

function a.InitializeSettings()
	local y = -16
	for _, overlay in pairs(a.GetOverlays()) do
		panel.AddCheckBox(overlay, "TOPLEFT", 16, y)
		y = y - 22
	end
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

a.ToggleOptionsAction = { Name = "Toggle Options", Function = a.ToggleOptions }
