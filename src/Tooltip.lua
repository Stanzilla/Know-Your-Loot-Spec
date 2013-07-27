local addonName, a = ...
local u = BittensGlobalTables.GetTable("BittensUtilities")
local qTip = LibStub('LibQTip-1.0')

local SELECT_LOOT_SPECIALIZATION = SELECT_LOOT_SPECIALIZATION
local ipairs = ipairs

local tooltip
local radioFormat = "|TInterface\\Buttons\\UI-RadioButton:0:0:0:0:64:16:%s:%s:%s:%s|t"
local radioOutline = radioFormat:format(1, 14, 1, 14)
local radioFill = radioFormat:format(19, 28, 3, 12)

local function clickHandler(_, spec)
	a.SwitchTo(spec)
end

function a.RefreshTooltip()
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

function a.ShowTooltip(anchor)
	tooltip = qTip:Acquire(addonName, 3, "CENTER", "CENTER", "LEFT")
	tooltip:SetAutoHideDelay(.2, anchor)	
	tooltip:SmartAnchorTo(anchor)
	a.RefreshTooltip()
	tooltip:Show()
end

function a.ToggleTooltip(anchor)
	if qTip:IsAcquired(addonName) and tooltip:IsVisible() then
		tooltip:Hide()
	else
		a.ShowTooltip(anchor)
	end
end