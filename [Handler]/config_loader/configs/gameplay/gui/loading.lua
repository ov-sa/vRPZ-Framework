----------------------------------------------------------------
--[[ Resource: Config Loader
     Script: configs: gameplay: gui: loading.lua
     Author: vStudio
     Developer(s): Mario, Tron, Aviril
     DOC: 31/01/2022
     Desc: Loading UI Configns ]]--
----------------------------------------------------------------


------------------
--[[ Configns ]]--
------------------

configVars["UI"]["Loading"] = {

    fadeInDuration = 500,
    fadeOutDuration = 2500,
    fadeDelayDuration = 2000,
    bgColor = {0, 0, 0, 255},

    loader = {
        size = 50,
        animDuration = 750,
        bgColor = {200, 200, 200, 255},
        bgPath = "files/images/loading/loader.png"
    },

    hint = {
        fontColor = {200, 200, 200, 255},

        ["Titles"] = {
            {
                ["EN"] = "Upgrade your skills to unlock higher blood limit!",
                ["TR"] = "Daha yüksek kan limitinin kilidini açmak için yeteneklerinizi geliştirmelisin!"
            },
            {
                ["EN"] = "Use Antiradiation suits to evade radiations effectively!",
                ["TR"] = "Radyasyonlardan etkili bir şekilde kaçmak için Radyasyon Önleyici giysiler kullanmalısın!"
            },
            {
                ["EN"] = "Use helmets to evade headshots!",
                ["TR"] = "Kafa vuruşlarından kaçınmak için kask kullanmalısın!"
            },
            {
                ["EN"] = "Use armors to evade damages!",
                ["TR"] = "Hasarlardan kaçınmak için zırhları kullanmalısın!"
            },
            {
                ["EN"] = "Use backpacks to carry more items!",
                ["TR"] = "Daha fazla eşya taşımak için sırt çantalarını kullanmalısın!"
            },
            {
                ["EN"] = "Always be alarmed, never trust anyone!",
                ["TR"] = "Her zaman dikkatli olmalısın, asla kimseye güvenmemelisin!"
            },
            {
                ["EN"] = "Revive your group members to gain more reputation!",
                ["TR"] = "Daha fazla itibar kazanmak için grup üyelerinizi canlandırın!"
            },
            {
                ["EN"] = "Killing your group members will reduce your reputation!",
                ["TR"] = "Grup üyelerinizi öldürmek itibarınızı düşürür!"
            },
            {
                ["EN"] = "Maintain higher reputation to unlock high tier loots!",
                ["TR"] = "Yüksek seviyeli ganimetlerin kilidini açmak için daha yüksek itibarı koruyun!"
            },
            {
                ["EN"] = "Collect GPS & Compass to help you travel on the map!",
                ["TR"] = "Haritada seyahat etmenize yardımcı olması için GPS ve Pusula toplayın!"
            }
        }
    }

}