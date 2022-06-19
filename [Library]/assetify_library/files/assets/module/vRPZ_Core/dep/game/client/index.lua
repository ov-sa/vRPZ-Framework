-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    getLocalization = getLocalization,
    string = string,
    file = file,
    json = json,
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
    imports.file.write(CGame.CSettings.path, imports.json.encode(CGame.CSettings.cache))
    return true
end

CGame.loadLanguage = function()
    local cLanguage = CGame.fetchSettings("language")
    cLanguage = (cLanguage and FRAMEWORK_CONFIGS["Game"]["Game_Languages"][cLanguage] and cLanguage) or false
    if not cLanguage then
        local localization = imports.getLocalization()
        CPlayer.setLanguage(localization.code, true)
    else
        CPlayer.setLanguage(cLanguage)
    end
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
        not CPlayer.isInitialized(localPlayer),
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

for i, j in imports.pairs(FRAMEWORK_CONFIGS["Templates"]["Roles"]) do
    if i ~= "default" then
        j.badge = imports.assetify.getAssetDep("module", "vRPZ_HUD", "texture", "role:".. imports.string.gsub(imports.string.lower(i), " ", "_"))
    end
end
CGame.CSettings.cache = imports.file.read(CGame.CSettings.path)
CGame.CSettings.cache = (CGame.CSettings.cache and imports.json.decode(CGame.CSettings.cache)) or {}