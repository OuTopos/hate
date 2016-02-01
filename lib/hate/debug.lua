local hate = require((...):match("(.+)%.[^%.]+$") .. ".table")

-- Verbose level
-- 0: nothing
-- 1: warnings
-- 2: warnings + info
local level = 0
local function setLevel(value)
	if tonumber(value) then
		level = value
	end
end

-- Throw error on warnings
local eow = false
local function setEOW(value)
	if value then
		eow = true
	else
		eow = false
	end
end

-- Write to log
-- LOG FILE
local log = nil
local function enableLogging(filename)
	if not filename then
		 filename = "hate.log"
	end
	log = love.filesystem.newFile(filename)
	log:open("w")
end

function info(text, i)
	if level >= 2 then
		local info = debug.getinfo(i or 2, "lS")
		local finaltext = "Info: " .. info.short_src .. ":" .. info.currentline .. ": " .. text
		print(finaltext)
		if log then
			log:write(finaltext .. "\r\n")
		end
	end
end
function warning(text, i)
	if level >= 1 then
		if eow then
			error(text)
		else
			local info = debug.getinfo(i or 2, "lS")
			local finaltext = "Warning: " .. info.short_src .. ":" .. info.currentline .. ": " .. text
			print(finaltext)
			if log then
				log:write(finaltext .. "\r\n")
			end
		end
	end
end



-- PHYSICS
local function drawFixture(fixture)
	local r, g, b, a = 0, 0, 0, 0

	if fixture:getBody():getType() == "static" then
		r, g = 255, 0
	else
		r, g = 0, 255
	end

	if fixture:isSensor() then
		b = 255
	else
		b = 0
	end

	if fixture:getBody():isActive() then
		a = 102
	else
		a = 51
	end

	if not fixture:getUserData() then
		a = 255
	end
	love.graphics.setColor(r, g, b, a)

	if fixture:getShape():getType() == "circle" then
		love.graphics.circle("fill", fixture:getBody():getX(), fixture:getBody():getY(), fixture:getShape():getRadius())
	elseif fixture:getShape():getType() == "polygon" then
		love.graphics.polygon("fill", fixture:getBody():getWorldPoints(fixture:getShape():getPoints()))
	elseif fixture:getShape():getType() == "edge" then
		love.graphics.line(fixture:getBody():getWorldPoints(fixture:getShape():getPoints()))
	elseif fixture:getShape():getType() == "chain" then
		love.graphics.line(fixture:getBody():getWorldPoints(fixture:getShape():getPoints()))
	end
	love.graphics.setColor(255, 255, 255, 255)
end

local function drawPhysics(world)
	if world then
		for k, body in ipairs(world:getBodyList()) do
			for k, fixture in ipairs(body:getFixtureList()) do
				drawFixture(fixture)
			end
		end
	end
end

return {
	setLevel = setLevel,
	setEOW = setEOW,
	enableLogging = enableLogging,
	info = info,
	warning = warning,
	drawPhysics = drawPhysics
}