--[[
    LadyCelestia 8/25/2023
    AnimationLoader Module
--]]

local RunService = game:GetService("RunService")
if RunService:IsClient() == true then
	Instance = {
		new = function(...)
			error("[AnimationLoader]: A script attempted to call Instance.new() on client.")
			return nil
		end,
	}
end

local AnimationLoader = {}

AnimationLoader.Prep = function(Name : string, Animation : {any}, Character : Model, AnimParent : Instance) -- server only
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if Humanoid ~= nil then
		local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
		local newAnim = AnimParent:FindFirstChild(Name) or Instance.new("Animation")
		if newAnim.Name ~= Name then
			newAnim.AnimationId = Animation["ID"] or ""
			newAnim.Name = Name
			newAnim.Parent = AnimParent or Character
		end
		return newAnim
	end
end

AnimationLoader.BulkPrep = function(Animations : {any}, Character : Model, AnimParent : Instance) -- server only
	local Anims : {Animation} = {}
	for i,v in pairs(Animations) do
		Anims[i] = AnimationLoader.Prep(i, v, Character, AnimParent)
	end
	return Anims
end

AnimationLoader.Load = function(Name : string, Animation : {any}, Character : Model, AnimParent : Instance) -- can be used on client if prepped on server previously
	local AnimParent = Character:FindFirstChild("Animations") or Instance.new("Folder", Character)
	AnimParent.Name = "Animations"
	local newAnim = AnimParent:FindFirstChild(Name) or AnimationLoader.Prep(Name, Animation, Character, AnimParent)
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if newAnim ~= nil and Humanoid ~= nil then
		local Animator = Humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", Humanoid)
		local newTrack = Animator:LoadAnimation(newAnim)
		newTrack:AdjustSpeed(Animation["Speed"] or 1)
		newTrack:AdjustWeight(Animation["Weight"] or 1)
		return newTrack
	end
	return nil
end

AnimationLoader.BulkLoad = function(Animations : {any}, Character : Model, AnimParent : Instance) -- can be used on client if prepped on server previously
	local Anims : {AnimationTrack} = {}
	for i,v in pairs(Animations) do
		Anims[i] = AnimationLoader.Load(i, v, Character, AnimParent)
	end
	return Anims
end

return AnimationLoader
