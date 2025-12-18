---@enum DrawFlags
local DrawFlags = {
	STUDIO_NONE = 0x00000000,
	STUDIO_RENDER = 0x00000001,
	STUDIO_VIEWXFORMATTACHMENTS = 0x00000002,
	STUDIO_DRAWTRANSLUCENTSUBMODELS = 0x00000004,
	STUDIO_TWOPASS = 0x00000008,
	STUDIO_STATIC_LIGHTING = 0x00000010,
	STUDIO_WIREFRAME = 0x00000020,
	STUDIO_ITEM_BLINK = 0x00000040,
	STUDIO_NOSHADOWS = 0x00000080,
	STUDIO_WIREFRAME_VCOLLIDE = 0x00000100,
	STUDIO_NO_OVERRIDE_FOR_ATTACH = 0x00000200,

	--- Not a studio flag, but used to flag when we want studio stats
	STUDIO_GENERATE_STATS = 0x01000000,

	--- Not a studio flag, but used to flag model as using shadow depth material override
	STUDIO_SSAODEPTHTEXTURE = 0x08000000,

	--- Not a studio flag, but used to flag model as using shadow depth material override
	STUDIO_SHADOWDEPTHTEXTURE = 0x40000000,

	--- Not a studio flag, but used to flag model as a non-sorting brush model
	STUDIO_TRANSPARENCY = 0x80000000,
}

return DrawFlags