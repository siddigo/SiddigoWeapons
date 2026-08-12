-- Armas do mod nas costas do zumbi sobrevivente.
--
-- NAO MOVER PARA shared/. Em shared/ o SandboxVars ainda tem os valores DEFAULT do
-- sandbox-options.txt, nao os do mundo -- o gate abaixo leria sempre `true`, sem erro e sem log.
-- server/ carrega depois do SandboxOptions.load(). Contrato em
-- Documentacao/jogo/sandbox-options.md, secao "O que falha em silencio".

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

-- meleeInBackBag e a definicao que o traje survivalista referencia nas tres eras, e e de onde sai
-- o BaseballBat_Nails -- inserir aqui da a mesma frequencia dele. Declarar definicao propria nao
-- funciona: o traje so sorteia da sua lista curada. Contrato da camada em
-- Documentacao/jogo/definitions-lua.md, secao "A camada acima das definicoes".
--
-- Sao tabelas do JOGO: inserir, nunca substituir. O peso e por REPETICAO -- inserir duas vezes
-- dobra a chance, nao existe campo numerico aqui.
local ITEM = "SiddigoWeapons.SkullCrusher"
local ALVOS = { "meleeInBackBag", "meleeInBackBag_Mid", "meleeInBackBag_Late" }

if spawns("SpawnSkullCrusher") then
    for _, nome in ipairs(ALVOS) do
        local def = AttachedWeaponDefinitions[nome]
        if def and def.weapons then
            table.insert(def.weapons, ITEM)
            -- Descomentar conforme 06-tocha e 07-estilingue forem implementados.
            -- Atencao: so arma corpo-a-corpo comprida faz sentido nas costas.
            -- table.insert(def.weapons, "SiddigoWeapons.Torch")
        end
    end
end
