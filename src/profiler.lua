---@class Profiler
local Profiler = {}

local font = draw.CreateFont("Arial", 12, 1000)
local active = {}
local results = {}
local interval = 0.5
local accum = 0.0

---@param name string
function Profiler:Start(name)
	active[name] = os.clock()
end

---@param name string
function Profiler:Stop(name)
	local start = active[name]
	if not start then
		return false
	end

	local dt = os.clock() - start
	results[name] = (results[name] or 0) + dt
	active[name] = nil
	return true
end

function Profiler:Reset()
	for k in pairs(results) do
		results[k] = nil
	end
end

function Profiler:Present()
	draw.SetFont(font)
	draw.Color(255, 255, 255, 255)

	local names = {}
	--- lua doesn't like to count keys
	local counter = 0

	for name in pairs(results) do
		names[#names + 1] = name
		counter = counter + 1
	end

	if counter == 0 then
		return
	end

	table.sort(names)

	for i = 1, #names do
		local name = names[i]
		draw.TextShadow(10, 12 * i, string.format("%s: %.6f ms", name, results[name] * 1000))
	end

	accum = accum + globals.AbsoluteFrameTime()
	if accum >= interval then
		accum = accum - interval
		self:Reset()
	end
end

return Profiler