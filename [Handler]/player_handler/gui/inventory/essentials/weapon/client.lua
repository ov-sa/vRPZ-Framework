----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: essentials: weapon: client.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Weapon's Essentials ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    addEvent = addEvent,
    addEventHandler = addEventHandler,
    cancelEvent = cancelEvent,
    triggerEvent = triggerEvent
}


---------------------------------------------
--[[ Event: On Client Player Weapon Fire ]]--
---------------------------------------------

imports.addEventHandler("onClientPlayerWeaponFire", root, function(_weapon, _ammo, _ammoInClip)
    if source ~= localPlayer and not isElementStreamedIn(source) then return false end
    local currentPlayerWeapon = getPlayerCurrentSlotItem(source, "weapon")
    if not currentPlayerWeapon then return false end
    local weaponAmmoName = getWeaponAmmoName(currentPlayerWeapon)
    if not weaponAmmoName then return false end

    if source == localPlayer then
        if weaponAmmoName ~= "Melee" then
            local weaponAmmoValue = tonumber(getElementData(source, "Item:"..weaponAmmoName)) or 0
            if weaponAmmoValue <= 0 then
                toggleControl("fire", false)
            else
                weaponAmmoValue = weaponAmmoValue - 1
                --setElementData(source, "Item:"..weaponAmmoName, weaponAmmoValue)
                if _ammo <= 1 then
                    toggleControl("fire", false)
                    --setElementData(source, "Item:"..weaponAmmoName, 0)
                elseif (_ammoInClip == serverWeaponFakeAmmoAmount) and (_ammoInClip < _ammo) then
                    setElementData(source, "Character:ReloadingWeapon", true)
                    toggleControl("fire", false)
                    toggleControl("aim_weapon", false)
                    triggerServerEvent("onPlayerWeaponReload", source)
                else
                    local weaponDetails = getItemDetails(currentPlayerWeapon)
                    if weaponDetails and weaponDetails.fireDelay and not isPlayerReloadingWeapon(source) then
                        toggleControl("fire", false)
                        Timer(function()
                            if not isPlayerReloadingWeapon(source) and isInventoryEnabled() then
                                toggleControl("fire", true)
                            end
                        end, weaponDetails.fireDelay, 1)
                    end
                end
            end
        else
            local weaponSlotID = getWeaponSlotID(currentPlayerWeapon)
            if not weaponSlotID then return false end
            if weaponSlotID == 16 then
                --setElementData(source, "Item:Grenade", (tonumber(getElementData(source, "Item:Grenade")) or 0) - 1)
            end
        end        
    end
    if playerVirtualWeaponCache[source] and playerVirtualWeaponCache[source].virtualWeapon and isElement(playerVirtualWeaponCache[source].virtualWeapon) then
        fireWeapon(playerVirtualWeaponCache[source].virtualWeapon)
        if source == localPlayer then
            triggerServerEvent("onClientPlayerRequestSyncWeaponFire", source)
        end
    end
end)

imports.addEvent("onClientPlayerSyncWeaponFire", true)
imports.addEventHandler("onClientPlayerSyncWeaponFire", root, function()
    imports.triggerEvent("onClientPlayerWeaponFire", source)
end)

imports.addEventHandler("onClientPlayerDamage", localPlayer, function(attacker, weapon, bodypart, lossPercent)
    imports.cancelEvent()
    processPlayerDamage(attacker, weapon, bodypart, lossPercent)
end)

imports.addEventHandler("onClientVehicleDamage", root, function(attacker, weapon, lossValue, _, _, _, tireID)
    processVehicleDamage(source, attacker, weapon, lossValue, tireID)
end)