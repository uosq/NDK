local projectiles = {}

local env = physics.CreateEnvironment()
env:SetAirDensity(2.0)
env:SetGravity(Vector3(0, 0, -800))
env:SetSimulationTimestep(globals.TickInterval())

---@return PhysicsObject
local function GetPhysicsProjectile(info)
	local modelName = info.m_sModelName
	if projectiles[modelName] then
		return projectiles[modelName]
	end

	local solid, collision = physics.ParseModelByName(info.m_sModelName)
	if solid == nil or collision == nil then
		error("Solid/collision is nil! Model name: " .. info.m_sModelName)
		return {}
	end

	local projectile = env:CreatePolyObject(collision, solid:GetSurfacePropName(), solid:GetObjectParameters())
	projectiles[modelName] = projectile

	return projectiles[modelName]
end

--- source: https://developer.mozilla.org/en-US/docs/Games/Techniques/3D_collision_detection
---@param currentPos Vector3
---@param vecTargetPredictedPos Vector3
---@param weaponInfo WeaponInfo
---@param vecTargetMaxs Vector3
---@param vecTargetMins Vector3
local function IsIntersectingBB(currentPos, vecTargetPredictedPos, weaponInfo, vecTargetMaxs, vecTargetMins)
    local vecProjMins = weaponInfo.m_vecMins + currentPos
    local vecProjMaxs = weaponInfo.m_vecMaxs + currentPos

    local targetMins = vecTargetMins + vecTargetPredictedPos
    local targetMaxs = vecTargetMaxs + vecTargetPredictedPos

    -- check overlap on X, Y, and Z
    if vecProjMaxs.x < targetMins.x or vecProjMins.x > targetMaxs.x then return false end
    if vecProjMaxs.y < targetMins.y or vecProjMins.y > targetMaxs.y then return false end
    if vecProjMaxs.z < targetMins.z or vecProjMins.z > targetMaxs.z then return false end

    return true -- all axis overlap
end

---@param vStart Vector3
---@param vEnd Vector3
---@param mins Vector3
---@param maxs Vector3
local function TraceProjectileHull(vStart, vEnd, mins, maxs)
    return engine.TraceHull(vStart, vEnd, mins, maxs, MASK_VISIBLE | MASK_SHOT_HULL, function(ent)
        return true
    end)
end

---@param startPos Vector3
---@param launchAngle EulerAngles
---@param time_seconds number
---@param hull Vector3
---@param quick boolean # True means we don't simulate the path with full quality (default: true)
---@return Vector3[] Path, boolean Full
local function SimulateFakeProjectile(startPos, launchAngle, time_seconds, speed, gravity, hull, quick)
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

local function OnUnload()
	for _, obj in pairs (projectiles) do
		env:DestroyObject(obj)
	end

	physics.DestroyEnvironment(env)

	print("Physics environment destroyed!")
end


callbacks.Register("Unload", OnUnload)
return SimulateFakeProjectile