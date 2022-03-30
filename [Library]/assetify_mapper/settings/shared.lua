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
    toggleCursor = "mouse2", switchTranslation = "capslock", switchAxis = "tab",
    cloneObject = "c", deleteObject = "delete",
    speedUp = "lshift", speedDown = "space",
    valueUp = "num_add", valueDown = "num_sub",
    moveForwards = "forwards", moveBackwards = "backwards",
    moveLeft = "left", moveRight = "right"
}

availableColors = {
    success = {50, 255, 50, 255},
    error = {255, 50, 50, 255}
}