local hate = require((...):match("(.+)%.[^%.]+$") .. ".table")

local viewports = {}

local function new()
	local self = {}

	self.x = 0
	self.y = 0
	self.r = 0
	self.sx = 1
	self.sy = 1
	self.ox = 0
	self.oy = 0
	self.kx = 0
	self.ky = 0
	
	local width, height = love.graphics.getDimensions()

	-- CAMERAS
	local cameras = {}
	function self.newCamera()
		local camera = hate.cameras.new(self)

		table.insert(cameras, camera)
		return camera
	end

	-- CANVAS
	local canvas = love.graphics.newCanvas(width, height)

	local function newCanvas()
		canvas = love.graphics.newCanvas(width, height)
	end
	
	-- SET SIZE
	function self.setSize(w, h)
		width = w or width
		height = h or height

		newCanvas()
		for k = 1, #cameras do
			cameras[k].width = width
			cameras[k].height = height
		end
	end

	-- RESIZE & ZOOM
	function self.resize(width, height)
		print("KÖR EN RESIZE")
		self.width = width or love.window.getWidth()
		self.height = height or love.window.getHeight()
		
		setupCanvases()
	end

	function self.update(dt)
		for k = 1, #cameras do
			cameras[k].update()
		end
	end

	function self.draw()
		-- set canvas
		love.graphics.setCanvas(canvas)
		love.graphics.clear()

		for k = 1, #cameras do
			cameras[k].draw()
		end
		-- unset canvas
		love.graphics.setCanvas()

		-- draw canvas
		love.graphics.draw(canvas, self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy, self.kx, self.ky)
	end

	table.insert(viewports, self)
	return self
end

local function update(dt)
	for k = 1, #viewports do
		viewports[k].update(dt)
	end
end

local function draw()
	for k = #viewports, 1, -1 do
		viewports[k].draw()
	end
end


return {
	new = new,
	update = update,
	draw = draw
}