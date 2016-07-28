local addonName, a = ...
local L = a.Localize
local u = BittensGlobalTables.GetTable("BittensUtilities")

local GetItemCount = GetItemCount
local GetTime = GetTime
local GetInstanceInfo = GetInstanceInfo
local UIErrorsFrame = UIErrorsFrame
local UnitAffectingCombat = UnitAffectingCombat
local UnitLevel = UnitLevel
local pairs = pairs
local print = print
local select = select
local tinsert = tinsert

a.AnnounceOptions = { }
a.AnnounceTargets = { }
local lastAnnounce = 0
local paused = UnitAffectingCombat("player")
local announcedThisPause = false
local ANNOUNCE_THROTTLE = 5

local function createOption(name, text, default, table)
	local option = u.CreateCheckBoxOption(name, text, default)
	tinsert(table, option)
	return option
end

local function createAnnounceOption(name, text, default)
	return createOption(name, text, default, a.AnnounceOptions)
end

local function createAnnounceTarget(name, text)
	return createOption(name, text, true, a.AnnounceTargets)
end

local warningOption = createAnnounceTarget(
	"AnnounceToWarning", L["Warning Text"])
local chatOption = createAnnounceTarget(
	"AnnounceToChat", L["General Chat Log"])
local function announce()
	if paused and announcedThisPause then
		return
	end

	local now = GetTime()
	if now - lastAnnounce < ANNOUNCE_THROTTLE then
		return
	end

	local text =
		"|cffffc800Your loot spec is set to:|r " .. a.GetCurrentSpec().LongName
	if a.IsOptionSelected(chatOption) then
		print(text)
	end
	if a.IsOptionSelected(warningOption) then
		UIErrorsFrame:AddMessage(text)
	end
	lastAnnounce = now
	announcedThisPause = true
end

function a.PauseAnnouncements()
	paused = true
	announcedThisPause = GetTime() - lastAnnounce < ANNOUNCE_THROTTLE
end

function a.UnpauseAnnouncements()
	paused = false
end

------------------------------------------------------------------------- Login
local loginOption = createAnnounceOption("AnnounceLogin", L["Logging In"], false)

function a.AnnounceOnLogin()
	if a.IsOptionSelected(loginOption) then
		announce()
	else
		a.AnnounceOnZoneChange()
	end
end

---------------------------------------------------------------- Enter Instance
local zoneInOption = createAnnounceOption(
	"AnnounceZone", L["Entering an Instance"], true)

local announceDifficulties = {
	[0] = false, -- no instance
	[1] = true, -- 5 man
	[2] = true, -- 5 man heroic
	[3] = true, -- 10 man
	[4] = true, -- 25 man
	[5] = true, -- 10 man heroic
	[6] = true, -- 25 man heroic
	[7] = true, -- LFR
	[8] = false, -- challenge mode
	[9] = false, -- 40 man
	[10] = false, -- not used
	[11] = true, -- heroic scenario
	[12] = true, -- scenario
}

function a.AnnounceOnZoneChange()
	if not a.IsOptionSelected(zoneInOption) then
		return
	end

	local difficulty = select(3, GetInstanceInfo())
	if difficulty and announceDifficulties[difficulty] then
		announce()
	end
end

------------------------------------------------------------------- Target Boss
local targetOption = createAnnounceOption(
	"AnnounceTarget", L["Targeting a Boss"], true)

function a.AnnounceOnTargetChange()
	if a.IsOptionSelected(targetOption) and UnitLevel("target") == -1 then
		announce()
	end
end

----------------------------------------------------------------- Changing Spec
local specOption = createAnnounceOption(
	"AnnounceSpec", L["Changing Spec"], true)

function a.AnnounceOnSpecChange()
	if a.IsOptionSelected(specOption) then
		announce()
	end
end

------------------------------------------------------------ Changing Loot Spec
local lootSpecOption = createAnnounceOption(
	"AnnounceLootSpec", L["Changing Loot Spec"], false)

function a.AnnounceOnLootSpecChange()
	if a.IsOptionSelected(lootSpecOption) then
		announce()
	end
end

--------------------------------------------------------------------- Inventory
local inventory = { }

local function addInterestingItems(optionName, optionText, ...)
	createAnnounceOption(optionName, optionText, false)
	local items = { }
	for i = 1, select("#", ...) do
		items[select(i, ...)] = 0
	end
	inventory[optionName] = items
end

addInterestingItems(
	"AnnounceHeroicCache",
	L["Receiving a Heroic Cache of Treasures"],
	98134, -- Heroic Cache of Treasures
	98546) -- Bulging Heroic Cache of Treasures
addInterestingItems(
	"AnnounceOtherCache",
	L["Receiving Other Caches of Treasures"],
	89613, -- Cache of Treasures
	98133, -- Greater Cache of Treasures
	92813) -- Greater Cache of Treasures

function a.ScanInventory()
	local announcable = false
	for optionName, items in pairs(inventory) do
		for itemId, oldCount in pairs(items) do
			local newCount = GetItemCount(itemId)
			announcable = announcable
				or (newCount > oldCount and a.IsOptionSelected(optionName))
			items[itemId] = newCount
		end
	end
	return announcable
end

function a.ScanInventoryForAnnounce()
	if a.ScanInventory() then
		announce()
	end
end
