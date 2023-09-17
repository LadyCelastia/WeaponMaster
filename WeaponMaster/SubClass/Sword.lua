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
	
	function self:Initiate(this)
		this:TransferComboAnimations(this)
		this:TransferHeavyAnimation(this)
		if this.Owner ~= nil then
			this.OwnerCharacterStats = this.Owner:FindFirstChild("CharacterStats")
			if this.OwnerCharacterStats then
				this.CanParryValue = this.OwnerCharacterStats:FindFirstChild("CanParry")
			end
		end
	end
	
	return self
end

return sword
