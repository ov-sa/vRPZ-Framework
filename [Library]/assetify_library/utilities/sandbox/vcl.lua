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
    local rwLines = string.split(string.sub(rw, 0, index), "\n")
    return math.max(1, #rwLines), rwLines[#rwLines] or ""
end

function vcl.private.parseComment(parser, buffer, rw)
    local isCommentLine = parser.isCommentLine
    parser.isCommentLine = vcl.private.fetchLine(buffer, parser.ref)
    parser.isComment = ((isCommentLine == parser.isCommentLine) and parser.isComment) or false
    parser.isComment = (not parser.isComment and (not parser.isType or vcl.private.isVoid(parser.index)) and not parser.isComment and (rw == "#") and true) or parser.isComment
    return true
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

function vcl.private.parseObject(parser, buffer, rw, isTypePadding, isChild)
    if not parser.isComment and (parser.isType == "object") then
        if not vcl.private.isVoid(rw) then
            parser.index = parser.index..rw
        elseif not vcl.private.isVoid(parser.index) then
            if rw == ":" then
                if not isChild then
                    print(parser.index)
                    print(string.sub(buffer, parser.ref, #buffer))
                end
                local _, indexLine = vcl.private.fetchLine(string.sub(buffer, 0, parser.ref))
                parser.isTypePadding = #indexLine - #parser.index - 1
                local isAllowed = false
                if not isTypePadding then isAllowed = true
                elseif parser.isTypePadding > isTypePadding then isAllowed = true end
                if isAllowed then
                    if not isChild then
                        print("Fetched Index: "..parser.index.." | Parent: "..(isTypePadding or "-").." | Child: "..parser.isTypePadding)
                    end
                else
                    if not isChild then
                        print("Ignored Index: "..parser.index.." | Parent: "..(isTypePadding or "-").." | Child: "..parser.isTypePadding)
                    end
                    parser.ref = parser.ref - #parser.index
                    return false
                end
                local value, __index, error = vcl.private.decode(buffer, parser.ref + 1, true)
                if not error then
                    if not isChild then
                        print("Received Index: "..parser.index)
                        iprint(value)
                    end
                    parser.pointer[(parser.index)], parser.ref, parser.index = value, __index - 1, ""
                    vcl.private.parseComment(parser, buffer, vcl.private.fetch(buffer, parser.ref))
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
                vcl.private.fetchLine(buffer, parser.ref),
                ((parser.isType == "string") and "Malformed string") or
                ((parser.isType == "number") and "Malformed number") or
                "Invalid declaration"
            )
            imports.outputDebugString(parser.isErrored)
        end
        return false, false, true
    elseif (parser.isType == "object") then return parser.pointer, parser.ref
    else return ((parser.isType == "number" and imports.tonumber(parser.value)) or parser.value), parser.ref end
end

function vcl.private.decode(buffer, ref, isChild)
    local parser = {
        ref = ref or 1, index = "", pointer = {}, value = "",
        isErrored = "Failed to decode vcl. [Line: %s] [Reason: %s]"
    }
    while(parser.ref <= #buffer) do
        local character = vcl.private.fetch(buffer, parser.ref)
        vcl.private.parseComment(parser, buffer, character)
        local isChildValid = (not parser.isComment and isChild and true) or false
        if isChildValid then
            parser.isSkipAppend = false
            if not vcl.private.parseString(parser, buffer, character) then break end
            if not vcl.private.parseNumber(parser, buffer, character) then break end
            if parser.isType and not parser.isSkipAppend and not parser.isParsed then parser.value = parser.value..character end
        end
        parser.isType = ((not isChild or isChildValid) and (not parser.isType and not vcl.private.isVoid(character)) and "object") or parser.isType
        local result = vcl.private.parseObject(parser, buffer, character, parser.isTypePadding, isChild)
        if not result or (result == -1) then break end
        if isChild and not parser.isChildErrored and parser.isParsed then break end
        parser.ref = parser.ref + 1
    end
    return vcl.private.parseReturn(parser, buffer)
end

vcl.public.decode = function(buffer)
    return vcl.private.decode(buffer)
end

--TESTS

setTimer(function()
local test = [[
A:
  B: "vB"
C: "vC"
]]
local result = vcl.public.decode(test)
iprint(result)
end, 1000, 1)
