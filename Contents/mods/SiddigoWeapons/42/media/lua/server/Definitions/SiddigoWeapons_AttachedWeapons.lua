-- Armas do mod visiveis equipadas no corpo do zumbi sobrevivente (costas e cinto).
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

-- handgunHolster ja e gateada pelos cinco trajes Survivalist e ja traz ensureItem =
-- Base.HolsterSimple, entao o zumbi ganha o coldre junto. So arma AttachmentType = Holster
-- encaixa aqui -- por isso o estilingue e nao a tocha (AttachmentType = BigWeapon, tipo de costas).
-- Ver Projetos/SiddigoWeapons/pendencias.md, secao "Modelo 3D", sobre o bloqueio da tocha.
local SURVIVOR_BELT_DEFINITIONS = {
    "handgunHolster",
}

local WEAPONS_ON_SURVIVOR_BELT = {
    { fullType = "SiddigoWeapons.Slingshot", sandboxOption = "SpawnSlingshot" },
}

-- `weapons` e tabela do jogo: inserir, nunca substituir. O peso e por repeticao -- o mesmo fullType
-- duas vezes na lista dobra a chance, nao existe campo numerico aqui.
local function addWeaponToDefinition(definitionName, fullType)
    local definition = AttachedWeaponDefinitions[definitionName]
    if not definition or not definition.weapons then
        print("[SiddigoWeapons] AttachedWeaponDefinitions." .. definitionName
            .. " nao existe na tabela do jogo: " .. fullType .. " nao vai aparecer equipado.")
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

local function registerWeaponsOnSurvivorBelt()
    for _, weapon in ipairs(WEAPONS_ON_SURVIVOR_BELT) do
        if SiddigoWeapons.isSpawnEnabled(weapon.sandboxOption) then
            for _, definitionName in ipairs(SURVIVOR_BELT_DEFINITIONS) do
                addWeaponToDefinition(definitionName, weapon.fullType)
            end
        end
    end
end

registerWeaponsOnSurvivorBack()
registerWeaponsOnSurvivorBelt()
