--[[
    LadyCelestia 8/23/2023
    Inheritance Parent Class Weapon
--]]

local weapon = {}
weapon.__index = weapon

local ServerStorage = game:GetService("ServerStorage")
local Bindables = ServerStorage:WaitForChild("Bindables")

weapon.new = function(fields : {any?}?)
	fields = fields or {}
	
	local self = setmetatable({}, weapon)
	
	self.Name = fields["Name"] or nil
	self.Description = fields["Description"] or nil
	self.Type = fields["Type"] or nil
	self.Tool = fields["Tool"] or nil
	self.Owner = fields["Owner"] or nil -- Character which owns the tool
	
	self.DamageBindable = Bindables:WaitForChild("DamageBindable")
	self.StatusEffect = Bindables:WaitForChild("StatusEffect")
	
	return self
end

return weapon
