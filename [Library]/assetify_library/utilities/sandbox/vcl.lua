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
    local __p = {
        isType = false,
        isParsed = (not isChild and true) or false, isErrored = "Failed to decode vcl. [Line: %s] [Reason: %s]",
        ref = (isChild and index) or false, index = "", pointer = {}, value = ""
    }
    while(index <= #buffer) do
        local char = vcl.private.fetch(buffer, index)
        if isChild then
            local isSkipAppend = false
            if not __p.isType or (__p.isType == "string") then
                if (not __p.isTypeChar and ((char == "\"") or (char == "\'"))) or (__p.isTypeChar and (__p.isTypeChar == char)) then
                    if not __p.isType then isSkipAppend, __p.isType, __p.isTypeChar = true, "string", char
                    else __p.isParsed = true end
                end
            end
            if not __p.isType or (__p.isType == "number") then
                local isNumber = imports.tonumber(char)
                if not __p.isType and isNumber then __p.isType = "number"
                elseif __p.isType then
                    if char == "." then
                        if not __p.isTypeFloat then __p.isTypeFloat = true
                        else break end
                    elseif (char == " ") or (char == "\n") then __p.isParsed = true
                    elseif not isNumber then break end
                end
            end
            if __p.isType and not isSkipAppend and not __p.isParsed then __p.value = __p.value..char end
        end
        __p.isType = ((not __p.isType and not vcl.private.isVoid(char)) and "object") or __p.isType
        if __p.isType == "object" then
            if not vcl.private.isVoid(char) then
                __p.index = __p.index..char
            elseif not vcl.private.isVoid(__p.index) then
                if char == ":" then
                    local value, __index = vcl.private.decode(buffer, index + 1, true)
                    if value then
                        print(__p.index)
                        __p.pointer[(__p.index)], index = value, __index
                        __p.index = ""
                    else
                        __p.isChildErrored = true
                        break
                    end
                else
                    __p.isParsed = false
                    break
                end
            end
        end
        index = index + 1
        if isChild and __p.isParsed then break end
    end
    __p.isParsed = (not __p.isChildErrored and __p.isParsed) or __p.isParsed
    if not __p.isParsed then
        if not __p.isChildErrored then
            __p.isErrored = string.format(
                __p.isErrored,
                vcl.private.fetchLine(buffer, __p.ref or index),
                ((__p.isType == "string") and "Unterminated string") or
                ((__p.isType == "number") and "Malformed number") or
                "Invalid declaration"
            )
            imports.outputDebugString(__p.isErrored)
        end
        return __p.isParsed, false, __p.isErrored
    elseif (__p.isType == "object") then return __p.pointer, index
    else return ((__p.isType == "number" and imports.tonumber(__p.value)) or __p.value), index end
end

vcl.public.decode = function(buffer)
    return vcl.private.decode(buffer)
end

--TESTS

setTimer(function()

    local test2 = [[
        indexB: 1
        indexA: "XD"
    ]]
    local result = vcl.public.decode(test2)
    iprint(result)
end, 1000, 1)