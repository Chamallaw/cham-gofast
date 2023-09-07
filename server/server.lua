local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent(Config.giveMoneyServerEventName, function(moneyType, amount)
    local player = QBCore.Functions.GetPlayer(source)
    if player and moneyType and amount then
        player.Functions.AddMoney(moneyType, amount)
    end
end)