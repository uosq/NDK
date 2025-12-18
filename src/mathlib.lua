local lib = {}

local RAD2DEG = 180/math.pi

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

---@param from Vector3
---@param to Vector3
---@param clamp boolean # When true, clamps the angle (default: true)
function lib.CalcAngle(from, to, clamp)
	clamp = clamp == nil and true or clamp

	local delta = from - to
	local hyp = math.sqrt(delta.x^2 + delta.y^2)

	local angle = Vector3(
		math.atan(delta.z/hyp) * RAD2DEG,
		math.atan(delta.y / delta.x) * RAD2DEG,
		0
	)

	--- this is stupid
	if clamp == true then
		angle = Vector3(vector.AngleNormalize(angle):Unpack())
	end

	return angle
end

---@param a EulerAngles
---@param b EulerAngles
---@return number
function lib.CalcFov(a, b)
	local aForward, bForward
	aForward = a:Forward()
	bForward = b:Forward()
	return math.acos(aForward:Dot(bForward)) * RAD2DEG
end

function lib.DirectionToAngles(direction)
    local pitch = math.asin(-direction.z) * RAD2DEG
    local yaw = math.atan(direction.y, direction.x) * RAD2DEG
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
	local yaw = (math.atan(diff.y, diff.x)) * RAD2DEG
	local pitch = -angle * RAD2DEG

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