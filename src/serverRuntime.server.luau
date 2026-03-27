--!native
--!nonstrict
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Packages = ReplicatedStorage.Packages
local SystemsFolder = ServerStorage.Server.systems
local Matter = require(Packages.matter)
local Plasma = require(Packages.plasma)
local HotReloader = require(Packages.rewire).HotReloader

local components = require(ServerStorage.Server.configs.serverComponents)
local world = Matter.World.new()
local state = {}
local debugger = Matter.Debugger.new(Plasma)

debugger.findInstanceFromEntity = function(id)
    if not world:contains(id) then
        return
    end

    local model = world:get(id, components.Model)

    return if model then model.model else nil
end

local loop = Matter.Loop.new(world, state, debugger:getWidgets())

local hotReloader = HotReloader.new()
local firstRunSystems: any = {}
local systemsByModule = {}

local function loadModule(module, context)
    local originalModule = context.originalModule

    local ok, system = pcall(require, module)

    if not ok then
        warn("Error when hot-reloading system", module.name, system, "- serverRuntime")
        return
    end

    if firstRunSystems then
        table.insert(firstRunSystems, system)
    elseif systemsByModule[originalModule] then
        loop:replaceSystem(systemsByModule[originalModule], system)
        debugger:replaceSystem(systemsByModule[originalModule], system)
    else
        loop:scheduleSystem(system)
    end

	systemsByModule[originalModule] = system
end

local function unloadModule(_, context)
    if context.isReloading then
        return
    end

    local originalModule = context.originalModule
    if systemsByModule[originalModule] then
        loop:evictSystem(systemsByModule[originalModule])
        systemsByModule[originalModule] = nil
    end
end

hotReloader:scan(SystemsFolder, loadModule, unloadModule)
loop:scheduleSystems(firstRunSystems)

firstRunSystems = nil

debugger:autoInitialize(loop)

loop:begin({
    default = RunService.Heartbeat,
    Stepped = RunService.Stepped,
})