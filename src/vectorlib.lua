local lib = {}

--- Normalizes in place \
--- Returns the length
---@param vec Vector3
---@return number
function lib.Normalize(vec)
	local len = vec:Length()
	if len < 0.0001 then
		return 0
	end

	vec.x = vec.x / len
	vec.y = vec.y / len
	vec.z = vec.z / len

	return len
end

--- Normalizes the vector in places so you always get angles clamped to [-180, 180]
---@param vec Vector3
function lib.NormalizeAngle(vec)
	local x, y, z = vec:Unpack()

	if x > 180 then
		vec.x = x - 360
	end

	if x < -180 then
		vec.x = x + 360
	end

	if y > 180 then
		vec.y = y - 360
	end

	if y < -180 then
		vec.y = y + 360
	end

	if z > 180 then
		vec.z = z - 360
	end

	if z < -180 then
		vec.z = z + 360
	end
end

return lib