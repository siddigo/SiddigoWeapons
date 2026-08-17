-- Armas do mod visiveis nas costas do zumbi sobrevivente.
--
-- NAO MOVER PARA shared/: o gate de sandbox so le o valor do mundo a partir de server/. Ver o
-- cabecalho de SiddigoWeapons_Sandbox.lua.

require "Definitions/AttachedWeaponDefinitions"
require "SiddigoWeapons_Sandbox"

AttachedWeaponDefinitions = AttachedWeaponDefinitions or {}

-- As tres eras da definicao que o traje survivalista sorteia. Definicao propria do mod nao entra: o
-- traje so sorteia da lista curada dele. Contrato em Documentacao/jogo/definitions-lua.md.
local SURVIVOR_BACK_DEFINITIONS = {
    "meleeInBackBag",
    "meleeInBackBag_Mid",
    "meleeInBackBag_Late",
}

-- So arma corpo-a-corpo comprida faz sentido presa nas costas.
local WEAPONS_ON_SURVIVOR_BACK = {
    { fullType = "SiddigoWeapons.SkullCrusher", sandboxOption = "SpawnSkullCrusher" },
}

-- `weapons` e tabela do jogo: inserir, nunca substituir. O peso e por repeticao -- o mesmo fullType
-- duas vezes na lista dobra a chance, nao existe campo numerico aqui.
local function addWeaponToDefinition(definitionName, fullType)
    local definition = AttachedWeaponDefinitions[definitionName]
    if not definition or not definition.weapons then
        print("[SiddigoWeapons] AttachedWeaponDefinitions." .. definitionName
            .. " nao existe na tabela do jogo: " .. fullType .. " nao vai aparecer nas costas.")
        return
    end
    table.insert(definition.weapons, fullType)
end

local function registerWeaponsOnSurvivorBack()
    for _, weapon in ipairs(WEAPONS_ON_SURVIVOR_BACK) do
        if SiddigoWeapons.isSpawnEnabled(weapon.sandboxOption) then
            for _, definitionName in ipairs(SURVIVOR_BACK_DEFINITIONS) do
                addWeaponToDefinition(definitionName, weapon.fullType)
            end
        end
    end
end

registerWeaponsOnSurvivorBack()
