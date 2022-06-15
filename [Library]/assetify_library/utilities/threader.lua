----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: threader.lua
     Author: vStudio
     Developer(s): Aviril, Tron
     DOC: 19/10/2021
     Desc: Threader Utilities ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    type = type,
    unpack = unpack,
    tonumber = tonumber,
    setmetatable = setmetatable,
    collectgarbage = collectgarbage,
    setTimer = setTimer,
    isTimer = isTimer,
    killTimer = killTimer,
    coroutine = coroutine,
    math = math
}


-------------------------
--[[ Class: Threader ]]--
-------------------------

threader = {
    buffer = {}
}
threader.__index = threader

function threader:isInstance(cThread)
    if not self or (imports.type(cThread) ~= "table") then return false end
    if self == threader then return (cThread.isThread and true) or false end
    return (self.isThread and true) or false
end

function threader:create(exec)
    if not exec or imports.type(exec) ~= "function" then return false end
    local cThread = imports.setmetatable({}, {__index = self})
    cThread.isThread = true
    cThread.syncRate = {}
    cThread.threader = imports.coroutine.create(exec)
    threader.buffer[cThread] = true
    return cThread
end

function threader:createHeartbeat(conditionExec, exec, rate)
    if not conditionExec or not exec or (imports.type(conditionExec) ~= "function") or (imports.type(exec) ~= "function") then return false end
    rate = imports.math.max(imports.tonumber(rate) or 0, 1)
    return threader:create(function(self)
      while(conditionExec()) do
        self:pause()
      end
      exec()
      conditionExec, exec = nil, nil
    end):resume({
      executions = 1,
      frame = rate
    })
end

function threader:destroy()
    if not self or (self == threader) then return false end
    if self.timer and imports.isTimer(self.timer) then
        imports.killTimer(self.timer)
    end
    threader.buffer[self] = nil
    self = nil
    imports.collectgarbage()
    return true
end

function threader:status()
    if not self or (self == threader) then return false end
    if not self.threader then
        return "dead"
    else
        return imports.coroutine.status(self.threader)
    end
end

function threader:pause()
    return imports.coroutine.yield()
end

function threader:resume(syncRate)
    if not self or (self == threader) then return false end
    self.syncRate.executions = (syncRate and imports.tonumber(syncRate.executions)) or false
    self.syncRate.frames = (self.syncRate.executions and syncRate and imports.tonumber(syncRate.frames)) or false
    if self.syncRate.executions and self.syncRate.frames then
        self.timer = imports.setTimer(function()
            if self.isAwaiting then return false end
            if self:status() == "suspended" then
                for i = 1, self.syncRate.executions, 1 do
                    if self.isAwaiting then return false end
                    if self:status() == "dead" then return self:destroy() end
                    imports.coroutine.resume(self.threader, self)
                end
            end
            if self:status() == "dead" then self:destroy() end
        end, self.syncRate.frames, 0)
    else
        if self.isAwaiting then return false end
        if self.timer and imports.isTimer(self.timer) then
            imports.killTimer(self.timer)
        end
        if self:status() == "suspended" then
            imports.coroutine.resume(self.threader, self)
        end
        if self:status() == "dead" then self:destroy() end
    end
    return true
end

function threader:sleep(duration)
    duration = imports.math.max(0, imports.tonumber(duration) or 0)
    if not self or (self == threader) then return false end
    if self.timer and imports.isTimer(self.timer) then return false end
    self.isAwaiting = "sleep"
    self.timer = imports.setTimer(function()
        self:resume()
    end, duration, 1)
    self:pause()
    return true
end

function threader:await(exec)
    if not self or (self == threader) then return false end
    if not exec or imports.type(exec) ~= "function" then return self:resolve(exec) end
    self.isAwaiting = "promise"
    exec(self)
    threader:pause()
    local resolvedValues = self.awaitingValues
    self.awaitingValues = nil
    return imports.unpack(resolvedValues)
end

function threader:resolve(...)
    if not self or (self == threader) then return false end
    if not self.isAwaiting or (self.isAwaiting ~= "promise") then return false end
    self.isAwaiting = nil
    self.awaitingValues = {...}
    local self = self
    imports.setTimer(function()
        self:resume()
    end, 1, 1)
    return true
end

function async(...) return threader:create(...) end