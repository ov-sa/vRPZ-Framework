----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: essentials: weapon: server.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Weapon's Essentials ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

local reloadTimers = {}


---------------------------------------
--[[ Event: On Element Data Change ]]--
---------------------------------------

addEventHandler("onElementDataChange", root, function(key, oldValue, newValue)

    if source:getType() == "player" and isPlayerInitialized(source) and key == "Character:ReloadingWeapon" then
        if not newValue then
            if reloadTimers[source] and reloadTimers[source]:isValid() then
                reloadTimers[source]:destroy()
                reloadTimers[source] = nil
            end
        end
    end

end)


------------------------------------------------------
--[[ Events: On Player Refresh Weapon/Weapon Ammo ]]--
------------------------------------------------------

local function refreshPlayerWeaponAmmo(player, weaponID, weaponAmmoName, weaponMagSize)

    weaponID = tonumber(weaponID)
    weaponMagSize = tonumber(weaponMagSize)
    if not player or not isElement(player) or player:getType() ~= "player" or not isPlayerInitialized(player) or not weaponID or not weaponAmmoName or not weaponMagSize then return false end
    local itemDetails = getItemDetails(weaponAmmoName)
    if not itemDetails then return false end

    if weaponAmmoName ~= "Melee" then
        local weaponAmmoValue = (tonumber(player:getData("Item:"..weaponAmmoName)) or 0)
        weaponAmmoValue = weaponAmmoValue*itemDetails.ammoAmount
        if weaponAmmoValue > 0 then
            setWeaponAmmo(player, weaponID, ((weaponAmmoValue <= weaponMagSize) and (weaponAmmoValue + serverWeaponFakeAmmoAmount)) or (weaponAmmoValue + serverWeaponFakeAmmoAmount), ((weaponAmmoValue <= weaponMagSize) and (weaponAmmoValue + serverWeaponFakeAmmoAmount)) or (weaponMagSize + serverWeaponFakeAmmoAmount))
        else
            setWeaponAmmo(player, weaponID, serverWeaponFakeAmmoAmount, serverWeaponFakeAmmoAmount)
        end
        triggerClientEvent(player, "onClientPlayerRefreshClip", player)
        return true
    end
    return false

end

addEvent("onPlayerRefreshWeaponAmmo", true)
addEventHandler("onPlayerRefreshWeaponAmmo", root, function(item)

    if not isPlayerInitialized(source) or not item then return false end
    local itemDetails, itemCategory = getItemDetails(item)
    if not itemDetails or not itemCategory or not inventoryDatas[itemCategory].isAmmoCategory then return false end

    for i, j in pairs(availableWeaponSlots) do
        local weaponDataName = getElementData(source, "Slot:"..i)
        if weaponDataName then
            local weaponID = getWeaponID(weaponDataName)
            local weaponAmmoName = getWeaponAmmoName(weaponDataName)
            local weaponMagSize = getWeaponMagSize(weaponDataName)
            if weaponID and weaponAmmoName and weaponAmmoName ~= "Melee" and weaponMagSize then
                refreshPlayerWeaponAmmo(source, weaponID, weaponAmmoName, weaponMagSize)
            end
        end
    end

end)

addEvent("onPlayerRefreshWeapon", true)
addEventHandler("onPlayerRefreshWeapon", root, function()

    if not isPlayerInitialized(source) then return false end

    takeAllWeapons(source)
    for i, j in pairs(availableWeaponSlots) do
        local weaponDataName = getElementData(source, "Slot:"..i)
        if weaponDataName then
            local weaponID = getWeaponID(weaponDataName)
            local weaponAmmoName = getWeaponAmmoName(weaponDataName)
            if weaponID and weaponAmmoName then
                if weaponAmmoName == "Melee" then
                    giveWeapon(source, weaponID, 1, true)
                else
                    local weaponMagSize = getWeaponMagSize(weaponDataName)
                    if weaponMagSize then
                        giveWeapon(source, weaponID, serverWeaponFakeAmmoAmount, true)
                        refreshPlayerWeaponAmmo(source, weaponID, weaponAmmoName, weaponMagSize)
                    end
                end
            end
        end
    end
    --updatePlayerBackpackWeapon(source)

end)


----------------------------------------
--[[ Event: On Player Weapon Reload ]]--
----------------------------------------

addEvent("onPlayerWeaponReload", true)
addEventHandler("onPlayerWeaponReload", root, function()

    if not isPlayerInitialized(source) then return false end

    local reloadWeaponState = false
    local currentPlayerWeapon = getPlayerCurrentSlotItem(source, "weapon")
    if currentPlayerWeapon then
        local weaponID = getWeaponID(currentPlayerWeapon)
        local weaponAmmoName = getWeaponAmmoName(currentPlayerWeapon)
        if weaponID and weaponAmmoName and weaponAmmoName ~= "Melee" then
            local itemDetails = getItemDetails(weaponAmmoName)
            if itemDetails then
                local weaponAmmoValue = tonumber(getElementData(source, "Item:"..weaponAmmoName)) or 0
                weaponAmmoValue = weaponAmmoValue*itemDetails.ammoAmount
                local weaponClipAmmo = source:getAmmoInClip()
                local weaponUnusedAmmo = source:getTotalAmmo() - weaponClipAmmo
                local weaponMagSize = getWeaponMagSize(currentPlayerWeapon)
                if (weaponAmmoValue > 0) and (weaponClipAmmo < (weaponMagSize + serverWeaponFakeAmmoAmount)) and (weaponUnusedAmmo > 0) then
                    if reloadTimers[source] and reloadTimers[source]:isValid() then reloadTimers[source]:destroy(); reloadTimers[source] = nil; end
                    refreshPlayerWeaponAmmo(source, weaponID, weaponAmmoName, weaponMagSize)
                    --if isPlayerReadyForAnimation(source) then
                        source:setAnimation("TEC", "TEC_reload", -1, false, false, false, false)
                    --end
                    --triggerClientEvent(source, "onClientWeaponReloadSound", source, weaponID)
                    reloadTimers[source] = Timer(function(player)
                        if player and isElement(player) and player:getType() == "player" then
                            player:setData("Character:ReloadingWeapon", nil)
                            --if isPlayerReadyForTask(player) then
                                toggleControl(player, "fire", true)
                                toggleControl(player, "aim_weapon", true)
                            --end
                            reloadTimers[player] = nil
                        end
                    end, 1500, 1, source)
                    reloadWeaponState = true
                end
            end
        end
    end

    if not reloadWeaponState then
        setElementData(source, "Character:ReloadingWeapon", nil)
        --if isPlayerReadyForTask(source) then
            toggleControl(source, "fire", true)
            toggleControl(source, "aim_weapon", true)
        --end
    end

end)