local hate = require(... .. ".table")

-- PATHS
hate.paths = {}
hate.paths.lib = ...
hate.paths.src = "src"
hate.paths.assets = "assets"

hate.paths.entities = hate.paths.src .. "/entities"

-- MODULES
hate.worlds         = require(... .. ".worlds")
hate.sentities      = require(... .. ".sentities")
hate.cameras        = require(... .. ".cameras")
--hate.viewports      = require(hate.paths.lib .. "/hate.viewports")

hate.tools		    = require(... .. ".tools")

-- VARIABLES
hate.v = {}
hate.v.paused = false
hate.v.gcInterval = 10
hate.v.gcTimer = 10


-- DEBUG FUNCTIONS
hate.log = love.filesystem.newFile("hate.log")
hate.log:open("w")


hate.debug = {}
hate.debug.level = 2
hate.debug.warning2error = false
hate.debug.log = false

function info(text, i)
	if hate.debug.level >= 2 then
		local info = debug.getinfo(i or 2, "lS")
		print("Info: " .. info.short_src .. ":" .. info.currentline .. ": " .. text)
		hate.log:write("Info: " .. info.short_src .. ":" .. info.currentline .. ": " .. text .. "\r\n")
	end
end
function warning(text, i)
	if hate.debug.level >= 1 then
		if hate.debug.warning2error then
			error(text)
		else
			local info = debug.getinfo(i or 2, "lS")
			print("Warning: " .. info.short_src .. ":" .. info.currentline .. ": " .. text)
			hate.log:write("Warning: " .. info.short_src .. ":" .. info.currentline .. ": " .. text .. "\r\n")
		end
	end
end


-- TOOLS

local function requireDir(path)
	local table = {}
	if love.filesystem.exists(path) then
		local files = love.filesystem.getDirectoryItems(path)
		for k, file in ipairs(files) do
			info("require(" .. path .. "/" .. file:gsub("%.lua", "") .. ")", 3)
			table[file:gsub("%.lua", "")] = require(path .. "/" .. file:gsub("%.lua", ""))
		end
	else
		error(path .. ' does not exist')
	end
	return table
end


local function load()
	--love.graphics.setDefaultFilter("linear", "linear")
	love.graphics.setDefaultFilter("nearest", "nearest")

	-- Loading entities
	print(hate.paths.entities)
	hate.entities = requireDir(hate.paths.entities)
end

local function update(dt)
	if not hate.v.paused then
		hate.worlds.update(dt)
	end
	--hate.viewports.update(dt)
end

local function draw()
	-- hate.worlds.draw()
	--hate.viewports.draw()

	---[[ FPS
	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.printf("FPS: " .. love.timer.getFPS(), 3, 3, 100, "left")

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.printf("FPS: " .. love.timer.getFPS(), 2, 2, 100, "left")
	--]]
end

-- Love callbacks
hate.keybindings = {}
function love.keypressed(key)
	if hate.keybindings[key] then
		if type(hate.keybindings[key]) == "function" then
			hate.keybindings[key]()
		end
	end
end

hate.keybindings["escape"] = function()
	love.event.push("quit")
end

hate.keybindings["p"] = function()
	hate.v.paused = not hate.v.paused
end



-- KEY BINDINGS
hate.keybindings["0"] = function()
	hate.hud.enabled = not hate.hud.enabled
end

hate.keybindings["1"] = function()
	hate.hud.drawEntities = not hate.hud.drawEntities
end

hate.keybindings["2"] = function()
	hate.hud.drawSceneEntities = not hate.hud.drawSceneEntities
end

hate.keybindings["3"] = function()
	hate.hud.drawLocations = not hate.hud.drawLocations
end

hate.keybindings["4"] = function()
	hate.hud.drawPaths = not hate.hud.drawPaths
end

hate.keybindings["5"] = function()
	hate.hud.drawPhysics = not hate.hud.drawPhysics
end

hate.keybindings[","] = function()
	hate.hud.drawSceneEntity = hate.hud.drawSceneEntity - 1
end

hate.keybindings["."] = function()
	hate.hud.drawSceneEntity = hate.hud.drawSceneEntity + 1
end

return {
	load = load,
	update = update,
	draw = draw,

	newWorld = hate.worlds.new,
	newCamera = hate.cameras.new,
	--newViewport = hate.viewports.new,

	keybindings = hate.keybindings,

	requireDir = requireDir,

	assets = hate.assets,
	tools = hate.tools,
}