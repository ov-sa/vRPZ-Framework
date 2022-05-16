------------------
--[[ Configns ]]--
------------------

FRAMEWORK_CONFIGS["Templates"]["Inventory"] = {
    ["Priority"] = {
        "Primary",
        "Secondary",
        "Ammo",
        "Helmet",
        "Vest",
        "Backpack",
        "Upper",
        "Lower",
        "Shoes",
        "Medicine",
        "Snack",
        "Beverage"
    },

    ["Slots"] = {
        ["Primary"] = {
            ["Title"] = {
                ["EN"] = "Primary",
                ["TR"] = "Öncelik",
                ["RU"] = "Начальный",
                ["BR"] = "Primária",
                ["NL"] = "primair"
            },
            identifier = "Weapon",
            slots = {rows = 2, columns = 6}
        },
    
        ["Secondary"] = {
            ["Title"] = {
                ["EN"] = "Secondary",
                ["TR"] = "İkincil",
                ["RU"] = "Среднее",
                ["BR"] = "Secundária",
                ["NL"] = "Ondergeschikt"
            },
            identifier = "Weapon",
            slots = {rows = 2, columns = 4}
        },
    
        ["Helmet"] = {
            ["Title"] = {
                ["EN"] = "Helmet",
                ["TR"] = "Kask",
                ["RU"] = "Шлем",
                ["BR"] = "Capacete",
                ["NL"] = "Helm"
            },
            identifier = "Helmet",
            slots = {rows = 2, columns = 2}
        },
    
        ["Vest"] = {
            ["Title"] = {
                ["EN"] = "Vest",
                ["TR"] = "Yelek",
                ["RU"] = "Жилет",
                ["BR"] = "Colete",
                ["NL"] = "Vest"
            },
            identifier = "Vest",
            slots = {rows = 2, columns = 2}
        },
    
        ["Backpack"] = {
            ["Title"] = {
                ["EN"] = "Backpack",
                ["TR"] = "Sırt çantası",
                ["RU"] = "Рюкзак",
                ["BR"] = "Mochila",
                ["NL"] = "Rugzak"
            },
            identifier = "Backpack",
            slots = {rows = 3, columns = 3}
        },

        ["Upper"] = {
            ["Title"] = {
                ["EN"] = "Upper", 
                ["TR"] = "Üst", 
                ["RU"] = "Верх",
                ["BR"] = "Parte de cima",
                ["NL"] = "Bovenste"
            },
            identifier = "Upper",
            slots = {rows = 2, columns = 2}
        },

        ["Lower"] = {
            ["Title"] = {
                ["EN"] = "Lower", 
                ["TR"] = "Alt", 
                ["RU"] = "Низ",
                ["BR"] = "Parte de baixo",
                ["NL"] = "Lager"
            },
            identifier = "Lower",
            slots = {rows = 2, columns = 2}
        },

        ["Shoes"] = {
            ["Title"] = {
                ["EN"] = "Shoes", 
                ["TR"] = "Ayakkabı", 
                ["RU"] = "Обувь",
                ["BR"] = "Calçados",
                ["NL"] = "Schoenen"
            },
            identifier = "Shoes",
            slots = {rows = 2, columns = 2}
        }
    }
}