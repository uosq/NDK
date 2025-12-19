--[[
Example

UnlitGeneric
{
	$basetexture "white"
	$phongtint "[1 1 1]"
}

]]

---@class KeyValue
---@field private __index KeyValue
---@field private _vals table<string, string>
---@field private _name string
local KeyValue = {
	_name = "",
	_vals = {}
}
KeyValue.__index = KeyValue

---@param name string
function KeyValue.New(name)
	assert(type(name) == "string", "KeyValue name must be a string!")
	return setmetatable({_name = name}, {__index = KeyValue})
end

--- Returns the type of its only argument, coded as a string.
---@return "AttributeDefinition" | "BitBuffer" | "DrawModelContext" | "Entity" | "EulerAngles" | "EventInfo" | "GameEvent" | "GameServerLobby" | "Item" | "ItemDefinition" | "LobbyPlayer" | "MatchGroup" | "MatchMapDefinition" | "Material" | "Model" | "NetChannel" | "NetMessage" | "PartyMemberActivity" | "PhysicsCollisionModel" | "PhysicsEnvironment" | "PhysicsObject" | "PhysicsObjectParameters" | "PhysicsSolid" | "StaticPropRenderInfo" | "StringCmd" | "StudioBBox" | "StudioHitboxSet" | "StudioModelHeader" | "TempEntity" | "Texture" | "Trace" | "UserCmd" | "UserMessage" | "Vector3" | "ViewSetup" | "WeaponData
local function typeof(v)
	return getmetatable(v).__name
end

---@param name string
---@param value string|number|integer|table|Vector3
function KeyValue:SetParam(name, value)
	assert(type(name) == "string", "Param name must be a string!")
	assert(type(value) == "number" or type(value) == "string" or type(value) == "table" or typeof(value) == "Vector3")

	local t = type(value)
	if t == "number" then
		value = tostring(value)
	end

	if t == "table" then
		--- example: [1 1 1]
		value = "[" .. table.concat(value, " ") .. "]"
	end

	if typeof(value) == "Vector3" then
		value = string.format("[%s %s %s]", value.x, value.y, value.z)
	end

	---@cast value string

	if name:sub(1, 1) ~= "$" then
		name = "$" .. name
	end

	self._vals[name] = value
end

---@param name string
---@return string?
function KeyValue:GetParam(name)
	return self._vals[name]
end

---@return string?
function KeyValue:ToVMT()
	if type(self._name) ~= "string" then
		return nil
	end

	if #self._vals == 0 then
		return nil
	end

	--- UnlitGeneric \n { \n
	local vmt = self._name .. "\n" .. "{\n"

	for key, value in pairs (self._vals) do
		---	$basetexture "white"
		vmt = vmt .. "\t" .. key .. "\"" .. value .. "\"\n"
	end

	return vmt .. "}"
end

return KeyValue