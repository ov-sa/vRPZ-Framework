loadstring(exports.assetify_library:fetchImports())()

-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    pairs = pairs,
    unpack = unpack,
    md5 = md5,
    tonumber = tonumber,
    tostring = tostring,
    setmetatable = setmetatable,
    getResourceName = getResourceName,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    triggerEvent = triggerEvent,
    triggerClientEvent = triggerClientEvent,
    triggerServerEvent = triggerServerEvent,
    json = json,
    table = table
}


------------------------
--[[ Class: Network ]]--
------------------------

network = {
    identifier = imports.md5(imports.getResourceName(resource)),
    buffer = {},
    cache = {
        execSerials = {}
    }
}
network.__index = network

imports.addEvent("Assetify:Network:API")
imports.addEventHandler("Assetify:Network:API", root, function(serial, payload)
    if not serial or not payload or (payload.isRestricted and (serial ~= network.identifier)) then return false end
    if payload.processType == "emit" then
        local cNetwork = network:fetch(payload.networkName)
        if cNetwork and not cNetwork.isCallback then
            for i, j in imports.pairs(cNetwork.handlers) do
                if i and (imports.type(i) == "function") then
                    i(imports.unpack(payload.processArgs))
                end
            end
        end
    end
    --print("Got Response: "..iprint(payload))
end)

network.fetchArg = function(index, pool)
    index = imports.tonumber(index) or 1
    if not pool or (imports.type(pool) ~= "table") then return false end
    local argValue = pool[index]
    if (index > 0) and (index <= #pool) then imports.table.remove(pool, index) end
    return argValue
end

function network:create(...)
    local cNetwork = imports.setmetatable({}, {__index = self})
    if not cNetwork:load(...) then
        cNetwork = nil
        return false
    end
    return cNetwork
end

function network:destroy(...)
    if not self or (self == network) then return false end
    return self:unload(...)
end

function network:load(name, isCallback)
    if not self or (self == network) then return false end
    if not name or (imports.type(name) ~= "string") or network.buffer[name] then return false end
    self.name = name
    self.owner = network.identifier
    self.isCallback = (isCallback and true) or false
    if not self.isCallback then self.handlers = {} end
    network.buffer[name] = self
    return true
end

function network:unload()
    if not self or (self == network) then return false end
    network.buffer[(self.name)] = nil
    self = nil
    return true
end

function network:fetch(name)
    if not self or (self ~= network) then return false end
    return network.buffer[name] or false
end

function network:serializeExec(exec)
    if not self or (self ~= network) then return false end
    if not exec or (imports.type(exec) ~= "function") then return false end
    local cSerial = imports.md5(network.identifier..":"..imports.tostring(exec))
    network.cache.execSerials[cSerial] = exec
    return cSerial
end

function network:on(exec)
    if not self or (self == network) then return false end
    if not exec or (imports.type(exec) ~= "function") then return false end
    if self.isCallback then
        if not self.handler then
            self.handler = exec
            return true
        end
    else
        if not self.handlers[exec] then
            self.handlers[exec] = true
            return true
        end
    end
    return false
end

function network:emit(...)
    if not self then return false end
    local cArgs = {...}
    local payload = {
        isRemote = false,
        isRestricted = false,
        processType = "emit",
        networkName = false
    }
    if self == network then
        payload.networkName, payload.isRemote = network.fetchArg(_, cArgs), network.fetchArg(_, cArgs)
    else
        payload.isRestricted = true
        payload.networkName = self.name
    end
    payload.processArgs = cArgs
    if not payload.isRemote then
        imports.triggerEvent("Assetify:Network:API", root, network.identifier, payload)
    else
        --TODO: JUST TRIGGER THE EVENT TO EMIT ON SERVER SIDE
    end
    return true
end

function network:emitCallback(...)
    if not self then return false end
    local cArgs = {...}
    local cNetwork, isRemote = false, false
    if self == network then
        local name = network.fetchArg(_, cArgs)
        isRemote = network.fetchArg(_, cArgs)
        cNetwork = (not isRemote and network:fetch(name)) or cNetwork
        if isRemote then
            --TODO: JUST TRIGGER THE EVENT TO EMIT ON SERVER SIDE
            return true
        end
    else
        isRemote = network.fetchArg(_, cArgs)
        if not isRemote then cNetwork = self end
    end
    if not cNetwork or not cNetwork.isCallback or not cNetwork.handler then return false end
    return function() return cNetwork.handler(imports.unpack(cArgs)) end
end




-----------------------------------------------------------
--TODO: TESTING ZONE...
-----------------------------------------------------------

local cNetwork = network:create("TestEvent", false)
cNetwork:on(function(first, second)
    print("wew?")
    print(first.." : "..second)
    --return first + second
end)

--local value = network:emitCallback("TestEvent", false, 1, 2)()
--iprint(value) --3

cNetwork:emit("Arg1", "Arg2")
--network:destroy("TestEvent")
