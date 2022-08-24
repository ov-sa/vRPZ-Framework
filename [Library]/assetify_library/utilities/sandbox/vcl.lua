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

function vcl.private.parseString(parser, buffer, rw)
    if not parser.isType or (parser.isType == "string") then
        if (not parser.isTypeChar and ((rw == "\"") or (rw == "\'"))) or parser.isTypeChar then
            if not parser.isType then parser.isSkipAppend, parser.isType, parser.isTypeChar = true, "string", rw
            elseif rw == parser.isTypeChar then
                if not parser.isTypeParsed then parser.isSkipAppend, parser.isTypeParsed = true, true
                else return false end
            elseif parser.isTypeParsed then
                if rw == "\n" then parser.isParsed = true
                else return false end
            end
        end
    end
    return true
end

function vcl.private.parseNumber(parser, buffer, rw)
    if not parser.isType or (parser.isType == "number") then
        local isNumber = imports.tonumber(rw)
        if not parser.isType and isNumber then parser.isType = "number"
        elseif parser.isType then
            if rw == "." then
                if not parser.isTypeFloat then parser.isTypeFloat = true
                else return false end
            elseif rw == "\n" then parser.isParsed = true
            elseif not isNumber then return false end
        end
    end
    return true
end

function vcl.private.parseObject(parser, buffer, rw)
    if parser.isType == "object" then
        if not vcl.private.isVoid(rw) then
            parser.index = parser.index..rw
        elseif not vcl.private.isVoid(parser.index) then
            if rw == ":" then
                print("FETCHING: "..parser.index)
                local value, __index, error = vcl.private.decode(buffer, parser.refAt + 1, true)
                if not error then
                    print("RECEIVED: "..parser.index)
                    parser.pointer[(parser.index)], parser.refAt = value, __index - 1
                    parser.index = ""
                    iprint(value)
                else parser.isChildErrored = 1 end
            else parser.isChildErrored = 0 end
            if parser.isChildErrored then return false end
        end
    end
    return true
end

function vcl.private.parseReturn(parser, buffer)
    parser.isParsed = (not parser.isChildErrored and ((parser.isType == "object") or parser.isParsed) and true) or false
    if not parser.isParsed then
        if not parser.isChildErrored or (parser.isChildErrored == 0) then
            parser.isErrored = string.format(
                parser.isErrored,
                vcl.private.fetchLine(buffer, parser.refOn),
                ((parser.isType == "string") and "Malformed string") or
                ((parser.isType == "number") and "Malformed number") or
                "Invalid declaration"
            )
            imports.outputDebugString(parser.isErrored)
        end
        return false, false, true
    elseif (parser.isType == "object") then return parser.pointer, parser.refAt
    else return ((parser.isType == "number" and imports.tonumber(parser.value)) or parser.value), parser.refAt end
end

function vcl.private.decode(buffer, index, isChild)
    index = index or 1
    local parser = {
        refOn = index, refAt = index,
        index = "", pointer = {}, value = "",
        isErrored = "Failed to decode vcl. [Line: %s] [Reason: %s]"
    }
    while(parser.refAt <= #buffer) do
        local character = vcl.private.fetch(buffer, parser.refAt)
        local isChildValid = (isChild and true) or false
        if isChildValid then
            parser.isSkipAppend = false
            if not vcl.private.parseString(parser, buffer, character) then break end
            if not vcl.private.parseNumber(parser, buffer, character) then break end
            if parser.isType and not parser.isSkipAppend and not parser.isParsed then parser.value = parser.value..character end
        end
        parser.isType = ((not isChild or isChildValid) and (not parser.isType and not vcl.private.isVoid(character)) and "object") or parser.isType
        if not vcl.private.parseObject(parser, buffer, character) then break end
        if not parser.isType and character == "#" then
            print("COMMENT!")
        end
        parser.refAt = parser.refAt + 1
        if isChild and not parser.isChildErrored and parser.isParsed then break end
    end
    return vcl.private.parseReturn(parser, buffer)
end

vcl.public.decode = function(buffer)
    return vcl.private.decode(buffer)
end

--TESTS

setTimer(function()
local test2 = [[
    rootA: 1.222
    indexA:
        indexB: 1.222
        indexC: "valueC" SOMETHING INVALID EXISTS HERE FAIL TO LOAD??
    rootB: 1.222
]]
local result = vcl.public.decode(test2)
iprint(result)
end, 1000, 1)