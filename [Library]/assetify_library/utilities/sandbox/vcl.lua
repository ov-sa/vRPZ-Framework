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
    pairs = pairs,
    tonumber = tonumber,
    outputDebugString = outputDebugString
}


--------------------
--[[ Class: VCL ]]--
--------------------

local vcl = class:create("vcl")
vcl.private.types = {
    init = ":",
    comment = "#",
    newline = "\n",
    carriageline = "\r",
    decimal = ".",
    bool = {
        ["true"] = "true",
        ["false"] = "false"
    },
    string = {
        ["`"] = true,
        ["'"] = true,
        ["\""] = true
    }
}

function vcl.private.isVoid(rw)
    return (not rw or (imports.type(rw) ~= "string") or not string.match(rw, "%w") and true) or false
end

function vcl.private.fetch(rw, index)
    return string.sub(rw, index, index)
end

function vcl.private.fetchLine(rw, index)
    local rwLines = string.split(string.sub(rw, 0, index), vcl.private.types.newline)
    return math.max(1, #rwLines), rwLines[(#rwLines)] or ""
end

function vcl.private.parseComment(parser, buffer, rw)
    local isCommentLine = parser.isCommentLine
    parser.isCommentLine = vcl.private.fetchLine(buffer, parser.ref)
    parser.isComment = ((isCommentLine == parser.isCommentLine) and parser.isComment) or false
    parser.isComment = (not parser.isComment and (not parser.isType or vcl.private.isVoid(parser.index)) and (rw == vcl.private.types.comment) and true) or parser.isComment
    return true
end

function vcl.private.parseBoolean(parser, buffer, rw)
    if not parser.isType or (parser.isType == "bool") then
        if not parser.isType then
            for i, j in imports.pairs(vcl.private.types.bool) do
                if string.sub(buffer, parser.ref, parser.ref + #i - 1) == i then
                    rw = i
                    break
                end
            end
        end
        if not parser.isType and vcl.private.types.bool[rw] then
            parser.isSkipAppend, parser.ref, parser.isType, parser.value = true, parser.ref + #rw - 1, "bool", rw
        elseif parser.isType then
            if rw == vcl.private.types.newline then parser.isSkipAppend, parser.isParsed = true, true
            else return false end
        end
    end
    return true
end

function vcl.private.parseString(parser, buffer, rw)
    if not parser.isType or (parser.isType == "string") then
        if (not parser.isTypeChar and vcl.private.types.string[rw]) or parser.isTypeChar then
            if not parser.isType then parser.isSkipAppend, parser.isType, parser.isTypeChar = true, "string", rw
            elseif rw == parser.isTypeChar then
                if not parser.isTypeParsed then parser.isSkipAppend, parser.isTypeParsed = true, true
                else return false end
            elseif parser.isTypeParsed then
                if rw == vcl.private.types.newline then parser.isParsed = true
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
            if rw == vcl.private.types.decimal then
                if not parser.isTypeFloat then parser.isTypeFloat = true
                else return false end
            elseif rw == vcl.private.types.newline then parser.isParsed = true
            elseif not parser.isTypeFloat and (rw == vcl.private.types.init) then parser.ref, parser.isType = parser.ref - #parser.value - 1, "object"
            elseif not isNumber then return false end
        end
    end
    return true
end

function vcl.private.parseObject(parser, buffer, rw, isChild)
    if not parser.isComment and (parser.isType == "object") then
        if not vcl.private.isVoid(rw) then
            parser.index = parser.index..rw
        elseif not vcl.private.isVoid(parser.index) then
            if rw == vcl.private.types.init then
                local _, indexLine = vcl.private.fetchLine(string.sub(buffer, 0, parser.ref))
                local indexPadding = #indexLine - #parser.index - 1
                parser.padding = parser.padding or indexPadding - 1
                if indexPadding <= parser.padding then
                    parser.ref = parser.ref - #parser.index
                    return false
                end
                local value, __index, error = vcl.private.decode(buffer, parser.ref + 1, indexPadding, true)
                if not error then
                    parser.pointer[(imports.tonumber(parser.index) or parser.index)], parser.ref, parser.index = value, __index - 1, ""
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
            parser.isErrored = string.format(parser.isErrored, vcl.private.fetchLine(buffer, parser.ref), (parser.isType and "Malformed "..parser.isType) or "Invalid declaration")
            imports.outputDebugString(parser.isErrored)
        end
        return false, false, true
    elseif (parser.isType == "object") then return parser.pointer, parser.ref
    elseif (parser.isType == "bool") then return ((parser.value == "true") and true) or false, parser.ref
    else return ((parser.isType == "number" and imports.tonumber(parser.value)) or parser.value), parser.ref end
end

function vcl.private.encode(buffer)
    print("uo")
    return 1
end
function vcl.public.encode(buffer) return vcl.private.encode(buffer) end

function vcl.private.decode(buffer, ref, padding, isChild)
    local parser = {
        ref = ref or 1, padding = padding,
        index = "", pointer = {}, value = "",
        isErrored = "Failed to decode vcl. [Line: %s] [Reason: %s]"
    }
    if not isChild then
        buffer = string.gsub(buffer, vcl.private.types.carriageline, "")
        buffer = (not isChild and (vcl.private.fetch(buffer, #buffer) ~= vcl.private.types.newline) and buffer..vcl.private.types.newline) or buffer
    end
    while(parser.ref <= #buffer) do
        vcl.private.parseComment(parser, buffer, vcl.private.fetch(buffer, parser.ref))
        local isChildValid = (not parser.isComment and isChild and true) or false
        if isChildValid then
            parser.isSkipAppend = false
            if not vcl.private.parseBoolean(parser, buffer, vcl.private.fetch(buffer, parser.ref)) then break end
            if not vcl.private.parseNumber(parser, buffer, vcl.private.fetch(buffer, parser.ref)) then break end
            if not vcl.private.parseString(parser, buffer, vcl.private.fetch(buffer, parser.ref)) then break end
            if parser.isType and not parser.isSkipAppend and not parser.isParsed then parser.value = parser.value..vcl.private.fetch(buffer, parser.ref) end
        end
        parser.isType = ((not isChild or isChildValid) and (not parser.isType and not vcl.private.isVoid(vcl.private.fetch(buffer, parser.ref))) and "object") or parser.isType
        if not vcl.private.parseObject(parser, buffer, vcl.private.fetch(buffer, parser.ref), isChild) then break end
        if isChild and not parser.isChildErrored and parser.isParsed then break end
        parser.ref = parser.ref + 1
    end
    return vcl.private.parseReturn(parser, buffer)
end
function vcl.public.decode(buffer) return vcl.private.decode(buffer) end


--TESTS

setTimer(function()
local data = file:read("test.vcl")
local result = vcl.public.decode(data)
end, 1000, 1)