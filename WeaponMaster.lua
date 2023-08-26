--[[
    LadyCelestia 8/23/2023
    WeaponMaster object-oriented inheritance-composition-wrapper hybrid weapon system
--]]

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
local StatusEffects = require(script:WaitForChild("StatusEffects"))
local Patriarch = require(script:WaitForChild("Weapon"))
local AnimationLoader = require(script:WaitForChild("AnimationLoader"))
local WeaponLibrary = require(script:WaitForChild("WeaponLibrary"))

local ServerStorage = game:WaitForChild("ServerStorage")
local ServerModules = ServerStorage:WaitForChild("Modules")
local HitboxMaster = require(ServerModules:WaitForChild("HitboxMaster"))

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
		if Composite:FindFirstChild(v[1]) then
			local self = require(Composite[v[1]])
			Object = WeaponMaster.Compose(Object, self.new(v[2] or {}), Override or false)
		end
	end
	
	return Object
end

WeaponMaster.new = function(Character : Model, Object : string, Fields : {any?})
	if SubClass:FindFirstChild(Object) then
		Fields = Fields or {}
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
							table.insert(Composition, {v2, Fields[v2] or {}})
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
		self.Type = Object
		self.HitboxMaster = HitboxMaster
		self:Initiate()
		
		-- Load animations
		local AnimFolder = Character:FindFirstChild("Animations") or Instance.new("Folder", Character)
		AnimFolder.Name = "Animations"
		local Animations = {}
		for i,v in pairs(self.Animations) do
			Animations[i] = v.Animation
		end
		self.AnimationTracks = AnimationLoader.BulkLoad(Animations, Character, AnimFolder)
		
		
		-- Enable sub-class functionalities
		
		return self
	end
	
	return {}
end

WeaponMaster.newFromLibrary = function(Character : Model, Name : string)
	local result = WeaponLibrary("find", Name)
	if result ~= nil then
		return WeaponMaster.new(Character, result["SubClass"], result["Fields"])
	end
	return {}
end

return WeaponMaster
