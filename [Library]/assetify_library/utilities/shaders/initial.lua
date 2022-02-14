----------------------------------------------------------------
--[[ Resource: Assetify Library
     Script: utilities: shaders: initial.lua
     Server: -
     Author: OvileAmriam
     Developer(s): Aviril, Tron
     DOC: 19/10/2021 (OvileAmriam)
     Desc: Shader Initializer ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    pairs = pairs,
    dxCreateShader = dxCreateShader
}


-------------------
--[[ Variables ]]--
-------------------

Assetify_Shaders, Assetify_CShaders = {}, {}

Assetify_CShaders["Assetify_TextureClearer"] = imports.dxCreateShader(Assetify_Shaders["Assetify_TextureClearer"], 1000, 0, false, "all")