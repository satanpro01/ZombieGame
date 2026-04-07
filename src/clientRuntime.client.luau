--!native
--!nonstrict
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages
local Configs = ReplicatedStorage.Shared.configs
local SystemsFolder = ReplicatedStorage.Client.systems
local Matter = require(Packages.matter)
local Plasma = require(Packages.plasma)
local HotReloader = require(Packages.rewire).HotReloader
local Net = require(Packages.yetanothernet)

local me = Players.LocalPlayer
local authorizedPlayers = require(Configs.authorizedPlayers)
local components = require(Configs.components)
local routes = require(Configs.routes)
local world = Matter.World.new()
local state = {} -- add later if needed
local debugger = Matter.Debugger.new(Plasma)

debugger.findInstanceFromEntity = function(id)
    if not world:contains(id) then
        return
    end

    local model = world:get(id, components.Model)

    return if model then model.model else nil
end

local loop = Matter.Loop.new(world, state, debugger:getWidgets())

Net.start(loop, routes)

local hotReloader = HotReloader.new()
local firstRunSystems: any = {}
local systemsByModule = {}

local function loadModule(module, context)
    print("loadmodule called", module.name, context.isReloading)
    local originalModule = context.originalModule

    local ok, system = pcall(require, module)

    if not ok then
        warn("Error when hot-reloading system", module.name, system)
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
    default = RunService.PostSimulation,
    RenderStepped = RunService.PreRender,
    Stepped = RunService.PreSimulation,
})

-- Setup tags for teleporters
for _index, instance in ipairs(CollectionService:GetTagged("Teleporter")) do
    world:spawn(
        components.Teleporter(), -- not replicated; thus, should only be used for identifying teleporters
        components.Model({
            model = instance
        })
    )
end

if table.find(authorizedPlayers, me.Name) then
    ContextActionService:BindAction("ToggleDebugger", function(_actionName, inputState)
        if inputState == Enum.UserInputState.Begin then
            debugger:toggle()
        end
    end, true, Enum.KeyCode.F4)

    ContextActionService:SetTitle("ToggleDebugger", "MatterDebugger")
end