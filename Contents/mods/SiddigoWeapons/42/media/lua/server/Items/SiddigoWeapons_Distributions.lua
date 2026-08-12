-- Distribuicao de loot do SiddigoWeapons.
-- Espelha media/lua/server/Items/ do jogo. BagsAndContainers e ProceduralDistributions
-- nao tem merge (escrita direta); Distributions tem (table.insert + MergeDistributionRecursive).

require "Items/Distribution_BagsAndContainers"
require "Items/Distributions"
require "Items/ProceduralDistributions"

local function addToBag(listName, fullType, weight)
    BagsAndContainers[listName] = BagsAndContainers[listName] or {}
    table.insert(BagsAndContainers[listName], fullType)
    table.insert(BagsAndContainers[listName], weight)
end

local function addToProcList(listName, fullType, weight)
    ProceduralDistributions.list[listName] = ProceduralDistributions.list[listName] or {}
    local t = ProceduralDistributions.list[listName]
    t.items = t.items or {}
    table.insert(t.items, fullType)
    table.insert(t.items, weight)
end

-- Le a opcao de spawn de um item. Ausente ou nil = ligado,
-- para nao tirar o loot de quem ja tem save.
local function spawns(optionName)
    local vars = SandboxVars and SandboxVars.SiddigoWeapons
    if not vars then return true end
    local v = vars[optionName]
    if v == nil then return true end
    return v == true
end

-- Skull Crusher: mochila do sobrevivente (todas as eras), abrigo/acampamento e listas de arma
-- improvisada. Conjunto 04-loot-de-sobrevivente, SPEC-01 e 03; gate de sandbox somado por
-- 05-opcoes-de-sandbox/SPEC-03. A rota visivel nas costas do zumbi e o AttachedWeaponDefinitions,
-- em arquivo proprio -- ver SiddigoWeapons_AttachedWeapons.lua.
if spawns("SpawnSkullCrusher") then
    -- SurvivorItems e a mesma tabela que SurvivorBag, SurvivorBag_Mid e SurvivorBag_Late usam em
    -- `items`, por referencia (Distribution_BagsAndContainers.lua:3240, :3255, :3270) -- inserir
    -- aqui alcanca as tres eras e chega ao zumbi pelo campo `bags` do traje.
    -- O nome da lista tem de existir: com nome errado, o `or {}` do addToBag cria uma tabela
    -- orfa e a insercao nao tem efeito nem erro.
    addToBag("SurvivorItems", "SiddigoWeapons.SkullCrusher", 2)

    -- Arma de tamanho real vai na mochila, nao em Outfit_Survivalist*.items -- essa lista e o
    -- bolso do zumbi e o vanilla so poe miudeza ali. Regua: peso e TwoHandWeapon. Ver
    -- Documentacao/jogo/distribuicao-loot.md, secao "Qual das duas cargas recebe arma".

    -- Listas onde o vanilla ja poe ferramenta de pedra.
    -- Museu (AnthropologyDisplay*) e antiquario (Antiques) ficam de fora de proposito.
    addToProcList("ImprovisedCrafts",  "SiddigoWeapons.SkullCrusher", 4)
    addToProcList("MeleeWeapons",      "SiddigoWeapons.SkullCrusher", 0.5)
    addToProcList("MeleeWeapons_Late", "SiddigoWeapons.SkullCrusher", 2)

    -- O abrigo e um conteiner da sala all, entao entra pelo merge de Distributions.
    local modDist = { all = {} }
    modDist.all.shelter = {
        items = {
            "SiddigoWeapons.SkullCrusher", 1,
        },
    }

    table.insert(Distributions, modDist)
end

-- Revista de receitas. O peso e por lista, nao uniforme: no vanilla o mesmo item varia ate 100x
-- entre listas (SmithingMag1 vale 1 em SurvivalGear e 0.01 em LivingRoomShelf), entao peso fixo
-- nao reproduz a curva.
--
-- Regra usada: copiar o peso de PrimitiveToolMag1 na lista, ou de SmithingMag1 se aquele nao
-- estiver ali -- igualar o peso na mesma lista reproduz a chance da revista de referencia, ja que
-- `rolls` e da lista e nao do item. O comentario ao lado de cada linha diz qual foi a ancora.
-- As 8 listas sem comentario (Camping/Outdoor e BookstoreOutdoors) nao tem nenhuma das duas no
-- vanilla e usam 0.01 fixo.
if spawns("SpawnSurvivorCraftMag1") then
    local mag = "SiddigoWeapons.SurvivorCraftMag1"

    -- Original (9)
    addToProcList("SurvivalGear",       mag, 1)     -- SmithingMag1
    addToProcList("Homesteading",       mag, 1)     -- SmithingMag1
    addToProcList("Hobbies",            mag, 1)     -- SmithingMag1
    addToProcList("CrateMagazines",     mag, 0.001) -- PrimitiveToolMag1
    addToProcList("MagazineRackMixed",  mag, 0.1)   -- SmithingMag1
    addToProcList("SafehouseBookShelf", mag, 1)     -- PrimitiveToolMag1
    addToProcList("ToolStoreBooks",     mag, 1)     -- SmithingMag1
    addToProcList("ShelfGeneric",       mag, 0.01)  -- SmithingMag1
    addToProcList("RecRoomShelf",       mag, 0.01)  -- SmithingMag1

    -- Sala de estar (7) -- todas SmithingMag1, exceto Classy (PrimitiveToolMag1, mesmo valor aqui)
    addToProcList("LivingRoomShelf",            mag, 0.01)
    addToProcList("LivingRoomShelfClassy",      mag, 0.01)
    addToProcList("LivingRoomShelfRedneck",     mag, 0.01)
    addToProcList("LivingRoomSideTable",        mag, 0.01)
    addToProcList("LivingRoomSideTableClassy",  mag, 0.01)
    addToProcList("LivingRoomSideTableRedneck", mag, 0.01)
    addToProcList("LivingRoomWardrobe",         mag, 0.01)

    -- Camping/outdoor (7) -- sem PrimitiveToolMag1/SmithingMag1 no vanilla; peso fixo 0.01
    addToProcList("CampingLockers",         mag, 0.01)
    addToProcList("CampingStoreBooks",      mag, 0.01)
    addToProcList("CrateCamping",           mag, 0.01)
    addToProcList("FishingStoreGear",       mag, 0.01)
    addToProcList("OutdoorSupplyMagazines", mag, 0.01)
    addToProcList("GarageFirearms",         mag, 0.01)
    addToProcList("Hunter",                 mag, 0.01)

    -- Livraria (4)
    addToProcList("BookstoreMisc",       mag, 0.1)  -- SmithingMag1
    addToProcList("BookstoreBlueCollar", mag, 0.1)  -- SmithingMag1
    addToProcList("BookstoreOutdoors",   mag, 0.01) -- sem ancora, peso fixo
    addToProcList("BookstoreCrafts",     mag, 0.5)  -- PrimitiveToolMag1
end
