--[[
    LadyCelestia 8/25/2023
    AnimationLoader Module
--]]

local AnimationLoader = {}

AnimationLoader.Load = function(Name : string, Animation : {any}, Character : Model, AnimParent : Instance)
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if Humanoid ~= nil then
		local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
		if Animator ~= nil then
			local newAnim = Instance.new("Animation")
			newAnim.AnimationId = Animation["ID"] or ""
			newAnim.Name = Name
			newAnim.Parent = AnimParent or Character
			local newTrack = Animator:LoadAnimation(newAnim)
			newTrack:AdjustSpeed(Animation["Speed"] or 1)
			newTrack:AdjustWeight(Animation["Weight"] or 1)
			return newTrack
		end
	end
	return nil
end

AnimationLoader.BulkLoad = function(Animations : {any}, Character : Model, AnimParent : Instance)
	local Anims = {}
	for i,v in pairs(Animations) do
		Anims[i] = AnimationLoader.Load(i, v, Character, AnimParent)
	end
	return Anims
end

return AnimationLoader
