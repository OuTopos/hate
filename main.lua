require("strict")

local hate = require("lib.hate")
hate.debug.setLevel(2)

local game = {}
function love.load()
	hate.load()

	game.world = hate.newWorld()
	game.world.enablePhysics()

	game.viewport = hate.newViewport()
	game.camera = game.viewport.newCamera()
	--game.camera.x = -50
	--game.camera.y = -50
	game.camera.r = 0
	game.camera.sx = 1
	game.camera.sy = 1
	game.camera.width = 300
	game.camera.height = 400
	game.camera.attach(game.world.scene)

	game.player = game.world.newEntity("player", {700,400, 0})
	if love.joystick.getJoystickCount() > 0 then
		game.player.setJoystick(love.joystick.getJoysticks()[1])
	end

	game.camera.target = game.player

	local bleed = love.graphics.newImage("assets/bleed.png")
	--game.world.scene.drawable = bleed

	local tree1 = love.graphics.newImage("assets/tree1.png")
	local tree2 = love.graphics.newImage("assets/tree2.png")
	local tree3 = love.graphics.newImage("assets/tree3.png")
	local treedead = love.graphics.newImage("assets/treedead.png")
	local treestump = love.graphics.newImage("assets/treestump.png")
	local barrel = love.graphics.newImage("assets/barrel.png")


	local vertexformat = {
		{"VertexPosition", "float", 2}, -- The x,y position of each vertex.
		{"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
		{"VertexColor", "byte", 4}, -- The r,g,b,a color of each vertex.
		{"z", "float", 1}
	}

	local vertices = {
		{0, 0, 0, 0, 255, 255, 255, 255, 128},
		{128, 0, 1, 0, 255, 255, 255, 255, 128},
		{128, 128, 1, 1, 255, 255, 255, 255, 0},


		{128, 128, 1, 1, 255, 255, 255, 255, 0},
		{0, 128, 0, 1, 255, 255, 255, 255, 0},
		{0, 0, 0, 0, 255, 255, 255, 255, 128}
	}



	local testmesh = game.world.scene.newChild()
	testmesh.drawable = love.graphics.newMesh( vertexformat, vertices, "triangles")
	testmesh.drawable:setTexture(bleed)
	testmesh.width = 128
	testmesh.height = 128
	--testmesh.r = 0.1

	local treeverts = {
		{0, 0, 0, 0, 255, 255, 255, 255, 256},
		{256, 0, 1/3, 0, 255, 255, 255, 255, 256},
		{256, 256, 1/3, 1, 255, 255, 255, 255, 0},


		{256, 256, 1/3, 1, 255, 255, 255, 255, 0},
		{0, 256, 0, 1, 255, 255, 255, 255, 0},
		{0, 0, 0, 0, 255, 255, 255, 255, 256}
	}
	local img_bigtrees = hate.loadImage("bigtrees.png")

	for i = 0, 100 do
		local sentity = game.world.scene.newChild()
		sentity.drawable = love.graphics.newMesh( vertexformat, treeverts, "triangles")
		sentity.drawable:setTexture(img_bigtrees)
		sentity.width = 256
		sentity.height = 256
		sentity.x = math.random(0, 2000)
		sentity.y = math.random(0, 1000)
	end

end

function love.update(dt)
	hate.update(dt)
end

function love.draw()
	hate.draw()

	-- PHYSICS DEBUG - very tempy
	game.camera.translate()
	hate.debug.drawPhysics(game.world.physics)
	love.graphics.pop()
end

function love.resize(w, h)
	game.viewport.setSize(w, h)
	--vp1.resize(love.graphics.getWidth(), love.graphics.getHeight())
end