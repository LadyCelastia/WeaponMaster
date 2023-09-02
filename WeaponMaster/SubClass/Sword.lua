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
		if self.Owner ~= nil then
			self.OwnerCharacterStats = self.Owner:FindFirstChild("CharacterStats")
			if self.OwnerCharacterStats then
				self.CanParryValue = self.OwnerCharacterStats:FindFirstChild("CanParry")
			end
		end
	end
	
	return self
end

return sword
