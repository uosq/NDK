local BaseClass = require("src.wrappers.cbaseobject")

---@class CObjectSentrygun: CBaseObject
---@field protected __index CObjectSentrygun
local CObjectSentrygun = {}
CObjectSentrygun.__index = CObjectSentrygun
setmetatable(CObjectSentrygun, {__index = BaseClass})

function CObjectSentrygun:m_iAmmoShells()
	return self.__handle:GetPropInt("m_iAmmoShells")
end

function CObjectSentrygun:m_iAmmoRockets()
	return self.__handle:GetPropInt("m_iAmmoRockets")
end

function CObjectSentrygun:m_iState()
	return self.__handle:GetPropInt("m_iState")
end

function CObjectSentrygun:m_bPlayerControlled()
	return self.__handle:GetPropBool("m_bPlayerControlled")
end

function CObjectSentrygun:m_nShieldLevel()
	return self.__handle:GetPropInt("m_nShieldLevel")
end

function CObjectSentrygun:m_bShielded()
	return self.__handle:GetPropBool("m_bShielded")
end

function CObjectSentrygun:m_hEnemy()
	return self.__handle:GetPropEntity("m_hEnemy")
end

function CObjectSentrygun:m_hAutoAimTarget()
	return self.__handle:GetPropEntity("m_hAutoAimTarget")
end

function CObjectSentrygun:m_iKills()
	return self.__handle:GetPropInt("SentrygunLocalData", "m_iKills")
end

function CObjectSentrygun:m_iAssists()
	return self.__handle:GetPropInt("SentrygunLocalData", "m_iAssists")
end

return CObjectSentrygun