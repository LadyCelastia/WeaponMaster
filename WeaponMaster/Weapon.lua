--[[
    LadyCelestia 8/23/2023
    Inheritance Parent Class Weapon
--]]

local weapon = {}
weapon.__index = weapon

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local ServerStorage = game:GetService("ServerStorage")
local Bindables = ServerStorage:WaitForChild("Bindables")

weapon.new = function(fields : {any?}?)
	fields = fields or {}
	
	local self = setmetatable({}, weapon)
	
	self.Name = fields["Name"] or nil
	self.Description = fields["Description"] or nil
	self.SubClass = fields["SubClass"] or nil
	self.Tool = fields["Tool"] or nil
	self.Serial = fields["Serial"] or nil
	self.Owner = fields["Owner"] or nil -- Character which owns the tool
	self.Player = fields["Player"] or nil
	self.RawAnimations = fields["RawAnimations"] or {}
	self.RawAnimationInfo = fields["RawAnimationInfo"] or {}
	self.WeaponRemote = fields["WeaponRemote"] or {}
	
	self.DamageBindable = Bindables:WaitForChild("DamageEvent")
	self.StatusEffect = Bindables:WaitForChild("StatusEffect")
	self.LoadAnimation = Remotes:WaitForChild("LoadAnimation")
	
	function self:Destroy(this) -- only removes weapon object
		for i,_ in pairs(this) do
			this[i] = nil
		end
		this = nil
		return true
	end
	
	function self:ReplicateAnimations(this)
		if this.Player ~= nil then
			this.LoadAnimation:FireClient(this.Player, "WeaponBulk", {
				["Serial"] = this.Serial,
				["RawAnimations"] = this.RawAnimations,
				["AnimInfo"] = this.RawAnimationInfo
			})
			return true
		end
		return false
	end
	
	return self
end

return weapon
