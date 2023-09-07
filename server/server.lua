local QBCore = exports['qb-core']:GetCoreObject()

-- Give Player Money
RegisterNetEvent(Config.giveMoneyServerEventName, function(moneyType, amount)
    local player = QBCore.Functions.GetPlayer(source)
    if player and moneyType and amount then
        player.Functions.AddMoney(moneyType, amount)
    end
end)

-- Send Police Search Zone
RegisterNetEvent(Config.sendPoliceSearchZoneServer, function(coords, vehicleName)
    local players = QBCore.Functions.GetPlayers()
    for i=1, #players, 1 do
        local xPlayer = QBCore.Functions.GetPlayer(players[i])
        if xPlayer then
            local playerJob = xPlayer.PlayerData.job.id
            local onDuty = xPlayer.PlayerData.job.onduty
            for _, job in pairs(Config.searchZone.allowedJobs) do
                if job == playerJob and onDuty then
                    -- Randomize the search zone
                    local newCoords = vector3(coords.x + math.random(-Config.searchZone.policeSearchZoneRadius+50.0, Config.searchZone.policeSearchZoneRadius-50.0), 
                                              coords.y + math.random(-Config.searchZone.policeSearchZoneRadius+50.0, Config.searchZone.policeSearchZoneRadius-50.0), 
                                              coords.z)
                    TriggerClientEvent(Config.sendPoliceSearchZoneClient, players[i], newCoords, vehicleName)
                end
            end
        end
    end
end)