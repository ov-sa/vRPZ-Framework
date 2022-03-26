----------------------------------------------------------------
--[[ Resource: Assetify Mapper
     Script: settings: shared.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/03/2022
     Desc: Shared Settings ]]--
----------------------------------------------------------------


------------------
--[[ Settings ]]--
------------------

resource = getResourceRootElement(getThisResource())

availableControlSpeeds = {normal = 1, slow = 0.2, fast = 3}
availableControls = {
    speedUp = "lshift",
    speedDown = "space",
    toggleCursor = "mouse2",
    moveForwards = "forwards",
    moveBackwards = "backwards",
    moveLeft = "left",
    moveRight = "right"
}