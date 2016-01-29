local hate = require((...):match("(.+)%.[^%.]+$") .. ".table")

local function new(parent)
	local self = {}
	self.parent = parent
	self.children = {}

	self.sortchildren = true

	self.drawable = nil

	self.shader = nil


	-- entity.batch = {}
	-- entity.drawables = {}
	-- entity.shader = nil -- Should be default shader. Maybe.
	-- entity.samplers = {}
	-- self.depthmap = yama.assets.loadImage("colors/0.0.0")
	-- self.normalmap = yama.assets.loadImage("colors/127.127.255")
	self.x = 0
	self.y = 0
	self.z = 0
	self.r = 0
	self.sx = 1
	self.sy = 1
	self.ox = 0
	self.oy = 0
	self.kx = 0
	self.ky = 0

	self.width = 10
	self.height = 10

	function self.newChild()
		local child = new(self)
		if type(self.children) ~= "table" then
			self.children = {}
		end
		table.insert(self.children, child)
		return child
	end

	function self.getAbsolutes()
		local px, py = 0, 0
		if parent then
			px, py = parent.getAbsolutes()
		end
		return self.x + px, self.y + py
	end

	-- UPDATE
	function self.update(dt)
		self.updateEnv(dt)
	end

	return self
end

return {
	new = new,
}