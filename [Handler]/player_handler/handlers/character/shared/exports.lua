----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: character: shared: exports.lua
     Author: vStudio
     Developer(s): Mario, Tron
     DOC: 31/01/2022
     Desc: Character Handler ]]--
----------------------------------------------------------------


-----------------
--[[ Exports ]]--
-----------------

function getPlayerFromCharacterID(...) return CCharacter.getPlayer(...) end
function getCharacterHealth(...) return CCharacter.getHealth(...) end
function getCharacterMaximumHealth(...) return CCharacter.getMaxHealth(...) end
function getCharacterFaction(...) return CCharacter.getFaction(...) end
function setCharacterMoney(...) return CCharacter.setMoney(...) end
function getCharacterMoney(...) return CCharacter.getMoney(...) end
function isCharacterKnocked(...) return CCharacter.isKnocked(...) end
function isCharacterReloading(...) return CCharacter.isReloading(...) end
function isCharacterReloading(...) return CCharacter.isReloading(...) end