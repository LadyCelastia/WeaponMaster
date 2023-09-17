--[[
    LadyCelestia 8/23/2023
    WeaponMaster object-oriented inheritance-composition-wrapper hybrid weapon system
--]]

local RunService = game:GetService("RunService")
if RunService:IsClient() == true then
	return require(script:WaitForChild("AnimationLoader"))
end

local WeaponMaster = {}
WeaponMaster.__index = WeaponMaster

local SubClass = script:WaitForChild("SubClass")
local WeaponObjects = setmetatable({}, {
	__call = function(self : {any?}, name : string)
		for i,v in pairs(self) do
			if i == name then
				return v
			end
		end
	end,
})
for _,v in ipairs(SubClass:GetChildren()) do
	WeaponObjects[v.Name] = require(v)
end

local Composite = script:WaitForChild("Composite")
local Patriarch = require(script:WaitForChild("Weapon"))
local WeaponLibrary = require(script:WaitForChild("WeaponLibrary"))
local AnimationLoader = require(script:WaitForChild("AnimationLoader"))

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local LoadAnimation = Remotes:WaitForChild("LoadAnimation")
local ReplicatedModules = ReplicatedStorage:WaitForChild("Modules")
local SafeInvoke = require(ReplicatedModules:WaitForChild("SafeInvoke"))

local ServerStorage = game:GetService("ServerStorage")
local ServerModules = ServerStorage:WaitForChild("Modules")
local HitboxMaster = require(ServerModules:WaitForChild("HitboxMaster"))
local ServerValues = ServerStorage:WaitForChild("Values")
local WeaponSerial = ServerValues:WaitForChild("WeaponSerial")

local Players = game:GetService("Players")

WeaponMaster.Compose = function(Object : {any?}, Component : {any?}, Override : boolean?)
	for i,v in pairs(Component) do
		if Object[i] == nil or Override == true then
			Object[i] = v
		end
	end
	
	return Object
end

WeaponMaster.BulkCompose = function(Object : {any?}, Composition : {{any}}, Override : boolean?)
	for _,v in ipairs(Composition) do
		local target = Composite:FindFirstChild(v[1], true)
		if target ~= nil then
			local self = require(target)
			Object = WeaponMaster.Compose(Object, self.new(v[2] or {}), Override or false)
		end
	end
	
	return Object
end

WeaponMaster.new = function(Character : Model, Object : string, Fields : {any?})
	if SubClass:FindFirstChild(Object) then
		Fields = Fields or {}
		WeaponSerial.Value += 1
		Fields["Weapon"]["Serial"] = WeaponSerial.Value
		Fields["Weapon"]["SubClass"] = Object
		Fields["Weapon"]["Owner"] = Character
		Fields["Weapon"]["Player"] = Players:GetPlayerFromCharacter(Character)
		-- Creation of sub-class object
		local module = WeaponObjects(Object)
		local self = setmetatable(module.new(), WeaponMaster)
		
		-- Inherit Weapon parent class
		self = WeaponMaster.Compose(self, Patriarch.new(Fields["Weapon"] or {}), true)
		
		-- Dependency injection of composite classes
		local Composition = {}
		for _,v in pairs(module.Composites) do
			local Class = Composite:FindFirstChild(v) or Composite:FindFirstDescendant(v)
			if Class ~= nil then
				if Class:IsA("Folder") then
					for _,v2 in pairs(Class:GetChildren()) do
						if v2:IsA("ModuleScript") then
							table.insert(Composition, {v2.Name, Fields[v2.Name] or {}})
						end
					end
				elseif Class:IsA("ModuleScript") then
					table.insert(Composition, {v, Fields[v] or {}})
				end
			else
				warn("[WeaponMaster]: Invalid Composite Class/Package specified by sub-class " .. Object .. ".")
			end
		end
		self = WeaponMaster.BulkCompose(self, Composition, true)
		
		-- Initiation of sub-class object
		self.HitboxMaster = HitboxMaster
		self:Initiate(self)
		
		-- Load animations
		local AnimFolder = Character:FindFirstChild("Animations") or Instance.new("Folder", Character)
		AnimFolder.Name = "Animations"
		local Animations = {}
		for i,v in pairs(self.Animations) do
			Animations[i] = v.Animation
		end
		self["RawAnimations"] = AnimationLoader.BulkPrep(Animations, Character, AnimFolder)
		self["RawAnimationInfo"] = Animations
		--self:ReplicateAnimations(self)
		
		return self
	end
	
	return {}
end

WeaponMaster.newFromLibrary = function(Character : Model, Name : string)
	local result = WeaponLibrary("find", Name)
	if result ~= nil then
		local fields = result["Fields"]
		return WeaponMaster.new(Character, result["SubClass"], fields)
	end
	return {}
end

WeaponMaster.SafeDestroy = function(self) -- Completely remove a weapon safely from a weapon object
	-- WIP
end

return WeaponMaster
