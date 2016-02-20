local hate = require((...):match("(.+)%.[^%.]+$") .. ".table")

local cameras = {}

local function new(viewport)
	local self = {}

	self.shader = love.graphics.newShader("vert.glsl")

	self.x = 0
	self.y = 0
	self.r = 0

	self.sx = 1
	self.sy = 1

	self.width = 0
	self.height = 0

	self.cx = 0
	self.cy = 0

	self.round = false

	self.target = nil

	local shader = {}
	function shader.predraw()
		self.shader:send("camera_position" , {self.cx, self.cy})
		love.graphics.setShader(self.shader)
	end

	function shader.postdraw()
		love.graphics.setShader()
	end
	-- Translate for the camera run before drawing everything.
	-- The fnction is public so it can be run from other places when drawing overlay gui.
	function self.translate()
		love.graphics.push()

		-- Translate to camera center, rotate, translate back to make sure camerea rotates around center.
		love.graphics.translate(self.width / 2 * self.sx, self.height / 2 * self.sy)
 		love.graphics.rotate(- self.r)
		love.graphics.translate(- self.width / 2 * self.sx, - self.height / 2 * self.sy)

		-- Then do the scale and translate.
		love.graphics.scale(self.sx, self.sy)
		love.graphics.translate(- self.x, - self.y)
	end

	-- Ocular returns true if the sentity is in camera view.
	local function ocular(sentity)
		return (
			( sentity.x <= self.x + self.width / self.sx ) and
			( self.x <= sentity.x + sentity.height ) and
			( sentity.y <= self.y + self.height / self.sy ) and
			( self.y <= sentity.y + sentity.width )
		)
	end

	-- ROOTSENTITY
	local rootsentity = nil

	-- Attach and detach a rootsentity. It and all it's children will be drawn.
	function self.attach(sentity)
		if sentity then
			rootsentity = sentity
		end
	end

	function self.detach()
		rootsentity = nil
	end


	-- BUFFER
	-- The buffer is a table filled with every *sorted sentity that is in view.
	-- This buffer gets sorted and all sentities inside it will be drawn.
	-- * If the children are not to be sorted they will not be added to the buffer. Instead they will be drawn when the parent is drawn.

	local buffer = {}
	
	local function bufferSentity(sentity, root)
		-- Buffer if sentity should be sorted. Also buffering if it's the root sentity to avoid an empty buffer.
		if sentity.parent.sortchildren or root then
			-- Test if the sentity is in view (ocular).
			if ocular(sentity) then
				-- Add sentity to the buffer.
				table.insert(buffer, sentity)
			end
		end
		-- Iterating on the children.
		for k = #sentity.children, 1, -1 do
			local child = sentity.children[k]
			
			if child.destroyed then
				-- Remove child if it has been destroyed.
				table.remove(sentity.children, k)
			else
				-- Else buffer the child.
				bufferSentity(child)
			end
		end
	end

	function self.update(dt)
		if self.target then
			if self.target.x and self.target.y then
				self.x = self.target.x - self.width / 2
				self.y = self.target.y - self.height / 2
			end
		end

		self.cx = self.x + self.width / 2
		self.cy = self.y + self.height / 2
	end

	-- DRAW
	-- drawChildren will call itself to draw the children. If you mess up you can easily create an infinite loop :)

	local function drawSentity(sentity)
		-- Draw children if they didn't get added to the buffer.
		if not sentity.sortchildren then
			for k = 1, #sentity.children do
				drawSentity(sentity.children[k])
			end
		end
		-- Draw the actual drawable if there is one.
		if sentity.drawable then

			-- SHADER PER DRAWCALL
			love.graphics.draw(sentity.drawable, sentity.x, sentity.y, sentity.r, sentity.sx, sentity.sy, sentity.ox, sentity.oy, sentity.kx, sentity.ky)
		end
	end

	function self.draw()
		if rootsentity then
			-- Clear the buffer, clear it here instead of after draw incase it's needed for debugging.
			buffer = {}
			-- Add the rootsentity to the buffer.
			bufferSentity(rootsentity, true)

			-- SHADER PRE DRAW
			shader.predraw()
			-- To bee done.

			-- Sort the buffer.

			-- Translate.
			self.translate()

			-- Draw the buffer.
			for k = 1, #buffer do
				drawSentity(buffer[k])
			end

			-- Debugging temp stuff
			love.graphics.setColor(255, 0, 0, 127)
			love.graphics.rectangle( "line", self.x, self.y, self.width / self.sx, self.height / self.sy)
			love.graphics.setColor(255, 255, 255, 255)


			love.graphics.setColor(0, 0, 0, 255)
			love.graphics.printf("Buffer: " .. #buffer, self.x+3, self.y+3, 100, "right")
			love.graphics.printf("Camera: " .. self.cx .. " " .. self.cy, self.x+3, self.y+13, 200, "left")

			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.printf("Buffer: " .. #buffer, self.x+2, self.y+2, 100, "right")
			love.graphics.printf("Camera: " .. self.cx .. " " .. self.cy, self.x+2, self.y+12, 200, "left")

			-- Unset the camera.
			love.graphics.pop()

			-- SHADER POST DRAW
			shader.postdraw()
			-- To be done.

		end
	end

	table.insert(cameras, self)
	return self
end

local function update(dt)
	for k = 1, #cameras do
		cameras[k].update(dt)
	end
end

return {
	new = new,
	update = update
}