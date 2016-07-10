local addonName, a = ...
local u = BittensGlobalTables.GetTable("BittensUtilities")

local broker

-- GLOBALS: LibStub LOOT

function a.InitializeDataBroker()
	local ldb = LibStub:GetLibrary("LibDataBroker-1.1", true)
	if not ldb then
		return
	end

	local addonTitle = select(2, GetAddOnInfo(addonName))
	broker = ldb:NewDataObject(addonTitle, {
		type = "data source",
		text = "",
		label = LOOT,
	})

	function broker.OnEnter(anchor)
		a.ShowTooltip(anchor, a.ToggleJournalAction, a.ToggleOptionsAction)
	end

	broker.OnLeave = u.NoOp

	function broker:OnClick(button)
		if button == "LeftButton" then
			ToggleEncounterJournal()
		elseif button == "RightButton" then
			a.ToggleOptions()
		end
	end
end

function a.RefreshDataBroker(spec)
	if broker then
		broker.text = spec.Name
		broker.icon = spec.Icon
	end
end
