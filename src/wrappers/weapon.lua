local playerWrapper = require("src.wrappers.player")
local BaseClass = require("src.wrappers.basewrapper")

local ProjectileInfo_t = require("src.projinfo")

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

---Always tries to return a [0, 1] value
---@return number
function Weapon:GetCurrentCharge()
	if self.__handle:CanCharge() then
		local id = self:GetID()
		local charge = self.__handle:GetCurrentCharge() or 0

		--- sticky launcher
		if id == TF_WEAPON_PIPEBOMBLAUNCHER then
			if charge > self.__handle:GetChargeMaxTime() then
				return 0
			end

			return charge
		end

		--- loose cannon
		if id == TF_WEAPON_CANNON then
			charge = mathlib.RemapVal(charge, 1, 0, 0, 1, true)
		end

		return charge
	end

	return 0
end

function Weapon:GetHandle()
	return self.__handle
end

function Weapon:GetID()
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
	return self:GetID() == TF_WEAPON_REVOLVER and self:get_weapon_mode_float() == 1.0
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
		local weaponID = self:GetID()
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
		local weaponID = self:GetID()
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

	local weaponID = self:GetID()
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

---@param offset Vector3
---@param angle EulerAngles
---@param allowflip boolean
---@return Vector3 startPos, Vector3 startAngle
function Weapon:GetProjectileFireSetup2(offset, angle, allowflip)
	allowflip = allowflip == nil and true or false

	local cl_flipviewmodels = client.GetConVar("cl_flipviewmodels")
	if allowflip and cl_flipviewmodels == 1 then
		offset.y = offset.y * -1
	end

	local m_hOwner = self:m_hOwner()
	local shootPos = m_hOwner:GetAbsOrigin() + m_hOwner:GetPropVector("localdata", "m_vecViewOffset[0]")

	local forward, right, up = angle:Forward(), angle:Right(), angle:Up()
	local posOut = shootPos + (forward * offset.x) + (right * offset.y) + (up * offset.z)

	local endPos = shootPos + forward * 2048
	local trace = engine.TraceHull(shootPos, endPos, m_hOwner:GetMins(), m_hOwner:GetMaxs(), MASK_SOLID, function (ent, contentsMask)
		if ent:GetIndex() == m_hOwner:GetIndex() then
			return false
		end

		return true
	end)

	if trace.fraction < 1.0 then
		endPos = trace.endpos
	end

	--- this is fucking stupid
	--- why vector.AngleVectors wants a EulerAngles?!?!?!
	return posOut, EulerAngles((endPos - posOut):Unpack()):Forward()
end

function Weapon:m_flDetonateTime()
	if self.__handle:GetClass() == "CWeaponGrenadeLauncher" then
		return self.__handle:GetPropFloat("m_flDetonateTime")
	end

	return 0
end

--- Source: https://github.com/rei-2/Amalgam/blob/bffae9999cf35a5fbdeb92387b9fae58796b8939/Amalgam/src/Features/Simulation/ProjectileSimulation/ProjectileSimulation.cpp#L6
--- I dont like pasting amalgam just as much as you
--- But I dont have the patience to get all the stats for every weapon
--- Why we dont have a native function for this??

---@return ProjectileInfo?
function Weapon:GetProjectileInfo()
	if self:IsHitscan() then
		return nil
	end

	local m_hOwner = self:m_hOwner()
	local m_bDucking = m_hOwner:GetPropInt("m_fFlags") & FL_DUCKING ~= 0
	local _, gravity = client.GetConVar("sv_gravity")
	gravity = gravity/800

	local id = self:GetID()
	if id == TF_WEAPON_ROCKETLAUNCHER
	or id == TF_WEAPON_DIRECTHIT then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.x = 23.5
		info.offset.y = self:AttributeHookInt("centerfire_projectile", 0) == 1 and 0 or 12
		info.offset.z = m_bDucking and 8 or -3
		info.speed = m_hOwner:InCond(E_TFCOND.TFCond_RunePrecision) and 3000 or self:AttributeHookFloat("mult_projectile_speed", 1100)
		info.hull.x = 0
		info.hull.y = 0
		info.hull.z = 0
		info.gravity = 0
		info.simple_trace = true
		return info
	end

	if id == TF_WEAPON_PARTICLE_CANNON
	or id == TF_WEAPON_RAYGUN
	or id == TF_WEAPON_DRG_POMSON then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		local isCowMangler = id == TF_WEAPON_PARTICLE_CANNON
		info.offset.x = 23.5
		info.offset.y = 8
		info.offset.z = m_bDucking and 8 or -3
		info.speed = isCowMangler and 1100 or 1200
		info.hull = isCowMangler and Vector3() or Vector3(1, 1, 1)
		info.simple_trace = true
		return info
	end

	if id == TF_WEAPON_GRENADELAUNCHER
	or id == TF_WEAPON_CANNON then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		local isCannon = id == TF_WEAPON_CANNON
		local mortar = isCannon and self:AttributeHookFloat("grenade_launcher_mortar_mode", 0) or 0
		info.speed = self:AttributeHookFloat("mult_projectile_range", m_hOwner:InCond(E_TFCOND.TFCond_RunePrecision) and 3000 or self:AttributeHookFloat("mult_projectile_speed", 1200))
		info.lifetime = mortar ~= 0 and self:m_flDetonateTime() > 0 and self:m_flDetonateTime() - globals.CurTime() or mortar or self:AttributeHookFloat("fuse_mult", 2)
		info.gravity = gravity

		return info
	end

	if id == TF_WEAPON_PIPEBOMBLAUNCHER then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.x = 16
		info.offset.y = 8
		info.offset.z = -6
		info.gravity = gravity

		local charge = self:GetCurrentCharge()
		info.speed = self:AttributeHookFloat("mult_projectile_range", mathlib.RemapVal(charge, 0, self:AttributeHookFloat("stickybomb_charge_rate", 4.0), 900, 2400, true))

		return info
	end

	if id == TF_WEAPON_FLAREGUN then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.x = 23.5
		info.offset.y = 12
		info.offset.z = m_bDucking and 8 or -3
		info.hull.x = 0
		info.hull.y = 0
		info.hull.z = 0
		info.speed = self:AttributeHookFloat("mult_projectile_speed", 2000)
		info.gravity = 0
		info.lifetime = 0.3 * gravity

		return info
	end

	--- TF_WEAPON_FLAREGUN_RENVEGE
	if id == TF_WEAPON_RAYGUN_REVENGE then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.x = 23.5
		info.offset.y = 12
		info.offset.z = m_bDucking and 8 or -3
		info.hull.x = 0
		info.hull.y = 0
		info.hull.z = 0
		info.speed = 3000

		return info
	end

	if id == TF_WEAPON_COMPOUND_BOW then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.x = 23.5
		info.offset.y = 12
		info.offset.z = -3
		info.hull.x = 1
		info.hull.y = 1
		info.hull.z = 1

		local charge = self:GetCurrentCharge()
		info.speed = mathlib.RemapVal(charge, 0, 1, 1800, 2600)
		info.gravity = mathlib.RemapVal(charge, 0, 1, 0.5, 0.1) * gravity
		info.lifetime = 10

		return info
	end

	if id == TF_WEAPON_CROSSBOW
	or id == TF_WEAPON_SHOTGUN_BUILDING_RESCUE then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		local isCrossbow = id == E_WeaponBaseID.TF_WEAPON_CROSSBOW
		info.offset.x = 23.5
		info.offset.y = 12
		info.offset.z = -3
		info.hull.x = isCrossbow and 3 or 1
		info.hull.y = isCrossbow and 3 or 1
		info.hull.z = isCrossbow and 3 or 1
		info.speed = 2400
		info.gravity = gravity * 0.2
		info.lifetime = 10

		return info
	end

	if id == TF_WEAPON_SYRINGEGUN_MEDIC then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.x = 16
		info.offset.y = 6
		info.offset.z = -8
		info.hull.x = 1
		info.hull.y = 1
		info.hull.z = 1
		info.speed = 1000
		info.gravity = 0.3 * gravity

		return info
	end

	if id == TF_WEAPON_FLAMETHROWER then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		local _, flhull = client.GetConVar("tf_flamethrower_boxsize")
		info.offset.x = 40
		info.offset.y = 5
		info.offset.z = 0
		info.hull.x = flhull
		info.hull.y = flhull
		info.hull.z = flhull
		info.speed = 1000
		info.lifetime = 0.285

		return info
	end

	if id == TF_WEAPON_FLAME_BALL then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.x = 3
		info.offset.y = 7
		info.offset.z = -9
		info.hull.x = 1
		info.hull.y = 1
		info.hull.z = 1
		info.speed = 3000
		info.lifetime = 0.18
		info.gravity = 0

		return info
	end

	if id == TF_WEAPON_CLEAVER then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.x = 16
		info.offset.y = 8
		info.offset.z = -6
		info.hull.x = 1
		info.hull.y = 1
		info.hull.z = 10
		info.speed = 3000
		info.gravity = 1
		info.lifetime = 2.2

		return info
	end

	if id == TF_WEAPON_BAT_WOOD
	or id == TF_WEAPON_BAT_GIFTWRAP then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		local _, tf_scout_stunball_base_speed = client.GetConVar("tf_scout_stunball_base_speed")
		info.speed = tf_scout_stunball_base_speed
		info.gravity = 1
		info.simple_trace = false
		info.lifetime = gravity

		return info
	end

	if id == TF_WEAPON_JAR
	or id == TF_WEAPON_JAR_MILK then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.x = 16
		info.offset.y = 8
		info.offset.z = -6
		info.speed = 1000
		info.gravity = 1
		info.lifetime = 2.2
		info.hull.x = 3
		info.hull.y = 3
		info.hull.z = 3
		info.simple_trace = false
		return info
	end

	if id == TF_WEAPON_JAR_GAS then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.x = 16
		info.offset.y = 8
		info.offset.z = -6
		info.speed = 2000
		info.gravity = 1
		info.lifetime = 2.2
		info.hull.x = 3
		info.hull.y = 3
		info.hull.z = 3
		info.simple_trace = false
		return info
	end

	if id == TF_WEAPON_LUNCHBOX then
		local info = ProjectileInfo_t.New(nil, 0, 0, 0, 0, 60, Vector3(6, 6, 6), false)
		info.offset.z = -8
		info.hull.x = 17
		info.hull.y = 17
		info.hull.z = 7
		info.speed = 500
		info.gravity = 1 * gravity
		info.simple_trace = false
	end

	return nil
end

return Weapon