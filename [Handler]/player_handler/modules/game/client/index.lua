----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: game: client: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
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
    table = table,
    beautify = beautify
}


----------------------
--[[ Module: Game ]]--
----------------------

CGame.CFont = {}

CGame.createFont = function(index, size)
    if not index or not size then return false end
    local cData = FRAMEWORK_CONFIGS["Templates"]["Fonts"][index]
    if not cData then return false end
    local cLanguage = CPlayer.getLanguage()
    local cResource, cSettings = nil, cData.alt and cData.alt[cLanguage]
    if cSettings then cResource = cSettings[3]
    else cResource = cData.resource end
    local cPath, cSize = ((cResource and ":"..cResource.."/") or "")..((cSettings and cSettings[1]) or cData.path), (cSettings and cSettings[2] and (cSettings[2]*size)) or size
    if CGame.CFont[index] and CGame.CFont[index][size] then return CGame.CFont[index][size] end
    local cFont = imports.beautify.native.createFont(cPath, cSize)
    if not cFont then return false end
    CGame.CFont[index] = CGame.CFont[index] or {}
    CGame.CFont[index][size] = {instance = cFont}
    return CGame.CFont[index][size]
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

imports.addEvent("Client:onUpdateLanguage", false)
imports.addEventHandler("Client:onUpdateLanguage", root, function(prevLanguage, currLanguage)
    for i, j in imports.pairs(CGame.CFont) do
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
