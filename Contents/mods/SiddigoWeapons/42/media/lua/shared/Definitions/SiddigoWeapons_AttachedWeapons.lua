-- Armas do mod cravadas em zumbi. Espelha shared/Definitions/ do jogo.
-- A global usa X = X or {}, entao acrescentar chave e seguro.

require "Definitions/AttachedWeaponDefinitions"

AttachedWeaponDefinitions = AttachedWeaponDefinitions or {}

-- Le a opcao de spawn de um item. Ausente ou nil = ligado,
-- para nao tirar o loot de quem ja tem save.
local function spawns(optionName)
    local vars = SandboxVars and SandboxVars.SiddigoWeapons
    if not vars then return true end
    local v = vars[optionName]
    if v == nil then return true end
    return v == true
end

local weapons = {}
if spawns("SpawnSkullCrusher") then
    table.insert(weapons, "SiddigoWeapons.SkullCrusher")
    -- Descomentar conforme 06-tocha e 07-estilingue forem implementados.
    -- Atencao: so arma corpo-a-corpo comprida faz sentido em "Back".
    -- "SiddigoWeapons.Torch",
end

if #weapons > 0 then
    AttachedWeaponDefinitions.siddigoSurvivorBack = {
        chance = 2,
        weaponLocation = {"Back"},
        bloodLocations = {"Back"},
        addHoles = true,
        daySurvived = 45,
        weapons = weapons,
    }
end
