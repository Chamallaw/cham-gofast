local QBCore = exports['qb-core']:GetCoreObject()
local startNpc
local isInMission = false
local car = nil
local Texts = Texts[Config.language]
local policeSearchZone = nil


Citizen.CreateThread(function ()
    while true do
        Wait(0)
        if not isInMission then
            exports['qb-target']:AddCircleZone("GoFast", vector3(Config.startNpcCoords.x, Config.startNpcCoords.y, Config.startNpcCoords.z+1), 1.5, { 
            name = "GoFast", 
            debugPoly = false, 
            }, {
            options = { 
                { 
                    num = 1,
                    type = "client", 
                    event = "Test:Event",
                    icon = 'fas fa-car',
                    label = 'Lancer la mission Go Fast', 
                    action = function(startNpc) 
                        if IsPedAPlayer(startNpc) then return false end 
                        startGoFast()
                    end,
                    drawColor = {255, 255, 255, 255},
                    successDrawColor = {30, 144, 255, 255}, 
                }
            },
            distance = 1.5, 
            })
        end
    end
end)

function startGoFast()
    if car == nil then
        isInMission = true
        local vehicleName = Config.vehicleList[math.random(#Config.vehicleList)]
        local hash = GetHashKey(vehicleName)
        while not HasModelLoaded(hash) do
            RequestModel(hash)
            Citizen.Wait(1)
        end
        ClearAreaOfVehicles(Config.vehicleCoords.x,Config.vehicleCoords.y,Config.vehicleCoords.z, 100, false, false, false, false, false)
        car = CreateVehicle(hash, Config.vehicleCoords.x,Config.vehicleCoords.y,Config.vehicleCoords.z, Config.vehicleCoords.w, true, false)
        SetEntityAsMissionEntity(car, false, false)
        SetVehicleDoorsLocked(car, 1)
    
        sendUserMessage(Config.startNpcName.." : "..Texts.textAfterStarting .. vehicleName)
        sendUserMessage(Config.startNpcName.." : "..Texts.textAfterStartingGps)

        local loadDrug = Config.loadDrugs.loadList[math.random(#Config.loadDrugs.loadList)]
        local loadDrugCoords = loadDrug.zoneCoords
        SetNewWaypoint(loadDrugCoords.x, loadDrugCoords.y)
        local isStopMessageSend = false
        local isStoppedInZone = false

        while not isStoppedInZone do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            distance = #(playerCoords-loadDrugCoords)
            if distance <= Config.loadDrugs.radius and not isStopMessageSend then
                sendUserMessage(Config.startNpcName.." : "..Texts.textArrivingLoadDrugs)
                isStopMessageSend = true
            end
            if distance <= Config.loadDrugs.radius and IsVehicleStopped(car) == 1 then
                TriggerServerEvent(EVENT.SENDSEARCHZONE_SERVER, playerCoords, vehicleName)
                isStoppedInZone = true
                FreezeEntityPosition(car, true)
                loadDrugs(car, loadDrug)
            end
        end

        local sellDrug = Config.sellDrugs.sellList[math.random(#Config.sellDrugs.sellList)]
        local sellDrugCoords = sellDrug.zoneCoords
        SetNewWaypoint(sellDrugCoords.x, sellDrugCoords.y)
        isStopMessageSend = false
        isStoppedInZone = false

        while not isStoppedInZone do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            distance = #(playerCoords-sellDrugCoords)
            if distance <= Config.sellDrugs.radius and not isStopMessageSend then
                sendUserMessage(Config.startNpcName.." : "..Texts.textArrivingSellDrugs)
                isStopMessageSend = true
            end
            if distance <= Config.sellDrugs.radius and IsVehicleStopped(car) == 1 then
                TriggerServerEvent(EVENT.SENDSEARCHZONE_SERVER, playerCoords, vehicleName)
                isStoppedInZone = true
                FreezeEntityPosition(car, true)
                unloadDrugs(car, sellDrug)
            end
        end

        local dropPoint = Config.dropLists[math.random(#Config.dropLists)]
        SetNewWaypoint(dropPoint.x, dropPoint.y)
        isStopMessageSend = false
        isStoppedInZone = false

        while not isStoppedInZone do
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            distance = #(playerCoords-dropPoint)
            if distance <= Config.dropRadius and not isStopMessageSend then
                sendUserMessage(Config.startNpcName.." : "..Texts.textArrivingDropVehicle)
                isStopMessageSend = true
            end
            if distance <= Config.dropRadius and IsVehicleStopped(car) == 1 then
                TriggerServerEvent(EVENT.SENDSEARCHZONE_SERVER, playerCoords, vehicleName)
                isStoppedInZone = true
                FreezeEntityPosition(car, true)
                Citizen.Wait(60000)
                DeleteEntity(car)
                car = nil
                isInMission = false
                sendUserMessage(Config.startNpcName.." : "..Texts.done)
            end
        end
    else
        DeleteEntity(car)
        car = nil
        isInMission = false
    end
end

function loadDrugs(car, loadDrug)
    Citizen.Wait(500)
    SetVehicleDoorOpen(car, 5, false, false)

    local drugSeller1, drugSeller2
    local carCoords = GetEntityCoords(car)
    
    local pedHash = GetHashKey(loadDrug.ped.modelName)
    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do
        Wait(50)
    end

    local cargoHash = GetHashKey(Config.loadDrugs.cargoModelName)
    Citizen.CreateThread(function()
        RequestModel(cargoHash)
        while not HasModelLoaded(cargoHash) do
            Wait(50)
        end
    end)

    drugSeller1 = CreatePed(26, loadDrug.ped.modelName, loadDrug.ped.spawnCoords.x, loadDrug.ped.spawnCoords.y, loadDrug.ped.spawnCoords.z, 0.0, true, false)
    drugSeller2 = CreatePed(26, loadDrug.ped.modelName, loadDrug.ped.spawnCoords.x + 1, loadDrug.ped.spawnCoords.y, loadDrug.ped.spawnCoords.z, 0.0, true, false)

    local box = CreateObject(cargoHash, 0, 0, 0, true, true, true)
    local box2 = CreateObject(cargoHash, 0, 0, 0, true, true, true)

    AttachEntityToEntity(box, drugSeller1, GetPedBoneIndex(drugSeller1, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    AttachEntityToEntity(box2, drugSeller2, GetPedBoneIndex(drugSeller2, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    local taskCoords = FindOppositePoint(carCoords.x, carCoords.y, carCoords.z, GetEntityPhysicsHeading(car), 2.5)
    TaskGoToCoordAnyMeans(drugSeller1, taskCoords.x, taskCoords.y, taskCoords.z, 1.0, 0, false, 786603, 0xbf800000)
    TaskGoToCoordAnyMeans(drugSeller2, taskCoords.x, taskCoords.y, taskCoords.z, 1.0, 0, false, 786603, 0xbf800000)
    
    TriggerServerEvent(EVENT.SYNCHANIMATION_SERVER, NetworkGetNetworkIdFromEntity(drugSeller1), Config.loadDrugs.loadingAnimationDictonary, Config.loadDrugs.loadingAnimationName, false)
    TriggerServerEvent(EVENT.SYNCHANIMATION_SERVER, NetworkGetNetworkIdFromEntity(drugSeller2), Config.loadDrugs.loadingAnimationDictonary, Config.loadDrugs.loadingAnimationName, false)

    while #(GetEntityCoords(drugSeller1) - taskCoords) > 1.5 and #(GetEntityCoords(drugSeller2) - taskCoords) > 1.5 do
        Citizen.Wait(500)
    end
    Citizen.Wait(1000)
    SetEntityHeading(drugSeller1, GetEntityPhysicsHeading(car))
    SetEntityHeading(drugSeller2, GetEntityPhysicsHeading(car))
    Citizen.Wait(4000)
    
    DeleteEntity(box)
    DeleteEntity(box2)

    TriggerServerEvent(EVENT.SYNCHANIMATION_SERVER, NetworkGetNetworkIdFromEntity(drugSeller1), Config.loadDrugs.loadingAnimationDictonary, Config.loadDrugs.loadingAnimationName, true)
    TriggerServerEvent(EVENT.SYNCHANIMATION_SERVER, NetworkGetNetworkIdFromEntity(drugSeller2), Config.loadDrugs.loadingAnimationDictonary, Config.loadDrugs.loadingAnimationName, true)

    TaskGoToCoordAnyMeans(drugSeller1, loadDrug.ped.spawnCoords.x, loadDrug.ped.spawnCoords.y, loadDrug.ped.spawnCoords.z, 1.0, 0, false, 786603, 0xbf800000)
    TaskGoToCoordAnyMeans(drugSeller2, loadDrug.ped.spawnCoords.x + 1, loadDrug.ped.spawnCoords.y, loadDrug.ped.spawnCoords.z, 1.0, 0, false, 786603, 0xbf800000)
    
    SetVehicleDoorShut(car, 5, false)

    Citizen.Wait(100)

    sendUserMessage(Texts.textAfterLoadingDrugs)
    sendUserMessage(Texts.textAfterLoadingDrugsGps)
    FreezeEntityPosition(car, false)

    Citizen.Wait(10000)

    DeleteEntity(drugSeller1)
    DeleteEntity(drugSeller2)

end

function unloadDrugs(car, sellDrugs)
    local ped1, ped2
    local carCoords = GetEntityCoords(car)
    
    local pedHash = GetHashKey(sellDrugs.pedGivingTheMoney.modelName)
    RequestModel(pedHash)
    while not HasModelLoaded(pedHash) do
        Wait(50)
    end
    local pedHash2 = GetHashKey(sellDrugs.ped.modelName)
    RequestModel(pedHash2)
    while not HasModelLoaded(pedHash2) do
        Wait(50)
    end

    local cargoHash = GetHashKey(Config.sellDrugs.cargoModelName)
    Citizen.CreateThread(function()
        RequestModel(cargoHash)
        while not HasModelLoaded(cargoHash) do
            Wait(50)
        end
    end)
    
    local suitcaseModel = GetHashKey(Config.sellDrugs.suitCaseModelName)
    Citizen.CreateThread(function()
        RequestModel(suitcaseModel)
        while not HasModelLoaded(suitcaseModel) do
            Wait(50)
        end
    end)
    
    ped1 = CreatePed(26, sellDrugs.ped.modelName, sellDrugs.ped.spawnCoords.x, sellDrugs.ped.spawnCoords.y, sellDrugs.ped.spawnCoords.z, 0.0, true, false)
    ped2 = CreatePed(26, sellDrugs.ped.modelName, sellDrugs.ped.spawnCoords.x + 1, sellDrugs.ped.spawnCoords.y, sellDrugs.ped.spawnCoords.z, 0.0, true, false)
    
    local taskCoords = FindOppositePoint(carCoords.x, carCoords.y, carCoords.z, GetEntityPhysicsHeading(car), 2.5)
    TaskGoToCoordAnyMeans(ped1, taskCoords.x, taskCoords.y, taskCoords.z, 1.0, 0, false, 786603, 0xbf800000)
    TaskGoToCoordAnyMeans(ped2, taskCoords.x, taskCoords.y, taskCoords.z, 1.0, 0, false, 786603, 0xbf800000)
    
    SetVehicleDoorOpen(car, 5, false, false)
    while #(GetEntityCoords(ped1) - taskCoords) > 2 and #(GetEntityCoords(ped2) - taskCoords) > 2 do
        Citizen.Wait(500)
    end
    Citizen.Wait(1000)
    SetEntityHeading(ped1, GetEntityPhysicsHeading(car))
    SetEntityHeading(ped2, GetEntityPhysicsHeading(car))
    
    TriggerServerEvent(EVENT.SYNCHANIMATION_SERVER, NetworkGetNetworkIdFromEntity(ped1), Config.sellDrugs.sellingAnimationDictonary, Config.sellDrugs.sellingAnimationName, false)
    TriggerServerEvent(EVENT.SYNCHANIMATION_SERVER, NetworkGetNetworkIdFromEntity(ped2), Config.sellDrugs.sellingAnimationDictonary, Config.sellDrugs.sellingAnimationName, false)
    
    local box = CreateObject(cargoHash, 0, 0, 0, true, true, true)
    local box2 = CreateObject(cargoHash, 0, 0, 0, true, true, true)
    
    AttachEntityToEntity(box, ped1, GetPedBoneIndex(ped1, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    AttachEntityToEntity(box2, ped2, GetPedBoneIndex(ped2, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    Wait(500)
   
    SetVehicleDoorShut(car, 5, false)

    TaskGoToCoordAnyMeans(ped1, sellDrugs.ped.spawnCoords.x, sellDrugs.ped.spawnCoords.y, sellDrugs.ped.spawnCoords.z, 1.0, 0, false, 786603, 0xbf800000)
    TaskGoToCoordAnyMeans(ped2, sellDrugs.ped.spawnCoords.x + 2, sellDrugs.ped.spawnCoords.y, sellDrugs.ped.spawnCoords.z, 1.0, 0, false, 786603, 0xbf800000)
   
    pedGivingTheMoney = CreatePed(26, sellDrugs.pedGivingTheMoney.modelName, sellDrugs.pedGivingTheMoney.spawnCoords.x, sellDrugs.pedGivingTheMoney.spawnCoords.y, sellDrugs.pedGivingTheMoney.spawnCoords.z, 0.0, true, false)
    local suitcase = CreateObject(suitcaseModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(suitcase, pedGivingTheMoney, GetPedBoneIndex(pedGivingTheMoney, 57005), 0.2, 0.0, 0.0, 0.0, -90.0, 0.0, true, true, false, true, 1, true)
    
    TaskGoToCoordAnyMeans(pedGivingTheMoney, taskCoords.x, taskCoords.y, taskCoords.z, 1.0, 0, false, 786603, 0xbf800000)
    
    while #(taskCoords - GetEntityCoords(pedGivingTheMoney)) > 2 do
        Citizen.Wait(500)
    end
    Citizen.Wait(1000)
    SetEntityHeading(ped1, GetEntityPhysicsHeading(car))
    TriggerServerEvent(EVENT.SYNCHANIMATION_SERVER, NetworkGetNetworkIdFromEntity(pedGivingTheMoney), Config.sellDrugs.giveMoneyAnimationDictonary, Config.sellDrugs.giveMoneyAnimationName, false)
    
    Citizen.Wait(2000)

    TriggerServerEvent(EVENT.SYNCHANIMATION_SERVER, NetworkGetNetworkIdFromEntity(pedGivingTheMoney), Config.sellDrugs.giveMoneyAnimationDictonary, Config.sellDrugs.giveMoneyAnimationName, true)
    DeleteEntity(suitcase)
    
    -- Give the player money
    local amount = math.random(Config.minEarningMoney, Config.maxEarningMoney)
    TriggerServerEvent(EVENT.GIVEMONEY, Config.moneyType, amount)
    sendUserMessage(Texts.getMoneyMessage..amount..Config.currency)

    TaskGoToCoordAnyMeans(pedGivingTheMoney, sellDrugs.ped.spawnCoords.x + 1, sellDrugs.ped.spawnCoords.y, sellDrugs.ped.spawnCoords.z, 1.0, 0, false, 786603, 0xbf800000)
    
    Citizen.Wait(1000)
    
    sendUserMessage(Texts.textAfterSellDrugs)
    sendUserMessage(Texts.textAfterSellDrugsGps)
    FreezeEntityPosition(car, false)
    
    Citizen.Wait(10000)
    
    DeleteEntity(box)
    DeleteEntity(box2)
    DeleteEntity(ped1)
    DeleteEntity(ped2)
    DeleteEntity(pedGivingTheMoney)
end

function sendUserMessage(text)
    -- Replace this with your notification système
    exports["soz-core"]:DrawNotification(text)
end

function sendPoliceMessage(text)
    -- Replace this with your notification système
    exports["soz-core"]:DrawAdvancedNotification(Config.policeNotification.title, Config.policeNotification.subtitle, text, Config.policeNotification.logo)
end

Citizen.CreateThread(function()
    local hash = GetHashKey(Config.startNpcModel)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(500)
    end
    startNpc = CreatePed(0, Config.startNpcModel, Config.startNpcCoords.x, Config.startNpcCoords.y, Config.startNpcCoords.z, Config.startNpcCoords.w, false, true)
    SetBlockingOfNonTemporaryEvents(startNpc, true)
    FreezeEntityPosition(startNpc, true)
    SetEntityInvincible(startNpc, true)
    RemoveAllPedWeapons(startNpc, true)
end)

-- Reset Mission
Citizen.CreateThread(function()
    while true do
        if isInMission and car ~= nil then
            local timer = GetGameTimer() + Config.missionTimeout
            while not IsPedInVehicle(GetPlayerPed(-1), car, false) and isInMission do
                if GetGameTimer() >= timer then
                    isInMission = false
                    DeleteEntity(car)
                    car = nil
                    sendUserMessage("~r~"..Config.startNpcName.." : "..Texts.failTimeout)
                end
                Citizen.Wait(60000)
            end
            timer = GetGameTimer() + Config.missionTimeout
        end
        Citizen.Wait(60000)
    end
end)

-- Send Police Search Zone
RegisterNetEvent(EVENT.SENDSEARCHZONE_CLIENT, function(coords, vehicleName)
    if policeSearchZone ~= nil then
        RemoveBlip(policeSearchZone)
    end

    policeSearchZone = AddBlipForRadius(coords.x, coords.y, coords.z , Config.searchZone.policeSearchZoneRadius) -- you can use a higher number for a bigger zone

	SetBlipHighDetail(policeSearchZone, true)
	SetBlipColour(policeSearchZone, Config.searchZone.SetBlipColour)
	SetBlipAlpha(policeSearchZone, Config.searchZone.SetBlipAlpha)

    sendPoliceMessage(Texts.searchAlert..vehicleName)
    sendPoliceMessage(Texts.searchZoneText)
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", false)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    DeleteEntity(startNpc)
    if car ~= nil then
        DeleteEntity(car)
    end
end)

RegisterNetEvent(EVENT.SYNCHANIMATION_CLIENT, function(pedNetId, dict, anim, stopAnimation)
    local ped = NetworkGetEntityFromNetworkId(pedNetId)
    if stopAnimation then
        StopAnimTask(ped, dict, anim, 1.0)
    else
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(100)
        end
        TaskPlayAnim(ped, dict, anim, 8.0, 8.0, -1, 49, 0, false, false, false)
    end
end)

function FindOppositePoint(x, y, z, heading, distance)
    -- Ajouter 180 degrés pour obtenir la direction opposée
    local opposite_theta = heading + 270

    -- S'assurer que la direction reste dans [0, 360)
    if opposite_theta >= 360 then
        opposite_theta = opposite_theta - 360
    end

    -- Convertir theta de degrés à radians
    local theta_rad = math.pi * opposite_theta / 180

    -- Trouver le point sur le cercle de rayon 2 mètres dans la direction opposée
    local x_new = x + distance * math.cos(theta_rad)
    local y_new = y + distance * math.sin(theta_rad)

    -- Retourner les nouvelles coordonnées
    return vector3(x_new, y_new, z)
end