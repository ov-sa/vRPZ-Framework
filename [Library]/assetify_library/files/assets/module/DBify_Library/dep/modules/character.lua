----------------------------------------------------------------
--[[ Resource: DBify Library
     Script: modules: character.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 11/10/2021
     Desc: Character Module ]]--
----------------------------------------------------------------


---------------------------
--[[ Module: Character ]]--
---------------------------

local cModule = dbify.createModule({
    moduleName = "character",
    tableName = "dbify_characters",
    structure = {
        {"id", "BIGINT AUTO_INCREMENT PRIMARY KEY"}
    }
})