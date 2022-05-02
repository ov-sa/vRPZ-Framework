-----------------
--[[ Exports ]]--
-----------------

function fetchCharacter(...) return CCharacter.fetch(...) end
function fetchCharactersOwned(...) return CCharacter.fetchOwned(...) end
function createCharacter(...) return CCharacter.create(...) end
function deleteCharacter(...) return CCharacter.delete(...) end
function setCharacterData(...) return CCharacter.setData(...) end
function getCharacterData(...) return CCharacter.getData(...) end
function resetCharacterProgress(...) return CCharacter.resetProgress(...) end
function loadCharacterProgress(...) return CCharacter.loadProgress(...) end
function saveCharacterProgress(...) return CCharacter.saveProgress(...) end