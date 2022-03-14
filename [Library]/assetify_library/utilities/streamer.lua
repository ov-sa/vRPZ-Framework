----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: streamer.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Streamer Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    isElement = isElement,
    addEventHandler = addEventHandler,
    attachElements = attachElements,
    setmetatable = setmetatable,
    setTimer = setTimer,
    isElementOnScreen = isElementOnScreen,
    getElementDimension = getElementDimension,
    getElementInterior = getElementInterior,
    setElementDimension = setElementDimension,
    setElementInterior = setElementInterior
}


-------------------------
--[[ Class: Streamer ]]--
-------------------------

streamer = {
    buffer = {},
    cache = {}
}
streamer.__index = streamer

function streamer:create(...)
    local cStreamer = imports.setmetatable({}, {__index = self})
    if not cStreamer:load(...) then
        cStreamer = nil
        return false
    end
    return cStreamer
end

function streamer:destroy(...)
    if not self or (self == streamer) then return false end
    return self:unload(...)
end

function streamer:load(streamerInstance, streamType, occlusionInstances)
    if not self or (self == streamer) then return false end
    if not streamerInstance or not streamType or not imports.isElement(streamerInstance) or not occlusionInstances or not occlusionInstances[1] or not imports.isElement(occlusionInstances[1]) then return false end
    self.streamer = streamerInstance
    self.streamType = streamType
    self.occlusions = occlusionInstances
    local streamDimension, streamInterior = imports.getElementDimension(occlusionInstances[1]), imports.getElementInterior(occlusionInstances[1])
    if streamerInstance ~= occlusionInstances[1] then
        if streamType ~= "bone" then
            imports.attachElements(streamerInstance, occlusionInstances[1])
        end
        imports.setElementDimension(streamerInstance, streamDimension)
        imports.setElementInterior(streamerInstance, streamInterior)
    end
    streamer.buffer[streamDimension] = streamer.buffer[streamDimension] or {}
    streamer.buffer[streamDimension][streamInterior] = streamer.buffer[streamDimension][streamInterior] or {}
    streamer.buffer[streamDimension][streamInterior][streamType] = streamer.buffer[streamDimension][streamInterior][streamType] or {}
    streamer.buffer[streamDimension][streamInterior][streamType][self] = true
    return true
end

function streamer:unload()
    if not self or (self == streamer) then return false end
    local streamType = self.streamType
    local streamDimension, streamInterior = imports.getElementDimension(self.streamer), imports.getElementInterior(self.streamer)
    streamer.buffer[(streamDimension)][streamInterior][streamType][self] = nil
    self = nil
    return true
end

function streamer:update(clientDimension, clientInterior)
    if not clientDimension and not clientInterior then return false end
    local currentDimension, currentInterior = imports.getElementDimension(localPlayer), imports.getElementInterior(localPlayer)
    clientDimension, clientInterior = clientDimension or _clientDimension, clientInterior or clientInterior
    if streamer.waterBuffer then
        imports.setElementDimension(streamer.waterBuffer, currentDimension)
        imports.setElementInterior(streamer.waterBuffer, currentInterior)
    end
    if streamer.buffer[clientDimension] and streamer.buffer[clientDimension][clientInterior] then
        for i, j in imports.pairs(streamer.buffer[clientDimension][clientInterior]) do
            if j then
                imports.setElementDimension(i.streamer, streamerSettings.unsyncDimension)
            end
        end
    end
    streamer.cache.clientWorld = streamer.cache.clientWorld or {}
    streamer.cache.clientWorld.dimension = currentDimension
    streamer.cache.clientWorld.interior = currentInterior
    return true
end

local onEntityStream = function(streamBuffer)
    for i, j in imports.pairs(streamBuffer) do
        if j then
            local isStreamed = false
            for k = 1, #i.occlusions, 1 do
                local v = i.occlusions[k]
                if imports.isElementOnScreen(v) then
                    isStreamed = true
                    break
                end
            end
            imports.setElementDimension(i.streamer, (isStreamed and clientDimension) or streamerSettings.unsyncDimension)
        end
    end
    return true
end

local onBoneStream = function(streamBuffer)
    if not streamBuffer then return false end
    for i, j in imports.pairs(streamBuffer) do
        if j then
            bone.buffer.element[(i.streamer)]:update()
        end
    end
    bone.cache = {}
    return true
end

imports.addEventHandler("onAssetifyLoad", root, function()
    streamer:update(imports.getElementDimension(localPlayer))
    imports.setTimer(function()
        local clientDimension, clientInterior = streamer.cache.clientWorld.dimension, streamer.cache.clientWorld.interior
        if streamer.buffer[clientDimension] and streamer.buffer[clientDimension][clientInterior] then
            for i, j in imports.pairs(streamer.buffer[clientDimension][clientInterior]) do
                onEntityStream(j)
            end
        end
    end, streamerSettings.syncRate, 0)
    imports.addEventHandler("onClientPedsProcessed", root, function()
        local clientDimension, clientInterior = streamer.cache.clientWorld.dimension, streamer.cache.clientWorld.interior
        if streamer.buffer[clientDimension] and streamer.buffer[clientDimension][clientInterior] then
            onBoneStream(streamer.buffer[clientDimension][clientInterior]["bone"])
        end
    end)
end)