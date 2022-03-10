----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: index.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Gameplay Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars = {

    ["Game"] = {
        ["FPS_Limit"] = 100,
        ["Sync_Rate"] = 50,
        ["Camera_FOV"] = {
            ["player"] = 40,
            ["vehicle"] = 50
        },
        ["Draw_Distance_Limit"] = {500, 1000},
        ["Fog_Distance_Limit"] = {5, 50},
        ["Character_Limit"] = {default = 2, vip = 4},
        ["Aircraft_Max_Height"] = 1000000,
        ["Jetpack_Max_Height"] = 10000,
        ["Minute_Duration"] = 60000,
        ["Logout_CoolDown_Duration"] = 120000,
        ["Game_Type"] = "vRPZ",
        ["Game_Map"] = "vRPZ : SA",
        ["Disabled_CMDS"] = {"register", "logout"},
    
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
    },

    ["UI"] = {}

}