----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: gui: login.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Login UI Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["UI"]["Login"] = {

    weather = 9,
    time = {12, 0},
    dimension = 1,
    fadeDelay = 7000,
    clientPoint = {x = 0, y = 0, z = 0},
    bgPath = "files/images/login/background.png",

    spawnLocations = {
        {
            cinemationFOV = 150,
            characterCinemationFOV = 85,
            characterPoint = {x = -364.2090454101562, y = -175.8919982910156, z = 58.309326171875, rotation = 353.33383178711},
            characterCinemationPoint = {
                cameraStart = {x = -363.1163940429688, y = -174.2259063720703, z = 59.26229858398438},
                cameraStartLook = {x = -363.6080627441406, y = -175.0481414794922, z = 58.9755973815918},
                cameraEnd = {x = -364.0956115722656, y = -174.0343933105469, z = 59.18849945068359},
                cameraEndLook = {x = -363.9120178222656, y = -174.9887084960938, z = 58.9527473449707},
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
            characterPoint = {x = -364.2090454101562, y = -175.8919982910156, z = 58.309326171875, rotation = 353.33383178711},
            characterCinemationPoint = {
                cameraStart = {x = -363.1163940429688, y = -174.2259063720703, z = 59.26229858398438},
                cameraStartLook = {x = -363.6080627441406, y = -175.0481414794922, z = 58.9755973815918},
                cameraEnd = {x = -364.0956115722656, y = -174.0343933105469, z = 59.18849945068359},
                cameraEndLook = {x = -363.9120178222656, y = -174.9887084960938, z = 58.9527473449707},
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
            ["Titles"] = {["EN"] = "Play", ["TR"] = "Oyna"},
            height = 35,
            embedLineSize = 3,
            fontColor = {150, 150, 150, 25},
            hoverfontColor = {170, 35, 35, 255},
            embedLineColor = {170, 35, 35, 50},
            hoverDuration = 2500,
            bgPath = "files/images/login/login.png"
        },

        characters = {
            ["Titles"] = {["EN"] = "Characters", ["TR"] = "karakterler"},
            width = 325,
            height = 610,

            titlebar = {
                ["Titles"] = {["EN"] = "Character", ["TR"] = "Karakter"},
                height = 35,
                fontColor = {170, 35, 35, 255},
                bgColor = {0, 0, 0, 255},
                shadowColor = {50, 50, 50, 255},
            },
            categories = {
                height = 30,
                fontColor = {200, 200, 200, 255},
                bgColor = {0, 0, 0, 235},

                ["Identity"] = {
                    ["Titles"] = {["EN"] = "Identity", ["TR"] = "Kimlik"},
                    tone = {
                        ["Titles"] = {["EN"] = "Skin Tone", ["TR"] = "Cilt tonu"},
                        ["Datas"] = configVars["Character"]["Identity"]["Tone"]
                    },
                    gender = {
                        default = "Male",
                        ["Titles"] = {["EN"] = "Gender", ["TR"] = "Cinsiyet"},
                        ["Datas"] = configVars["Character"]["Identity"]["Gender"]
                    },
                    faction = {
                        ["Titles"] = {["EN"] = "Faction", ["TR"] = "Hizip"},
                        ["Datas"] = configVars["Character"]["Identity"]["Faction"]
                    }
                },
                ["Facial"] = {
                    ["Titles"] = {["EN"] = "Facial", ["TR"] = "Yüz"},
                    hair = {
                        ["Titles"] = {["EN"] = "Hair", ["TR"] = "Saç"},
                        ["Datas"] = configVars["Character"]["Clothing"]["Facial"]["Hair"]
                    }
                },
                ["Upper"] = {
                    ["Titles"] = {["EN"] = "Upper", ["TR"] = "Üst"},
                    ["Datas"] = configVars["Character"]["Clothing"]["Upper"]
                },
                ["Lower"] = {
                    ["Titles"] = {["EN"] = "Lower", ["TR"] = "Daha düşük"},
                    ["Datas"] = configVars["Character"]["Clothing"]["Lower"]
                },
                ["Shoes"] = {
                    ["Titles"] = {["EN"] = "Shoes", ["TR"] = "Ayakkabı"},
                    ["Datas"] = configVars["Character"]["Clothing"]["Shoes"]
                }
            }
        },

        credits = {
            ["Titles"] = {["EN"] = "Credits", ["TR"] = "Kredi"},
            fontColor = {170, 35, 35, 255},
            scrollDuration = 8500,

            navigator = {
                ["Titles"] = {["EN"] = "Back", ["TR"] = "Geri"},
                hoverDuration = 2500
            },
            contributors = {
                "ov | Mario (Developer)",
                "ov | Buddy (Modeler)",
                "ov | Aviril (Graphics Developer)",
                "ov | April (Designer)",
                "ov | Tron (Developer)",
                "ov | Neor (Developer)",
                "ov | Skann (Modeler)",
                "ov | Mazvis (Contributor)"
            }
        }
    }

}