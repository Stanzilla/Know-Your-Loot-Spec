local addonName, a = ...
local u = BittensGlobalTables.GetTable("BittensUtilities")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local qTip = LibStub('LibQTip-1.0')

local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local SELECT_LOOT_SPECIALIZATION = SELECT_LOOT_SPECIALIZATION
local ipairs = ipairs

local addonTitle = select(2, GetAddOnInfo(addonName))
local broker = ldb:NewDataObject(addonTitle, { 
	type = "data source", 
	text = "", 
	label = LOOT, 
})

local function clickHandler(_, spec)
	a.SwitchTo(spec)
end

local tooltip
local radioFormat = "|TInterface\\Buttons\\UI-RadioButton:0:0:0:0:64:16:%s:%s:%s:%s|t"
local radioOutline = radioFormat:format(1, 14, 1, 14)
local radioFill = radioFormat:format(19, 28, 3, 12)
local function refreshTooltip()
	if not qTip:IsAcquired(addonName) then
		return
	end
	
	tooltip:Clear()
	local row = tooltip:AddLine()
	tooltip:SetCell(
		row, 1, 
		SELECT_LOOT_SPECIALIZATION, 
		tooltip:GetHeaderFont(), "CENTER", 3)
	for _, spec in ipairs(a.GetAllSpecs()) do
		row = tooltip:AddLine()
		tooltip:SetCell(row, 1, spec.Current and radioFill or radioOutline)
		tooltip:SetCell(row, 2, "|T" .. spec.Icon .. ":16|t")
		tooltip:SetCell(row, 3, spec.LongName)
		tooltip:SetLineScript(row, "OnMouseDown", clickHandler, spec)
	end
end

function broker.OnEnter(anchor)
	tooltip = qTip:Acquire(addonName, 3, "CENTER", "CENTER", "LEFT")
	tooltip:SetAutoHideDelay(.25, anchor)	
	tooltip:SmartAnchorTo(anchor)
	refreshTooltip()
	tooltip:Show()
end

function broker.OnLeave()
	-- QTip will auto-hide
end

function broker:OnClick(button)
--print("OnClick", button)
	if button == "RightButton" then
		InterfaceOptionsFrame_OpenToCategory(a.GetOptionsPanel())
	end
end

function a.RefreshDataBroker(spec)
	broker.text = spec.Name
	broker.icon = spec.Icon
	refreshTooltip()
end
