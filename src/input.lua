local lib = {}

---Returns true when the key is down \
---Can be anything like "W" or "MOUSE_4" \
---Accepts both lower and upper case \
---Always returns true when `keystr` is "KEY_NONE"!
---@param keystr string
---@return boolean success
function lib.IsKeyDown(keystr)
	local upper = string.upper(keystr)

	--- early return as none means yes
	if upper == "KEY_NONE" then
		return true
	end

	if E_ButtonCode[upper] then
		local isdown = input.IsButtonDown(E_ButtonCode[upper])
		return isdown
	end

	local key = E_ButtonCode["KEY_" .. upper]

	if not key then
		key = E_ButtonCode[upper]
	end

	return key and input.IsButtonDown(key)
end

return lib