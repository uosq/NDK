local BaseClass = require("src.wrappers.basewrapper")

---@class CBaseObject: BaseWrapper
---@field protected __index CBaseObject
local CBaseObject = {}
CBaseObject.__index = CBaseObject
setmetatable(CBaseObject, {__index = BaseClass})

function CBaseObject:IsSentry()
	return self.__handle:GetClass() == "CObjectSentrygun"
end

function CBaseObject:IsDispenser()
	return self.__handle:GetClass() == "CObjectDispenser"
end

function CBaseObject:IsTeleporter()
	return self.__handle:GetClass() == "CObjectTeleporter"
end

function CBaseObject:IsAlive()
	return self.__handle:GetHealth() > 0
end

function CBaseObject:m_iHealth()
	return self.__handle:GetPropInt("m_iHealth")
end

function CBaseObject:m_iMaxHealth()
	return self.__handle:GetPropInt("m_iMaxHealth")
end

function CBaseObject:m_bHasSapper()
	return self.__handle:GetPropBool("m_bHasSapper")
end

function CBaseObject:m_iObjectType()
	return self.__handle:GetPropInt("m_iObjectType")
end

function CBaseObject:m_bBuilding()
	return self.__handle:GetPropBool("m_bBuilding")
end

function CBaseObject:m_bPlacing()
	return self.__handle:GetPropBool("m_bPlacing")
end

function CBaseObject:m_bCarried()
	return self.__handle:GetPropBool("m_bCarried")
end

function CBaseObject:m_bCarryDeploy()
	return self.__handle:GetPropBool("m_bCarryDeploy")
end

function CBaseObject:m_bMiniBuilding()
	return self.__handle:GetPropBool("m_bMiniBuilding")
end

function CBaseObject:m_flPercentageConstructed()
	return self.__handle:GetPropFloat("m_flPercentageConstructed")
end

function CBaseObject:m_fObjectFlags()
	return self.__handle:GetPropInt("m_fObjectFlags")
end

function CBaseObject:m_hBuiltOnEntity()
	return self.__handle:GetPropEntity("m_hBuiltOnEntity")
end

function CBaseObject:m_bDisabled()
	return self.__handle:GetPropBool("m_bDisabled")
end

function CBaseObject:m_hBuilder()
	return self.__handle:GetPropEntity("m_hBuilder")
end

function CBaseObject:m_vecBuildMaxs()
	return self.__handle:GetPropVector("m_vecBuildMaxs")
end

function CBaseObject:m_vecBuildMins()
	return self.__handle:GetPropVector("m_vecBuildMins")
end

function CBaseObject:m_iDesiredBuildRotations()
	return self.__handle:GetPropInt("m_iDesiredBuildRotations")
end

function CBaseObject:m_bServerOverridePlacement()
	return self.__handle:GetPropBool("m_bServerOverridePlacement")
end

function CBaseObject:m_iUpgradeLevel()
	return self.__handle:GetPropInt("m_iUpgradeLevel")
end

function CBaseObject:m_iUpgradeMetal()
	return self.__handle:GetPropInt("m_iUpgradeMetal")
end

function CBaseObject:m_iUpgradeMetalRequired()
	return self.__handle:GetPropInt("m_iUpgradeMetalRequired")
end

function CBaseObject:m_iHighestUpgradeLevel()
	return self.__handle:GetPropInt("m_iHighestUpgradeLevel")
end

function CBaseObject:m_iObjectMode()
	return self.__handle:GetPropInt("m_iObjectMode")
end

function CBaseObject:m_bDisposableBuilding()
	return self.__handle:GetPropBool("m_bDisposableBuilding")
end

function CBaseObject:m_bWasMapPlaced()
	return self.__handle:GetPropBool("m_bWasMapPlaced")
end

function CBaseObject:m_bPlasmaDisable()
	return self.__handle:GetPropBool("m_bPlasmaDisable")
end

return CBaseObject