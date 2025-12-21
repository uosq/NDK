local playerWrapper = require("src.wrappers.player")
local BaseClass = require("src.wrappers.basewrapper")

local WEAPON_NOCLIP = -1
local SYDNEY_SLEEPER = 230
local TF_PARTICLE_MAX_CHARGE_TIME = 2.0

local EMinigunState = require("src.minigunstate")
local mathlib = require("src.mathlib")
local vectorlib = require("src.vectorlib")

local iThrowTick = -5
local iLastTickBase = 0
local Throwing = false
local bFiring, bLoading = false, false

local TF_TEAM_PVE_INVADERS = 3

---@class Weapon: BaseWrapper
---@field protected __handle Entity
local Weapon = {
}
Weapon.__index = Weapon
setmetatable(Weapon, {__index = BaseClass})

---@param entity Entity?
---@return Weapon?
function Weapon.Get(entity)
	if entity == nil then
		return nil
	end

	return setmetatable({__handle = entity}, Weapon)
end

function Weapon:m_hOwner()
	return self.__handle:GetPropEntity("m_hOwner")
end

function Weapon:m_iClip1()
	return self.__handle:GetPropInt("LocalWeaponData", "m_iClip1")
end

function Weapon:m_iClip2()
	return self.__handle:GetPropInt("LocalWeaponData", "m_iClip2")
end

function Weapon:m_iPrimaryAmmoType()
	return self.__handle:GetPropInt("LocalWeaponData", "m_iPrimaryAmmoType")
end

function Weapon:m_iSecondaryAmmoType()
	return self.__handle:GetPropInt("LocalWeaponData", "m_iSecondaryAmmoType")
end

function Weapon:m_flNextPrimaryAttack()
	return self.__handle:GetPropFloat("LocalActiveWeaponData", "m_flNextPrimaryAttack")
end

function Weapon:m_flNextSecondaryAttack()
	return self.__handle:GetPropFloat("LocalActiveWeaponData", "m_flNextSecondaryAttack")
end

function Weapon:m_flLastFireTime()
	return self.__handle:GetPropFloat("LocalActiveTFWeaponData", "m_flLastFireTime")
end

function Weapon:GetAmmoPerShot()
	local ammoPerShot = self.__handle:AttributeHookInt("mod_ammo_per_shot", 0)
	return ammoPerShot > 0 and ammoPerShot or self.__handle:GetWeaponData().ammoPerShot
end

function Weapon:HasPrimaryAmmoForShot()
	local iClip = self:m_iClip1()
	local owner = playerWrapper.Get(self:m_hOwner())
	if owner == nil then
		return false
	end

	return (iClip == WEAPON_NOCLIP and owner:GetAmmoCount(self:m_iPrimaryAmmoType()) or iClip) >= self:GetAmmoPerShot()
end

function Weapon:CanPrimaryAttack()
	local owner = self:m_hOwner()
	local player = playerWrapper.Get(owner)
	if player == nil then
		return false
	end

	local curtime = player:m_nTickBase() * globals.TickInterval()
	return self:m_flNextPrimaryAttack() <= curtime and player:m_flNextAttack() <= curtime
end

function Weapon:CanSecondaryAttack()
	local owner = playerWrapper.Get(self:m_hOwner())
	if owner == nil then
		return false
	end

	local curtime = owner:m_nTickBase() * globals.TickInterval()
	return self:m_flNextSecondaryAttack() <= curtime and owner:m_flNextAttack() <= curtime
end

function Weapon:IsMeleeWeapon()
	return self.__handle:IsMeleeWeapon()
end

function Weapon:GetWeaponData()
	return self.__handle:GetWeaponData()
end

function Weapon:GetWeaponProjectileType()
	return self.__handle:GetWeaponProjectileType()
end

---@param cmd UserCmd
function Weapon:CanShootPrimary(cmd)
	if cmd.weaponselect ~= 0 then
		return false
	end

	if self:HasPrimaryAmmoForShot() == false then
		return false
	end

	if self.__handle:IsMeleeWeapon() then
		return self:m_flNextPrimaryAttack() + self:GetWeaponData().smackDelay <= globals.CurTime()
	end

	return self:CanPrimaryAttack()
end

---@param cmd UserCmd
function Weapon:CanShootSecondary(cmd)
	if cmd.weaponselect ~= 0 then
		return false
	end

	if self:HasPrimaryAmmoForShot() == false then
		return false
	end

	return self:CanSecondaryAttack()
end

function Weapon:m_iItemDefinitionIndex()
	return self.__handle:GetPropInt("m_Item", "m_iItemDefinitionIndex")
end

---@return number
function Weapon:GetCurrentCharge()
	--- WARNING: CanCharge() will crash your game with a Rocket Launcher!
	--- I have to find another way
	--- This doesn't work right with Loose Cannon
	if self.__handle:CanCharge() then
		local maxtime = self.__handle:GetChargeMaxTime()
		local begintime = self.__handle:GetChargeBeginTime()
		local diff = globals.CurTime() - begintime
		if diff > maxtime then
			return 0
		end

		return diff/maxtime
	end

	return 0
end

function Weapon:GetHandle()
	return self.__handle
end

function Weapon:GetWeaponID()
	return self.__handle:GetWeaponID()
end

function Weapon:GetSlot()
	return self.__handle:GetLoadoutSlot()
end

function Weapon:m_iReloadMode()
	return self.__handle:GetPropInt("m_iReloadMode")
end

---@param attrib string
---@param defaultValue number? # optional (default = `1.0`)
---@return number
function Weapon:AttributeHookFloat(attrib, defaultValue)
	return self.__handle:AttributeHookFloat(attrib, defaultValue)
end

---@param attrib string
---@param defaultValue number? # optional (default = `1.0`)
function Weapon:AttributeHookInt(attrib, defaultValue)
	return self.__handle:AttributeHookInt(attrib, defaultValue)
end

function Weapon:m_flChargedDamage()
	if self.__handle:GetWeaponID() == E_WeaponBaseID.TF_WEAPON_SNIPERRIFLE
	or self.__handle:GetWeaponID() == E_WeaponBaseID.TF_WEAPON_SNIPERRIFLE_CLASSIC then
		return self.__handle:GetPropFloat("SniperRifleLocalData", "m_flChargedDamage")
	end

	return 0
end

function Weapon:m_iWeaponState()
	if self.__handle:GetWeaponID() == TF_WEAPON_MINIGUN then
		return self.__handle:GetPropInt("m_iWeaponState")
	end

	return 0
end

function Weapon:get_weapon_mode_float()
	return self.__handle:AttributeHookFloat("set_weapon_mode", 0.0)
end

function Weapon:get_weapon_mode_int()
	return self.__handle:AttributeHookInt("set_weapon_mode", 0)
end

function Weapon:IsAmbassador()
	return self:GetWeaponID() == TF_WEAPON_REVOLVER and self:get_weapon_mode_float() == 1.0
end

function Weapon:CanAmbassadorHeadshot()
	if self:IsAmbassador() then
		return (globals.CurTime() - self:m_flLastFireTime()) > 1.0
	end

	return false
end

function Weapon:IsHitscan()
	return self:GetWeaponProjectileType() == E_ProjectileType.TF_PROJECTILE_BULLET
end

function Weapon:IsProjectileWeapon()
	return self:IsHitscan() == false and self:IsMeleeWeapon() == false
end

---@param player Player
---@param offset Vector3
---@param hitTeammates boolean
---@return Vector3 vecSrc, Vector3 angForward
function Weapon:GetProjectileFireSetup(player, offset, hitTeammates)
	return self.__handle:GetProjectileFireSetup(player:GetHandle(), offset, hitTeammates, 2048)
end

---@param player Player
function Weapon:CanHit(player)
	local m_hOwner = self:m_hOwner()
	if m_hOwner == nil then
		return false
	end

	if m_hOwner:GetTeamNumber() == player:GetTeamNumber() then
		local weaponID = self:GetWeaponID()
		if weaponID == TF_WEAPON_MEDIGUN then
			return true
		end

		if weaponID == TF_WEAPON_LUNCHBOX then
			return true
		end

		if self:m_iItemDefinitionIndex() == SYDNEY_SLEEPER and player:InCond(TFCond_OnFire) then
			return true
		end

		return false
	end

	return player:InCond(TFCond_Ubercharged) == false
end

--- Source: https://github.com/rei-2/Amalgam/blob/398e61d0948c1a49477caf806a3995ab12efbeff/Amalgam/src/SDK/SDK.cpp#L531
--- Man this was an absolute nightmare to convert to Lua
--- Holy shit
--- Why we dont have a function for this natively??

--- This should only be called from a Localplayer's Weapon!
---@param cmd UserCmd
---@return boolean
function Weapon:IsAttacking(cmd)
	local m_hOwner = self:m_hOwner()
	if m_hOwner == nil then
		return false
	end

	if m_hOwner:GetIndex() ~= client.GetLocalPlayerIndex() then
		error("Weapon:IsAttacking should ever be called from a localplayer's weapon!")
		return false
	end

	if cmd.weaponselect ~= 0 then
		return false
	end

	local useTickBase = engine.GetServerIP() ~= "loopback"
	local iTickBase = useTickBase and m_hOwner:GetPropInt("m_nTickBase") or cmd.tick_count

	if self:GetSlot() == E_LoadoutSlot.LOADOUT_POSITION_MELEE then
		local weaponID = self:GetWeaponID()
		if weaponID == TF_WEAPON_KNIFE then
			return self:CanPrimaryAttack() and (cmd.buttons & IN_ATTACK) ~= 0

		elseif weaponID == TF_WEAPON_BAT_WOOD
		or weaponID == E_WeaponBaseID.TF_WEAPON_BAT_GIFTWRAP then
			if (iTickBase ~= iLastTickBase) then
				iThrowTick = math.max(iThrowTick - 1, -5)
			end
			iLastTickBase = iTickBase

			if self:CanPrimaryAttack() and self:HasPrimaryAmmoForShot() and cmd.buttons & IN_ATTACK2 ~= 0 and iThrowTick == -5 then
				iThrowTick = 12
			end

			if iThrowTick > -5 then
				Throwing = true
			end

			if iThrowTick > 1 then
				Throwing = true
			end

			if iThrowTick == 1 then
				return true
			end
		end

		--- no m_flSmackTime netvar so we're fucked here
		return self:CanPrimaryAttack()
	end

	local weaponID = self:GetWeaponID()
	if weaponID == TF_WEAPON_COMPOUND_BOW then
		return cmd.buttons & IN_ATTACK == 0 and self:GetCurrentCharge() > 0.0
	end

	if weaponID == TF_WEAPON_PIPEBOMBLAUNCHER
	or weaponID == TF_WEAPON_STICKY_BALL_LAUNCHER
	or weaponID == TF_WEAPON_GRENADE_STICKY_BALL then
		local charge = self:GetCurrentCharge()
		local amount = mathlib.RemapVal(charge, 0, self:AttributeHookFloat("stickybomb_charge_rate", 4.0), 0, 1, true)
		return (cmd.buttons & IN_ATTACK == 0 and amount > 0) or amount == 1
	end

	if weaponID == TF_WEAPON_CANNON then
		local mortar = self:AttributeHookFloat("grenade_launcher_mortar_mode", 0)
		if mortar ~= 0 then
			return (self:CanPrimaryAttack() and cmd.buttons & IN_ATTACK ~= 0)
		end

		local charge = self:GetCurrentCharge()
		local amount = mathlib.RemapVal(charge, 0, mortar, 0, 1, true)
		return (cmd.buttons & IN_ATTACK == 0 and amount > 0) or amount == 1
	end

	if weaponID == TF_WEAPON_SNIPERRIFLE_CLASSIC then
		return cmd.buttons & IN_ATTACK == 0 and self:m_flChargedDamage() > 0
	end

	if weaponID == TF_WEAPON_PARTICLE_CANNON then
		local charge = self:GetCurrentCharge()
		return charge >= TF_PARTICLE_MAX_CHARGE_TIME
	end

	if weaponID == TF_WEAPON_CLEAVER
	or weaponID == TF_WEAPON_JAR
	or weaponID == TF_WEAPON_JAR_MILK
	or weaponID == TF_WEAPON_JAR_GAS then
		if iTickBase ~= iLastTickBase then
			iThrowTick = math.max(iThrowTick - 1, -5)
		end
		iLastTickBase = iTickBase

		local iAttack = weaponID == E_WeaponBaseID.TF_WEAPON_CLEAVER and IN_ATTACK | IN_ATTACK2 or IN_ATTACK
		if self:CanPrimaryAttack() and self:HasPrimaryAmmoForShot() and cmd.buttons & IN_ATTACK ~= 0 and iAttack ~= 0 and iThrowTick == -5 then
			iThrowTick = 12
		end
		if iThrowTick > -5 then
			Throwing = true
		end
		if iThrowTick > 1 then
			iThrowTick = 2
		end
		return iThrowTick == 1
	end

	if weaponID == TF_WEAPON_MINIGUN then
		local state = self:m_iWeaponState()
		if state == EMinigunState.AC_STATE_FIRING
		or state == EMinigunState.AC_STATE_SPINNING then
			if self:HasPrimaryAmmoForShot() then
				return (self:CanPrimaryAttack() and cmd.buttons & IN_ATTACK ~= 0)
			end
		end

		--- on Amalgam this returns false, but if I do it then it breaks minigun
		return not (self:HasPrimaryAmmoForShot() and cmd.buttons & IN_ATTACK ~= 0)
	end

	if weaponID == TF_WEAPON_LUNCHBOX then
		if self:CanSecondaryAttack() and self:HasPrimaryAmmoForShot() and cmd.buttons & IN_ATTACK2 ~= 0 then
			return true
		end

		return false
	end

	if weaponID == TF_WEAPON_FLAMETHROWER then
		if self:AttributeHookInt("set_charged_airblast", 0) == 0 and self:CanSecondaryAttack() and cmd.buttons & IN_ATTACK2 ~= 0 then
			return true
		end
	end

	if weaponID == TF_WEAPON_FLAME_BALL then
		if self:AttributeHookInt("set_charged_airblast", 0) ~= 0 then
			return false
		elseif self:CanSecondaryAttack() and cmd.buttons & IN_ATTACK2 ~= 0 then
			return true
		end
	end

	--- Beggar's Bazooka
	if self:m_iItemDefinitionIndex() == 730 then
		local bAmmo = self:HasPrimaryAmmoForShot()
		if bAmmo == 0 then
			bLoading = false
			bFiring = false
		elseif not bFiring then
			bLoading = true
		end

		if ((bFiring or (bLoading and (cmd.buttons & IN_ATTACK == 0))) and bAmmo ~= 0) then
			bFiring = true
			bLoading = false
			return self:CanPrimaryAttack()
		end

		return false
	end

--- wtf does this 2 mean?
--- return G::CanPrimaryAttack && pCmd->buttons & IN_ATTACK ? 1 : G::Reloading && pCmd->buttons & IN_ATTACK ? 2 : 0;
--- we dont have m_bInReload so I can't get the reloading part :p
	return (self:CanPrimaryAttack() and cmd.buttons & IN_ATTACK ~= 0)
end

---@param plocal Player
---@param pTarget Player
---@return boolean
local function IsBehindAndFacingEntity(plocal, pTarget, fovPercent, range)
	local dir = pTarget:GetWorldSpaceCenter() - plocal:GetWorldSpaceCenter() -- local -> target
	if dir:Length() > range then return false end
	--dir.z = 0
	vectorlib.Normalize(dir)

	local localForward = engine.GetViewAngles():Forward()
	--localForward.z = 0
	vectorlib.Normalize(localForward)

	local targetForward = EulerAngles(pTarget:m_angEyeAngles():Unpack()):Forward()
	--targetForward.z = 0
	vectorlib.Normalize(targetForward)

	local posVsTargetView = dir:Dot(targetForward)
	local posVsLocalView = dir:Dot(localForward)
	local viewAnglesDot = localForward:Dot(targetForward)

	local isBehind = posVsTargetView > 0 --- for some reason this is positive, but in the tf2's source code it is negative wtf
	local maxAngle = fovPercent * math.pi/2
	local fovDot = math.cos(maxAngle)
	local isLookingAtTarget = posVsLocalView >= fovDot
	local isFacingBack = viewAnglesDot > -0.3

	return (isBehind and isLookingAtTarget and isFacingBack)
end

---@param pTarget Player
---@param fov number [0, 1] (0 = 0%; 1 = 100%)
---@param range number? Max distance that we can backstab (Usually 48 HUs) (default: 48)
---@return boolean
function Weapon:CanBackstab(pTarget, fov, range)
	local m_hOwner = playerWrapper.Get(self:m_hOwner())
	if m_hOwner == nil then
		return false
	end

	if pTarget == nil then
		return false
	end

	local iNoBackstab = pTarget:AttributeHookInt("cannot_be_backstabbed")
	if iNoBackstab == 0 then
		return false
	end

	range = range == nil and 48 or range

	if IsBehindAndFacingEntity(m_hOwner, pTarget, fov, range) then
		return true
	end

	if gamerules.IsMvM() and pTarget:GetTeamNumber() == TF_TEAM_PVE_INVADERS then
		if pTarget:InCond(E_TFCOND.TFCond_MVMBotRadiowave) then
			return true
		end

		if pTarget:InCond(E_TFCOND.TFCond_Sapped) and not pTarget:m_bIsMiniBoss() then
			return true
		end
	end

	return false
end

return Weapon