----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: handlers: api: library: exports.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 19/10/2021
     Desc: Library APIs ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

manager:exportAPI("Library", {
    shared = {
        {name = "isLibraryBooted", API = "isBooted"},
        {name = "isLibraryLoaded", API = "isLoaded"},
        {name = "isModuleLoaded"},
        {name = "getLibraryAssets", API = "fetchAssets"},
        {name = "getAssetData"},
        {name = "getAssetDep"},
        {name = "setElementAsset"},
        {name = "getElementAssetInfo"},
        {name = "setGlobalData"},
        {name = "getGlobalData"},
        {name = "setEntityData"},
        {name = "getEntityData"},
        {name = "setAttachment"},
        {name = "setDetachment"},
        {name = "clearAttachment"},
        {name = "createAssetDummy"},
        {name = "setBoneAttachment"},
        {name = "syncBoneDetachment"},
        {name = "setBoneRefreshment"},
        {name = "clearBoneAttachment"}
    },
    client = {
        {name = "getDownloadProgress", API = "getDownloadProgress"},
        {name = "isAssetLoaded", API = "isAssetLoaded"},
        {name = "getAssetID", API = "getAssetID"},
        {name = "loadAsset", API = "loadAsset"},
        {name = "unloadAsset", API = "unloadAsset"},
        {name = "createShader", API = "createShader"},
        {name = "isRendererVirtualRendering", API = "isRendererVirtualRendering"},
        {name = "setRendererVirtualRendering", API = "setRendererVirtualRendering"},
        {name = "getRendererVirtualSource", API = "getRendererVirtualSource"},
        {name = "getRendererVirtualRTs", API = "getRendererVirtualRTs"},
        {name = "isRendererTimeSynced", API = "isRendererTimeSynced"},
        {name = "setRendererTimeSync", API = "setRendererTimeSync"},
        {name = "setRendererServerTick", API = "setRendererServerTick"},
        {name = "setRendererMinuteDuration", API = "setRendererMinuteDuration"},
        {name = "setRendererAntiAliasing", API = "setRendererAntiAliasing"},
        {name = "getRendererAntiAliasing", API = "getRendererAntiAliasing"},
        {name = "isRendererDynamicSky", API = "isRendererDynamicSky"},
        {name = "setRendererDynamicSky", API = "setRendererDynamicSky"},
        {name = "getRendererDynamicSunColor", API = "getRendererDynamicSunColor"},
        {name = "setRendererDynamicSunColor", API = "setRendererDynamicSunColor"},
        {name = "isRendererDynamicStars", API = "isRendererDynamicStars"},
        {name = "setRendererDynamicStars", API = "setRendererDynamicStars"},
        {name = "getRendererDynamicCloudDensity", API = "getRendererDynamicCloudDensity"},
        {name = "setRendererDynamicCloudDensity", API = "setRendererDynamicCloudDensity"},
        {name = "getRendererDynamicCloudScale", API = "getRendererDynamicCloudScale"},
        {name = "setRendererDynamicCloudScale", API = "setRendererDynamicCloudScale"},
        {name = "getRendererDynamicCloudColor", API = "getRendererDynamicCloudColor"},
        {name = "setRendererDynamicCloudColor", API = "setRendererDynamicCloudColor"},
        {name = "getRendererTimeCycle", API = "getRendererTimeCycle"},
        {name = "setRendererTimeCycle", API = "setRendererTimeCycle"},
        {name = "createPlanarLight", API = "createPlanarLight"},
        {name = "setPlanarLightResolution", API = "setPlanarLightResolution"},
        {name = "setPlanarLightTexture", API = "setPlanarLightTexture"},
        {name = "setPlanarLightColor", API = "setPlanarLightColor"}
    },
    server = {}
})