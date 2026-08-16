local SurvivorTorchBurn = {}

-- UseDelta nao roda em ItemType = base:weapon (zero ocorrencias em weapon.txt do jogo, contra
-- 17 em drainable.txt) -- por isso o consumo da tocha acesa e feito aqui, reaproveitando a
-- Condition (ja tem barra visivel no item) em vez do campo morto.
SurvivorTorchBurn.LIT = "SiddigoWeapons.TorchLit"
SurvivorTorchBurn.BURNT_OUT = "Base.Branch_Broken"

local function burnIfLit(item, player)
    if not item or item:getFullType() ~= SurvivorTorchBurn.LIT then return end
    local condition = item:getCondition()
    if condition <= 1 then
        OnBreak.HandleHandler(item, player, SurvivorTorchBurn.BURNT_OUT, false)
    else
        item:setCondition(condition - 1)
    end
end

SurvivorTorchBurn.onEveryHours = function()
    for playerNum = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerNum)
        if player then
            local primary = player:getPrimaryHandItem()
            local secondary = player:getSecondaryHandItem()
            burnIfLit(primary, player)
            if secondary ~= primary then
                burnIfLit(secondary, player)
            end
        end
    end
end

Events.EveryHours.Add(SurvivorTorchBurn.onEveryHours)
