----------------------------------------------------------------
--[[ Resource: Party Handler
     Script: handlers: party.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Party Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------


local imports = {
    isTimer = isTimer,
    tostring = tostring,
    setTimer = setTimer,
    killTimer = killTimer,
    getPlayerName = getPlayerName,
    outputChatBox = outputChatBox,
    removeElementData = removeElementData,
    addCommandHandler = addCommandHandler,
    string = string,
    assetify = assetify
}


---------------
--[[ Command ]]
---------------


imports.addCommandHandler("party", function(player, _, category, ...)
    if not category then
        return imports.outputChatBox("━━ Syntax: /party create/invite/accept/leave/kick", player, 255, 255, 255)
    end

    category = imports.string.lower(imports.tostring(category))
    local args = {...}
    if category == "create" then
        if getPlayerParty(player) then
            return imports.outputChatBox("━━ Party: Couldn't create a new parte because you are already in one.", player, 255, 0, 0)
        end
        
        local party = createParty(player)
        if party then
            return imports.outputChatBox("━━ Party: You have succesfully created a party.", player, 0, 255, 0)
        else
            return imports.outputChatBox("━━ Party: Party creation failed.", player, 255, 0, 0)
        end
    elseif category == "invite" then
        local target = getPlayerFromPartialName(args[1])
        if not target then
            return imports.outputChatBox("━━ Syntax: /party invite player", player, 255, 255, 255)
        end

        if target == player then
            return imports.outputChatBox("━━ Party: You can't invite yourself.", player, 255, 0, 0)
        end

        local party = getPlayerParty(player)
        if not party then
            return imports.outputChatBox("━━ Party: You need to be in a party.", player, 255, 0, 0)
        end

        local targetParty = getPlayerParty(target)
        if targetParty then
            return imports.outputChatBox("━━ Party: Player is already in a party.", player, 255, 0, 0)
        end

        if #party.members > FRAMEWORK_CONFIGS["Party"]["Max_Members"] then
            return imports.outputChatBox("━━ Party: The maximum amount of members are already in the party.", player, 255, 0, 0)
        end

        imports.outputChatBox("━━ Party: Request has been sent to the player.", player, 0, 255, 0)
        imports.outputChatBox("━━ Party: Type /party accept to join " .. imports.getPlayerName(player) .. "'s party. Invite expires after " .. FRAMEWORK_CONFIGS["Party"]["Accept_Time"] .. " seconds", target, 0, 255, 0)
        local timer = imports.setTimer(function()
            if imports.assetify.syncer.getEntityData(target, "party:request") then
                imports.removeElementData(target, "party:request")
            end
        end, FRAMEWORK_CONFIGS["Party"]["Accept_Time"] * 1000, 1)
        imports.assetify.syncer.setEntityData(target, "party:request", {player, timer})
    elseif category == "accept" then
        local request = imports.assetify.syncer.getEntityData(player, "party:request")
        if request then
            local party = getPlayerParty(request[1])
            if party ~= nil then
                invitePartyMember(party.id, player)
                imports.assetify.syncer.setEntityData(player, "party:request", nil)
                if imports.isTimer(request[2]) then imports.killTimer(request[2]) end
            end
        end
    elseif category == "leave" then
        local party = getPlayerParty(player)
        if not party then
            return imports.outputChatBox("━━ Party: You need to be in a party.", player, 255, 0, 0)
        end
        
        if party.leader == player then
            destroyParty(party.id)
            return imports.outputChatBox("━━ Party: The party has been destroyed.", player, 0, 255, 0)
        else
            removePartyMember(party.id, player)
            return imports.outputChatBox("━━ Party: You have left the party.", player, 0, 255, 0)
        end
    elseif category == "kick" then
        local target = getPlayerFromPartialName(args[1])
        if not target then
            return imports.outputChatBox("━━ Syntax: /party invite player", player, 255, 255, 255)
        end

        local party = getPlayerParty(player)
        if not party then
            return imports.outputChatBox("━━ Party: You need to be in a party.", player, 255, 0, 0)
        end

        if party.leader ~= player then
            return imports.outputChatBox("━━ Party: You need to be the leader of the party to kick someone.", player, 255, 0, 0)
        end

        local targetParty = getPlayerParty(target)
        if targetParty ~= party then
            return imports.outputChatBox("━━ Party: The player is not in your party.", player, 255, 0, 0)
        end

        removePartyMember(party.id, target)
        imports.outputChatBox("━━ Party: You have been kicked from the party.", target, 0, 255, 0)
        imports.outputChatBox("━━ Party: You have kicked " .. imports.getPlayerName(target) .. " from the party.", player, 0, 255, 0)
    else
        return false
    end
end, false, false)