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
        bgColor = {200, 200, 200, 255}
    },

    hints = {
        fontColor = {200, 200, 200, 255},
        {
            ["EN"] = "Upgrade your skills to unlock higher blood limit!",
            ["TR"] = "Daha yüksek kan limitinin kilidini açmak için yeteneklerinizi geliştirmelisin!",
            ["RU"] = "Улучшите свои навыки, чтобы увеличить объем крови!",
            ["BR"] = "Melhore suas habilidades para ter mais vida!",
        },
        {
            ["EN"] = "Use Antiradiation suits to evade radiations effectively!",
            ["TR"] = "Radyasyonlardan etkili bir şekilde kaçmak için Radyasyon Önleyici giysiler kullanmalısın!",
            ["RU"] = "Используйте антирадиационные костюмы, чтобы эффективно уклоняться от радиации!",
            ["BR"] = "Use trajes anti-radiação para evitar radiações de forma eficaz!",
        },
        {
            ["EN"] = "Use helmets to evade headshots!",
            ["TR"] = "Kafa vuruşlarından kaçınmak için kask kullanmalısın!",
            ["RU"] = "Используйте шлем, чтобы уклоняться от выстрелов в голову!",
            ["BR"] = "Use capacetes para evitar tiros na cabeça!",
        },
        {
            ["EN"] = "Use armors to evade damages!",
            ["TR"] = "Hasarlardan kaçınmak için zırhları kullanmalısın!",
            ["RU"] = "Используйте броню, чтобы избежать повреждений!",
            ["BR"] = "Use coletes para reduzir o dano!",
        },
        {
            ["EN"] = "Use backpacks to carry more items!",
            ["TR"] = "Daha fazla eşya taşımak için sırt çantalarını kullanmalısın!",
            ["RU"] = "Используйте рюкзак, чтобы нести больше предметов!",
            ["BR"] = "Use mochilas para carregar mais items!",
        },
        {
            ["EN"] = "Always be alarmed, never trust anyone!",
            ["TR"] = "Her zaman dikkatli olmalısın, asla kimseye güvenmemelisin!",
            ["RU"] = "Будь всегда начеку, никогда никому не верь!",
            ["BR"] = "Esteja sempre alerta, não confie em ninguém!",
        },
        {
            ["EN"] = "Revive your group members to gain more reputation!",
            ["TR"] = "Daha fazla itibar kazanmak için grup üyelerinizi canlandırın!",
            ["RU"] = "Оживите членов вашей группы, чтобы получить больше репутации!",
            ["BR"] = "Reviva os membros do seu grupo para ganhar mais reputação!",
        },
        {
            ["EN"] = "Killing your group members will reduce your reputation!",
            ["TR"] = "Grup üyelerinizi öldürmek itibarınızı düşürür!",
            ["RU"] = "Убийство членов вашей группы снизит вашу репутацию!",
            ["BR"] = "Matar os membros do seu grupo reduzirá sua reputação!",
        },
        {
            ["EN"] = "Maintain higher reputation to unlock high tier loots!",
            ["TR"] = "Yüksek seviyeli ganimetlerin kilidini açmak için daha yüksek itibarı koruyun!",
            ["RU"] = "Поддерживайте более высокую репутацию, чтобы разблокировать добычу высокого уровня!",
            ["BR"] = "Mantenha uma reputação alta para desbloquear itens melhores!",
        },
        {
            ["EN"] = "Collect GPS & Compass to help you travel on the map!",
            ["TR"] = "Haritada seyahat etmenize yardımcı olması için GPS ve Pusula toplayın!",
            ["RU"] = "Найдите GPS и компас, они помогут путешествовать по карте!",
            ["BR"] = "Colete GPS e Bússola para ajudá-lo a viajar no mapa!",
        }
    }

}
