----------------------------------------------------------------
--[[ Resource: Player Handler
     Script: handlers: inventory: gui: cache.lua
     Server: -
     Author: OvileAmriam
     Developer: -
     DOC: 18/12/2020 (OvileAmriam)
     Desc: Inventory Cache Handler ]]--
----------------------------------------------------------------


-------------------
--[[ Variables ]]--
-------------------

inventoryCache = {
    state = false,
    enabled = true,
    isSlotsUpdated = false,
    isSlotsUpdatePending = false,
    vicinity = nil,
    hotBarTable = {},
    inventorySlots = nil,
    attachedItemAnimDuration = 750,
    attachedItemOnCursor = nil,
    gui = {
        postGUI = false,
        equipment = {
            startX = centerX - (391/2) - 30,
            startY = centerY - (508/3) - 25,
            width = 845,
            height = 485,
            bgColor = {255, 255, 255, 253},
            bgPath = DxTexture("files/images/inventory/ui/equipment/body.png", "argb", true, "clamp"),
            slotTopLeftCurvedEdgeBGPath = DxTexture("files/images/hud/curved_square/top_left.png", "argb", true, "clamp"),
            slotTopRightCurvedEdgeBGPath = DxTexture("files/images/hud/curved_square/top_right.png", "argb", true, "clamp"),
            slotBottomLeftCurvedEdgeBGPath = DxTexture("files/images/hud/curved_square/bottom_left.png", "argb", true, "clamp"),
            slotBottomRightCurvedEdgeBGPath = DxTexture("files/images/hud/curved_square/bottom_right.png", "argb", true, "clamp"),
            titleBar = {
                text = "E Q U I P M E N T",
                height = 30,
                font = fonts[9],
                dividerSize = 2,
                outlineWeight = 0.25,
                fontColor = {175, 175, 175, 255},
                dividerColor = {0, 0, 0, 75},
                bgColor = {0, 0, 0, 255},
                leftEdgePath = DxTexture("files/images/hud/right_triangle/default.png", "argb", true, "clamp"),
                rightEdgePath = DxTexture("files/images/hud/right_triangle/flipped.png", "argb", true, "clamp"),
                invertedEdgePath = DxTexture("files/images/hud/right_triangle/inverted.png", "argb", true, "clamp")
            },
            grids = {
                primary = {
                    startX = 25,
                    startY = 25,
                    width = 250,
                    height = 75,
                    paddingX = 34,
                    paddingY = 10,
                    slotCategory = "primary_weapon",
                    borderSize = 4,
                    borderColor = {100, 100, 100, 25},
                    bgColor = {0, 0, 0, 235},
                    availableBGColor = {0, 255, 0, 255},
                    unavailableBGColor = {255, 0, 0, 255},
                    bgImage = DxTexture("files/images/inventory/ui/primary_slot.png", "argb", true, "clamp")
                },
                secondary = {
                    startX = 25,
                    startY = 115,
                    width = 165,
                    height = 75,
                    paddingX = 22,
                    paddingY = 10,
                    slotCategory = "secondary_weapon",
                    borderSize = 4,
                    borderColor = {100, 100, 100, 25},
                    bgColor = {0, 0, 0, 235},
                    availableBGColor = {0, 255, 0, 255},
                    unavailableBGColor = {255, 0, 0, 255},
                    bgImage = DxTexture("files/images/inventory/ui/secondary_slot.png", "argb", true, "clamp")
                },
                tertiary = {
                    startX = 200,
                    startY = 115,
                    width = 75,
                    height = 75,
                    paddingX = 10,
                    paddingY = 10,
                    slotCategory = "special_weapon",
                    borderSize = 4,
                    borderColor = {100, 100, 100, 25},
                    bgColor = {0, 0, 0, 235},
                    availableBGColor = {0, 255, 0, 255},
                    unavailableBGColor = {255, 0, 0, 255},
                    bgImage = DxTexture("files/images/inventory/ui/tertiary_slot.png", "argb", true, "clamp")
                },
                shirt = {
                    startX = 25,
                    startY = 207,
                    width = 75,
                    height = 75,
                    paddingX = 10,
                    paddingY = 10,
                    slotCategory = "Shirt",
                    borderSize = 4,
                    borderColor = {100, 100, 100, 25},
                    bgColor = {0, 0, 0, 235},
                    availableBGColor = {0, 255, 0, 255},
                    unavailableBGColor = {255, 0, 0, 255},
                    bgImage = DxTexture("files/images/inventory/ui/shirt_slot.png", "argb", true, "clamp")
                },
                helmet = {
                    startX = 112.5,
                    startY = 207,
                    width = 75,
                    height = 75,
                    paddingX = 10,
                    paddingY = 10,
                    slotCategory = "Helmet",
                    borderSize = 4,
                    borderColor = {100, 100, 100, 25},
                    bgColor = {0, 0, 0, 235},
                    availableBGColor = {0, 255, 0, 255},
                    unavailableBGColor = {255, 0, 0, 255},
                    bgImage = DxTexture("files/images/inventory/ui/helmet_slot.png", "argb", true, "clamp")
                },
                armor = {
                    startX = 200,
                    startY = 207,
                    width = 75,
                    height = 75,
                    paddingX = 10,
                    paddingY = 10,
                    slotCategory = "Armor",
                    borderSize = 4,
                    borderColor = {100, 100, 100, 25},
                    bgColor = {0, 0, 0, 235},
                    availableBGColor = {0, 255, 0, 255},
                    unavailableBGColor = {255, 0, 0, 255},
                    bgImage = DxTexture("files/images/inventory/ui/armor_slot.png", "argb", true, "clamp")
                },
                torso = {
                    startX = 25,
                    startY = 300,
                    width = 75,
                    height = 75,
                    paddingX = 10,
                    paddingY = 10,
                    slotCategory = "Torso",
                    borderSize = 4,
                    borderColor = {100, 100, 100, 25},
                    bgColor = {0, 0, 0, 235},
                    availableBGColor = {0, 255, 0, 255},
                    unavailableBGColor = {255, 0, 0, 255},
                    bgImage = DxTexture("files/images/inventory/ui/torso_slot.png", "argb", true, "clamp")
                },
                shoes = {
                    startX = 25,
                    startY = 385,
                    width = 75,
                    height = 75,
                    paddingX = 10,
                    paddingY = 10,
                    slotCategory = "Shoes",
                    borderSize = 4,
                    borderColor = {100, 100, 100, 25},
                    bgColor = {0, 0, 0, 235},
                    availableBGColor = {0, 255, 0, 255},
                    unavailableBGColor = {255, 0, 0, 255},
                    bgImage = DxTexture("files/images/inventory/ui/shoes_slot.png", "argb", true, "clamp")
                },
                backpack = {
                    startX = 115,
                    startY = 300,
                    width = 160,
                    height = 160,
                    paddingX = 15,
                    paddingY = 15,
                    slotCategory = "Backpack",
                    borderSize = 4,
                    borderColor = {100, 100, 100, 25},
                    bgColor = {0, 0, 0, 235},
                    availableBGColor = {0, 255, 0, 255},
                    unavailableBGColor = {255, 0, 0, 255},
                    bgImage = DxTexture("files/images/inventory/ui/backpack_slot.png", "argb", true, "clamp")
                }
            },
            description = {
                startX = 300,
                startY = 395,
                width = 520,
                height = 70,
                padding = 10,
                font = fonts[10],
                fontColor = {175, 175, 175, 200},
                bgColor = {5, 5, 5, 200}
            }
        },
        lockStat = {
            startX = -23,
            startY = 0,
            iconSize = 20,
            iconColor = {200, 200, 200, 255},
            lockedIconPath = DxTexture("files/images/hud/lock/locked.png", "argb", true, "clamp"),
            unlockedIconPath = DxTexture("files/images/hud/lock/unlocked.png", "argb", true, "clamp")
        },
        tranparencyAdjuster = {
            startX = 4,
            startY = -3,
            width = -8,
            height = 10,
            slideRange = 20,
            percent = 1,
            minPercent = 0.75,
            thumbSize = 12,
            borderSize = 2,
            borderColor = {175, 175, 175, 255},
            thumbColor = {0, 0, 0, 255}
        },
        itemBox = {
            templates = {
                {
                    width = 520,
                    height = 360,
                    borderSize = 4,
                    borderColor = {100, 100, 100, 25},
                    bgColor = {0, 0, 0, 235},
                    contentWrapper = {
                        startX = 3,
                        startY = 3,
                        width = 514,
                        height = 354,
                        padding = 1,
                        itemGrid = {
                            padding = 15,
                            slot = {
                                size = 68,
                                font = fonts[13],
                                fontColor = {175, 175, 175, 235},
                                bgColor= {100, 100, 100, 100},
                                availableBGColor = {0, 50, 0, 200},
                                unavailableBGColor = {50, 0, 0, 200}
                            }
                        }
                    },
                    scrollBar = {
                        overlay = {
                            startX = 514,
                            startY = 3,
                            width = 4,
                            height = 354,
                            bgColor = {15, 15, 15, 100}
                        },
                        bar = {
                            height = 60,
                            bgColor = {175, 175, 175, 200}
                        }
                    }
                },
                {
                    width = 310,
                    height = 455,
                    bgColor = {255, 255, 255, 253},
                    bgImage = DxTexture("files/images/inventory/ui/equipment/itemBox/template_2.png", "argb", true, "clamp"),
                    contentWrapper = {
                        startX = 0,
                        startY = 3,
                        width = 306,
                        height = 449,
                        itemSlot = {
                            startX = 0,
                            startY = 5,
                            width = 0,
                            height = 70,
                            paddingY = 5,
                            bgImage = DxTexture("files/images/inventory/ui/equipment/itemBox/itemSlot.png", "argb", true, "clamp"),
                            availableBGColor = {0, 255, 0},
                            unavailableBGColor = {255, 0, 0},
                            iconSlot = {
                                startX = 10,
                                startY = 5,
                                height = 60
                            },
                            itemCounter = {
                                paddingX = 5,
                                paddingY = 5,
                                font = fonts[11],
                                fontColor = {200, 200, 200, 200}
                            },
                            itemName = {
                                paddingX = 10,
                                font = fonts[12],
                                fontColor = {255, 255, 255, 255},
                                hoverAnimDuration = 5000,
                                bgImage = DxTexture("files/images/inventory/ui/equipment/itemBox/itemNameSlot.png", "argb", true, "clamp")
                            }
                        }
                    },
                    scrollBar = {
                        overlay = {
                            startX = 305,
                            startY = 3,
                            width = 4,
                            height = 449,
                            bgColor = {15, 15, 15, 100}
                        },
                        bar = {
                            height = 60,
                            bgColor = {175, 175, 175, 200}
                        }
                    }
                }
            }
        }
    }
}
inventoryCache.gui.equipment.description.startX = inventoryCache.gui.equipment.startX + inventoryCache.gui.equipment.description.startX
inventoryCache.gui.equipment.description.startY = inventoryCache.gui.equipment.startY + inventoryCache.gui.equipment.description.startY
for i, j in pairs(inventoryCache.gui.equipment.grids) do
    j.startX = inventoryCache.gui.equipment.startX + j.startX
    j.startY = inventoryCache.gui.equipment.startY + j.startY
end
inventoryCache.gui.tranparencyAdjuster.startX = inventoryCache.gui.equipment.startX + inventoryCache.gui.tranparencyAdjuster.startX
inventoryCache.gui.tranparencyAdjuster.startY = inventoryCache.gui.equipment.startY + inventoryCache.gui.equipment.height - inventoryCache.gui.tranparencyAdjuster.height + inventoryCache.gui.tranparencyAdjuster.startY
inventoryCache.gui.tranparencyAdjuster.width = inventoryCache.gui.equipment.width + inventoryCache.gui.tranparencyAdjuster.width