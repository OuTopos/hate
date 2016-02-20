local hate = require((...):match("(.+)%.[^%.]+$") .. ".table")

-- List of all the animations
local list = require(hate.paths.src .. "/animations")

local function new()
	local self = {}

	self.frame = 1
	self.finished = false
	self.timescale = 1

	self.time = 0
	self.animation = nil

	self.delay = 1
	self.first = 1
	self.last = 1
	self.loop = true
	self.finish = false
	self.reverse = false

	function self.set(animation, force, loop, finish, reverse)
		if not self.finish or self.finished or force then
			self.time = 0
			self.animation = list[animation]

			self.delay = self.animation.delay
			self.first = self.animation.first
			self.last = self.animation.last
			self.loop = loop or self.animation.loop
			self.finish = finish or self.animation.finish
			self.reverse = reverse or self.animation.reverse

			self.frame = self.first
			self.finished = false
		end
	end

	function self.update(dt, animation)
		if animation and list[animation] ~= self.animation then
			self.set(animation)
		end
		
		self.time = self.time + dt * self.timescale

		if self.time > self.delay then
			self.time = self.time - self.delay
			
			if self.reverse then
				self.frame = self.frame - 1

				if self.frame < self.first and self.loop then
					self.frame = self.last
					self.finished = true
				elseif self.frame < self.first then
					self.frame = self.first
					self.finished = true
				elseif self.frame > self.last then
					self.frame = self.last
					self.finished = true
				end
				return true
			else
				self.frame = self.frame + 1

				if self.frame > self.last and self.loop then
					self.frame = self.first
					self.finished = true
				elseif self.frame > self.last then
					self.frame = self.last
					self.finished = true
				elseif self.frame < self.first then
					self.frame = self.first
					self.finished = true
				end
				return true

			end
		end

		return false
	end

	return self
end

return {
	new = new,
}