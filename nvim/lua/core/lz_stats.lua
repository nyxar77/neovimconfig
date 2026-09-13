local M = {
	loaded = 0,
	total = 0,
}

local initialized = false

local function instrument(spec)
	if type(spec) ~= "table" then
		return
	end

	if type(spec[1]) == "string" then
		M.total = M.total + 1
		local after = spec.after
		spec.after = function(...)
			M.loaded = M.loaded + 1
			if after then
				return after(...)
			end
		end
		return
	end

	for _, child in ipairs(spec) do
		instrument(child)
	end
end

function M.setup()
	if initialized then
		return
	end
	initialized = true

	local lz = require("lz.n")
	local load = lz.load
	lz.load = function(spec)
		instrument(spec)
		return load(spec)
	end
end

return M
