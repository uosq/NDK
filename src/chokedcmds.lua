local lib = {}
local choked = 0

function lib.GetChoked()
	return choked
end

function lib.SetChoked(value)
	choked = value
end

function lib.AddChoked()
	choked = choked + 1
end

function lib.ResetChoked()
	choked = 0
end

return lib