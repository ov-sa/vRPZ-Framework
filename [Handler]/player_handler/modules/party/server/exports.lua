----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: modules: player: server: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril, Аниса
     DOC: 31/01/2022
     Desc: Player Module ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

function createParty(...) return CParty.create(...) end
function destroyParty(...) return CParty.destroy(...) end
function getPartyMembers(...) return CParty.getMembers(...) end
function getParty(...) return CParty.getParty(...) end
function invitePartyMember(...) return CParty.invite(...) end
function removePartyMember(...) return CParty.remove(...) end