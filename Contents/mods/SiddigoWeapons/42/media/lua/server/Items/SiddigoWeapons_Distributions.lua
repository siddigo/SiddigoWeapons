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

-- Revista de receitas. As 9 listas foram escolhidas entre as 23 que o jogo usa para
-- revista de receita; as outras 14 (sala de estar, livraria, loja de armas, correio)
-- ficam de fora porque nao casam com publicacao de sobrevivencia caseira.
local mag = "SiddigoWeapons.SurvivorCraftMag1"

addToProcList("SurvivalGear",       mag, 6)
addToProcList("Homesteading",       mag, 4)
addToProcList("Hobbies",            mag, 3)
addToProcList("CrateMagazines",     mag, 3)
addToProcList("MagazineRackMixed",  mag, 2)
addToProcList("SafehouseBookShelf", mag, 3)
addToProcList("ToolStoreBooks",     mag, 2)
addToProcList("ShelfGeneric",       mag, 0.5)
addToProcList("RecRoomShelf",       mag, 1)
