---@class BasePlayer
---@field private __index BasePlayer
---@field private __handle Entity
local BasePlayer = {}
BasePlayer.__index = BasePlayer

---@param entity Entity?
---@return BasePlayer?
function BasePlayer.Get(entity)
	if entity == nil then
		return nil
	end

	return setmetatable({__handle = entity}, BasePlayer)
end

function BasePlayer:m_iFOV()
	return self.__handle:GetPropInt("m_iFOV")
end

function BasePlayer:m_iFOVStart()
	return self.__handle:GetPropInt("m_iFOVStart")
end

function BasePlayer:m_flFOVTime()
	return self.__handle:GetPropFloat("m_flFOVTime")
end

function BasePlayer:m_iDefaultFOV()
	return self.__handle:GetPropInt("m_iDefaultFOV")
end

function BasePlayer:m_hZoomOwner()
	return self.__handle:GetPropEntity("m_hZoomOwner")
end

function BasePlayer:m_hVehicle()
	return self.__handle:GetPropEntity("m_hVehicle")
end

function BasePlayer:m_hUseEntity()
	return self.__handle:GetPropEntity("m_hUseEntity")
end

function BasePlayer:m_iHealth()
	return self.__handle:GetPropInt("m_iHealth")
end

function BasePlayer:m_lifeState()
	return self.__handle:GetPropInt("m_lifeState")
end

function BasePlayer:m_iBonusProgress()
	return self.__handle:GetPropInt("m_iBonusProgress")
end

function BasePlayer:m_iBonusChallenge()
	return self.__handle:GetPropInt("m_iBonusChallenge")
end

function BasePlayer:m_flMaxspeed()
	return self.__handle:GetPropFloat("m_flMaxspeed")
end

function BasePlayer:m_fFlags()
	return self.__handle:GetPropInt("m_fFlags")
end

function BasePlayer:m_iObserverMode()
	return self.__handle:GetPropInt("m_iObserverMode")
end

function BasePlayer:m_hObserverTarget()
	return self.__handle:GetPropEntity("m_hObserverTarget")
end

function BasePlayer:m_hViewModel()
	return self.__handle:GetPropEntity("m_hViewModel[0]")
end

function BasePlayer:m_szLastPlaceName()
	return self.__handle:GetPropInt("m_szLastPlaceName")
end

function BasePlayer:m_vecViewOffset()
	return self.__handle:GetPropVector("localdata", "m_vecViewOffset[0]")
end

function BasePlayer:m_flFriction()
	return self.__handle:GetPropFloat("localdata", "m_flFriction")
end

function BasePlayer:m_iAmmo()
	return self.__handle:GetPropDataTableInt("localdata", "m_iAmmo")
end

function BasePlayer:m_fOnTarget()
	return self.__handle:GetPropInt("localdata", "m_fOnTarget")
end

function BasePlayer:m_nTickBase()
	return self.__handle:GetPropInt("localdata", "m_nTickBase")
end

function BasePlayer:m_nNextThinkTick()
	return self.__handle:GetPropInt("localdata", "m_nNextThinkTick")
end

function BasePlayer:m_hLastWeapon()
	return self.__handle:GetPropEntity("localdata", "m_hLastWeapon")
end

function BasePlayer:m_hGroundEntity()
	return self.__handle:GetPropEntity("localdata", "m_hGroundEntity")
end

function BasePlayer:m_vecVelocity()
	return self.__handle:GetPropVector("localdata", "m_vecVelocity[0]")
end

function BasePlayer:m_vecBaseVelocity()
	return self.__handle:GetPropVector("localdata", "m_vecBaseVelocity")
end

function BasePlayer:m_hConstraintEntity()
	return self.__handle:GetPropEntity("localdata", "m_hConstraintEntity")
end

function BasePlayer:m_vecConstraintCenter()
	return self.__handle:GetPropVector("localdata", "m_vecConstraintCenter")
end

function BasePlayer:m_flConstraintRadius()
	return self.__handle:GetPropFloat("localdata", "m_flConstraintRadius")
end

function BasePlayer:m_flConstraintWidth()
	return self.__handle:GetPropFloat("localdata", "m_flConstraintWidth")
end

function BasePlayer:m_flConstraintSpeedFactor()
	return self.__handle:GetPropFloat("localdata", "m_flConstraintSpeedFactor")
end

function BasePlayer:m_flDeathTime()
	return self.__handle:GetPropFloat("localdata", "m_flDeathTime")
end

function BasePlayer:m_nWaterLevel()
	return self.__handle:GetPropInt("localdata", "m_nWaterLevel")
end

function BasePlayer:m_flLaggedMovementValue()
	return self.__handle:GetPropFloat("localdata", "m_flLaggedMovementValue")
end

--- Im not sure if this is as integer
function BasePlayer:m_chAreaBits()
	return self.__handle:GetPropDataTableInt("localdata", "m_Local", "m_chAreaBits")
end

--- Im not sure if this is as integer
function BasePlayer:m_chAreaPortalBits()
	return self.__handle:GetPropDataTableInt("localdata", "m_Local", "m_chAreaPortalBits")
end

function BasePlayer:m_iHideHUD()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_iHideHUD")
end

function BasePlayer:m_flFOVRate()
	return self.__handle:GetPropFloat("localdata", "m_Local", "m_flFOVRate")
end

function BasePlayer:m_bDucked()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_bDucked")
end

function BasePlayer:m_bDucking()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_bDucking")
end

function BasePlayer:m_bInDuckJump()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_bInDuckJump")
end

function BasePlayer:m_flDucktime()
	return self.__handle:GetPropFloat("localdata", "m_Local", "m_flDucktime")
end

function BasePlayer:m_flDuckJumpTime()
	return self.__handle:GetPropFloat("localdata", "m_Local", "m_flDuckJumpTime")
end

function BasePlayer:m_flJumpTime()
	return self.__handle:GetPropFloat("localdata", "m_Local", "m_flJumpTime")
end

function BasePlayer:m_flFallVelocity()
	return self.__handle:GetPropFloat("localdata", "m_Local", "m_flFallVelocity")
end

function BasePlayer:m_vecPunchAngle()
	return self.__handle:GetPropVector("localdata", "m_Local", "m_vecPunchAngle")
end

function BasePlayer:m_vecPunchAngleVel()
	return self.__handle:GetPropVector("localdata", "m_Local", "m_vecPunchAngleVel")
end

function BasePlayer:m_bDrawViewmodel()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_bDrawViewmodel")
end

function BasePlayer:m_bWearingSuit()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_bWearingSuit")
end

function BasePlayer:m_bPoisoned()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_bPoisoned")
end

function BasePlayer:m_bForceLocalPlayerDraw()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_bForceLocalPlayerDraw")
end

function BasePlayer:m_flStepSize()
	return self.__handle:GetPropFloat("localdata", "m_Local", "m_flStepSize")
end

function BasePlayer:m_bAllowAutoMovement()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_bAllowAutoMovement")
end

function BasePlayer:m_skybox3d_scale()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_skybox3d.scale")
end

function BasePlayer:m_skybox3d_origin()
	return self.__handle:GetPropVector("localdata", "m_Local", "m_skybox3d.origin")
end

function BasePlayer:m_skybox3d_area()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_skybox3d.area")
end

function BasePlayer:m_skybox3d_fog_enable()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_skybox3d.fog.enable")
end

function BasePlayer:m_skybox3d_fog_blend()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_skybox3d.fog.blend")
end

function BasePlayer:m_skybox3d_fog_dirPrimary()
	return self.__handle:GetPropVector("localdata", "m_Local", "m_skybox3d.fog.dirPrimary")
end

function BasePlayer:m_skybox3d_fog_colorPrimary()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_skybox3d.fog.colorPrimary")
end

function BasePlayer:m_skybox3d_fog_colorSecondary()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_skybox3d.fog.colorSecondary")
end

function BasePlayer:m_skybox3d_fog_start()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_skybox3d.fog.start")
end

function BasePlayer:m_skybox3d_fog_end()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_skybox3d.fog.end")
end

function BasePlayer:m_skybox3d_fog_maxdensity()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_skybox3d.fog.maxdensity")
end

function BasePlayer:m_PlayerFog_m_hCtrl()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_PlayerFog.m_hCtrl")
end

function BasePlayer:m_audio_soundscapeIndex()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_audio.soundscapeIndex")
end

function BasePlayer:m_audio_localBits()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_audio.localBits")
end

function BasePlayer:m_audio_entIndex()
	return self.__handle:GetPropInt("localdata", "m_Local", "m_audio.entIndex")
end

function BasePlayer:m_szScriptOverlayMaterial()
	return self.__handle:GetPropString("localdata", "m_Local", "m_szScriptOverlayMaterial")
end

function BasePlayer:lengthprop20()
	return self.__handle:GetPropInt("m_AttributeList", "m_Attributes", "lengthproxy", "lengthprop20")
end

function BasePlayer:deadflag()
	return self.__handle:GetPropInt("pl", "deadflag")
end

return BasePlayer