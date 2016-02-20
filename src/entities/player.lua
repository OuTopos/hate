local hate = require("lib.hate")

local function new(world, x, y, z)
	local self = {}

	self.x = x
	self.y = y
	self.z = z

	-- PHYSICS VARIABLES
	self.radius = 10
	self.mass = 1

	self.direction = 0
	self.velocity = 1000


	-- SENTITY
	local img = love.graphics.newImage("assets/player.png")

	local sentity = world.scene.newChild()
	sentity.drawable = img

	-- JOYSTICK & INPUT
	function self.setJoystick(joystick)
		if joystick:isGamepad() then
			self.joystick = joystick
		end
	end

	function self.updateInput(dt)
		local deadzone = 0.2

		local movex, movey = 0, 0
		local aimx, aimy = 0, 0
		
		if self.joystick then
			movex = self.joystick:getGamepadAxis("leftx")
			movey = self.joystick:getGamepadAxis("lefty")
			aimx = self.joystick:getGamepadAxis("rightx")
			aimy = self.joystick:getGamepadAxis("righty")
		end	

		if love.keyboard.isDown("left") then
			movex = -1
		elseif love.keyboard.isDown("right") then
			movex = 1
		end
		if love.keyboard.isDown("up") then
			movey = -1
		elseif love.keyboard.isDown("down") then
			movey = 1
		end

		local movedistance = hate.tools.getDistance(0, 0, movex, movey)
		local aimdistance =  hate.tools.getDistance(0, 0, aimx, aimy)
		-- Adjust for deadzone
		movedistance = (movedistance - deadzone) / 1 - deadzone
		aimdistance = (aimdistance - deadzone) / 1 - deadzone

		if movedistance > 0 then
			self.direction = math.atan2(movey, movex)

			-- Cap movedistance
			if movedistance > 1 then
				movedistance = 1
			end

			-- Force
			local forcex = self.velocity * movedistance * math.cos(self.direction)
			local forcey = self.velocity * movedistance * math.sin(self.direction)
			self.fixtures.anchor:getBody():applyForce(forcex, forcey)
		end

		if aimdistance > 0 then
			self.aim = math.atan2(aimy, aimx)
			self.fixtures.anchor:getBody():setAngle(self.aim)
		elseif movedistance > 0 then
			self.aim = self.direction
			self.fixtures.anchor:getBody():setAngle(self.aim)
		end
	end
	
	-- DEFAULT FUNCTIONS
	function self.initialize(properties)
		if properties then
			self.name = properties.name
		end

		-- PHYSICS OBJECTS
		self.fixtures = {}

		self.fixtures.anchor = love.physics.newFixture(love.physics.newBody(world.physics, self.x, self.y, "dynamic"), love.physics.newCircleShape(self.radius), self.mass)
		self.fixtures.anchor:setRestitution(0)
		self.fixtures.anchor:getBody():setLinearDamping(10)
		self.fixtures.anchor:getBody():setFixedRotation(true)
		--self.fixtures.anchor:setUserData({type = "pawn", callbacks = self, name = properties.name })
		--self.fixtures.anchor:setGroupIndex( 1 )
		--self.fixtures.anchor:setCategory( 1 )
		----self.fixtures.anchor:setMask( 2 )

		self.fixtures.weapon = love.physics.newFixture(self.fixtures.anchor:getBody(), love.physics.newPolygonShape(0, 0, 16, -16, 32, -16, 32, 16, 16, 16), 0)
		-- self.fixtures.weapon:setUserData(self.weapon.data)
		self.fixtures.weapon:setSensor(true)
		self.fixtures.weapon:setMask(16)	
	end
	function self.update(dt)
		self.updateInput(dt)

		self.x, self.y = self.fixtures.anchor:getBody():getX(), self.fixtures.anchor:getBody():getY()

		sentity.x = self.x
		sentity.y = self.y
	end

	return self
end

return {
	new = new
}