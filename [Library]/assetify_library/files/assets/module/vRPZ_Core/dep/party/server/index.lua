----------------------------------------------------------------
--[[ Resource: Party Handler
     Script: modules: party: server: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Party Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------


local imports = {
    triggerClientEvent = triggerClientEvent,
    table = {
        insert = table.insert,
        remove = table.remove
    }
}


----------------
--[[ Module ]]--
----------------


CParty = {}
CParty.CParties = {}


CParty.create = function(leader)
    local partyIndex = #CParty.CParties + 1
    CParty.CParties[partyIndex] = {
        id = partyIndex,
        leader = leader,
        members = {leader}
    }

    setPlayerParty(leader, CParty.CParties[partyIndex])
    return partyIndex
end

CParty.destroy = function(partyIndex)
    if not CParty.CParties[partyIndex] then return false end
    local partyMembers = CParty.CParties[partyIndex].members
    CParty.CParties[partyIndex] = nil
    setPlayerParty(partyMembers, nil)
    return true
end

CParty.getMembers = function(partyIndex)
    if not CParty.CParties[partyIndex] then return false end
    return CParty.CParties[partyIndex].members
end

CParty.getParty = function(partyIndex)
    if not CParty.CParties[partyIndex] then return false end
    return CParty.CParties[partyIndex]
end

CParty.invite = function(partyIndex, player)
    if not CParty.CParties[partyIndex] or not isPlayerInitialized(player) then return false end
    if getPlayerParty(player) ~= nil then return false end
    imports.table.insert(CParty.CParties[partyIndex].members, player)
    setPlayerParty(CParty.CParties[partyIndex].members, CParty.CParties[partyIndex])
    return true
end

CPlayer.remove = function(partyIndex, player)
    if not CParty.CParties[partyIndex] or not isPlayerInitialized(player) then return false end
    if getPlayerParty(player) == nil then return false end
    local memberIndex = binsearch(CParty.CParties[partyIndex].members, player)
    imports.table.remove(CParty.CParties[partyIndex].members, memberIndex[1])
    setPlayerParty(CParty.CParties[partyIndex].members, CParty.CParties[partyIndex])
    setPlayerParty(player, nil)
    return true
end