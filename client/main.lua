-- Basic fuel logic
local isRefueling = false
local pendingVehicle = nil

CreateThread(function()
    if Config.System == 'target' then
        exports['rpa-lib']:AddTargetModel(Config.FuelNozzleModels, {
            {
                label = "Refuel Vehicle",
                icon = "fas fa-gas-pump",
                action = function(entity)
                    local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 5.0, 0, 71)
                    if DoesEntityExist(vehicle) then
                        TriggerEvent('rpa-fuel:client:requestRefuel', vehicle)
                    else
                        exports['rpa-lib']:Notify("No vehicle nearby!", "error")
                    end
                end
            }
        })
    end
end)

RegisterNetEvent('rpa-fuel:client:requestRefuel', function(vehicle)
    if isRefueling then return end
    isRefueling = true
    pendingVehicle = vehicle
    
    local currentFuel = GetVehicleFuelLevel(vehicle)
    if currentFuel >= 100.0 then
        exports['rpa-lib']:Notify(_U('fuel_full') or "Tank is full", "info")
        isRefueling = false
        pendingVehicle = nil
        return
    end
    
    local fuelNeeded = 100.0 - currentFuel
    local cost = math.ceil(fuelNeeded * Config.FuelCost)

    exports['rpa-lib']:Notify(_U('fuel_refueling') or "Refueling...", "info", 3000)
    
    -- Refueling animation
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)
    Wait(3000)
    ClearPedTasks(ped)
    
    -- Request payment from server
    TriggerServerEvent('rpa-fuel:server:pay', cost)
end)

-- Payment success - complete the refuel
RegisterNetEvent('rpa-fuel:client:paymentSuccess', function(amount)
    if pendingVehicle and DoesEntityExist(pendingVehicle) then
        SetVehicleFuelLevel(pendingVehicle, 100.0)
    end
    isRefueling = false
    pendingVehicle = nil
end)

-- Payment failed - cancel the refuel
RegisterNetEvent('rpa-fuel:client:paymentFailed', function()
    isRefueling = false
    pendingVehicle = nil
end)

-- Fuel Consumption Loop
CreateThread(function()
    local wait = 2000
    while true do
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            wait = 1000
            local vehicle = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                local currentFuel = GetVehicleFuelLevel(vehicle)
                local rpm = GetVehicleCurrentRpm(vehicle)
                local speed = GetEntitySpeed(vehicle)
                
                if currentFuel > 0 then
                    if speed > 1.0 and rpm > 0.2 then
                        local consumption = (rpm * speed) / 2000
                        SetVehicleFuelLevel(vehicle, currentFuel - consumption)
                    end
                else
                    SetVehicleEngineOn(vehicle, false, true, true)
                end
            end
        else
            wait = 2000
        end
        Wait(wait)
    end
end)
