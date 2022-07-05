----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: sandbox: string.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: String Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs
}


-----------------------
--[[ Class: String ]]--
-----------------------

local string = class:create("string", utf8)
for i, j in imports.pairs(imports.string) do
    string.public[i] = (not string.public[i] and j) or string.public[i]
end

local __string_gsub = string.public.gsub
string.public.gsub = function(string, matchWord, replaceWord, matchLimit, isStrictcMatch, matchPrefix, matchPostfix)
    matchPrefix, matchPostfix = (matchPrefix and (imports.type(matchPrefix) == "string") and matchPrefix) or "", (matchPostfix and (imports.type(matchPostfix) == "string") and matchPostfix) or ""
    matchWord = (isStrictcMatch and "%f[^"..matchPrefix.."%z%s]"..matchWord.."%f["..matchPostfix.."%z%s]") or matchPrefix..matchWord..matchPostfix
    return __string_gsub(string, matchWord, replaceWord, matchLimit)
end