local _, a = ...

local g = BittensGlobalTables
local u = g.GetTable("BittensUtilities")

local GetLootSpecialization = GetLootSpecialization
local GetNumSpecializations = GetNumSpecializations
local GetSpecialization = GetSpecialization
local GetSpecializationInfo = GetSpecializationInfo
local GetSpecializationInfoByID = GetSpecializationInfoByID
local LOOT_SPECIALIZATION_DEFAULT = LOOT_SPECIALIZATION_DEFAULT
local select = select

-- {
--     GlobalId = number,
--     Name = string,
--     LongName = string,
--     Icon = string,
--     Current = boolean,
-- }

local function populateSpec(globalId, table)
--print("populateSpec", globalId, table)
	table.GlobalId = globalId
	if globalId == 0 then
		table.Name = "Current"
		local _, name, icon
		local id = GetSpecialization()
		if id then
			_, name, _, icon = GetSpecializationInfo(id)
		else
			name = "?"
			icon = "Interface\\ICONS\\INV_Misc_QuestionMark"
		end
		table.LongName = LOOT_SPECIALIZATION_DEFAULT:format(name)
		table.Icon = icon
	else
		local _, name, _, icon = GetSpecializationInfoByID(globalId)
		table.Name = name
		table.LongName = name
		table.Icon = icon
	end
	table.Current = globalId == GetLootSpecialization()
--print("  - ", table.GlobalID, table.Name, table.Icon, table.Current)
end

local cur = { }
function a.GetCurrentSpec()
	populateSpec(GetLootSpecialization(), cur)
	return cur
end

local all = { }
function a.GetAllSpecs()
--print("GetAllSpecs")
	populateSpec(0, u.GetOrMakeTable(all, 1))
	for i = 1, GetNumSpecializations() do
		local globalId = GetSpecializationInfo(i)
		populateSpec(globalId, u.GetOrMakeTable(all, i + 1))
	end
	return all
end
