Config = {
    -- GLOBAL CONFIGURATION
    language = 'fr', -- Language Name Cf. Texts
    textViewDistance = 2, -- The distance to add the start Text

    -- START
    startNpcCoords = vector4(-1147.98, -1113.96, 1.29, 114.42), -- Coords of the start NPC
    startNpcModel = "ig_lamardavis", -- Skin on the start NPC
    startNpcAnimation = "WORLD_HUMAN_AA_SMOKE", -- Animation of the start NPC
    startNpcName = "Lamar", -- Name of the start NPC (Used in notifcation)
    minEarningMoney = 5000, -- Minimal earning
    maxEarningMoney = 10000, -- Maximal Earning
    missionTimeout = 300000, -- 5 min mission timeout
    policeNotification = {
        title = "CENTRALE",
        subtitle = "GoFast",
        logo = "CHAR_CALL911",
    },
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
    vehicleCoords = vector4(-1163.77, -1119.71, 1.71, 116.15), -- Coords where the vehicle will spawn

    -- FIRST POINT > Load drugs
    loadDrugs = {
        loadingAnimationDictonary = "anim@heists@box_carry@", -- Animation Dictionnary of carrying box
        loadingAnimationName = "idle", -- Animation Name of carrying box
        cargoModelName = "prop_mp_drug_package", -- Props name of the box
        radius = 30, -- Radius of the zone
        loadList = { -- Zone list
            { -- Zone 1
                zoneCoords = vector3(855.41, -2306.84, 30.35), -- Coords of the zone
                ped = { 
                    modelName = "s_m_y_dealer_01", -- Peds model that will bring the box
                    spawnCoords = vector3(869.52, -2308.89, 30.57) -- Peds spawn coords (Hide the spawn for more immersion)
                }, 
            },
            { -- Zone 2
                zoneCoords = vector3(2592.87, 2800.95, 33.55), -- Coords of the zone
                ped = { 
                    modelName = "s_m_y_dealer_01", -- Peds model that will bring the box
                    spawnCoords = vector3(2610.18, 2803.50, 33.72) -- Peds spawn coords (Hide the spawn for more immersion)
                }, 
            },
            { -- Zone 3
                zoneCoords = vector3(1411.70, 3620.54, 34.31), -- Coords of the zone
                ped = { 
                    modelName = "s_m_y_dealer_01", -- Peds model that will bring the box
                    spawnCoords = vector3(1401.53, 3626.90, 34.89) -- Peds spawn coords (Hide the spawn for more immersion)
                }, 
            },
            { -- Zone 4
                zoneCoords = vector3(-800.64, -2904.07, 13.37), -- Coords of the zone
                ped = { 
                    modelName = "s_m_y_dealer_01", -- Peds model that will bring the box
                    spawnCoords = vector3(-815.54, -2905.92, 16.12) -- Peds spawn coords (Hide the spawn for more immersion)
                }, 
            },
            { -- Zone 5
                zoneCoords = vector3(1725.44, -1599.56, 111.94), -- Coords of the zone
                ped = { 
                    modelName = "s_m_y_dealer_01", -- Peds model that will bring the box
                    spawnCoords = vector3(1714.68, -1598.61, 113.81) -- Peds spawn coords (Hide the spawn for more immersion)
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
        sellList = {
            { -- Zone 1
                pedGivingTheMoney = { 
                    modelName = "cs_bankman", -- Peds model that will bring the money
                    spawnCoords = vector3(1213.38, -3097.63, 5.83) -- Peds spawn coords (Hide the spawn for more immersion)
                },
                zoneCoords = vector3(1202.53, -3092.50, 5.80), -- Coords of the zone
                ped = { 
                    modelName = "g_m_y_mexgoon_01", -- Peds model that will take the box
                    spawnCoords = vector3(1213.38, -3097.63, 5.83) -- Peds spawn coords (Hide the spawn for more immersion)
                },
            },
            { -- Zone 2
                pedGivingTheMoney = { 
                    modelName = "cs_bankman", -- Peds model that will bring the money
                    spawnCoords = vector3(-61.74, -2517.78, 7.40) -- Peds spawn coords (Hide the spawn for more immersion)
                },
                zoneCoords = vector3(-62.96, -2526.48, 5.43), -- Coords of the zone
                ped = { 
                    modelName = "g_m_y_mexgoon_01", -- Peds model that will take the box
                    spawnCoords = vector3(-61.74, -2517.78, 7.40) -- Peds spawn coords (Hide the spawn for more immersion)
                },
            },
            { -- Zone 3
                pedGivingTheMoney = { 
                    modelName = "cs_bankman", -- Peds model that will bring the money
                    spawnCoords = vector3(1707.50, 4837.42, 42.02) -- Peds spawn coords (Hide the spawn for more immersion)
                },
                zoneCoords = vector3(1704.46, 4850.85, 41.45), -- Coords of the zone
                ped = { 
                    modelName = "g_m_y_mexgoon_01", -- Peds model that will take the box
                    spawnCoords = vector3(1707.50, 4837.42, 42.02) -- Peds spawn coords (Hide the spawn for more immersion)
                },
            },
            { -- Zone 4
                pedGivingTheMoney = { 
                    modelName = "cs_bankman", -- Peds model that will bring the money
                    spawnCoords = vector3(2001.48, 3039.34, 47.21) -- Peds spawn coords (Hide the spawn for more immersion)
                },
                zoneCoords = vector3(1993.30, 3036.13, 47.03), -- Coords of the zone
                ped = { 
                    modelName = "g_m_y_mexgoon_01", -- Peds model that will take the box
                    spawnCoords = vector3(2001.48, 3039.34, 47.21) -- Peds spawn coords (Hide the spawn for more immersion)
                },
            },
            { -- Zone 5
                pedGivingTheMoney = { 
                    modelName = "cs_bankman", -- Peds model that will bring the money
                    spawnCoords = vector3(91.34, 3746.78, 40.77) -- Peds spawn coords (Hide the spawn for more immersion)
                },
                zoneCoords = vector3(95.47, 3736.00, 39.62), -- Coords of the zone
                ped = { 
                    modelName = "g_m_y_mexgoon_01", -- Peds model that will take the box
                    spawnCoords = vector3(91.34, 3746.78, 40.77) -- Peds spawn coords (Hide the spawn for more immersion)
                },
            },
        },
    },

    -- FINAL POINT > Drop the vehicle
    dropLists = {
        vector3(1244.51, -3276.48, 5.43), -- Coords of the zone
        vector3(-440.91, 6341.68, 12.15), -- Coords of the zone2
        vector3(-496.50, 5264.59, 80.03), -- Coords of the zone3
        vector3(-439.83, -2181.24, 9.74), -- Coords of the zone4
        vector3(1148.64, -1642.00, 35.76), -- Coords of the zone5
    },
    dropRadius = 15, -- Radius of the zone
}