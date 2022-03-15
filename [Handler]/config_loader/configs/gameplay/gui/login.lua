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

    weathers = {
        {weather = 9, time = {12, 0}},
        {weather = 15, time = {12, 0}}
    },
    dimension = 1,
    fadeDelay = 7000,
    clientPoint = {x = 0, y = 0, z = 0},
    bgPath = "files/images/login/background.png",

    spawnLocations = {
        {
            cinemationFOV = 30,
            cinemationPoint = {
                cameraStart = {x = 763.5717163085938, y = 463.2174987792969, z = 151.6784057617188},
                cameraStartLook = {x = 762.7440795898438, y = 462.7048645019531, z = 151.4499969482422},
                cameraEnd = {x = 1.57449996471405, y = 8.598099708557129, z = 4.809100151062012},
                cameraEndLook = {x = 1.33843719959259, y = 8.141613006591797, z = 3.951257228851318},
                cinemationDuration = 10000 
            },
            characterCinemationFOV = 85,
            characterPoint = {x = -257.4282531738281, y = -76.09749603271484, z = 67.12364196777344, rotation = 110},
            characterCinemationPoint = {
                cameraStart = {x = -260.7944030761719, y = -79.50209808349609, z = 68.51069641113281},
                cameraStartLook = {x = -260.2499389648438, y = -78.67666625976562, z = 68.36155700683594},
                cameraEnd = {x = -260.7944030761719, y = -79.50209808349609, z = 68.51069641113281},
                cameraEndLook = {x = -260.2499389648438, y = -78.67666625976562, z = 68.36155700683594},
                cinemationDuration = 14000
            }
        }
    },

    ["Notifications"] = {
        [1] = {["EN"] = "You must create a character inorder to play..", ["TR"] = "Oynamak için bir karakter seçmelisin.."},
        [2] = {["EN"] = "You must pick a character inorder to play..", ["TR"] = "Oynamak için bir karakter seçmelisiniz.."},
        [3] = {["EN"] = "You have exceeded character limit..", ["TR"] = "Karakter sınırını aştınız.."},
        [4] = {["EN"] = "You've successfully created a character!", ["TR"] = "Başarıyla bir karakter yarattınız!.."},
        [5] = {["EN"] = "You don't have enough characters..", ["TR"] = "Yeterli karakteriniz yok.."},
        [6] = {["EN"] = "You've successfully deleted the character!", ["TR"] = "Karakteri başarıyla sildiniz!"},
        [7] = {["EN"] = "You must save the character prior to picking..", ["TR"] = "Seçmeden önce karakteri kaydetmelisiniz.."},
        [8] = {["EN"] = "You've successfully picked the character!", ["TR"] = "Karakteri başarıyla seçtiniz!"},
        [9] = {["EN"] = "You've successfully saved the character!", ["TR"] = "Karakteri başarıyla kaydettiniz!"},
        [10] = {["EN"] = "Failed to save your character..", ["TR"] = "Karakteriniz kaydedilemedi.."},
        [11] = {["EN"] = "You must either save or delete your character before navigating..", ["TR"] = "Gezinmeden önce karakterinizi kaydetmeli veya silmelisiniz.."}
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
            height = 510,
            titlebar = {
                ["Titles"] = {["EN"] = "Character", ["TR"] = "Karakter"},
                height = 35,
                fontColor = {170, 35, 35, 255},
                bgColor = {0, 0, 0, 255},
                shadowColor = {50, 50, 50, 255},
            },
            options = {
                size = 30,
                iconSize = 14,
                iconColor = {255, 255, 255, 255},
                bgColor = {0, 0, 0, 255},
                hoverDuration = 2750,
                tooltips = {
                    previous = {["EN"] = "Previous", ["TR"] = "Öncesi"},
                    next = {["EN"] = "Next", ["TR"] = "Sonraki"},
                    pick = {["EN"] = "Pick", ["TR"] = "Seçmek"},
                    create = {["EN"] = "Create", ["TR"] = "Yaratmak"},
                    delete = {["EN"] = "Delete", ["TR"] = "Silmek"},
                    save = {["EN"] = "Save", ["TR"] = "Kayıt etmek"},
                    back = {["EN"] = "Back", ["TR"] = "Geri"}
                }
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
                    ["Titles"] = {["EN"] = "Lower", ["TR"] = "Alt"},
                    ["Datas"] = configVars["Character"]["Clothing"]["Lower"]
                },
                ["Shoes"] = {
                    ["Titles"] = {["EN"] = "Shoes", ["TR"] = "Ayakkabı"},
                    ["Datas"] = configVars["Character"]["Clothing"]["Shoes"]
                }
            }
        },

        credits = {
            ["Titles"] = {["EN"] = "Credits", ["TR"] = "Yapımcılar"},
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
                "ov | Mazvis (Contributor)",
                "ov | Drew (Contributor)"
            }
        }
    }

}