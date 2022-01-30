----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: index.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 25/01/2022
     Desc: Gameplay Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars = {

    ["Game"] = {
        ["FPS_Limit"] = 200,
        ["Draw_Distance_Limit"] = {500, 1000},
        ["Fog_Distance_Limit"] = {50, 100},
        ["Water_Level_Limit"] = {0, 10},

        ["Character"] = {
            ["Max_Blood"] = 1000,
            ["Default_Damage"] = 5,
            ["Water_Damage"] = 10,
            ["Explosion_Damage"] = 120,
            ["Fall_Damage"] = 70,
            ["Ram_Damage"] = 100,
            ["Knockdown_Blood_Percent"] = 0.05,
            ["Knockdown_Duration"] = 20*1000
        },

        ["Interaction"] = {
            ["NPC_Range"] = 1.75,
            ["Vehicle_Range"] = 1.75,
            ["Pickup_Range"] = 1.75,
        },

        ["Pickup"] = {
            ["Expiry_Duration"] = 48*60*1000
        }
    }

}