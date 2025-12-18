local lib = {}

---@type CVar[]
local cvars = {}

---@class CVar
---@field value string
local cvar_t = {
	value = "0",
}

cvar_t.__index = cvar_t

--- Returns the type of its only argument, coded as a string.
---@return "AttributeDefinition" | "BitBuffer" | "DrawModelContext" | "Entity" | "EulerAngles" | "EventInfo" | "GameEvent" | "GameServerLobby" | "Item" | "ItemDefinition" | "LobbyPlayer" | "MatchGroup" | "MatchMapDefinition" | "Material" | "Model" | "NetChannel" | "NetMessage" | "PartyMemberActivity" | "PhysicsCollisionModel" | "PhysicsEnvironment" | "PhysicsObject" | "PhysicsObjectParameters" | "PhysicsSolid" | "StaticPropRenderInfo" | "StringCmd" | "StudioBBox" | "StudioHitboxSet" | "StudioModelHeader" | "TempEntity" | "Texture" | "Trace" | "UserCmd" | "UserMessage" | "Vector3" | "ViewSetup" | "WeaponData
local function typeof(v)
	return tostring(getmetatable(v).__name)
end

---@param defaultValue string|number
function cvar_t.New(defaultValue)
	assert(type(defaultValue), "ConVar value must not be nil!")
	return setmetatable({value = defaultValue}, cvar_t)
end

function cvar_t:GetString()
	return tostring(self.value)
end

function cvar_t:GetNumber()
	return tonumber(self.value)
end

---@return string[]
function cvar_t:GetTable()
	local list = {}
	for word in string.gmatch(self:GetString(), "%S+") do
		list[#list+1] = word
	end
	return list
end

function cvar_t:GetVector3()
	local list = self:GetTable()
	local x, y, z = 0, 0, 0

	if #list == 3 then
		x, y, z = tonumber(list[1]) or 0, tonumber(list[2]) or 0, tonumber(list[3]) or 0
	end

	return Vector3(x or 0, y or 0, z or 0)
end

---@param value string
function cvar_t:SetValue(value)
	self.value = value
end

---@param str StringCmd
local function OnSendStringCmd(str)
	local text = str:Get()
	if #text == 0 then
		return
	end

	local words = {}
	for word in string.gmatch(text, "%S+") do
		words[#words+1] = word
	end

	if #words == 0 then
		return
	end

	local cvarName = words[0]
	if cvars[cvarName] == nil then
		return
	end

	table.remove(words, 1)
	if #words == 0 then
		--- I have to check again
		--- As we might be doing something like:
		--- "helloworld" and no other argument
		--- which defeats the purpose of a cvar
		--- then it would be a command
		return
	end

	local cvar = cvars[cvarName]

	if #words == 1 then
		cvar:SetValue(words[1])
	else
		cvar:SetValue(table.concat(words, " "))
	end

	str:Set(string.format("Changed ConVar %s to %s", cvarName, cvar:GetString()))
end

--- Registers and initializes the cvar manager \
--- Without calling this, the SDK does not automatically manage the convars \
--- And trying to set their values from the console won't work
---@return boolean success
function lib:Init()
	return callbacks.Register("SendStringCmd", OnSendStringCmd)
end

---@param name string
---@param defaultValue number|string|Vector3
---@return boolean success
function lib:RegisterConVar(name, defaultValue)
	assert(type(name) == "string", "Trying to register a cvar with the wrong type of name!")
	assert(type(defaultValue) == "string" or type(defaultValue) == "number" or typeof(defaultValue) == "Vector3", "The default value must be a string or number!")

	--- sanitize our stuff
	if type(defaultValue) == "number" then
		defaultValue = tostring(defaultValue)
	end

	if typeof(defaultValue) == "Vector3" then
		defaultValue = string.format("%s %s %s", defaultValue.x, defaultValue.y, defaultValue.z)
	end

	--- lsp hacks
	---@cast defaultValue string

	if cvars[name] == nil then
		cvars[name] = cvar_t.New(defaultValue)
		return true
	end

	return false
end

---Gets a convar managed by the SDK \
---Does NOT get values from TF2's convars!
---@param name string
---@return CVar ConVar
function lib:GetConVar(name)
	assert(type(name) == "string", "name must be a string!")
	return cvars[name]
end

---Sets the value of a convar managed by the SDK \
---Does NOT set values for TF2's convars!
---@param name string
---@param newValue string|number|Vector3
function lib:SetConVar(name, newValue)
	assert(type(name) == "string", "name must be a string!")
	assert(type(newValue) == "string" or type(newValue) == "number" or typeof(newValue) == "Vector3", "New ConVar value must be a number or string!")

	if type(newValue) == "number" then
		newValue = tostring(newValue)
	end

	if typeof(newValue) == "Vector3" then
		newValue = string.format("%s %s %s", newValue.x, newValue.y, newValue.z)
	end

	--- another lsp hack
	---@cast newValue string

	local cvar = cvars[name]
	assert(cvar, string.format("ConVar %s doesn't exist!", name))

	cvar:SetValue(newValue)
end

return lib