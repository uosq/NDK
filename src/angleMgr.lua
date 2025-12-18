local lib = {}
local angle = nil

function lib.SetAngle(ang)
	angle = ang
end

function lib.GetAngle()
	return angle
end

return lib