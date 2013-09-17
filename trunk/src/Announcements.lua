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
		"|cffffc800Know your loot spec:|r " .. a.GetCurrentSpec().LongName
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
local loginOption = createAnnounceOption("AnnounceLogin", L["Logging In"], true)

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
	"AnnounceSpec", L["Changing Spec"], false)

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
	createAnnounceOption(optionName, optionText, true)
	local items = { }
	for i = 1, select("#", ...) do
		items[select(i, ...)] = 0
	end
	inventory[optionName] = items
end

local function addTimelessItems(...)
	addInterestingItems(
		"AnnounceTimelessItems",
		L["Receiving a Timeless Armor Piece"],
		102318, -- Timless Cloak
		104347, -- Timeless Curio
		104345, -- Timeless Lavalliere
		...)
end

addInterestingItems(
	"AnnounceBurdens",
	L["Receiving a Burden of Eternity"],
	103982)
local _, class = UnitClass("player")
if class == "MAGE" or class == "PRIEST" or class == "WARLOCK" then
	addTimelessItems(
		104013, -- Timeless Cloth Armor Cache
		102291, -- Timeless Signet
		102290, -- Timeless Cloth Belt
		102285, -- Timeless Cloth Boots
		102321, -- Timeless Cloth Bracers
		102286, -- Timeless Cloth Gloves
		102287, -- Timeless Cloth Helm
		102288, -- Timeless Cloth Leggings
		102284, -- Timeless Cloth Robes
		102289) -- Timeless Cloth Spaulders
elseif class == "DRUID" or class == "MONK" or class == "ROGUE" then
	addTimelessItems(
		104012, -- Timeless Leather Armor Cache
		102283, -- Timeless Leather Belt
		102278, -- Timeless Leather Boots
		102322, -- Timeless Leather Bracers
		102277, -- Timeless Leather Chestpiece
		102278, -- Timeless Leather Gloves
		102280, -- Timeless Leather Helm
		102281, -- Timeless Leather Leggings
		102282) -- Timeless Leather Spaulders
elseif class == "HUNTER" or class == "SHAMAN" then
	addTimelessItems(
		104010, -- Timeless Mail Armor Cache
		102276, -- Timeless Mail Belt
		102271, -- Timeless Mail Boots
		102323, -- Timeless Mail Bracers
		102270, -- Timeless Mail Chestpiece
		102272, -- Timeless Mail Gloves
		102273, -- Timeless Mail Helm
		102274, -- Timeless Mail Leggings
		102275) -- Timeless Mail Spaulders
elseif class == "DEATHKNIGHT" or class == "PALADIN" or class == "WARRIOR" then
	addTimelessItems(
		104009, -- Timeless Plate Armor Cache
		102269, -- Timeless Plate Belt
		102264, -- Timeless Plate Boots
		102320, -- Timeless Plate Bracers
		102263, -- Timeless Plate Chestpiece
		102265, -- Timeless Plate Gloves
		102266, -- Timeless Plate Helm
		102267, -- Timeless Plate Leggings
		102268) -- Timeless Plate Spaulders
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
