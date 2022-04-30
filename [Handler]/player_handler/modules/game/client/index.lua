----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: game: client: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Game Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    tonumber = tonumber,
    destroyElement = destroyElement,
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    toJSON = toJSON,
    table = table,
    beautify = beautify,
    assetify = assetify
}


----------------------
--[[ Module: Game ]]--
----------------------

CGame.CSettings = {
    path = FRAMEWORK_CACHE.."settings.rw"
}
CGame.CFont = {
    static = {},
    dynamic = {}
}

CGame.fetchSettings = function(index)
    return CGame.CSettings.cache[index] or false
end

CGame.updateSettings = function(index, data)
    CGame.CSettings.cache[index] = data
    imports.file.write(CGame.CSettings.path, imports.toJSON(CGame.CSettings.cache))
    return true
end

CGame.createFont = function(index, size, isStatic)
    if not index or not size then return false end
    local cPool = (isStatic and CGame.CFont.static) or CGame.CFont.dynamic
    if cPool[index] and cPool[index][size] then return cPool[index][size] end
    local cData = FRAMEWORK_CONFIGS["Templates"]["Fonts"][index]
    if not cData then return false end
    local cLanguage = CPlayer.getLanguage()
    local cResource, cSettings = nil, cData.alt and cData.alt[cLanguage]
    if cSettings then cResource = cSettings[3]
    else cResource = cData.resource end
    local cPath, cSize = ((cResource and ":"..cResource.."/") or "")..((cSettings and cSettings[1]) or cData.path), (cSettings and cSettings[2] and (cSettings[2]*size)) or size
    local cFont = imports.beautify.native.createFont(cPath, cSize)
    if not cFont then return false end
    cPool[index] = cPool[index] or {}
    cPool[index][size] = {instance = cFont}
    return cPool[index][size]
end

CGame.isUIVisible = function()
    local uiStates = {
        not isPlayerInitialized(localPlayer),
        isLoginUIVisible(),
        isInventoryUIVisible(),
        isScoreboardUIVisible()
    }
    local state = false
    for i = 1, #uiStates, 1 do
        local j = uiStates[i]
        if j then
            state = true
            break
        end
    end
    return state
end

CGame.loadAnim = function(element, templateType, ...)
    if not FRAMEWORK_CONFIGS["Templates"]["Animations"][templateType] then return false end
    for i = 1, #FRAMEWORK_CONFIGS["Templates"]["Animations"][templateType], 1 do
        imports.assetify.loadAnim(element, FRAMEWORK_CONFIGS["Templates"]["Animations"][templateType][i], ...)
    end
    return true
end

CGame.unloadAnim = function(element, templateType, ...)
    if not FRAMEWORK_CONFIGS["Templates"]["Animations"][templateType] then return false end
    for i = 1, #FRAMEWORK_CONFIGS["Templates"]["Animations"][templateType], 1 do
        imports.assetify.unloadAnim(element, FRAMEWORK_CONFIGS["Templates"]["Animations"][templateType][i], ...)
    end
    return true
end

CGame.playSound = function(...)
    return imports.assetify.playSound(...)
end

CGame.playSound3D = function(...)
    return imports.assetify.playSound3D(...)
end

CGame.CSettings.cache = imports.file.read(CGame.CSettings.path)
CGame.CSettings.cache = (CGame.CSettings.cache and imports.fromJSON(CGame.CSettings.cache)) or {}

imports.addEvent("Client:onUpdateLanguage", false)
imports.addEventHandler("Client:onUpdateLanguage", root, function(prevLanguage, currLanguage)
    for i, j in imports.pairs(CGame.CFont.dynamic) do
        for k, v in imports.pairs(j) do
            local cData = FRAMEWORK_CONFIGS["Templates"]["Fonts"][i]
            if cData.alt then
                local cResource, cSettings = nil, cData.alt[currLanguage]
                if cData.alt[prevLanguage] or cSettings then
                    if cSettings then cResource = cSettings[3]
                    else cResource = cData.resource end
                    local cPath, cSize = ((cResource and ":"..cResource.."/") or "")..((cSettings and cSettings[1]) or cData.path), (cSettings and cSettings[2] and (cSettings[2]*k)) or k
                    local cFont = imports.beautify.native.createFont(cPath, cSize)
                    if cFont then
                        local __cFont = v.instance
                        v.instance = cFont
                        imports.destroyElement(__cFont)
                    end
                end
            end
        end
    end
    for i, j in imports.pairs(FRAMEWORK_CONFIGS["Templates"]["Beautify"]) do
        local isTemplateUpdated = false
        local cTemplate = imports.beautify.getUITemplate(i)
        if not cTemplate.isVRPZTemplate then
            cTemplate = imports.table.clone(j, true)
            isTemplateUpdated = true
        end
        if j.font then
            local cData = FRAMEWORK_CONFIGS["Templates"]["Fonts"][(j.font[1])]
            if cData.alt then
                local cResource, cSettings = nil, cData.alt and cData.alt[currLanguage]
                if cData.alt[prevLanguage] or cSettings then
                    if cSettings then cResource = cSettings[3]
                    else cResource = cData.resource end
                    local cPath, cSize = (cSettings and cSettings[1]) or cData.path, (cSettings and cSettings[2] and (cSettings[2]*j.font[2])) or j.font[2]
                    cTemplate.font = {cPath, cSize, cResource}
                    isTemplateUpdated = true
                end
            end
        end
        if isTemplateUpdated then
            imports.beautify.setUITemplate(i, cTemplate)
        end
    end
end)
