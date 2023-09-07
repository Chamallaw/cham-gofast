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
        SetEntityAsMissionEntity(car, true, true)
        SetVehicleDoorsLocked(car, 1)
        SetVehicleDoorsLockedForAllPlayers(car, false)
    
        sendUserMessage(Config.startNpcName.." : "..Texts.textAfterStarting)
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
                TriggerServerEvent(Config.sendPoliceSearchZoneServer, playerCoords, vehicleName)
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
                TriggerServerEvent(Config.sendPoliceSearchZoneServer, playerCoords, vehicleName)
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
                TriggerServerEvent(Config.sendPoliceSearchZoneServer, playerCoords, vehicleName)
                isStoppedInZone = true
                FreezeEntityPosition(car, true)
                Citizen.Wait(300000) -- 5 Minutes
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
    local voiturePosition = GetEntityCoords(car)
    
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

    TaskGoToCoordAnyMeans(drugSeller1, voiturePosition.x, voiturePosition.y, voiturePosition.z, 1.0, 0, false, 786603, 0xbf800000)
    TaskGoToCoordAnyMeans(drugSeller2, voiturePosition.x, voiturePosition.y, voiturePosition.z, 1.0, 0, false, 786603, 0xbf800000)
    RequestAnimDict(Config.loadDrugs.loadingAnimationDictonary)
    while not HasAnimDictLoaded(Config.loadDrugs.loadingAnimationDictonary) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(drugSeller1, Config.loadDrugs.loadingAnimationDictonary, Config.loadDrugs.loadingAnimationName, 8.0, -8.0, -1, 49, 0, false, false, false)
    TaskPlayAnim(drugSeller2, Config.loadDrugs.loadingAnimationDictonary, Config.loadDrugs.loadingAnimationName, 8.0, -8.0, -1, 49, 0, false, false, false)
    
    while #(GetEntityCoords(drugSeller1) - GetEntityCoords(car)) > 2 and #(GetEntityCoords(drugSeller2) - GetEntityCoords(car)) > 2 do
        Citizen.Wait(500)
    end
    
    Citizen.Wait(5000)

    DeleteEntity(box)
    DeleteEntity(box2)

    StopAnimTask(drugSeller1, Config.loadDrugs.loadingAnimationDictonary, Config.loadDrugs.loadingAnimationName, 1.0)
    StopAnimTask(drugSeller2, Config.loadDrugs.loadingAnimationDictonary, Config.loadDrugs.loadingAnimationName, 1.0)

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
    local voiturePosition = GetEntityCoords(car)
    
    local pedHash = GetHashKey(Config.sellDrugs.pedGivingTheMoney.modelName)
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
    
    TaskGoToCoordAnyMeans(ped1, voiturePosition.x, voiturePosition.y, voiturePosition.z, 1.0, 0, false, 786603, 0xbf800000)
    TaskGoToCoordAnyMeans(ped2, voiturePosition.x, voiturePosition.y, voiturePosition.z, 1.0, 0, false, 786603, 0xbf800000)
    
    SetVehicleDoorOpen(car, 5, false, false)
    while #(GetEntityCoords(ped1) - GetEntityCoords(car)) > 2 and #(GetEntityCoords(ped2) - GetEntityCoords(car)) > 2 do
        Citizen.Wait(500)
    end
    RequestAnimDict(Config.sellDrugs.sellingAnimationDictonary)
    while not HasAnimDictLoaded(Config.sellDrugs.sellingAnimationDictonary) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(ped1, Config.sellDrugs.sellingAnimationDictonary, Config.sellDrugs.sellingAnimationName, 8.0, -8.0, -1, 49, 0, false, false, false)
    TaskPlayAnim(ped2, Config.sellDrugs.sellingAnimationDictonary, Config.sellDrugs.sellingAnimationName, 8.0, -8.0, -1, 49, 0, false, false, false)
    
    
    local box = CreateObject(cargoHash, 0, 0, 0, true, true, true)
    local box2 = CreateObject(cargoHash, 0, 0, 0, true, true, true)
    
    AttachEntityToEntity(box, ped1, GetPedBoneIndex(ped1, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    AttachEntityToEntity(box2, ped2, GetPedBoneIndex(ped2, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    Wait(500)
   
    SetVehicleDoorShut(car, 5, false)
   
    TaskGoToCoordAnyMeans(ped1, sellDrugs.ped.spawnCoords.x, sellDrugs.ped.spawnCoords.y, sellDrugs.ped.spawnCoords.z, 1.0, 0, false, 786603, 0xbf800000)
    TaskGoToCoordAnyMeans(ped2, sellDrugs.ped.spawnCoords.x + 2, sellDrugs.ped.spawnCoords.y, sellDrugs.ped.spawnCoords.z, 1.0, 0, false, 786603, 0xbf800000)
   
    pedGivingTheMoney = CreatePed(26, Config.sellDrugs.pedGivingTheMoney.modelName, Config.sellDrugs.pedGivingTheMoney.spawnCoords.x, Config.sellDrugs.pedGivingTheMoney.spawnCoords.y, Config.sellDrugs.pedGivingTheMoney.spawnCoords.z, 0.0, true, false)
    local suitcase = CreateObject(suitcaseModel, 0, 0, 0, true, true, true)
    AttachEntityToEntity(suitcase, pedGivingTheMoney, GetPedBoneIndex(pedGivingTheMoney, 57005), 0.2, 0.0, 0.0, 0.0, -90.0, 0.0, true, true, false, true, 1, true)
    
    local playerPos = GetEntityCoords(PlayerPedId())
    TaskGoToCoordAnyMeans(pedGivingTheMoney, playerPos.x, playerPos.y, playerPos.z, 1.0, 0, false, 786603, 0xbf800000)
    
    while #(playerPos - GetEntityCoords(pedGivingTheMoney)) > 2 do
        Citizen.Wait(500)
    end

    RequestAnimDict(Config.sellDrugs.giveMoneyAnimationDictonary)
    while not HasAnimDictLoaded(Config.sellDrugs.giveMoneyAnimationDictonary) do
        Citizen.Wait(0)
    end

    TaskPlayAnim(pedGivingTheMoney, Config.sellDrugs.giveMoneyAnimationDictonary, Config.sellDrugs.giveMoneyAnimationName, 8.0, -8.0, -1, 49, 0, false, false, false)

    Citizen.Wait(2000)

    StopAnimTask(pedGivingTheMoney, Config.sellDrugs.giveMoneyAnimationDictonary, Config.sellDrugs.giveMoneyAnimationName, 1.0)
    DeleteEntity(suitcase)
    
    -- Give the player money
    local amount = math.random(Config.minEarningMoney, Config.maxEarningMoney)
    TriggerServerEvent(Config.giveMoneyServerEventName, Config.moneyType, amount)
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

Citizen.CreateThread(function()
    local hash = GetHashKey(Config.startNpcModel)
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(5000)
    end
    startNpc = CreatePed("PED_TYPE_CIVMALE", Config.startNpcModel, Config.startNpcCoords.x, Config.startNpcCoords.y, Config.startNpcCoords.z, Config.startNpcCoords.w, false, true)
    SetBlockingOfNonTemporaryEvents(startNpc, true)
    FreezeEntityPosition(startNpc, true)
    SetEntityInvincible(startNpc, true)
    RemoveAllPedWeapons(startNpc, true)
end)

-- Send Police Search Zone
RegisterNetEvent(Config.sendPoliceSearchZoneClient, function(coords, vehicleName)
    if policeSearchZone ~= nil then
        RemoveBlip(policeSearchZone)
    end

    policeSearchZone = AddBlipForRadius(coords.x, coords.y, coords.z , Config.searchZone.policeSearchZoneRadius) -- you can use a higher number for a bigger zone

	SetBlipHighDetail(policeSearchZone, true)
	SetBlipColour(policeSearchZone, Config.searchZone.SetBlipColour)
	SetBlipAlpha(policeSearchZone, Config.searchZone.SetBlipAlpha)

    sendUserMessage(Texts.searchAlert..vehicleName)
    sendUserMessage(Texts.searchZoneText)
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", false)
end)

AddEventHandler('onResourceStop', function(resourceName)
    DeleteEntity(startNpc)
end)