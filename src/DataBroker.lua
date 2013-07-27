local addonName, a = ...
local u = BittensGlobalTables.GetTable("BittensUtilities")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

local addonTitle = select(2, GetAddOnInfo(addonName))
local broker = ldb:NewDataObject(addonTitle, { 
	type = "data source", 
	text = "", 
	label = LOOT, 
})

broker.OnEnter = a.ShowTooltip
broker.OnLeave = u.NoOp

function broker:OnClick(button)
--print("OnClick", button)
	if button == "LeftButton" then
		ToggleEncounterJournal()
	elseif button == "RightButton" then
		a.ToggleOptions()
	end
end

function a.RefreshDataBroker(spec)
	broker.text = spec.Name
	broker.icon = spec.Icon
end
