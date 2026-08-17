-- Leitura das opcoes de sandbox do mod.
--
-- CHAMAR SO DE media/lua/server/. Em shared/ e client/ o SandboxVars ainda tem os valores DEFAULT
-- do sandbox-options.txt, entao o gate leria "ligado" mesmo com a opcao desmarcada -- sem erro e
-- sem log. Contrato em Documentacao/jogo/sandbox-options.md, secao "O que falha em silencio".

SiddigoWeapons = SiddigoWeapons or {}

-- optionName: nome do campo em sandbox-options.txt sem o namespace, ex. "SpawnSkullCrusher".
-- Opcao ausente conta como ligada, para nao tirar loot de quem ja tem save.
function SiddigoWeapons.isSpawnEnabled(optionName)
    local options = SandboxVars and SandboxVars.SiddigoWeapons
    if not options then return true end
    if options[optionName] == nil then return true end
    return options[optionName] == true
end
