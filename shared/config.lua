Config = {
    -- GLOBAL CONFIGURATION
    language = 'fr', -- Language Name Cf. Texts
    textViewDistance = 2, -- The distance to add the start Text

    -- START
    startNpcCoords = vector4(1296.60, -3346.14, 5.03, 29.02), -- Coords of the start NPC
    startNpcModel = "ig_lamardavis", -- Skin on the start NPC
    startNpcAnimation = "WORLD_HUMAN_AA_SMOKE", -- Animation of the start NPC
    startNpcName = "Lamar", -- Name of the start NPC (Used in notifcation)
    minEarningMoney = 5000, -- Minimal earning
    maxEarningMoney = 10000, -- Maximal Earning
    giveMoneyServerEventName = "cham-gofast:server:giveMoney", -- Server Event name for giving player money
    sendPoliceSearchZoneServer = "chal-gofast:server:sendPoliceSearchZone", -- Server Event name for giving lspd zone
    sendPoliceSearchZoneClient = "chal-gofast:client:sendPoliceSearchZone", -- Server Event name for giving lspd zone
    searchZone = {
        policeSearchZoneRadius = 400.0, -- Radius of search zone
        allowedJobs = { "lspd", },
        SetBlipColour = 5,
        SetBlipAlpha = 128,
    },
    moneyType = "marked_money", -- Type of money (money, marked_money, bank)
    currency = "$", -- currency, used in notification

    -- VEHICLE
    vehicleList = { -- Liste of gofast vehicles
        "Sultan",
        "Sentinel",
        "Dominator3",
        "Raiden",
        "Cypher",
        "Rhinehart",
    },
    vehicleCoords = vector4(1283.35, -3328.08, 5.90, 354.73), -- Coords where the vehicle will spawn

    -- FIRST POINT > Load drugs
    loadDrugs = {
        loadingAnimationDictonary = "anim@heists@box_carry@", -- Animation Dictionnary of carrying box
        loadingAnimationName = "idle", -- Animation Name of carrying box
        cargoModelName = "prop_mp_drug_package", -- Props name of the box
        radius = 30, -- Radius of the zone
        loadList = { -- Zone list
            {
                zoneCoords = vector3(855.41, -2306.84, 30.35), -- Coords of the zone
                ped = { 
                    modelName = "s_m_y_dealer_01", -- Peds model that will bring the box
                    spawnCoords = vector3(869.52, -2308.89, 30.57) -- Peds spawn coords (Hide the spawn for more immersion)
                }, 
            },
        },
    },

    -- SECOND POINT > Unload drugs
    sellDrugs = {
        sellingAnimationDictonary = "anim@heists@box_carry@", -- Animation Dictionnary of carrying box
        sellingAnimationName = "idle", -- Animation Name of carrying box
        giveMoneyAnimationDictonary = "mp_common", -- Animation Dictionnary of giving
        giveMoneyAnimationName = "givetake1_a", -- Animation Name of giving
        cargoModelName = "prop_mp_drug_package",  -- Props name of the box
        suitCaseModelName = "prop_security_case_01",  -- Props name of the suitecase
        radius = 30, -- Radius of the zone
        pedGivingTheMoney = { 
            modelName = "cs_bankman", -- Peds model that will bring the money
            spawnCoords = vector3(1213.38, -3097.63, 5.83) -- Peds spawn coords (Hide the spawn for more immersion)
        },
        sellList = {
            {
                zoneCoords = vector3(1202.53, -3092.50, 5.80), -- Coords of the zone
                ped = { 
                    modelName = "g_m_y_mexgoon_01", -- Peds model that will take the box
                    spawnCoords = vector3(1213.38, -3097.63, 5.83) -- Peds spawn coords (Hide the spawn for more immersion)
                },
            },
        },
    },

    -- FINAL POINT > Drop the vehicle
    dropLists = {
        vector3(1244.51, -3276.48, 5.43), -- Coords of the zone
    },
    dropRadius = 15, -- Radius of the zone

}

-- Languages available
Texts = {
    ['en'] = {
        textToAcceptGoFast = 'Press ~b~[E]~w~ to accept the GoFast mission',
        textAfterStarting = 'Get in the car behind you and go pick up the drugs.',
        textAfterStartingGps = 'If you have a GPS, I will set the location for you...',
        textArrivingLoadDrugs = 'Stop here, they will be here soon',
        textAfterLoadingDrugs = 'Guys: Everything is loaded, go!',
        textAfterLoadingDrugsGps = 'Guys: If you have a GPS, I will send it to you in a few seconds',
        textArrivingSellDrugs = 'It should be around here, stop...',
        textAfterSellDrugs = 'The man: Pleasure doing business with you... Get rid of the car now.',
        textAfterSellDrugsGps = "The man: I'm sending you a location where you can drop it off.",
        getMoneyMessage = 'You have received : ~b~',
        textArrivingDropVehicle = 'Stop here and leave the car, I will come pick it up.',
        done = "I've retrieved the car, come see me if you want to do it again.",

        searchAlert = "~b~Dispatch: A vehicle suspected of GOFAST has been spotted, model: ~g~",
        searchZoneText = "~b~Dispatch: ~y~The zone~b~ is on your GPS",

    },
    ['fr'] = {
        textToAcceptGoFast = 'Appuyez sur ~b~[E]~w~ pour accepter la mission de GoFast',
        textAfterStarting = "Monte dans la voiture derrière toi, et va récupérer la drogue.",
        textAfterStartingGps = "Si t'as un gps je te met la position...",
        textArrivingLoadDrugs = "Arrête toi là, ils ne vont pas tarder",
        textAfterLoadingDrugs = "Les gars : C'est bon tout est chargé, file !",
        textAfterLoadingDrugsGps = "Les gars : Si t'as un gps je te transmet ça dans quelques secondes",
        textArrivingSellDrugs = "Normalement c'est par ici, arrête toi...",
        textAfterSellDrugs = "L'homme : Un plaisir de faire affaire avec toi... Débarasse toi de la voiture maitenant.",
        textAfterSellDrugsGps = "L'homme : Je t'envoie une position où tu peux la déposer.",
        getMoneyMessage = "Vous avez reçu : ~b~",
        textArrivingDropVehicle = "Arrête toi là et laisse la voiture, je vais venir la chercher.",
        done = "C'est bon j'ai récupéré la caisse, passe me voir si tu veux le refaire.",

        searchAlert = "~b~Centrale : Un véhicule suspecté de GOFAST à été repéré, modèle : ~g~",
        searchZoneText = "~b~Centrale : ~y~La zone~b~ est sur votre GPS",
    },
}