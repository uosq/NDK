local projectiles = {}

---@param vStart Vector3
---@param vEnd Vector3
---@param mins Vector3
---@param maxs Vector3
local function TraceProjectileHull(vStart, vEnd, mins, maxs)
    return engine.TraceHull(vStart, vEnd, mins, maxs, CONTENTS_GRATE | MASK_SHOT_HULL, function(ent)
        return true
    end)
end

---@param startPos Vector3
---@param launchAngle EulerAngles
---@param time_seconds number
---@param hull Vector3
---@param quick boolean # True means we don't simulate the path with full quality (default: true)
---@return Vector3[] Path, boolean Full
local function SimulateProjectile(startPos, launchAngle, time_seconds, speed, gravity, hull, quick)
	quick = quick == nil and true or quick

	local angForward = launchAngle:Forward()
	local tickInterval = globals.TickInterval() * (quick and 3 or 1)
	local startVelocity = angForward * speed
	local mins, maxs = -hull, hull
	local path = {}
	local simulatedFull = true
	local time = 0.0

	local currentPos = startPos
	local currentVel = startVelocity
	local gravity_to_add = Vector3(0, 0, -gravity * tickInterval)

	while time < time_seconds do
		local vStart = currentPos
		-- Apply gravity to velocity
		currentVel = currentVel + gravity_to_add
		local vEnd = currentPos + currentVel * tickInterval
		local trace = TraceProjectileHull(vStart, vEnd, mins, maxs)

		-- Add current position to path before checking collision
		path[#path+1] = Vector3(vEnd:Unpack())

		if trace.fraction < 1.0 then
			simulatedFull = false
			break
		end
			currentPos = vEnd
			time = time + tickInterval
		end

	return path, simulatedFull
end

return SimulateProjectile