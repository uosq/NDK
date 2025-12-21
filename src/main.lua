---@class NDK
local ndk = {}

---@diagnostic disable-next-line: undefined-global
if __bundle_require == nil then
	printc(0, 255, 255, 255, "NDK not required from a bundled script! Might not unload correctly some callbacks")
end

local CTFPlayer = require("src.wrappers.player")
local weaponWrap = require("src.wrappers.weapon")
local CObjectSentrygun = require("src.wrappers.cobjectsentrygun")
local CBaseObject = require("src.wrappers.cbaseobject")

local inputlib = require("src.input")
local mathlib = require("src.mathlib")
local chokedlib = require("src.chokedcmds")

local angleManager = require("src.angleMgr")
local cvarManager = require("src.cvarManager")
local keyValLib = require("src.keyvalues")
local colorManager = require("src.colors")

local EAmmoType = require("src.ammotype")
local EMinigunState = require("src.minigunstate")
local EBoneIndex = require("src.boneindexes")

local profiler = require("src.profiler")

local playerSimulation = require("src.prediction.playersim")
local projectileSimulation = require("src.prediction.projectilesim")

function ndk.GetPlayerSim()
	return playerSimulation
end

function ndk.GetProjectileSim()
	return projectileSimulation
end

--- Function to convert `obj` to `class` (Player, BasePlayer, Weapon, ...) \
--- Can convert a Entity to class \
--- Or you can use a already existing wrapped class (example: Player)
---@generic T
---@param obj Entity|table?
---@param classTable T
---@return T?
function ndk.Reinterpret(obj, classTable)
	if obj == nil or type(classTable) ~= "table" then
		return nil
	end

	if type(obj) == "table" then
		if obj.__handle == nil then
			return nil
		end

		return setmetatable(obj, classTable)
	end

	return setmetatable({__handle = obj}, classTable)
end

function ndk.GetWeaponClass()
	return weaponWrap
end

function ndk.GetPlayerClass()
	return CTFPlayer
end

function ndk.GetBaseObjectClass()
	return CBaseObject
end

function ndk.GetSentryClass()
	return CObjectSentrygun
end

---@return Player[]
function ndk.GetPlayerList()
	local baseclass = CTFPlayer
	local list = {}

	for i = 1, globals.MaxClients() do
		local player = ndk.Reinterpret(entities.GetByIndex(i), baseclass)
		if player then
			list[#list+1] = player
		end
	end

	return list
end

function ndk.GetInputLib()
	return inputlib
end

function ndk.GetMathLib()
	return mathlib
end

function ndk.GetAngleManager()
	return angleManager
end

function ndk.GetAmmoTypeEnum()
	return EAmmoType
end

function ndk.GetBoneIndexEnum()
	return EBoneIndex
end

function ndk.UnloadScript()
	UnloadScript(GetScriptName())
end

function ndk.GetChokedLib()
	return chokedlib
end

function ndk.GetConVarManager()
	return cvarManager
end

function ndk.GetMinigunStateEnum()
	return EMinigunState
end

function ndk.GetProfiler()
	return profiler
end

function ndk.GetKeyValueLib()
	return keyValLib
end

function ndk.GetColorManager()
	return colorManager
end

return ndk