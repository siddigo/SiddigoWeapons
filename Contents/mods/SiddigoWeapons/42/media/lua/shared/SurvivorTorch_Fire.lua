local SurvivorTorchFire = {}

-- 1 em CHANCE de incendiar o zumbi a cada acerto com a tocha acesa
SurvivorTorchFire.CHANCE = 4
SurvivorTorchFire.WEAPON = "SiddigoWeapons.TorchLit"

SurvivorTorchFire.onHitZombie = function(zombie, wielder, bodyPart, weapon)
    if not zombie or not weapon then return end
    if weapon:getFullType() ~= SurvivorTorchFire.WEAPON then return end
    if ZombRand(SurvivorTorchFire.CHANCE) ~= 0 then return end
    zombie:setOnFire(true)
end

Events.OnHitZombie.Add(SurvivorTorchFire.onHitZombie)
