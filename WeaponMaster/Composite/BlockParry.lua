--[[
    LadyCelestia 8/25/2023
    Composite Class BlockParry
--]]

local BlockParry = {}
BlockParry.__index = BlockParry

local Debris = game:GetService("Debris")

BlockParry.new = function(fields : {any?}?)
	fields = fields or {}
	
	local self = setmetatable({}, BlockParry)
	
	function self:Block(this)
		if this.Owner ~= nil then
			if this.Owner:FindFirstChild("Blocking") == nil and this.Owner:FindFirstChild("TrueStun") == nil then
				local Parry = Instance.new("BoolValue")
				Debris:AddItem(Parry, 0.2)
				Parry.Name = "Parrying"
				Parry.Value = true
				Parry.Parent = this.Owner
				local Block = Instance.new("BoolValue")
				Block.Name = "Blocking"
				Block.Value = true
				Block.Parent = this.Owner
				return true
			end
		end
		
		return false
	end
	
	function self:Unblock(this)
		if this.Owner ~= nil then
			for _,v in ipairs(this.Owner:GetChildren()) do
				if v:IsA("BoolValue") and (v.Name == "Parrying" or v.Name == "Blocking") then
					v:Destroy()
				end
			end
			return true
		end
		return false
	end
	
	return self
end

return BlockParry
