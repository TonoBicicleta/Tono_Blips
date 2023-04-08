--[[

hey welcome back xd. 

note. im a huge stargate sg-1 fan. 

if some one have an idea on how to optmize this code will be apreciated

FEEL FREE TO MAKE PR IN GITHUB.


]]


RegisterCommand(Config.OpenContext, function(source, args, rawmessage)
    if (source > 0) then
        local ped = GetPlayerPed(source)
        local coordenadas = GetEntityCoords(ped)
        TriggerClientEvent('Tono_Blips:MenuBlip', source)
    end
end, true)


RegisterServerEvent('Tono_Blips:Permisos')
AddEventHandler('Tono_Blips:Permisos', function(source)
    local _source = source
    if not IsPlayerAceAllowed(source, 'Tono_Blips') then
        return
    end
    TriggerClientEvent("Tono_Blips:print", source, true)
end)

RegisterServerEvent('Tono_Blips:TO_Client')
AddEventHandler('Tono_Blips:TO_Client', function (source, bool)
    local loadFile= LoadResourceFile(GetCurrentResourceName(), "./Blips.json")
    local extract = {}
    extract = json.decode(loadFile)
    TriggerClientEvent("Tono_Blips:Load_Table", source, extract)
end)


RegisterServerEvent('Tono_Blips:Client_Photos')
AddEventHandler('Tono_Blips:Client_Photos', function (source, bool)
    local loadFile= LoadResourceFile(GetCurrentResourceName(), "./blips_meta.json")
    local extract = {}
    extractorfotos = json.decode(loadFile)
    TriggerClientEvent("Tono_Blips:Load_Photos", source, extractorfotos)
end)

RegisterServerEvent('Tono_Blips:Client_Colors')
AddEventHandler('Tono_Blips:Client_Colors', function (source, bool)
    local loadFile= LoadResourceFile(GetCurrentResourceName(), "./blips_colors.json")
    extractorcolors = json.decode(loadFile)
    TriggerClientEvent("Tono_Blips:Load_Colors", source, extractorcolors)
end)

RegisterServerEvent('Tono_Blips:To_Json')
AddEventHandler('Tono_Blips:To_Json', function (title, coords, color, sprite, size)
    local tableblip = {}
    local archivo = LoadResourceFile(GetCurrentResourceName(), "Blips.json")
    tableblip = json.decode(archivo)
	local inserting = {
        Coords = coords,
        Size = size,
        Sprite = sprite,
        Color = color,
        Title = title
    }
	table.insert(tableblip, inserting)
	SaveResourceFile(GetCurrentResourceName(), "Blips.json", json['encode'](tableblip, { indent = true }), -1)
    TriggerClientEvent('Tono_Blips:Client:Removeblips', -1)
    Wait(250)
    TriggerEvent('Tono_Blips:TO_Client', -1)
end)


RegisterServerEvent('Tono_Blips:delete')
AddEventHandler('Tono_Blips:delete', function (id)
    local loadz = LoadResourceFile(GetCurrentResourceName(), "Blips.json")
    tableblip = json.decode(loadz)
    table['remove'](tableblip, id)
    SaveResourceFile(GetCurrentResourceName(), "Blips.json", json['encode'](tableblip, { indent = true }), -1)
    TriggerClientEvent('Tono_Blips:Client:Removeblips', -1)
    Wait(250)
    TriggerEvent('Tono_Blips:TO_Client', -1)
end)


function checkVersion() 
    local versionUrl = "https://raw.githubusercontent.com/TonoBicicleta/Tono_Zone_VerCheck/main/Blipeo.json"
    local fxVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
    PerformHttpRequest(versionUrl, function(errorCode, resultData, resultHeaders)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data and data.version and data.version > fxVersion then
                print("There is a new version of the script available!")
                print("Current version: " .. fxVersion)
                print("New version: " .. data.version)
                print("What does the latest version Contains: " .. data.New)
            else
                print("You have the latest version of the script!")
            end
        else
            print("Error checking for new version: " .. tostring(errorCode))
        end
    end, "GET", "", {})
end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        checkVersion()
        Citizen.Wait(1800000)
    end
end)