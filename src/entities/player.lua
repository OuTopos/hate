local hate = require("lib.hate")

local function new(world, x, y, z)
	local self = {}

	self.x = x
	self.y = y
	self.z = z



	local img = love.graphics.newImage("assets/barrel.png")

	local sentity = world.scene.newChild()
	sentity.drawable = img



	
	function self.update(dt)
		sentity.x = self.x
		sentity.y = self.y

	end

	return self
end

return {
	new = new
}