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
        ref = index, index = "", pointer = {}, value = "",
        isErrored = "Failed to decode vcl. [Line: %s] [Reason: %s]"
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
        if not __p.isType and not vcl.private.isVoid(char) then __p.isType, __p.isParsed = "object", true end
        if __p.isType == "object" then
            if not vcl.private.isVoid(char) then
                __p.index = __p.index..char
                print(__p.index.." - "..char)
            elseif not vcl.private.isVoid(__p.index) then
                if char == ":" then
                    print("Fetching | "..__p.index)
                    local value, __index, error = vcl.private.decode(buffer, index + 1, true)
                    if not error then
                        print(tostring(__p.index).." : "..tostring(value))
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
                vcl.private.fetchLine(buffer, (isChild and __p.ref) or index),
                ((__p.isType == "string") and "Unterminated string") or
                ((__p.isType == "number") and "Malformed number") or
                "Invalid declaration"
            )
            imports.outputDebugString(__p.isErrored)
        end
        return false, false, true
    elseif (__p.isType == "object") then return __p.pointer, index
    else return ((__p.isType == "number" and imports.tonumber(__p.value)) or __p.value), index end
end

vcl.public.decode = function(buffer)
    return vcl.private.decode(buffer)
end

--TESTS

setTimer(function()

    local test2 = [[
        indexC:
            subindexC1: "valueA"
    ]]
    local result = vcl.public.decode(test2)
    iprint(result)
end, 1000, 1)