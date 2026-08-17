-- Distribuicao de loot do SiddigoWeapons. Espelha media/lua/server/Items/ do jogo.
--
-- NAO MOVER PARA shared/: o gate de sandbox so le o valor do mundo a partir de server/. Ver o
-- cabecalho de SiddigoWeapons_Sandbox.lua.

require "Items/Distribution_BagsAndContainers"
require "Items/Distributions"
require "Items/ProceduralDistributions"
require "SiddigoWeapons_Sandbox"

local MOD_LOOT = {
    {
        fullType = "SiddigoWeapons.SkullCrusher",
        sandboxOption = "SpawnSkullCrusher",

        -- SurvivorItems e a mesma tabela que SurvivorBag, SurvivorBag_Mid e SurvivorBag_Late usam
        -- em `items`, por referencia: uma insercao aqui alcanca as tres eras.
        bagLists = {
            SurvivorItems = 2,
        },

        -- Listas onde o vanilla ja poe ferramenta de pedra. Museu (AnthropologyDisplay*) e
        -- antiquario (Antiques) ficam de fora de proposito.
        proceduralLists = {
            ImprovisedCrafts  = 4,
            MeleeWeapons      = 0.5,
            MeleeWeapons_Late = 2,
        },

        -- Arma de tamanho real vai na mochila e no conteiner de sala, nunca no bolso do zumbi
        -- (`Outfit_*.items`). Regua: peso e TwoHandWeapon. Ver
        -- Documentacao/jogo/distribuicao-loot.md, secao "Qual das duas cargas recebe arma".
        roomContainers = {
            { room = "all", container = "shelter", weight = 1 },
        },
    },
    {
        fullType = "SiddigoWeapons.SurvivorCraftMag1",
        sandboxOption = "SpawnSurvivorCraftMag1",

        -- Peso de revista: copia o que PrimitiveToolMag1 -- ou SmithingMag1, quando aquele nao esta
        -- ali -- tem NA MESMA LISTA. `rolls` pertence a lista, entao peso igual reproduz a chance da
        -- revista ancora; peso fixo nao reproduziria, ja que no vanilla a mesma revista varia ate
        -- 100x entre listas. Lista sem nenhuma das duas ancoras fica com 0.01.
        proceduralLists = {
            SurvivalGear       = 1,
            Homesteading       = 1,
            Hobbies            = 1,
            CrateMagazines     = 0.001,
            MagazineRackMixed  = 0.1,
            SafehouseBookShelf = 1,
            ToolStoreBooks     = 1,
            ShelfGeneric       = 0.01,
            RecRoomShelf       = 0.01,

            LivingRoomShelf            = 0.01,
            LivingRoomShelfClassy      = 0.01,
            LivingRoomShelfRedneck     = 0.01,
            LivingRoomSideTable        = 0.01,
            LivingRoomSideTableClassy  = 0.01,
            LivingRoomSideTableRedneck = 0.01,
            LivingRoomWardrobe         = 0.01,

            CampingLockers         = 0.01,
            CampingStoreBooks      = 0.01,
            CrateCamping           = 0.01,
            FishingStoreGear       = 0.01,
            OutdoorSupplyMagazines = 0.01,
            GarageFirearms         = 0.01,
            Hunter                 = 0.01,

            BookstoreMisc       = 0.1,
            BookstoreBlueCollar = 0.1,
            BookstoreOutdoors   = 0.01,
            BookstoreCrafts     = 0.5,
        },
    },
    {
        fullType = "SiddigoWeapons.Torch",
        sandboxOption = "SpawnTorch",

        -- A versao acesa (TorchLit) nao entra em loot -- so existe depois de acender uma apagada,
        -- achada ou fabricada.
        bagLists = {
            SurvivorItems = 4,
        },

        proceduralLists = {
            ImprovisedCrafts  = 6,
            MeleeWeapons      = 0.5,
            MeleeWeapons_Late = 1.5,
        },

        roomContainers = {
            { room = "all", container = "shelter", weight = 1 },
        },
    },
    {
        fullType = "SiddigoWeapons.Slingshot",
        sandboxOption = "SpawnSlingshot",

        -- SubCategory = Firearm, nao Swinging: nao entra em MeleeWeapons/MeleeWeapons_Late, que sao
        -- listas de arma branca.
        bagLists = {
            SurvivorItems = 3,
        },

        proceduralLists = {
            ImprovisedCrafts = 4,
        },

        roomContainers = {
            { room = "all", container = "shelter", weight = 1 },
        },
    },
    {
        fullType = "SiddigoWeapons.SlingStone",
        sandboxOption = "SpawnSlingshot",

        -- Municao do estilingue: so na mochila, junto com a arma.
        bagLists = {
            SurvivorItems = 8,
        },
    },
}

local function warnLost(target, fullType)
    print("[SiddigoWeapons] " .. target .. " nao existe na tabela do jogo: " .. fullType
        .. " nao vai aparecer no loot.")
end

-- Toda lista de loot e plana e alternada: cada item custa duas insercoes, nome e peso. Inserir so o
-- nome desalinha o resto da lista, e o desalinhamento nao aparece na carga.
local function insertItemAndWeight(items, fullType, weight)
    table.insert(items, fullType)
    table.insert(items, weight)
end

local function addToBagList(listName, fullType, weight)
    local items = BagsAndContainers[listName]
    if not items then
        warnLost("BagsAndContainers." .. listName, fullType)
        return
    end
    insertItemAndWeight(items, fullType, weight)
end

local function addToProceduralList(listName, fullType, weight)
    local list = ProceduralDistributions.list[listName]
    if not list or not list.items then
        warnLost("ProceduralDistributions.list." .. listName, fullType)
        return
    end
    insertItemAndWeight(list.items, fullType, weight)
end

-- Conteiner de sala e a unica das tres rotas com merge: a tabela do mod entra no fim de
-- `Distributions` e o MergeDistributionRecursive concatena `items` por cima da do jogo. Sala ou
-- conteiner com nome errado nao da erro -- o merge trata a chave desconhecida como nova e a adiciona
-- num canto que ninguem le. Ver Documentacao/jogo/distribuicao-loot.md.
local function addToRoomContainer(roomDistributions, place, fullType)
    local gameRooms = Distributions[1]
    local gameRoom = gameRooms and gameRooms[place.room]
    if not (gameRoom and gameRoom[place.container]) then
        warnLost("Distributions." .. place.room .. "." .. place.container, fullType)
        return
    end

    local room = roomDistributions[place.room]
    if not room then
        room = {}
        roomDistributions[place.room] = room
    end

    local container = room[place.container]
    if not container then
        container = { items = {} }
        room[place.container] = container
    end

    insertItemAndWeight(container.items, fullType, place.weight)
end

local function applyLoot(loot, roomDistributions)
    for listName, weight in pairs(loot.bagLists or {}) do
        addToBagList(listName, loot.fullType, weight)
    end
    for listName, weight in pairs(loot.proceduralLists or {}) do
        addToProceduralList(listName, loot.fullType, weight)
    end
    for _, place in ipairs(loot.roomContainers or {}) do
        addToRoomContainer(roomDistributions, place, loot.fullType)
    end
end

local function distributeModLoot()
    local roomDistributions = {}

    for _, loot in ipairs(MOD_LOOT) do
        if SiddigoWeapons.isSpawnEnabled(loot.sandboxOption) then
            applyLoot(loot, roomDistributions)
        end
    end

    if next(roomDistributions) then
        table.insert(Distributions, roomDistributions)
    end
end

distributeModLoot()
