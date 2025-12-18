local lib = {}

---@param vec Vector3
---@return number
function lib.NormalizeVector(vec)
	local len = vec:Length()
	if len < 0.0001 then
		return 0
	end

	vec.x = vec.x / len
	vec.y = vec.y / len
	vec.z = vec.z / len

	return len
end

---@param a Vector3
---@param b Vector3
---@return number
function lib.Fov(a, b)
	return math.acos(a:Dot(b)) * (180 / math.pi)
end

function lib.DirectionToAngles(direction)
    local pitch = math.asin(-direction.z) * (180 / math.pi)
    local yaw = math.atan(direction.y, direction.x) * (180 / math.pi)
    return Vector3(pitch, yaw, 0)
end

---@param p0 Vector3 -- start position
---@param p1 Vector3 -- target position
---@param speed number -- projectile speed
---@param gravity number -- gravity constant
---@return Vector3? -- Returns the angle and the apex of the trajectory
function lib.SolveBallisticArc(p0, p1, speed, gravity)
	local diff = p1 - p0
	local dx = diff:Length2D()
	local dy = diff.z
	local speed2 = speed * speed
	local g = gravity

	local root = speed2 * speed2 - g * (g * dx * dx + 2 * dy * speed2)
	if root < 0 then
		return nil -- no solution
	end

	local angle = math.atan((speed2 - math.sqrt(root)) / (g * dx)) -- low arc
	local yaw = (math.atan(diff.y, diff.x)) * (180 / math.pi)
	local pitch = -angle * (180 / math.pi)

	return Vector3(pitch, yaw, 0)
end

function lib.Lerp(a, b, t)
	return a + (b - a) * t;
end

function lib.Clamp(val, min, max)
	return math.min(max, math.max(val, min))
end

---@param val number
---@param a number
---@param b number
---@param c number
---@param d number
---@param clamp boolean? true
function lib.RemapVal(val, a, b, c, d, clamp)
	clamp = clamp == nil and true or clamp

	if a == b then
		return val >= b and d or c
	end

	local t = (val - a) / (b - a)
	if clamp then
		t = lib.Clamp(t, 0, 1)
	end

	return c + (d - c) * t
end

return lib