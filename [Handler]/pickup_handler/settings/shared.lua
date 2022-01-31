----------------------------------------------------------------
--[[ Resource: Pickup Handler
     Script: settings: shared.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 22/03/2021 (OvileAmriam)
     Desc: Shared Settings ]]--
----------------------------------------------------------------


------------------
--[[ Settings ]]--
------------------

resource = getResourceRootElement(getThisResource())

pickupExpiryDuration = exports.config_loader:getConfigData("pickup_expiryDuration")