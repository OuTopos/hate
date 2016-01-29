require("strict")

local hate = require("lib.hate")

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


	local bleed = love.graphics.newImage("assets/bleed.png")
	--game.world.scene.drawable = bleed

	local whale = love.graphics.newImage("assets/whale.png")
	local whaleSentity = game.world.scene.newChild()
	whaleSentity.drawable = whale

	local tree1 = love.graphics.newImage("assets/tree1.png")
	local tree2 = love.graphics.newImage("assets/tree2.png")
	local tree3 = love.graphics.newImage("assets/tree3.png")
	local treedead = love.graphics.newImage("assets/treedead.png")
	local treestump = love.graphics.newImage("assets/treestump.png")
	local barrel = love.graphics.newImage("assets/barrel.png")

	local tree01 = game.world.scene.newChild()
	tree01.drawable = tree1
	--tree01.setX(400)
	tree01.x = 400
	tree01.sortchildren = true

	local tree02 = tree01.newChild()
	tree02.drawable = tree1
	tree02.y = 200
	tree02.x = 100
	print(tree02.getAbsolutes())

	local tree03 = game.world.scene.newChild()
	tree03.drawable = treedead
	tree03.x = 300
	tree03.y = 100

	local vertexformat = {
		{"VertexPosition", "float", 2}, -- The x,y position of each vertex.
		{"VertexTexCoord", "float", 2}, -- The u,v texture coordinates of each vertex.
		{"VertexColor", "byte", 4}, -- The r,g,b,a color of each vertex.
		{"ZPosition", "float", 1}
	}

	local vertices = {
		{0, 0, 0, 0, 255, 255, 255, 255, 1},
		{100, 0, 1, 0, 255, 255, 255, 255, 1},
		{100, 100, 1, 1, 255, 255, 255, 255, 0},


		{100, 100, 1, 1, 255, 255, 255, 255, 0},
		{0, 100, 0, 1, 255, 255, 255, 255, 0},
		{0, 0, 0, 0, 255, 255, 255, 255, 1}
	}



	local testmesh = game.world.scene.newChild()
	testmesh.drawable = love.graphics.newMesh( vertexformat, vertices, "triangles")
	testmesh.drawable:setTexture(bleed)


end

function love.update(dt)
	hate.update(dt)
end

function love.draw()
	--game.camera.draw()
	hate.draw()

end

function love.resize(w, h)
	game.viewport.setSize(w, h)
	--vp1.resize(love.graphics.getWidth(), love.graphics.getHeight())
end