-- Basic fuel logic
local isRefueling = false

CreateThread(function()
    if Config.System == 'target' then
        exports['rpa-lib']:AddTargetModel(Config.FuelNozzleModels, {
            {
                label = "Refuel Vehicle",
                icon = "fas fa-gas-pump", -- Assuming fontawesome available
                action = function(entity)
                    -- Check for vehicle nearby or if player is in vehicle? usually target on pump means OUT of vehicle
                    -- Simple logic: Find closest vehicle
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
    
    local currentFuel = GetVehicleFuelLevel(vehicle)
    local currentFuel = GetVehicleFuelLevel(vehicle)
    if currentFuel >= 100.0 then
        exports['rpa-lib']:Notify(_U('fuel_full'), "info")
        isRefueling = false
        return
    end

    exports['rpa-lib']:Notify(_U('fuel_refueling'), "info", 3000)
    -- Fake progress
    Wait(3000)
    
    SetVehicleFuelLevel(vehicle, 100.0)
    exports['rpa-lib']:Notify(_U('fuel_cost', 50), "success") -- hardcoded 50 for now
    isRefueling = false
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
