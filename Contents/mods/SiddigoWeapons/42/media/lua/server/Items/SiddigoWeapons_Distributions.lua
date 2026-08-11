-- Distribuicao de loot do SiddigoWeapons.
-- Escrita direta: ProceduralDistributions nao tem merge.

require "Items/ProceduralDistributions"

local function addToProcList(listName, fullType, weight)
    ProceduralDistributions.list[listName] = ProceduralDistributions.list[listName] or {}
    local t = ProceduralDistributions.list[listName]
    t.items = t.items or {}
    table.insert(t.items, fullType)
    table.insert(t.items, weight)
end

-- Revista de receitas. Peso calibrado por lista, nao uniforme -- 2a passada em 10/08/2026.
-- A 1a passada (peso 1 uniforme) foi testada via LootZed e corrigida: peso do mesmo item
-- pode ser 100x maior ou menor entre listas no proprio vanilla (ex: SmithingMag1 vale 1 em
-- SurvivalGear e 0.01 em LivingRoomShelf), entao peso fixo nao reproduz a curva do jogo.
--
-- Metodo: em cada lista, o peso copia o de PrimitiveToolMag1 quando ela existe ali; senao
-- o de SmithingMag1. `rolls` e propriedade da lista (nao do item), entao igualar o peso na
-- mesma lista reproduz a chance da revista de referencia exatamente, sem mexer em rolls.
-- Censo contra ProceduralDistributions.lua: 19 das 27 listas tem uma das duas; as outras 8
-- (grupo Camping/Outdoor inteiro + BookstoreOutdoors) so tem HuntingMag1/FishingMag1 no
-- vanilla -- sem ancora em Primitive/Smithing ali, usam peso fixo 0.01 por decisao explicita.
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
