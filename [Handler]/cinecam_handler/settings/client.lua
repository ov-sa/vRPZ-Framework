----------------------------------------------------------------
--[[ Resource: Cinematic Camera Handler
     Script: settings: client.lua
     Server: -
     Author: vStudio
     Developer: -
     DOC: 13/10/2019 (vStudio)
     Desc: Client Sided Settings ]]--
----------------------------------------------------------------


------------------
--[[ Settings ]]--
------------------

resource = getResourceRootElement(getThisResource())
blurStrength = 6

availableCinemationPoints = {

    {
        cameraStart = {x = 2551.50146484375, y = -1667.528686523438, z = 48.12009811401367},
        cameraStartLook = {x = 2550.865234375, y = -1667.528564453125, z = 47.34856414794922},
        cameraEnd = {x = 2397.070556640625, y = -1660.260009765625, z = 14.6624002456665},
        cameraEndLook = {x = 2398.056884765625, y = -1660.214111328125, z = 14.50369930267334},
        cinemationDuration = 8500
    },

    {
        cameraStart = {x = 2656.0268554688, y = -1755.9916992188, z = 37.880844116211},
        cameraStartLook = {x = 2755.3369140625, y = -1758.2503662109, z = 26.374568939209},
        cameraEnd = {x = 2812.7878417969, y = -1764.4494628906, z = 50.781707763672},
        cameraEndLook = {x = 2909.6337890625, y = -1770.3770751953, z = 26.579612731934},
        cinemationDuration = 8500
    },

    {
        cameraStart = {x = -918.24700927734, y = 1297.5876464844, z = 36.686199188232},
        cameraStartLook = {x = -919.46997070313, y = 1295.9678955078, z = 37.071399688721},
        cameraEnd = {x = -857.88909912109, y = 1783.3575439453, z = 88.140602111816},
        cameraEndLook = {x = -871.23498535156, y = 1675.9477539063, z = 76.763389587402},
        cinemationDuration = 20000
    },

    {
        cameraStart = {x = -238.1817932128906, y = 112.8569030761719, z = 94.99420166015625},
        cameraStartLook = {x = -238.0286712646484, y = 113.3094940185547, z = 94.11573028564453},
        cameraEnd = {x = -107.7714004516602, y = -185.5608062744141, z = 82.71489715576172},
        cameraEndLook = {x = -107.4400253295898, y = -186.4563293457031, z = 82.41788482666016},
        cinemationDuration = 7500
    }

}