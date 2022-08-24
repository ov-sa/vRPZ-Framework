----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: sandbox: vcl.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: VCL Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    tonumber = tonumber,
    outputDebugString = outputDebugString
}


--------------------
--[[ Class: vcl ]]--
--------------------

local vcl = class:create("vcl")

function vcl.private.isVoid(rw)
    return (not rw or (imports.type(rw) ~= "string") or not string.match(rw, "%w") and true) or false
end

function vcl.private.fetch(rw, index)
    return string.sub(rw, index, index)
end

function vcl.private.fetchLine(rw, index)
    return #string.split(string.sub(rw, 0, index), "\n")
end

function vcl.private.decode(buffer, index, isChild)
    index = index or 1
    local parser = {
        ref = index, index = "", pointer = {}, value = "",
        isErrored = "Failed to decode vcl. [Line: %s] [Reason: %s]"
    }
    while(index <= #buffer) do
        local character = vcl.private.fetch(buffer, index)
        local isChildValid = (isChild and true) or false
        if isChildValid then
            local isSkipAppend = false
            if not parser.isType or (parser.isType == "string") then
                if (not parser.isTypeChar and ((character == "\"") or (character == "\'"))) or (parser.isTypeChar and (parser.isTypeChar == character)) then
                    if not parser.isType then isSkipAppend, parser.isType, parser.isTypeChar = true, "string", character
                    else parser.isParsed = true end
                end
            end
            if not parser.isType or (parser.isType == "number") then
                local isNumber = imports.tonumber(character)
                if not parser.isType and isNumber then parser.isType = "number"
                elseif parser.isType then
                    if character == "." then
                        if not parser.isTypeFloat then parser.isTypeFloat = true
                        else break end
                    elseif (character == " ") or (character == "\n") then parser.isParsed = true
                    elseif not isNumber then break end
                end
            end
            if parser.isType and not isSkipAppend and not parser.isParsed then parser.value = parser.value..character end
        end
        parser.isType = ((not isChild or isChildValid) and (not parser.isType and not vcl.private.isVoid(character)) and "object") or parser.isType
        if parser.isType == "object" then
            if not vcl.private.isVoid(character) then
                parser.index = parser.index..character
            elseif not vcl.private.isVoid(parser.index) then
                if character == ":" then
                    print("FETCHING: "..parser.index)
                    local value, __index, error = vcl.private.decode(buffer, index + 1, true)
                    if not error then
                        print("RECEIVED: "..parser.index)
                        parser.pointer[(parser.index)], index = value, __index - 1
                        parser.index = ""
                        iprint(value)
                    else parser.isChildErrored = 1 end
                else parser.isChildErrored = 0 end
                if parser.isChildErrored then break end
            end
        end
        index = index + 1
        if isChild and not parser.isChildErrored and parser.isParsed then break end
    end
    parser.isParsed = (not parser.isChildErrored and ((parser.isType == "object") or parser.isParsed) and true) or false
    if not parser.isParsed then
        if not parser.isChildErrored or (parser.isChildErrored == 0) then
            parser.isErrored = string.format(
                parser.isErrored,
                vcl.private.fetchLine(buffer, parser.ref),
                ((parser.isType == "string") and "Unterminated string") or
                ((parser.isType == "number") and "Malformed number") or
                "Invalid declaration"
            )
            imports.outputDebugString(parser.isErrored)
        end
        return false, false, true
    elseif (parser.isType == "object") then return parser.pointer, index
    else return ((parser.isType == "number" and imports.tonumber(parser.value)) or parser.value), index end
end

vcl.public.decode = function(buffer)
    return vcl.private.decode(buffer)
end

--TESTS

setTimer(function()
local test2 = [[
# comment
rootA: 1.222
indexA:
    indexB: 1.222
    indexC: "valueC"
rootB: 1.222
]]
local result = vcl.public.decode(test2)
iprint(result)
end, 1000, 1)