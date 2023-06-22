----------------------------------------------------------------
--[[ Resource: DBify Library
     Script: modules: account.lua
     Author: vStudio
     Developer(s): Aviril, Tron, Mario, Аниса
     DOC: 11/10/2021
     Desc: Account Module ]]--
----------------------------------------------------------------


-----------------
--[[ Imports ]]--
-----------------

local imports = {
    getElementsByType = getElementsByType,
    addEventHandler = addEventHandler,
    getPlayerAccount = getPlayerAccount,
    isGuestAccount = isGuestAccount,
    getAccountName = getAccountName,
    table = table,
    assetify = assetify
}


-------------------------
--[[ Module: Account ]]--
-------------------------

local cModule = dbify.createModule({
    moduleName = "account",
    tableName = "dbify_accounts",
    structure = {
        {"name", "VARCHAR(100) PRIMARY KEY"}
    }
})

if dbify.settings.syncNativeAccounts then
    imports.assetify.thread:create(function(self)
        local serverPlayers = imports.getElementsByType("player")
        for i = 1, imports.table.length(serverPlayers), 1 do
            local playerAccount = imports.getPlayerAccount(serverPlayers[i])
            if playerAccount and not imports.isGuestAccount(playerAccount) then
                cModule.create(imports.getAccountName(playerAccount))
            end
        end
        imports.addEventHandler("onPlayerLogin", root, function(_, currAccount)
            cModule.create(imports.getAccountName(currAccount))
        end)
    end):resume()
end