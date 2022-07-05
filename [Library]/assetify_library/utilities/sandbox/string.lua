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
    pairs = pairs,
    string = string,
    encodeString = encodeString,
    decodeString = decodeString
}


-----------------------
--[[ Class: String ]]--
-----------------------

local string = class:create("string", utf8)
for i, j in imports.pairs(imports.string) do
    string.public[i] = (not string.public[i] and j) or string.public[i]
end

local __string_gsub = string.public.gsub
function string.public.gsub(baseString, matchWord, replaceWord, matchLimit, isStrictcMatch, matchPrefix, matchPostfix)
    matchPrefix, matchPostfix = (matchPrefix and (imports.type(matchPrefix) == "string") and matchPrefix) or "", (matchPostfix and (imports.type(matchPostfix) == "string") and matchPostfix) or ""
    matchWord = (isStrictcMatch and "%f[^"..matchPrefix.."%z%s]"..matchWord.."%f["..matchPostfix.."%z%s]") or matchPrefix..matchWord..matchPostfix
    return __string_gsub(baseString, matchWord, replaceWord, matchLimit)
end

function string.public.decode(type, baseString, options, clipNull)
    if not baseString or (imports.type(baseString) ~= "string") then return false end
    local rawString = imports.decodeString(type, baseString, options)
    return (rawString and clipNull and string.public.gsub(rawString, string.char(0), "")) or rawString
end