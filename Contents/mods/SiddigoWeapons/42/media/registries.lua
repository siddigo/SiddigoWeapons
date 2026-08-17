-- Registro dos identificadores do mod. Nome e local sao fixos: <versao>/media/registries.lua, lido
-- antes de qualquer .txt -- sem ele, ID de namespace proprio nao existe para o parser.

SiddigoWeapons = SiddigoWeapons or {}
SiddigoWeapons.ItemTag = SiddigoWeapons.ItemTag or {}
SiddigoWeapons.AmmoType = SiddigoWeapons.AmmoType or {}

SiddigoWeapons.ItemTag.SlingAmmo = ItemTag.register("siddigoweapons:slingammo")

-- O 2o argumento e a string "Modulo.Item". NAO trocar por ItemKey.new (a forma do exemplo oficial
-- testmod_registries, que e 42.13): nesta build o registro rejeita o ItemKey e o mod nem carrega.
-- Ver Documentacao/jogo/scripts-txt.md, secao "Arma a distancia".
SiddigoWeapons.AmmoType.SlingAmmo = AmmoType.register("siddigoweapons:slingammo", "SiddigoWeapons.SlingStone")
