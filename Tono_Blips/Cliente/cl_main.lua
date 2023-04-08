local coorz = {}
local blijp = {}
local blibpImported = {}
serversql = {}
local blip = nil
local photos = {}
local importedData = {}

--[[

I dont use callbacks because i intended this script to be truly standalone. and also my pure lazines. soo enjoy editing.! 
i know is not the most eficiant script there is but hey, it got you interested xd. 

]]

Citizen.CreateThread(function()
    local id = GetPlayerServerId(PlayerId())
    while true do
        Wait(500)
        TriggerEvent('chat:addSuggestion', '/'..Config.OpenContext..'', ' Create Blip In Game (Admin Use Only)')
        TriggerServerEvent("Tono_Blips:TO_Client", id)
        TriggerServerEvent("Tono_Blips:Client_Photos", id)
        TriggerServerEvent("Tono_Blips:Client_Colors", id)
        TriggerServerEvent("Tono_Blips:Permisos", id)
        break
    end
end)



function ImportBlip(coordinates, sprite, color, size, blip_text, sourceScript, duration) -- duration
    local importedblipsdata = {
        sourceScript = sourceScript,
        coordenadas = coordinates,
        logo = sprite,
        lanco = color,
        tamano = size,
        Name = blip_text,
        duration = duration
    }
    table.insert(importedData, importedblipsdata)
    ExportedBlipsTable(importedData)
end

function ClearBlips(sourceScript)
    borrarimports(sourceScript)
    importedData = {}
end

function borrarimports(sourceScript)
    for k, v in pairs(blibpImported) do
        if v.sourceScript == sourceScript then
            RemoveBlip(v.blip)
            table.remove(blibpImported, k)
        end
    end
end


exports('ImportBlip', ImportBlip)
exports('ClearBlips', ClearBlips)

RegisterNetEvent("Tono_Blips:print")
AddEventHandler("Tono_Blips:print", function (error)
    if error then
        administrador = true
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        TriggerEvent('chat:removeSuggestion', '/'..Config.OpenContext..'')
        for k,v in pairs(blijp) do
            RemoveBlip(v)
        end
        for k,v in pairs(blibpImported) do
            RemoveBlip(v.blip)
        end
    end
end)

RegisterNetEvent("Tono_Blips:Load_Table")
AddEventHandler("Tono_Blips:Load_Table", function (coorz)
    serversql = coorz
    CreateBlip(serversql)
    abrirmenu(true, coorz)
end)

RegisterNetEvent("Tono_Blips:Load_Photos")
AddEventHandler("Tono_Blips:Load_Photos", function (data)
    photos = data
    local photodata = {}
    for i, v in ipairs(photos) do
        table.insert(photodata, {['id'] = v.id, ['name'] = v.alt, ['src'] = v.src})
    end

    print('test'..json.encode(photodata))

    SendNUIMessage({
        type = 'photo_data',
        tableData = json.encode(photodata)
    })
end)

RegisterNetEvent("Tono_Blips:Load_Colors")
AddEventHandler("Tono_Blips:Load_Colors", function (data)
    photos = data
    local photodata = {}
    for i, v in ipairs(photos) do
        table.insert(photodata, {['id'] = v.id, ['name'] = v.name, ['color'] = v.color})
    end

    print('test'..json.encode(photodata))

    SendNUIMessage({
        type = 'color_data',
        tableData = json.encode(photodata)
    })
end)


RegisterNetEvent("Tono_Blips:Client:Removeblips")
AddEventHandler("Tono_Blips:Client:Removeblips", function ()
    for k,v in pairs(blijp) do
        RemoveBlip(v)
    end
end)

RegisterNetEvent("Tono_Blips:MenuBlip")
AddEventHandler("Tono_Blips:MenuBlip", function (source)
    if administrador then
        abrirmenu(false, serversql)
    end
end)



---------------
-- Functions --
---------------

function Tono_Blips_Notify(title, subtitle, message, duration) -- this shit here manage the notifications. you here can add ur code if u want (●'◡'●)
    if title == nil then title = "Notification" end
    if subtitle == nil then subtitle = "" end
    if message == nil then message = "" end
    if duration == nil then duration = 5000 end

    Citizen.CreateThread(function()
        SetNotificationTextEntry("STRING")
        AddTextComponentSubstringPlayerName(message)
        local notification = SetNotificationMessage("CHAR_DEFAULT", "CHAR_DEFAULT", true, 0, title, subtitle)
        DrawNotification(false, true)

        local endTime = GetGameTimer() + duration
        while (GetGameTimer() < endTime) do
            Citizen.Wait(0)
        end

        RemoveNotification(notification)
    end)
end






function ExportedBlipsTable(datos) -- this other shit manage the blips created with the export....
    for _, v in pairs(datos) do
        local blipImport = AddBlipForCoord(v.coordenadas.x, v.coordenadas.y)
        SetBlipDisplay(blipImport, 2)
        SetBlipSprite(blipImport, v.logo)
        SetBlipColour(blipImport, v.lanco)
        SetBlipScale(blipImport, v.tamano)
        SetBlipAsShortRange(blipImport, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.Name)
        EndTextCommandSetBlipName(blipImport)

        local blipData = {
            blip = blipImport,
            sourceScript = v.sourceScript -- i had to implement this so the blips dont errase when other exports try to create blips. if some one have a better idea contact me or just make a PR in git hub
        }

        if v.duration then
            Citizen.SetTimeout(v.duration, function()
                RemoveBlip(blipImport)
            end)
        else
            table.insert(blibpImported, blipData)
        end
    end
end



function CreateBlip(data) -- create the blips from the nui. 
    for k, v in pairs(data) do
        blip = AddBlipForCoord(v.Coords.x, v.Coords.y, v.Coords.z)
        SetBlipDisplay(blip, 2)
        SetBlipSprite(blip, v.Sprite)
        SetBlipColour(blip, v.Color)
        SetBlipScale(blip, v.Size)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.Title)
        EndTextCommandSetBlipName(blip)
        table.insert(blijp, blip)
    end
end