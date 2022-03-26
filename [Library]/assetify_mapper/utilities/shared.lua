----------------------------------------------------------------
--[[ Resource: Assetify Mapper
     Script: utilities: shared.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/03/2022
     Desc: Shared Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

if localPlayer then
    loadstring(exports.beautify_library:fetchImports())()
end
loadstring(exports.assetify_library:fetchImports())()
loadstring(exports.assetify_library:fetchThreader())()
