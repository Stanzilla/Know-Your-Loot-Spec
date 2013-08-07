local addonName, a = ...
local L = a.Localize
local u = BittensGlobalTables.GetTable("BittensUtilities")
local qTip = LibStub('LibQTip-1.0')

local NORMAL_FONT_COLOR = NORMAL_FONT_COLOR
local SELECT_LOOT_SPECIALIZATION = SELECT_LOOT_SPECIALIZATION
local ipairs = ipairs

local tooltip
local leftClick
local rightClick
local radioFormat = "|TInterface\\Buttons\\UI-RadioButton:0:0:0:0:64:16:%s:%s:%s:%s|t"
local radioOutline = radioFormat:format(1, 14, 1, 14)
local radioFill = radioFormat:format(19, 28, 3, 12)

local function tooltipIsShowing()
	return qTip:IsAcquired(addonName) and tooltip:IsVisible()
end

function a.ShowTooltip(anchor, leftAction, rightAction)
	if tooltipIsShowing() then
		return
	end
	
	tooltip = qTip:Acquire(addonName, 4)
	tooltip:SetAutoHideDelay(.2, anchor)	
	tooltip:SmartAnchorTo(anchor)
	
	leftClick = leftAction
	rightClick = rightAction
	a.RefreshTooltip()
	
	tooltip:Show()
end

local function addActionLine(label, action)
	if action then
		local row = tooltip:AddLine()
		tooltip:SetCell(row, 1, label .. ":", nil, nil, 3)
		tooltip:SetCell(row, 4, action.Name)
		tooltip:SetCellTextColor(
			row, 1, 
			NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		tooltip:SetCellTextColor(
			row, 4, 
			NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b)
		tooltip:SetCellScript(row, 4, "OnMouseDown", action.Function)
	end
end

function a.RefreshTooltip()
	if not qTip:IsAcquired(addonName) then
		return
	end
	
	tooltip:Clear()
	local row = tooltip:AddLine()
	tooltip:SetCell(
		row, 1, SELECT_LOOT_SPECIALIZATION, 
		tooltip:GetHeaderFont(), "CENTER", 4)
	for _, spec in ipairs(a.GetAllSpecs()) do
		row = tooltip:AddLine()
		tooltip:SetCell(row, 1, spec.Current and radioFill or radioOutline)
		tooltip:SetCell(row, 2, "|T" .. spec.Icon .. ":16|t")
		tooltip:SetCell(row, 3, spec.LongName, nil, nil, 2)
		tooltip:SetLineScript(row, "OnMouseDown", function()
			a.SwitchTo(spec)
		end)
	end
	if leftClick or rightClick then
		tooltip:AddSeparator()
		addActionLine(L["Left Click"], leftClick)
		addActionLine(L["Right Click"], rightClick)
	end
end

function a.HideTooltip()
	qTip:Release(tooltip)
end

function a.ToggleTooltip(anchor, leftAction, rightAction)
	if tooltipIsShowing() then
		a.HideTooltip()
	else
		a.ShowTooltip(anchor, leftAction, rightAction)
	end
end
