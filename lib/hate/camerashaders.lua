local hate = require((...):match("(.+)%.[^%.]+$") .. ".table")

function newLight(camera)
	local self = {}
	local shaders = {}

	local function setupShaders()
		self.shaders = {}
		self.shaders.pre = love.graphics.newShader("shader_pre.glsl")
		self.shaders.post = love.graphics.newShader("shader_light.glsl")
		--self.shaders.transition = love.graphics.newShader("transition.glsl")
	end


	local function setupCanvases()
		self.canvases = {}
		self.canvases.diffuse = love.graphics.newCanvas(self.width, self.height)
		self.canvases.normal = love.graphics.newCanvas(self.width, self.height)
		self.canvases.depth = love.graphics.newCanvas(self.width, self.height)
		self.canvases.final = love.graphics.newCanvas(self.width, self.height)

		-- self.shaders.pre:send("canvas_diffuse", self.canvases.diffuse)
		-- self.shaders.pre:send("canvas_normal", self.canvases.normal)
		-- self.shaders.pre:send("canvas_depth", self.canvases.depth)

		self.shaders.post:send("normalmap", self.canvases.normal)
		self.shaders.post:send("depthmap", self.canvases.depth)
		self.shaders.post:send("fog_mask", yama.assets.loadImage("fog"))
		-- self.shaders.post:send("ambientmap", yama.assets.loadImage("ambient"))

		-- self.shaders.transition:send("pre_canvas", yama.assets.loadImage("test_canvas"))
		-- self.shaders.transition:send("mask", yama.assets.loadImage("transitiontest"))
		-- self.shaders.transition:send("time", 0.5)
		-- self.shaders.transition:send("feather", 1)
	end
	local canvases = {}

	function self.predraw()
		-- Set canvases
		love.graphics.setCanvas(canvases.diffuse, canvases.normal, canvases.depth, canvases.transparency)

		-- Set shader
		love.graphics.setShader(shaders.pre)
	end

	function self.postsdraw()

	end

	return self
end


return {
	newLight = newLight
}