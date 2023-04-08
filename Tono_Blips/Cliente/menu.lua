local display = false
local displayblips = false
local displayColors = false
function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })   
end

function DisplayBlips(bool)
    displayblips = bool
    SendNUIMessage({
        type = "ui_blips",
        status = bool,
    })
end

function DisplayColors(bool)
    displayColors = bool
    SendNUIMessage({
        type = "ui_colors",
        status = bool,
    })
end

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
    DisplayBlips(false)
    DisplayColors(false)
end)
RegisterNUICallback("Borrar", function(data)
    local fuente = GetPlayerServerId(PlayerId())
    TriggerServerEvent('Tono_Blips:delete', data.id)
    Tono_Blips_Notify("BLIP DELETED", "Succesfully", "You have deleted a Blip", 5000)
end)

RegisterNUICallback("Tele", function(data)
    TP(data)
    Tono_Blips_Notify("Teleported", "Succesfully", "You have been Teleported. SG-1 Out", 5000)
end)

RegisterNUICallback("error", function(data)
    Tono_Blips_Notify("ERROR", "Creating Blip", "The Blip Name field is empty or it is larger than 15 characters", 5000)
end)

RegisterNUICallback("error2", function(data)
    Tono_Blips_Notify("ERROR", "Creating Blip", "The Blip Size is larger than 3 characters or you did not put any", 8000)
end)

RegisterNUICallback("error3", function(data)
    Tono_Blips_Notify("~r~ERROR~s~", "Creating Blip", "You did not set a Blip Icon", 5000)
end)

RegisterNUICallback("error4", function(data)
    Tono_Blips_Notify("~r~ERROR~s~", "Creating Blip", "You did not set a Blip Color", 5000)
end)

RegisterNUICallback("crear", function(data)
    creartabla(data)
    local name = tostring(data.nombre)
    Tono_Blips_Notify("~G~BLIP CREATED~S~", "Blip: "..name, "You have succesfully created a blip!", 5000)
end)

function creartabla(data)
    local name = tostring(data.nombre)
    local coords = GetEntityCoords(GetPlayerPed(PlayerId()))
    TriggerServerEvent('Tono_Blips:To_Json', name, coords, data.color, data.sprite, data.size)
    SetDisplay(false)
end

function TP(data)
    local _, z = GetGroundZFor_3dCoord(data.x, data.y, 850.00, 0)
    SetEntityCoordsNoOffset(PlayerPedId(), data.x, data.y, z, false, false, false)
end
function abrirmenu(bool, tablamenu)
    local tableData = {}

    

    
    for i, v in ipairs(tablamenu) do
        local vertices = {}
        table.insert(tableData, {['id'] = i, ['name'] = v.Title, ['x'] = v.Coords.x, ['y'] = v.Coords.y, ['z'] = v.Coords.z, ['Sprite'] = v.Sprite})
    end

    SendNUIMessage({
        type = 'table_data',
        tableData = json.encode(tableData)
    })
    if not bool then
        SetDisplay(true)
    end
end