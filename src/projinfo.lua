---@class ProjectileInfo
local ProjectileInfo = {
	speed = 0.0,
	gravity = 0.0,
	primetime = 0.0,
	damage_radius = 0.0,
	offset = Vector3(),
	simple_trace = false,
	lifetime = 60,
	hull = Vector3(6, 6, 6),
}
ProjectileInfo.__index = ProjectileInfo

---@param offset Vector3?
---@param speed number?
---@param gravity number?
---@param primetime number?
---@param damage_radius number?
---@param simple_trace boolean
---@param lifetime number?
---@param hull Vector3?
---@return ProjectileInfo
function ProjectileInfo.New(offset, speed, gravity, primetime, damage_radius, lifetime, hull, simple_trace)
	local new = setmetatable({}, {__index = ProjectileInfo})
	new.speed = speed or 0
	new.gravity = gravity or 0
	new.primetime = primetime or 0
	new.damage_radius = damage_radius or 0
	new.lifetime = lifetime or 60
	new.simple_trace = simple_trace
	new.offset = offset or Vector3()
	new.hull = hull or Vector3(6, 6, 6)
	return new
end

return ProjectileInfo