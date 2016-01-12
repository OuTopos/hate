local hate = require((...):match("(.+)%.[^%.]+$") .. ".table")

local cameras = {}

local function new()
	local self = {}

	self.x = 0
	self.y = 0

	local scene = nil

	function self.attach(sceneentity)
		if sceneentity then
			scene = sceneentity
		end
	end

	function self.detach()
		scene = nil
	end

	-- BUFFER
	local buffer = {}
	
	local function bufferSentity(sentity, root)
		-- Buffer if sentity should be sorted. Also buffering if it's the root sentity to avoid an empty buffer.
		if sentity.parent.sortchildren or root then
			table.insert(buffer, sentity)
		end
		-- Iterating on the children.
		for k = #sentity.children, 1, -1 do
			local child = sentity.children[k]
			if child.destroyed then
				table.remove(sentity.children, k)
			else
				bufferSentity(child)
			end
		end
	end

	function self.update(dt)

	end

	local function drawSentity(sentity)
		-- Draw children that are not in the buffer
		if not sentity.sortchildren then
			for k = 1, #sentity.children do
				drawSentity(sentity.children[k])
			end
		end
		if sentity.drawable then
			love.graphics.draw(sentity.drawable, sentity.x, sentity.y, sentity.r, sentity.sx, sentity.sy, sentity.ox, sentity.oy)
		end
	end

	function self.draw()
		if scene then
			buffer = {}
			bufferSentity(scene, true)

			-- sort

			-- translate and camera stuff
			
			-- Draw the buffer
			for k = 1, #buffer do
				drawSentity(buffer[k])
			end

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