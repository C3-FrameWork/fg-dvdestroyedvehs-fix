-- Made by C3
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Discord Webhook URL
local discordWebhook = "WH_URL"

-- Function to send a Discord webhook message
function SendDiscordWebhook(message)
    if discordWebhook ~= "" then
        PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end

-- Event triggered when a vehicle is destroyed
RegisterServerEvent('vehicleDestroyed')
AddEventHandler('vehicleDestroyed', function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local vehicle = ESX.Game.GetVehicleByPlate(plate)

        if vehicle then
            ESX.Game.DeleteVehicle(vehicle)
            xPlayer.showNotification("Your vehicle has been destroyed and deleted.")

            -- Notify the Discord server
            local playerName = GetPlayerName(source)
            local vehicleModel = GetDisplayNameFromVehicleModel(vehicle.model)
            local message = string.format("%s's vehicle (%s) has been destroyed and deleted.", playerName, vehicleModel)
            SendDiscordWebhook(message)
        else
            xPlayer.showNotification("Vehicle not found.")
        end
    end
end)

print("Made by C3 for FG!")