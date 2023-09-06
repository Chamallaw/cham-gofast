-- Global configuration
Config = {
    -- GLOBAL CONFIGURATION
    language = 'fr',
    textViewDistance = 2,

    -- START
    startNpcCoords = vector4(1296.60, -3346.14, 5.03, 29.02), -- Name of the coords
    startNpcModel = "ig_lamardavis",
    startNpcAnimation = "WORLD_HUMAN_AA_SMOKE",
    startNpcName = "Lamar",

    -- VEHICLE
    vehicleList = {
        "sultan",
        "sentinel",
        "dominator3",
        "raiden",
        "cypher",
        "rhinehart",
    },
    vehicleCoords = vector4(1283.35, -3328.08, 5.90, 354.73), -- Name of the coords

    loadDrugs = {
        loadingAnimationDictonary = "anim@heists@box_carry@",
        loadingAnimationName = "idle",
        cargoModelName = "prop_mp_drug_package",
        radius = 30,
        loadLists = {
            {
                zoneCoords = vector3(1261.41, -3256.32, 5.25),
                ped = { modelName = "s_m_y_dealer_01", spawnCoords = vector3(1280.47, -3243.99, 5.90) },
            },
        },
    },

    sellDrugs = {
        sellingAnimationDictonary = "anim@heists@box_carry@",
        sellingAnimationName = "idle",
        giveMoneyAnimationDictonary = "mp_common",
        giveMoneyAnimationName = "givetake1_a",
        cargoModelName = "prop_mp_drug_package",
        suitCaseModelName = "prop_security_case_01",
        radius = 30,
        pedGivingTheMoney = { modelName = "cs_bankman", spawnCoords = vector3(1182.17, -3323.82, 6.03) },
        sellLists = {
            {
                zoneCoords = vector3(1200.75, -3338.18, 5.80),
                ped = { modelName = "g_m_y_mexgoon_01", spawnCoords = vector3(1180.17, -3323.82, 6.03) },
            },
        },
    },

}

-- Languages available
Texts = {
    ['en'] = {
    },
    ['fr'] = {
        textToAcceptGoFast = 'Appuyez sur ~b~[E]~w~ pour accepter la mission de GoFast',
        textAfterStarting = "Monte dans la voiture derrière toi, et va récupérer la drogue.",
        textAfterStartingGps = "Si t'as un gps je te met la position...",
        textArrivingLoadDrugs = "Arrête toi là, ils ne vont pas tarder",
        textAfterLoadingDrugs = "Les gars : C'est bon tout est chargé, file !",
        textAfterLoadingDrugsGps = "Les gars : Si t'as un gps je te transmet ça dans quelques secondes",
        textArrivingSellDrugs = "Normalement c'est par ici, arrête toi...",
        textAfterSellDrugs = "Les gars : Un plaisir de faire affaire avec toi... Débarasse toi de la voiture maitenant.",
        textAfterSellDrugsGps = "Les gars : Je t'envoie une position où tu peux la déposer.",
    },
}