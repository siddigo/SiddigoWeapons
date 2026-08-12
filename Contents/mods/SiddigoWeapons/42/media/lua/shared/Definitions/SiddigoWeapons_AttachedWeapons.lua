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
    -- Atencao: so arma corpo-a-corpo comprida faz sentido nas costas.
    -- "SiddigoWeapons.Torch",
end

-- Molde: a definicao vanilla meleeInBackBag_Late (AttachedWeaponDefinitions.lua:1457), que cobre
-- exatamente estes 5 trajes. A versao anterior desta tabela errava cinco coisas de uma vez e
-- nenhuma delas gerava erro -- teste in-game de 12/08/2026 com 1000+ zumbis nao produziu um
-- unico avistamento:
--
--   1. weaponLocation = {"Back"} nao existe. "Back" e nome de bloodLocation (parte do corpo); os
--      nomes validos de fixacao sao os de shared/NPCs/AttachedLocations.lua, que sao outros
--      ("Axe Back", "Big Weapon On Back", "Rifle On Back with Bag"...). Os dois campos parecem
--      aceitar a mesma coisa e nao aceitam.
--   2. Sem o campo `outfit`, a definicao nao fica escopada a traje nenhum. 62 das 142 definicoes
--      do jogo usam esse campo; e por ele que o vanilla mira o survivalista.
--   3. Zumbi survivalista usa mochila, e para esse caso o vanilla nao usa "Big Weapon On Back"
--      (que e a variante sem mochila) -- em :1462 ele deixa "Big Weapon On Back with Bag"
--      comentado e usa "Rifle On Back with Bag".
--   4. bloodLocations/addHoles sao semantica de arma CRAVADA no corpo (spearStomach). Arma
--      carregada nas costas vai com bloodLocations = nil e addHoles = false, como as 67
--      definicoes do jogo que fazem isso.
--   5. daySurvived = 45 era gate redundante: quem carrega a progressao temporal e o proprio
--      traje _Late, e por isso toda a familia meleeInBackBag_* do jogo usa daySurvived = 0.
if #weapons > 0 then
    AttachedWeaponDefinitions.siddigoSurvivorBackBag_Late = {
        id = "siddigoSurvivorBackBag_Late",
        -- `chance` e peso relativo, nao percentual: o jogo soma a de todas as definicoes elegiveis
        -- e sorteia uma proporcionalmente (AttachedWeaponDefinitions.lua:12). Censo do pool de um
        -- Survivalist_Late em mundo novo: 58 definicoes elegiveis somando 2305. Entao 2 aqui vale
        -- ~0,09% dos sorteios, e o gate global ChanceOfAttachedWeapon (padrao 6) ainda multiplica
        -- por cima. Numero deliberadamente raro: e arma de sobrevivente, nao equipamento padrao.
        chance = 2,
        outfit = {
            "Survivalist_Late",
            "Survivalist02_Late",
            "Survivalist03_Late",
            "Survivalist04_Late",
            "Survivalist05_Late",
        },
        weaponLocation = {"Rifle On Back with Bag"},
        bloodLocations = nil,
        addHoles = false,
        daySurvived = 0,
        weapons = weapons,
    }
end
