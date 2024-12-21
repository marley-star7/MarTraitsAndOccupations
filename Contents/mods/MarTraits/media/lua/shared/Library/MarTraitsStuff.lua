local JustDrankBooze = BodyDamage.JustDrankBooze
function BodyDamage:JustDrankBooze(food, percentage)
    JustDrankBooze(food, percentage)
    print(percentage)
end

--[[
local _MapItemLoadWorldMap = MapItem.LoadWorldMap
function MapItem:LoadWorldMap()
    if getPlayer:HasTrait("blind") then return end
    print("Ass")
    _MapItemLoadWorldMap(self)
end
]]--
--[[
local JustTookPill = BodyDamage:JustTookPill
function BodyDamage:JustTookPill(item)
    if ("PillsAntiDep".equals(var1.getType()))
    setTraitDepressiveTimePaused()
end]]--