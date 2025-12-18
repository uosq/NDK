local BaseClass = require("src.wrappers.basewrapper")

---@class Player: BaseWrapper
---@field protected __index Player
local Player = {}
Player.__index = Player
setmetatable(Player, {__index = BaseClass})

---@param entity Entity?
---@return Player?
function Player.Get(entity)
	if entity == nil then
		return nil
	end

	return setmetatable({__handle = entity}, Player)
end

---@param boneIndex BoneIndex
---@return Vector3?
function Player:GetBonePosition(boneIndex)
	local model = self.__handle:GetModel()
	local studioHdr = models.GetStudioModel(model)
	local myHitBoxSet = self.__handle:GetPropInt("m_nHitboxSet")
	local hitboxSet = studioHdr:GetHitboxSet(myHitBoxSet)
	local hitboxes = hitboxSet:GetHitboxes()
	local hitbox = hitboxes[boneIndex]
	local bone = hitbox:GetBone()

	local boneMatrices = self.__handle:SetupBones()
	local boneMatrix = boneMatrices[bone]
	if boneMatrix == nil then
		return nil
	end

	return Vector3(boneMatrix[1][4], boneMatrix[2][4], boneMatrix[3][4])
end

function Player:m_iDefaultFOV()
	return self.__handle:GetPropInt("m_iDefaultFOV")
end

function Player:IsAlive()
	return self.__handle:IsAlive()
end

function Player:IsDormant()
	return self.__handle:IsDormant()
end

function Player:m_bDucking()
	return self.__handle:GetPropBool("m_bDucking")
end

function Player:GetMins()
	return self.__handle:GetMins()
end

function Player:GetMaxs()
	return self.__handle:GetMaxs()
end

---@param flags DrawFlags
function Player:DrawModel(flags)
	self.__handle:DrawModel(flags)
end

function Player:GetModelName()
	return models.GetModelName(self.__handle:GetModel())
end

---@param condition E_TFCOND
function Player:InCond(condition)
	return self.__handle:InCond(condition)
end

function Player:GetTeamNumber()
	return self.__handle:GetTeamNumber()
end

function Player:GetIndex()
	return self.__handle:GetIndex()
end

function Player:m_hActiveWeapon()
	return self.__handle:GetPropEntity("m_hActiveWeapon")
end

function Player:m_flNextAttack()
	return self.__handle:GetPropFloat("bcc_localdata", "m_flNextAttack")
end

function Player:m_nTickBase()
	return self.__handle:GetPropInt("m_nTickBase")
end

function Player:GetHealth()
	return self.__handle:GetHealth()
end

function Player:GetMaxUberHealth()
	return self.__handle:GetMaxBuffedHealth()
end

function Player:GetEyePosOffset()
	return self.__handle:GetPropVector("localdata", "m_vecViewOffset[0]")
end

---@param iAmmoIndex integer
function Player:GetAmmoCount(iAmmoIndex)
	if iAmmoIndex == -1 then
		return 0
	end

	return self.__handle:GetPropDataTableInt("m_iAmmo")[iAmmoIndex]
end

function Player:GetWorldSpaceCenter()
	local mins = self.__handle:GetMins()
	local maxs = self.__handle:GetMaxs()
	local origin = self.__handle:GetAbsOrigin()
	return origin + (mins + maxs) * 0.5
end

function Player:GetAbsOrigin()
	return self.__handle:GetAbsOrigin()
end

function Player:GetVAngle()
	return self.__handle:GetVAngles()
end

---@param vecAngle Vector3
function Player:SetVAngle(vecAngle)
	self.__handle:SetVAngles(vecAngle)
end

function Player:GetEyePos()
	return self.__handle:GetAbsOrigin() + self.__handle:GetPropVector("localdata", "m_vecViewOffset[0]")
end

function Player:GetHandle()
	return self.__handle
end

function Player:m_bIsABot()
	return self.__handle:GetPropBool("m_bIsABot")
end

function Player:m_bIsMiniBoss()
	return self.__handle:GetPropBool("m_bIsMiniBoss")
end

function Player:m_nWaterLevel()
	return self.__handle:GetPropInt("m_nWaterLevel")
end

function Player:m_nBotSkill()
	return self.__handle:GetPropInt("m_nBotSkill")
end

function Player:m_hRagdoll()
	return self.__handle:GetPropEntity("m_hRagdoll")
end

function Player:m_iClass()
	return self.__handle:GetPropInt("m_PlayerClass", "m_iClass")
end

function Player:m_iszClassIcon()
	return self.__handle:GetPropString("m_PlayerClass", "m_iszClassIcon")
end

function Player:m_iszCustomModel()
	return self.__handle:GetPropString("m_PlayerClass", "m_iszCustomModel")
end

function Player:m_vecCustomModelOffset()
	return self.__handle:GetPropVector("m_PlayerClass", "m_vecCustomModelOffset")
end

function Player:m_angCustomModelRotation()
	return self.__handle:GetPropVector("m_PlayerClass", "m_angCustomModelRotation")
end

function Player:m_bCustomModelRotates()
	return self.__handle:GetPropBool("m_PlayerClass", "m_bCustomModelRotates")
end

function Player:m_bCustomModelRotationSet()
	return self.__handle:GetPropBool("m_PlayerClass", "m_bCustomModelRotationSet")
end

function Player:m_bCustomModelVisibleToSelf()
	return self.__handle:GetPropBool("m_PlayerClass", "m_bCustomModelVisibleToSelf")
end

function Player:m_bUseClassAnimations()
	return self.__handle:GetPropBool("m_PlayerClass", "m_bUseClassAnimations")
end

function Player:m_iClassModelParity()
	return self.__handle:GetPropInt("m_PlayerClass", "m_iClassModelParity")
end

function Player:m_nNumHealers()
	return self.__handle:GetPropInt("m_Shared", "m_nNumHealers")
end

function Player:m_iCritMult()
	return self.__handle:GetPropInt("m_Shared", "m_iCritMult")
end

function Player:m_iAirDash()
	return self.__handle:GetPropInt("m_Shared", "m_iAirDash")
end

function Player:m_nAirDucked()
	return self.__handle:GetPropInt("m_Shared", "m_nAirDucked")
end

function Player:m_flDuckTimer()
	return self.__handle:GetPropFloat("m_Shared", "m_flDuckTimer")
end

function Player:m_nPlayerState()
	return self.__handle:GetPropInt("m_Shared", "m_nPlayerState")
end

function Player:m_iDesiredPlayerClass()
	return self.__handle:GetPropInt("m_Shared", "m_iDesiredPlayerClass")
end

function Player:m_flMovementStunTime()
	return self.__handle:GetPropFloat("m_Shared", "m_flMovementStunTime")
end

function Player:m_iMovementStunAmount()
	return self.__handle:GetPropInt("m_Shared", "m_iMovementStunAmount")
end

function Player:m_iMovementStunParity()
	return self.__handle:GetPropInt("m_Shared", "m_iMovementStunParity")
end

function Player:m_hStunner()
	return self.__handle:GetPropEntity("m_Shared", "m_hStunner")
end

function Player:m_iStunFlags()
	return self.__handle:GetPropInt("m_Shared", "m_iStunFlags")
end

function Player:m_nArenaNumChanges()
	return self.__handle:GetPropInt("m_Shared", "m_nArenaNumChanges")
end

function Player:m_bArenaFirstBloodBoost()
	return self.__handle:GetPropBool("m_Shared", "m_bArenaFirstBloodBoost")
end

function Player:m_iWeaponKnockbackID()
	return self.__handle:GetPropInt("m_Shared", "m_iWeaponKnockbackID")
end

function Player:m_bLoadoutUnavailable()
	return self.__handle:GetPropBool("m_Shared", "m_bLoadoutUnavailable")
end

function Player:m_iItemFindBonus()
	return self.__handle:GetPropInt("m_Shared", "m_iItemFindBonus")
end

function Player:m_bShieldEquipped()
	return self.__handle:GetPropBool("m_Shared", "m_bShieldEquipped")
end

function Player:m_bParachuteEquipped()
	return self.__handle:GetPropBool("m_Shared", "m_bParachuteEquipped")
end

function Player:m_iNextMeleeCrit()
	return self.__handle:GetPropInt("m_Shared", "m_iNextMeleeCrit")
end

function Player:m_iDecapitations()
	return self.__handle:GetPropInt("m_Shared", "m_iDecapitations")
end

function Player:m_iRevengeCrits()
	return self.__handle:GetPropInt("m_Shared", "m_iRevengeCrits")
end

function Player:m_iDisguiseBody()
	return self.__handle:GetPropInt("m_Shared", "m_iDisguiseBody")
end

function Player:m_hCarriedObject()
	return self.__handle:GetPropEntity("m_Shared", "m_hCarriedObject")
end

function Player:m_bCarryingObject()
	return self.__handle:GetPropBool("m_Shared", "m_bCarryingObject")
end

function Player:m_flNextNoiseMakerTime()
	return self.__handle:GetPropFloat("m_Shared", "m_flNextNoiseMakerTime")
end

function Player:m_iSpawnRoomTouchCount()
	return self.__handle:GetPropInt("m_Shared", "m_iSpawnRoomTouchCount")
end

function Player:m_iKillCountSinceLastDeploy()
	return self.__handle:GetPropInt("m_Shared", "m_iKillCountSinceLastDeploy")
end

function Player:m_flFirstPrimaryAttack()
	return self.__handle:GetPropFloat("m_Shared", "m_flFirstPrimaryAttack")
end

function Player:m_flEnergyDrinkMeter()
	return self.__handle:GetPropFloat("m_Shared", "m_flEnergyDrinkMeter")
end

function Player:m_flHypeMeter()
	return self.__handle:GetPropFloat("m_Shared", "m_flHypeMeter")
end

function Player:m_flChargeMeter()
	return self.__handle:GetPropFloat("m_Shared", "m_flChargeMeter")
end

function Player:m_flInvisChangeCompleteTime()
	return self.__handle:GetPropFloat("m_Shared", "m_flInvisChangeCompleteTime")
end

function Player:m_nDisguiseTeam()
	return self.__handle:GetPropInt("m_Shared", "m_nDisguiseTeam")
end

function Player:m_nDisguiseClass()
	return self.__handle:GetPropInt("m_Shared", "m_nDisguiseClass")
end

function Player:m_nDisguiseSkinOverride()
	return self.__handle:GetPropInt("m_Shared", "m_nDisguiseSkinOverride")
end

function Player:m_nMaskClass()
	return self.__handle:GetPropInt("m_Shared", "m_nMaskClass")
end

function Player:m_hDisguiseTarget()
	return self.__handle:GetPropEntity("m_Shared", "m_hDisguiseTarget")
end

function Player:m_iDisguiseHealth()
	return self.__handle:GetPropInt("m_Shared", "m_iDisguiseHealth")
end

function Player:m_bFeignDeathReady()
	return self.__handle:GetPropBool("m_Shared", "m_bFeignDeathReady")
end

function Player:m_hDisguiseWeapon()
	return self.__handle:GetPropEntity("m_Shared", "m_hDisguiseWeapon")
end

function Player:m_nTeamTeleporterUsed()
	return self.__handle:GetPropInt("m_Shared", "m_nTeamTeleporterUsed")
end

function Player:m_flCloakMeter()
	return self.__handle:GetPropFloat("m_Shared", "m_flCloakMeter")
end

function Player:m_flSpyTranqBuffDuration()
	return self.__handle:GetPropFloat("m_Shared", "m_flSpyTranqBuffDuration")
end

--- m_Shared, tfsharedlocaldata
function Player:m_nDesiredDisguiseTeam()
	return self.__handle:GetPropInt("m_Shared", "tfsharedlocaldata", "m_nDesiredDisguiseTeam")
end

function Player:m_nDesiredDisguiseClass()
	return self.__handle:GetPropInt("m_Shared", "tfsharedlocaldata", "m_nDesiredDisguiseClass")
end

function Player:m_flStealthNoAttackExpire()
	return self.__handle:GetPropFloat("m_Shared", "tfsharedlocaldata", "m_flStealthNoAttackExpire")
end

function Player:m_flStealthNextChangeTime()
	return self.__handle:GetPropFloat("m_Shared", "tfsharedlocaldata", "m_flStealthNextChangeTime")
end

function Player:m_bLastDisguisedAsOwnTeam()
	return self.__handle:GetPropBool("m_Shared", "tfsharedlocaldata", "m_bLastDisguisedAsOwnTeam")
end

function Player:m_flRageMeter()
	return self.__handle:GetPropFloat("m_Shared", "tfsharedlocaldata", "m_flRageMeter")
end

function Player:m_bRageDraining()
	return self.__handle:GetPropBool("m_Shared", "tfsharedlocaldata", "m_bRageDraining")
end

function Player:m_flNextRageEarnTime()
	return self.__handle:GetPropFloat("m_Shared", "tfsharedlocaldata", "m_flNextRageEarnTime")
end

function Player:m_bInUpgradeZone()
	return self.__handle:GetPropBool("m_Shared", "tfsharedlocaldata", "m_bInUpgradeZone")
end

function Player:m_flItemChargeMeter()
	return self.__handle:GetPropDataTableFloat("m_Shared", "tfsharedlocaldata", "m_flItemChargeMeter")
end

function Player:m_bPlayerDominated()
	return self.__handle:GetPropDataTableBool("m_Shared", "tfsharedlocaldata", "m_bPlayerDominated")
end

function Player:m_bPlayerDominatingMe()
	return self.__handle:GetPropDataTableBool("m_Shared", "tfsharedlocaldata", "m_bPlayerDominatingMe")
end

function Player:_condition_bits()
	return self.__handle:GetPropInt("m_ConditionList", "_condition_bits")
end

function Player:m_iTauntIndex()
	return self.__handle:GetPropInt("m_Shared", "m_iTauntIndex")
end

function Player:m_iTauntConcept()
	return self.__handle:GetPropInt("m_Shared", "m_iTauntConcept")
end

function Player:m_nPlayerCondEx()
	return self.__handle:GetPropInt("m_Shared", "m_nPlayerCondEx")
end

function Player:m_iStunIndex()
	return self.__handle:GetPropInt("m_Shared", "m_iStunIndex")
end

function Player:m_nHalloweenBombHeadStage()
	return self.__handle:GetPropInt("m_Shared", "m_nHalloweenBombHeadStage")
end

function Player:m_nPlayerCondEx2()
	return self.__handle:GetPropInt("m_Shared", "m_nPlayerCondEx2")
end

function Player:m_nPlayerCondEx3()
	return self.__handle:GetPropInt("m_Shared", "m_nPlayerCondEx3")
end

function Player:m_nStreaks()
	return self.__handle:GetPropInt("m_Shared", "m_nStreaks")
end

function Player:m_unTauntSourceItemID_Low()
	return self.__handle:GetPropInt("m_Shared", "m_unTauntSourceItemID_Low")
end

function Player:m_unTauntSourceItemID_High()
	return self.__handle:GetPropInt("m_Shared", "m_unTauntSourceItemID_High")
end

function Player:m_flRuneCharge()
	return self.__handle:GetPropFloat("m_Shared", "m_flRuneCharge")
end

function Player:m_bHasPasstimeBall()
	return self.__handle:GetPropInt("m_Shared", "m_bHasPasstimeBall")
end

function Player:m_bIsTargetedForPasstimePass()
	return self.__handle:GetPropInt("m_Shared", "m_bIsTargetedForPasstimePass")
end

function Player:m_hPasstimePassTarget()
	return self.__handle:GetPropEntity("m_Shared", "m_hPasstimePassTarget")
end

function Player:m_askForBallTime()
	return self.__handle:GetPropInt("m_Shared", "m_askForBallTime")
end

function Player:m_bKingRuneBuffActive()
	return self.__handle:GetPropInt("m_Shared", "m_bKingRuneBuffActive")
end

function Player:lengthprop131()
	return self.__handle:GetPropInt("m_Shared", "m_ConditionData", "lengthproxy", "lengthprop131")
end

function Player:m_nPlayerCondEx4()
	return self.__handle:GetPropInt("m_Shared", "m_nPlayerCondEx4")
end

function Player:m_flHolsterAnimTime()
	return self.__handle:GetPropFloat("m_Shared", "m_flHolsterAnimTime")
end

function Player:m_hSwitchTo()
	return self.__handle:GetPropEntity("m_Shared", "m_hSwitchTo")
end

function Player:m_hItem()
	return self.__handle:GetPropEntity("m_hItem")
end


function Player:m_vecOrigin()
	return self.__handle:GetPropVector("tflocaldata", "m_vecOrigin")
end

function Player:m_angEyeAngles()
	return self.__handle:GetPropVector("tflocaldata", "m_angEyeAngles[0]")
end

function Player:m_bIsCoaching()
	return self.__handle:GetPropBool("tflocaldata", "m_bIsCoaching")
end

function Player:m_hCoach()
	return self.__handle:GetPropEntity("tflocaldata", "m_hCoach")
end

function Player:m_hStudent()
	return self.__handle:GetPropEntity("tflocaldata", "m_hStudent")
end

function Player:m_nCurrency()
	return self.__handle:GetPropInt("tflocaldata", "m_nCurrency")
end

function Player:m_nExperienceLevel()
	return self.__handle:GetPropInt("tflocaldata", "m_nExperienceLevel")
end

function Player:m_nExperienceLevelProgress()
	return self.__handle:GetPropInt("tflocaldata", "m_nExperienceLevelProgress")
end

function Player:m_bMatchSafeToLeave()
	return self.__handle:GetPropBool("tflocaldata", "m_bMatchSafeToLeave")
end

function Player:m_bAllowMoveDuringTaunt()
	return self.__handle:GetPropBool("m_bAllowMoveDuringTaunt")
end

function Player:m_bIsReadyToHighFive()
	return self.__handle:GetPropBool("m_bIsReadyToHighFive")
end

function Player:m_hHighFivePartner()
	return self.__handle:GetPropEntity("m_hHighFivePartner")
end

function Player:m_nForceTauntCam()
	return self.__handle:GetPropInt("m_nForceTauntCam")
end

function Player:m_flTauntYaw()
	return self.__handle:GetPropFloat("m_flTauntYaw")
end

function Player:m_nActiveTauntSlot()
	return self.__handle:GetPropInt("m_nActiveTauntSlot")
end

function Player:m_iTauntItemDefIndex()
	return self.__handle:GetPropInt("m_iTauntItemDefIndex")
end

function Player:m_flCurrentTauntMoveSpeed()
	return self.__handle:GetPropFloat("m_flCurrentTauntMoveSpeed")
end

function Player:m_flVehicleReverseTime()
	return self.__handle:GetPropFloat("m_flVehicleReverseTime")
end

function Player:m_flMvMLastDamageTime()
	return self.__handle:GetPropFloat("m_flMvMLastDamageTime")
end

function Player:m_flLastDamageTime()
	return self.__handle:GetPropFloat("m_flLastDamageTime")
end

function Player:m_bInPowerPlay()
	return self.__handle:GetPropBool("m_bInPowerPlay")
end

function Player:m_iSpawnCounter()
	return self.__handle:GetPropInt("m_iSpawnCounter")
end

function Player:m_bArenaSpectator()
	return self.__handle:GetPropBool("m_bArenaSpectator")
end

function Player:m_hOuter()
	return self.__handle:GetPropEntity("m_AttributeManager", "m_hOuter")
end

function Player:m_ProviderType()
	return self.__handle:GetPropInt("m_AttributeManager", "m_ProviderType")
end

function Player:m_iReapplyProvisionParity()
	return self.__handle:GetPropInt("m_AttributeManager", "m_iReapplyProvisionParity")
end

function Player:m_flHeadScale()
	return self.__handle:GetPropFloat("m_flHeadScale")
end

function Player:m_flTorsoScale()
	return self.__handle:GetPropFloat("m_flTorsoScale")
end

function Player:m_flHandScale()
	return self.__handle:GetPropFloat("m_flHandScale")
end

function Player:m_bUseBossHealthBar()
	return self.__handle:GetPropBool("m_bUseBossHealthBar")
end

function Player:m_bUsingVRHeadset()
	return self.__handle:GetPropBool("m_bUsingVRHeadset")
end

function Player:m_bForcedSkin()
	return self.__handle:GetPropBool("m_bForcedSkin")
end

function Player:m_nForcedSkin()
	return self.__handle:GetPropInt("m_nForcedSkin")
end

function Player:m_bGlowEnabled()
	return self.__handle:GetPropBool("m_bGlowEnabled")
end

function Player:m_nActiveWpnClip()
	return self.__handle:GetPropInt("TFSendHealersDataTable", "m_nActiveWpnClip")
end

function Player:m_flKartNextAvailableBoost()
	return self.__handle:GetPropFloat("m_flKartNextAvailableBoost")
end

function Player:m_iKartHealth()
	return self.__handle:GetPropInt("m_iKartHealth")
end

function Player:m_iKartState()
	return self.__handle:GetPropInt("m_iKartState")
end

function Player:m_hGrapplingHookTarget()
	return self.__handle:GetPropEntity("m_hGrapplingHookTarget")
end

function Player:m_hSecondaryLastWeapon()
	return self.__handle:GetPropEntity("m_hSecondaryLastWeapon")
end

function Player:m_bUsingActionSlot()
	return self.__handle:GetPropInt("m_bUsingActionSlot")
end

function Player:m_flInspectTime()
	return self.__handle:GetPropFloat("m_flInspectTime")
end

function Player:m_flHelpmeButtonPressTime()
	return self.__handle:GetPropFloat("m_flHelpmeButtonPressTime")
end

function Player:m_iCampaignMedals()
	return self.__handle:GetPropInt("m_iCampaignMedals")
end

function Player:m_iPlayerSkinOverride()
	return self.__handle:GetPropInt("m_iPlayerSkinOverride")
end

function Player:m_bViewingCYOAPDA()
	return self.__handle:GetPropInt("m_bViewingCYOAPDA")
end

function Player:m_bRegenerating()
	return self.__handle:GetPropInt("m_bRegenerating")
end

return Player