----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: templates: reputations.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Reputation Templates Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["Templates"]["Reputations"] = {
    
    ["Regeneration_Duration"] = 5*60*1000,
    ["Max_Reputation"] = 150,
    ["Reputation_Action"] = {
        ["Mute"] = -5,
        ["Kick"] = -25,
        ["Ban"] = -50
    }

}