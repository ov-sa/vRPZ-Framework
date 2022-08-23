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

function vcl.private.parse(buffer, index, isChild)
    index = index or 1
    local __P = {
        isType = (not isChild and "object") or false,
        isParsed = (not isChild and true) or false, isErrored = "Failed to parse vcl. [Line: %s] [Reason: %s]",
        ref = (isChild and index) or false, index = "", pointer = {}, value = ""
    }
    while(index <= #buffer) do
        local char = vcl.private.fetch(buffer, index)
        if (__P.isType ~= "object") or not vcl.private.isVoid(char) then
            if __P.isType == "object" then
                __P.index = __P.index..char
                local __char = vcl.private.fetch(buffer, index + 1)
                if __char and (__char == ":") then
                    local value, __index = vcl.private.parse(buffer, index + 2, true)
                    if value then
                        __P.pointer[(__P.index)], index = value, __index
                        __P.index = ""
                    else
                        __P.isChildErrored = true
                        break
                    end
                end
            else
                local isSkipAppend = false
                if not __P.isType or (__P.isType == "object") then
                    --TODO: CHECK IF ITS OVJECT???
                    --[[
                    if (char == "\"") or (char == "\'") then
                        if not __P.isType then
                            isSkipAppend, __P.isType = true, "object"
                        else
                            __P.isParsed = true
                        end
                    end
                    ]]
                end
                if not __P.isType or (__P.isType == "string") then
                    if (not __P.isTypeChar and ((char == "\"") or (char == "\'"))) or (__P.isTypeChar and (__P.isTypeChar == char)) then
                        if not __P.isType then isSkipAppend, __P.isType, __P.isTypeChar = true, "string", char
                        else __P.isParsed = true end
                    end
                end
                if not __P.isType or (__P.isType == "number") then
                    local isNumber = imports.tonumber(char)
                    if not __P.isType and isNumber then __P.isType = "number"
                    elseif __P.isType then
                        if char == "." then
                            if not __P.isTypeFloat then __P.isTypeFloat = true
                            else break end
                        elseif (char == " ") or (char == "\n") then __P.isParsed = true
                        elseif not isNumber then break end
                    end
                end
                if __P.isType and not isSkipAppend and not __P.isParsed then __P.value = __P.value..char end
            end
        elseif (__P.isType == "object") and not vcl.private.isVoid(__P.index) then
            __P.isParsed = false
            break
        end
        index = index + 1
        if isChild and __P.isParsed then break end
    end
    __P.isParsed = (not __P.isChildErrored and __P.isParsed) or __P.isParsed
    if not __P.isParsed then
        if not __P.isChildErrored then
            __P.isErrored = string.format(
                __P.isErrored,
                vcl.private.fetchLine(buffer, __P.ref or index),
                ((__P.isType == "string") and "Unterminated string") or
                ((__P.isType == "number") and "Malformed number") or
                "Invalid declaration"
            )
            imports.outputDebugString(__P.isErrored)
        end
        return __P.isParsed, false, __P.isErrored
    elseif (__P.isType == "object") then return __P.pointer, index
    else return ((__P.isType == "number" and imports.tonumber(__P.value)) or __P.value), index end
end

vcl.public.parse = function(buffer)
    return vcl.private.parse(buffer)
end

--TESTS

setTimer(function()

    local test2 = [[
        index1: 1.02
        index2: "value2"
        index3: "value3"
        index4: "value4"
        index5: "value5"
        index6: "value6"
        index7: "value7"
    ]]
    local result = vcl.public.parse(test2)
    iprint(result)

end, 1000, 1)