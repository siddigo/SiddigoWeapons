-- O que a tocha acesa faz enquanto esta na mao: incendiar zumbi e gastar combustivel.

local LIT_TORCH = "SiddigoWeapons.TorchLit"
local BURNT_OUT_TORCH = "Base.Branch_Broken"

local IGNITE_CHANCE_ONE_IN = 4

-- A Condition e o combustivel da tocha, e a duracao em horas e o ConditionMax dela no .txt: a
-- familia de deplecao do jogo (UseDelta, ReplaceOnDeplete) nao roda em ItemType = base:weapon. Ver
-- Documentacao/jogo/scripts-txt.md.
local CONDITION_PER_HOUR = 1

local function igniteZombieOnTorchHit(zombie, attacker, bodyPart, weapon)
    if not zombie or not weapon then return end
    if weapon:getFullType() ~= LIT_TORCH then return end

    -- Experimento (SPEC-05): a luz da tocha fica vermelha quando ela suja de sangue. Nenhuma
    -- ligacao entre BloodLevel e cor de luz foi achada em Lua -- se existe, e Java sem gancho.
    -- Limpar a cada acerto e a unica cadencia que testa a hipotese: o bug aparece durante o
    -- combate, antes de qualquer passada periodica. Fica ANTES do sorteio de chance de proposito.
    weapon:setBloodLevel(0)

    if ZombRand(IGNITE_CHANCE_ONE_IN) ~= 0 then return end

    -- setOnFire(true) nao tem precedente vanilla em zumbi (so debug de animal). StartFire e o
    -- mecanismo real de incendio do jogo (SCampfireSystem.lua), sem o delay/inconsistencia relatado.
    local sq = zombie:getSquare()
    if not sq then return end
    IsoFireManager.StartFire(getCell(), sq, true, 100, 500)
end

local function burnDownTorch(item, player)
    if not item or item:getFullType() ~= LIT_TORCH then return end

    local condition = item:getCondition()
    if condition <= CONDITION_PER_HOUR then
        OnBreak.HandleHandler(item, player, BURNT_OUT_TORCH, false)
    else
        item:setCondition(condition - CONDITION_PER_HOUR)
    end
end

local function burnDownEquippedTorches()
    for playerNum = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerNum)
        if player then
            local primary = player:getPrimaryHandItem()
            local secondary = player:getSecondaryHandItem()

            burnDownTorch(primary, player)
            -- Item de duas maos ocupa as duas: sem o teste, gastaria o dobro por hora.
            if secondary ~= primary then
                burnDownTorch(secondary, player)
            end
        end
    end
end

Events.OnHitZombie.Add(igniteZombieOnTorchHit)
Events.EveryHours.Add(burnDownEquippedTorches)
