-- Registro de identificadores do mod. Carregado antes dos scripts e de qualquer outro Lua.
-- O nome do arquivo e o local sao fixos: <versao>/media/registries.lua

SiddigoWeapons = SiddigoWeapons or {}
SiddigoWeapons.ItemTag = SiddigoWeapons.ItemTag or {}
SiddigoWeapons.AmmoType = SiddigoWeapons.AmmoType or {}

-- Tag da municao de estilingue
SiddigoWeapons.ItemTag.SlingAmmo = ItemTag.register("siddigoweapons:slingammo")

-- Tipo de municao: liga a arma ao item que serve de projetil.
-- 2o argumento e o item qualificado, como string. Modulo deste mod, nao Base.
SiddigoWeapons.AmmoType.SlingAmmo = AmmoType.register("siddigoweapons:slingammo", "SiddigoWeapons.SlingStone")
