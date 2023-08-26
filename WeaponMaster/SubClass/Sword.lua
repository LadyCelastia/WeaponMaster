--[[
    LadyCelestia 8/23/2023
    Sword Sub-class Weapon Object
--]]

local sword = {}
sword.__index = sword

sword.Composites = {"BlockParry", "MeleeProperties", "StatusEffects", "SwordPack"}

sword.new = function()
	local self = setmetatable({}, sword)
	
	self.Blade = nil
	self.HitboxAttachment = nil
	
	function self:Initiate()
		self:TransferComboAnimations(self)
		self:TransferHeavyAnimation(self)
	end
	
	return self
end

-- Wrappers
function sword:GetComposites()
	return sword.Composites or {}
end

return sword
