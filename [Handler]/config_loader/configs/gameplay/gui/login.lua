----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: gui: login.lua
     Author: vStudio
     Developer(s): Tron
     DOC: 31/01/2022
     Desc: Login UI Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["UI"]["Login"] = {

    weather = 9,
    time = {12, 0},
    dimension = 100,
    fadeDelay = 7000,
    clientPoint = {x = 0, y = 0, z = 0},
    spawnLocations = {
        {
            cinemationFOV = 150,
            characterCinemationFOV = 85,
            characterPoint = {x = -1432.02795, y = 1499.02197, z = 1.86719, rotation = 130},
            characterCinemationPoint = {
                cameraStart = {x = -1433.584838867188, y = 1497.171142578125, z = 1.699100017547607},
                cameraStartLook = {x = -1433.377319335938, y = 1498.148193359375, z = 1.746061682701111},
                cameraEnd = {x = -1433.415649414063, y = 1497.1474609375, z = 1.662500023841858},
                cameraEndLook = {x = -1433.32470703125, y = 1498.140747070313, z = 1.734715104103088},
                cinemationDuration = 7000
            },
            cinemationPoint = {
                cameraStart = {x = -2024.715209960938, y = -2452.98876953125, z = 95.59519958496094},
                cameraStartLook = {x = -2024.66796875, y = -2452.803955078125, z = 94.61355590820313},
                cameraEnd = {x = -1831.124755859375, y = -2424.668701171875, z = 128.3296051025391},
                cameraEndLook = {x = -1831.974975585938, y = -2424.701416015625, z = 127.8042526245117},
                cinemationDuration = 10000 
            }
        },
        {
            characterCinemationFOV = 85,
            cinemationFOV = 150,
            characterPoint = {x = -1432.02795, y = 1499.02197, z = 1.86719, rotation = 130},
            characterCinemationPoint = {
                cameraStart = {x = -1433.584838867188, y = 1497.171142578125, z = 1.699100017547607},
                cameraStartLook = {x = -1433.377319335938, y = 1498.148193359375, z = 1.746061682701111},
                cameraEnd = {x = -1433.415649414063, y = 1497.1474609375, z = 1.662500023841858},
                cameraEndLook = {x = -1433.32470703125, y = 1498.140747070313, z = 1.734715104103088},
                cinemationDuration = 7000
            },
            cinemationPoint = {
                cameraStart = {x = -2024.715209960938, y = -2452.98876953125, z = 95.59519958496094},
                cameraStartLook = {x = -2024.66796875, y = -2452.803955078125, z = 94.61355590820313},
                cameraEnd = {x = -1726.987548828125, y = -2236.419189453125, z = 139.2445983886719},
                cameraEndLook = {x = -1726.531982421875, y = -2237.2822265625, z = 139.0268249511719},
                cinemationDuration = 15000 
            }
        }
    },

    ["Options"] = {
        play = {
            ["Titles"] = {
                ["EN"] = "Play",
                ["TR"] = "Oyna"
            }
        },

        characters = {
            ["Titles"] = {
                ["EN"] = "Characters",
                ["TR"] = "karakterler"
            }
        },

        credits = {
            scrollDuration = 7500,

            ["Titles"] = {
                ["EN"] = "Credits",
                ["TR"] = "Kredi"
            },

            ["Navigator"] = {
                ["Titles"] = {
                    ["EN"] = "Back",
                    ["TR"] = "Geri"
                }
            },

            ["Contributors"] = {
                "ov | Mario (Developer)",
                "ov | Buddy (Modeler)",
                "ov | Aviril (Graphics Developer)",
                "ov | April (Designer)",
                "ov | Tron (Developer)",
                "ov | Neor (Developer)",
                "ov | Skann (Modeler)",
                "ov | Mazvis (Developer)"
            }
        }
    }

}