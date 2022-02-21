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
            characterPoint = {x = 3.823265075683594, y = 5.68226146697998, z = 1.617531418800354, rotation = -80},
            characterCinemationPoint = {
                cameraStart = {x = 5.792200088500977, y = 6.651500225067139, z = 2.244400024414062},
                cameraStartLook = {x = 5.117425918579102, y = 5.936816692352295, z = 2.060261249542236},
                cameraEnd = {x = 5.582699775695801, y = 6.822999954223633, z = 2.206700086593628},
                cameraEndLook = {x = 5.052437305450439, y = 5.990044116973877, z = 2.048564910888672},
                cinemationDuration = 7000
            },
            cinemationPoint = {
                cameraStart = {x = 763.5717163085938, y = 463.2174987792969, z = 151.6784057617188},
                cameraStartLook = {x = 762.7440795898438, y = 462.7048645019531, z = 151.4499969482422},
                cameraEnd = {x = 1.57449996471405, y = 8.598099708557129, z = 4.809100151062012},
                cameraEndLook = {x = 1.33843719959259, y = 8.141613006591797, z = 3.951257228851318},
                cinemationDuration = 10000 
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