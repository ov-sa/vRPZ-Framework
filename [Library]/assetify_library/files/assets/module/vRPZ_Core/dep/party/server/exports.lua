-----------------
--[[ Exports ]]--
-----------------

CGame.createExports({
    {exportName = "createParty", moduleName = "CParty", moduleMethod = "create"},
    {exportName = "destroyParty", moduleName = "CParty", moduleMethod = "destroy"},
    {exportName = "getPartyMembers", moduleName = "CParty", moduleMethod = "getMembers"},
    {exportName = "getParty", moduleName = "CParty", moduleMethod = "getParty"},
    {exportName = "invitePartyMember", moduleName = "CParty", moduleMethod = "invite"},
    {exportName = "removePartyMember", moduleName = "CParty", moduleMethod = "remove"}
})