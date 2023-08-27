-- Made by C3
-- FIXED
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Discord Webhook URL
local discordWebhook = "YOUR_DISCORD_WEBHOOK_URL_HERE"

-- Function to send a Discord webhook message
function SendDiscordWebhook(message)
    if discordWebhook ~= "" then
        PerformHttpRequest(discordWebhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
    end
end

-- Event triggered when an entity is damaged
AddEventHandler('entityDamaged', function(entity, damageData)
    if DoesEntityExist(entity) and IsEntityAVehicle(entity) then
        local health = GetEntityHealth(entity)
        if health <= 0 then
            local plate = ESX.Game.GetVehicleProperties(entity).plate

            if plate then
                local xPlayer = ESX.GetPlayerFromIdentifier(ESX.GetPlayerIdentifier(source))
                if xPlayer then
                    ESX.Game.DeleteVehicle(entity)
                    xPlayer.showNotification("Your vehicle has been destroyed and deleted.")

                    -- Notify the Discord server
                    local playerName = xPlayer.getName()
                    local vehicleModel = GetDisplayNameFromVehicleModel(GetEntityModel(entity))
                    local message = string.format("%s's vehicle (%s) has been destroyed and deleted.", playerName, vehicleModel)
                    SendDiscordWebhook(message)
                end
            end
        end
    end
end)



print("Made by C3 for FG!")
