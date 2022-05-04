-----------------
--[[ Exports ]]--
-----------------

CGame.createExports({
    {exportName = "fetchCharacter", moduleName = "CCharacter", moduleMethod = "fetch"},
    {exportName = "fetchCharactersOwned", moduleName = "CCharacter", moduleMethod = "fetchOwned"},
    {exportName = "createCharacter", moduleName = "CCharacter", moduleMethod = "create"},
    {exportName = "deleteCharacter", moduleName = "CCharacter", moduleMethod = "delete"},
    {exportName = "setCharacterData", moduleName = "CCharacter", moduleMethod = "setData"},
    {exportName = "getCharacterData", moduleName = "CCharacter", moduleMethod = "getData"},
    {exportName = "resetCharacterProgress", moduleName = "CCharacter", moduleMethod = "resetProgress"},
    {exportName = "loadCharacterProgress", moduleName = "CCharacter", moduleMethod = "loadProgress"},
    {exportName = "saveCharacterProgress", moduleName = "CCharacter", moduleMethod = "saveProgress"}
})