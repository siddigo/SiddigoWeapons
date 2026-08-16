-- Registro de identificadores do mod. Carregado antes dos scripts e de qualquer outro Lua.
-- O nome do arquivo e o local sao fixos: <versao>/media/registries.lua

SiddigoWeapons = SiddigoWeapons or {}
SiddigoWeapons.ItemTag = SiddigoWeapons.ItemTag or {}
SiddigoWeapons.AmmoType = SiddigoWeapons.AmmoType or {}

-- Tag da municao de estilingue
SiddigoWeapons.ItemTag.SlingAmmo = ItemTag.register("siddigoweapons:slingammo")

-- Tipo de municao: liga a arma ao item que serve de projetil.
-- 2o argumento e string "Modulo.Item" nesta build (42.20.2) -- ItemKey.new (forma do exemplo
-- oficial testmod_registries, 42.13) derruba o jogo ao ativar o mod: KahluaThread rejeita com
-- "expected argument of type String, got ItemKey" (zombie.scripting.objects.ModRegistries.init).
-- A API mudou entre 42.13 e 42.20.2, ou o exemplo nunca foi essa forma nesta build -- copie o
-- jogo instalado, nao o exemplo desatualizado.
SiddigoWeapons.AmmoType.SlingAmmo = AmmoType.register("siddigoweapons:slingammo", "SiddigoWeapons.SlingStone")
