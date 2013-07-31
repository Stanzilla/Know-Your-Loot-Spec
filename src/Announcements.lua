local addonName, a = ...

local GetTime = GetTime
local GetInstanceInfo = GetInstanceInfo
local UIErrorsFrame = UIErrorsFrame
local UnitAffectingCombat = UnitAffectingCombat
local UnitLevel = UnitLevel
local print = print
local select = select
local tinsert = tinsert

a.AnnounceOptions = { }
a.AnnounceTargets = { }
local lastAnnounce = 0
local paused = UnitAffectingCombat("player")
local announcedThisPause = false

local function createOption(name, text, table)
	local option = { Name = name, Text = text, Default = true }
	tinsert(table, option)
	return option
end

local function createAnnounceOption(name, text)
	return createOption(name, text, a.AnnounceOptions)
end

local function createAnnounceTarget(name, text)
	return createOption(name, text, a.AnnounceTargets)
end

local chatOption = createAnnounceTarget("AnnounceToChat", "General Chat Log")
local warningOption = createAnnounceTarget("AnnounceToWarning", "Warning Text")
local function announce()
	if paused and announcedThisPause then
		return
	end
	
	local now = GetTime()
	if now - lastAnnounce < 60 then
		return
	end
	
	local text = 
		"|cffffc800Know your loot spec: |r" .. a.GetCurrentSpec().LongName
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
	announcedThisPause = GetTime() - lastAnnounce < 60
end

function a.UnpauseAnnouncements()
	paused = false
end

------------------------------------------------------------------------- Login
local loginOption = createAnnounceOption("AnnounceLogin", "Logging In")

function a.AnnounceOnLogin()
	if a.IsOptionSelected(loginOption) then
		announce()
	else
		a.AnnounceOnZoneChange()
	end
end

---------------------------------------------------------------- Enter Instance
local zoneInOption = createAnnounceOption(
	"AnnounceZone", "Entering an Instance")

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
local targetOption = createAnnounceOption("AnnounceTarget", "Targeting a Boss")

function a.AnnounceOnTargetChange()
	if a.IsOptionSelected(targetOption) and UnitLevel("target") == -1 then
		announce()
	end
end
