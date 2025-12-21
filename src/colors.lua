local lib = {}

local COLOR_AMMOPACK = {1, 1, 1}
local COLOR_MEDKIT = {0.15294117647059, 0.96078431372549, 0.32941176470588}
local COLOR_CPHYSICSPROP = {1, 1, 1}
local COLOR_ISWEAPON = {1, 1, 1}
local COLOR_FRIEND = {1, 1, 0}
local COLOR_PRIORITY = {0, 1, 0.501888}
local COLOR_AIMTARGET = {1, 1, 1}
local COLOR_LOCALPLAYER = {0, 1, 0.501888}
local COLOR_RED = {1, 0, 0}
local COLOR_BLU = {1, 1, 0}
local COLOR_NONE = {1, 1, 1}

local map = {
	AMMOPACK = COLOR_AMMOPACK,
	MEDKIT = COLOR_MEDKIT,
	CPHYSICSPROP = COLOR_CPHYSICSPROP,
	ISWEAPON = COLOR_ISWEAPON,
	FRIEND = COLOR_FRIEND,
	PRIORITY = COLOR_PRIORITY,
	AIMTARGET = COLOR_AIMTARGET,
	LOCALPLAYER = COLOR_LOCALPLAYER,
	RED = COLOR_RED,
	BLU = COLOR_BLU,
	NONE = COLOR_NONE,
}

---Always returns a RGB table normalized to [0, 1]
---@param entity Entity
---@param aimTarget Entity?
function lib.GetColor(entity, aimTarget)
	do
		local class = entity:GetClass()
		if class == "CBaseAnimating" then
			local modelName = models.GetModelName(entity:GetModel())
			if string.find(modelName, "ammopack") then
				return COLOR_AMMOPACK
			elseif string.find(modelName, "medkit") then
				return COLOR_MEDKIT
			end
		end

		if class == "CPhysicsProp" then
			return COLOR_CPHYSICSPROP
		end
	end

	if aimTarget and aimTarget:GetIndex() == entity:GetIndex() then
		return COLOR_AIMTARGET
	end

	if entity:IsWeapon() then
		return COLOR_ISWEAPON
	end

	do
		local priority = playerlist.GetPriority(entity)
		if priority > 0 then
			return COLOR_PRIORITY
		elseif priority < 0 then
			return COLOR_FRIEND
		end
	end

	if entity:GetIndex() == client.GetLocalPlayerIndex() then
		return COLOR_LOCALPLAYER
	end

	do
		local team = entity:GetTeamNumber()
		if team == 3 then
			return COLOR_RED
		end

		if team == 2 then
			return COLOR_BLU
		end
	end

	return COLOR_NONE
end

---@param colorStr "ammopack" | "medkit" | "cphysicsprop" | "isweapon" | "friend" | "priority" | "aimtarget" | "localplayer" | "red" | "blu" | "none"
---@param newColorTable {[1]: number, [2]: number, [3]: number} [1], [2] and [3] must be normalized to [0, 1] (The function does it automatically)
function lib.SetColor(colorStr, newColorTable)
	assert(type(colorStr) == "string", "colorStr is not a string!")
	assert(type(newColorTable) == "table", "newColorTable is not a table!")

	colorStr = string.upper(colorStr)

	local selected = map[colorStr]
	if selected == nil then
		return
	end

	local r, g, b = newColorTable[1], newColorTable[2], newColorTable[3]
	if r > 255 then r = r/255 end
	if g > 255 then g = g/255 end
	if b > 255 then b = b/255 end

	selected[1] = r
	selected[2] = g
	selected[3] = b
end

return lib