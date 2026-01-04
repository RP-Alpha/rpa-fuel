-- Fuel payment system
RegisterNetEvent('rpa-fuel:server:pay', function(amount)
    local src = source
    local Framework = exports['rpa-lib']:GetFramework()
    
    if not Framework then
        print("[rpa-fuel] ERROR: Framework not found")
        return
    end
    
    local Player = Framework.Functions.GetPlayer(src)
    if not Player then
        exports['rpa-lib']:Notify(src, "Player data not found", "error")
        return
    end
    
    local cash = Player.PlayerData.money.cash
    local bank = Player.PlayerData.money.bank
    
    -- Try to pay with cash first, then bank
    if cash >= amount then
        Player.Functions.RemoveMoney('cash', amount, 'fuel-purchase')
        exports['rpa-lib']:Notify(src, "Paid $" .. amount .. " for fuel (cash)", "success")
        TriggerClientEvent('rpa-fuel:client:paymentSuccess', src, amount)
    elseif bank >= amount then
        Player.Functions.RemoveMoney('bank', amount, 'fuel-purchase')
        exports['rpa-lib']:Notify(src, "Paid $" .. amount .. " for fuel (bank)", "success")
        TriggerClientEvent('rpa-fuel:client:paymentSuccess', src, amount)
    else
        exports['rpa-lib']:Notify(src, "You don't have enough money", "error")
        TriggerClientEvent('rpa-fuel:client:paymentFailed', src)
    end
end)
