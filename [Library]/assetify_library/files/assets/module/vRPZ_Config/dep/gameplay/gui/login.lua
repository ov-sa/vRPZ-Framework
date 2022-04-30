------------------
--[[ Configns ]]--
------------------

FRAMEWORK_CONFIGS["UI"]["Login"] = {
    lobbySound = {asset = "vRPZ_Lobby", category = "login"},
    weathers = {
        {weather = 9, time = {12, 0}},
        {weather = 15, time = {12, 0}}
    },
    dimension = 1,
    fadeDelay = 7000,
    clientPoint = {x = 0, y = 0, z = 0},

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
            characterCinemationFOV = 50,
            characterPoint = {x = -257.4282531738281, y = -76.09749603271484, z = 67.12364196777344, rotation = 110},
            characterCinemationPoint = {
                cameraStart = {x = -260.7944030761719, y = -79.50209808349609, z = 68.01069641113281},
                cameraStartLook = {x = -260.2499389648438, y = -78.67666625976562, z = 67.86155700683594},
                cameraEnd = {x = -260.7944030761719, y = -79.50209808349609, z = 68.01069641113281},
                cameraEndLook = {x = -260.2499389648438, y = -78.67666625976562, z = 67.86155700683594},
                cinemationDuration = 14000
            }
        }
    },

    ["Notifications"] = {
        [1] = {
            ["EN"] = "You must create a character inorder to play..",
            ["TR"] = "Oynamak için bir karakter seçmelisin..",
            ["RU"] = "Вы должны создать персонажа, чтобы играть..",
            ["BR"] = "Você deve criar um personagem para jogar..",
        },
        [2] = {
            ["EN"] = "You must pick a character inorder to play..", 
            ["TR"] = "Oynamak için bir karakter seçmelisiniz..", 
            ["RU"] = "Вы должны выбрать персонажа, чтобы играть..",
            ["BR"] = "Você deve escolher um personagem para jogar..",
        },
        [3] = {
            ["EN"] = "You have exceeded character limit..", 
            ["TR"] = "Karakter sınırını aştınız..", 
            ["RU"] = "Вы превысили лимит символов..",
            ["BR"] = "Você excedeu o limite de personagens.",
        },
        [4] = {
            ["EN"] = "You've successfully created a character!", 
            ["TR"] = "Başarıyla bir karakter yarattınız!..", 
            ["RU"] = "Вы успешно создали персонажа!",
            ["BR"] = "Você criou um personagem com sucesso!",
        },
        [5] = {
            ["EN"] = "You don't have enough characters..", 
            ["TR"] = "Yeterli karakteriniz yok..", 
            ["RU"] = "У вас недостаточно символов..",
            ["BR"] = "Você não tem personagens suficientes..",
        },
        [6] = {
            ["EN"] = "You've successfully deleted the character!", 
            ["TR"] = "Karakteri başarıyla sildiniz!", 
            ["RU"] = "Вы успешно удалили персонажа!",
            ["BR"] = "Você excluiu o personagem com sucesso!",
        },
        [7] = {
            ["EN"] = "You must save the character prior to picking..", 
            ["TR"] = "Seçmeden önce karakteri kaydetmelisiniz..", 
            ["RU"] = "Вы должны сохранить персонажа перед выбором..",
            ["BR"] = "Você deve salvar o personagem antes de escolher.",
        },
        [8] = {
            ["EN"] = "You've successfully picked the character!", 
            ["TR"] = "Karakteri başarıyla seçtiniz!", 
            ["RU"] = "Вы успешно выбрали персонажа!",
            ["BR"] = "Você escolheu o personagem com sucesso!",
        },
        [9] = {
            ["EN"] = "You've successfully saved the character!", 
            ["TR"] = "Karakteri başarıyla kaydettiniz!", 
            ["RU"] = "Вы успешно сохранили персонажа!",
            ["BR"] = "Você salvou o personagem com sucesso!",
        },
        [10] = {
            ["EN"] = "Failed to save your character..", 
            ["TR"] = "Karakteriniz kaydedilemedi..", 
            ["RU"] = "Не удалось сохранить вашего персонажа..",
            ["BR"] = "Falha ao salvar seu personagem..",
        },
        [11] = {
            ["EN"] = "You must either save or delete your character before navigating..", 
            ["TR"] = "Gezinmeden önce karakterinizi kaydetmeli veya silmelisiniz..", 
            ["RU"] = "Вы должны сохранить или удалить своего персонажа перед навигацией.",
            ["BR"] = "Você deve salvar ou excluir seu personagem antes de navegar.",
        }
    },

    ["Options"] = {
        play = {
            ["Titles"] = {
                ["EN"] = "Play", 
                ["TR"] = "Oyna", 
                ["RU"] = "Играть",
                ["BR"] = "Jogar",
            },
            height = 35, embedLineSize = 3,
            fontColor = {150, 150, 150, 25}, hoverfontColor = {170, 35, 35, 255}, embedLineColor = {170, 35, 35, 50},
            hoverDuration = 2500
        },

        characters = {
            ["Titles"] = {
                ["EN"] = "Characters", 
                ["TR"] = "karakterler", 
                ["RU"] = "Персонажи",
                ["BR"] = "Personagens",
            },
            width = 325, height = 560,
            titlebar = {
                ["Titles"] = {
                    ["EN"] = "Character", 
                    ["TR"] = "Karakter", 
                    ["RU"] = "Персонаж",
                    ["BR"] = "Personagem",
                },
                height = 35, iconSize = 18,
                fontColor = {170, 35, 35, 255}, iconColor = {255, 255, 255, 255*0.35}, bgColor = {0, 0, 0, 255}, shadowColor = {50, 50, 50, 255}
            },
            options = {
                size = 30, iconSize = 14,
                iconColor = {255, 255, 255, 255}, bgColor = {0, 0, 0, 255},
                hoverDuration = 2750,
                tooltips = {
                    previous = {
                        ["EN"] = "Previous", 
                        ["TR"] = "Öncesi", 
                        ["RU"] = "Предыдущий",
                        ["BR"] = "Anterior",
                    },
                    next = {
                        ["EN"] = "Next", 
                        ["TR"] = "Sonraki", 
                        ["RU"] = "Следующий",
                        ["BR"] = "Próximo",
                    },
                    pick = {
                        ["EN"] = "Pick", 
                        ["TR"] = "Seçmek", 
                        ["RU"] = "Выбирать",
                        ["BR"] = "Escolher",
                    },
                    create = {
                        ["EN"] = "Create", 
                        ["TR"] = "Yaratmak", 
                        ["RU"] = "Создать",
                        ["BR"] = "Criar",
                    },
                    delete = {
                        ["EN"] = "Delete", 
                        ["TR"] = "Silmek", 
                        ["RU"] = "Удалить",
                        ["BR"] = "Deletar",
                    },
                    save = {
                        ["EN"] = "Save", 
                        ["TR"] = "Kayıt etmek", 
                        ["RU"] = "Сохранить",
                        ["BR"] = "Salvar",
                    },
                    back = {
                        ["EN"] = "Back", 
                        ["TR"] = "Geri", 
                        ["RU"] = "Назад",
                        ["BR"] = "Voltar",
                    }
                }
            },
            categories = {
                height = 30,
                fontColor = {200, 200, 200, 255}, bgColor = {0, 0, 0, 235},

                ["Identity"] = {
                    ["Titles"] = {
                        ["EN"] = "Identity", 
                        ["TR"] = "Kimlik", 
                        ["RU"] = "Тело",
                        ["BR"] = "Características físicas",
                    },
                    tone = {
                        ["Titles"] = {
                            ["EN"] = "Skin Tone", 
                            ["TR"] = "Cilt tonu", 
                            ["RU"] = "Цвет кожи",
                            ["BR"] = "Tom da pele",
                        },
                        ["Datas"] = FRAMEWORK_CONFIGS["Character"]["Identity"]["Tone"]
                    },
                    gender = {
                        default = "Male",
                        ["Titles"] = {
                            ["EN"] = "Gender", 
                            ["TR"] = "Cinsiyet", 
                            ["RU"] = "Пол",
                            ["BR"] = "Gênero",
                        },
                        ["Datas"] = FRAMEWORK_CONFIGS["Character"]["Identity"]["Gender"]
                    }
                },
                ["Facial"] = {
                    ["Titles"] = {
                        ["EN"] = "Facial", 
                        ["TR"] = "Yüz", 
                        ["RU"] = "Голова",
                        ["BR"] = "Cabeça",
                    },
                    hair = {
                        ["Titles"] = {
                            ["EN"] = "Hair", 
                            ["TR"] = "Saç", 
                            ["RU"] = "Причёска",
                            ["BR"] = "Cabelo",
                        },
                        ["Datas"] = FRAMEWORK_CONFIGS["Character"]["Clothing"]["Facial"]["Hair"]
                    },
                    face = {
                        ["Titles"] = {
                            ["EN"] = "Face", 
                            ["TR"] = "Yüz", 
                            ["RU"] = "Лицо",
                            ["BR"] = "Rosto",
                        },
                        ["Datas"] = FRAMEWORK_CONFIGS["Character"]["Clothing"]["Facial"]["Face"]
                    }
                },
                ["Clothing"] = {
                    ["Titles"] = {
                        ["EN"] = "Clothing", 
                        ["TR"] = "Giyim", 
                        ["RU"] = "Одежда",
                        ["BR"] = "Roupas",
                    },
                    ["Upper"] = {
                        ["Titles"] = {
                            ["EN"] = "Upper", 
                            ["TR"] = "Üst", 
                            ["RU"] = "Верх",
                            ["BR"] = "Parte de cima",
                        },
                        ["Datas"] = FRAMEWORK_CONFIGS["Character"]["Clothing"]["Upper"]
                    },
                    ["Lower"] = {
                        ["Titles"] = {
                            ["EN"] = "Lower", 
                            ["TR"] = "Alt", 
                            ["RU"] = "Низ",
                            ["BR"] = "Parte de baixo",
                        },
                        ["Datas"] = FRAMEWORK_CONFIGS["Character"]["Clothing"]["Lower"]
                    },
                    ["Shoes"] = {
                        ["Titles"] = {
                            ["EN"] = "Shoes", 
                            ["TR"] = "Ayakkabı", 
                            ["RU"] = "Обувь",
                            ["BR"] = "Calçados",
                        },
                        ["Datas"] = FRAMEWORK_CONFIGS["Character"]["Clothing"]["Shoes"]
                    }
                }
            }
        },

        credits = {
            ["Titles"] = {
                ["EN"] = "Credits", 
                ["TR"] = "Yapımcılar", 
                ["RU"] = "Авторы",
                ["BR"] = "Créditos",
            },
            fontColor = {170, 35, 35, 255},
            scrollDuration = 8500,
            navigator = {
                ["Titles"] = {
                    ["EN"] = "Back", 
                    ["TR"] = "Geri", 
                    ["RU"] = "Назад",
                    ["BR"] = "Voltar",
                },
                hoverDuration = 2500
            },
            contributors = {
                "ov | Mario (Developer)",
                "ov | Buddy (Modeler)",
                "ov | Aviril (Graphics Developer)",
                "ov | April (Designer)",
                "ov | Tron (Developer)",
                "ov | Neor (Developer)",
                "ov | Аниса (Developer)",
                "ov | Skann (Modeler)",
                "ov | Mazvis (Contributor)",
                "ov | Drew (Contributor)",
                "ov | FlyingFork (Developer)",
                "ov | thejdmego (Developer)",
                "Gaimo (Developer)"
            }
        }
    }
}
