Tono_Blips

Agrega esto a tu archivo server.cfg / Add this to your server.cfg:

add_ace group.admin Tono_Blips allow ## Para todos los administradores / For all admins

o / or

add_ace identifier.license:53c9eaedc4b7546498432a6f76d99adasdsad65858 Tono_Blips allow # Para un individuo / For individual!

------------------------------------

Exports (Exportaciones):
coordinates, sprite, color, size, blip_text, ScriptName, duration (en milisegundos / in milliseconds)

Limpia todos los blips de un script específico / Clear all blips from a specific script:
exports["Tono_Blips"]:ClearBlips(GetCurrentResourceName())

Importa un blip con la duración opcional / Import a blip with an optional duration:
exports["Tono_Blips"]:ImportBlip(vector3(0, 0, 0), 1, 1, 1.5, 'TestBlip', GetCurrentResourceName(), 1000)

------------------------------------

Ejemplo de uso en un script (Example of usage in a script):

Esto es para cuando se inicia el script. This is for when the script starts:

Citizen.CreateThread(function()
    exports["Tono_Blips"]:ClearBlips(GetCurrentResourceName()) -- Por si se reinicia el script / In case the script is restarted
    exports["Tono_Blips"]:ImportBlip(vector3(0, 0, 0), 1, 1, 1.5, 'TestBlip', GetCurrentResourceName(), 1000)
end)


En este ejemplo, se muestra cómo limpiar todos los blips creados por el script actual antes de agregar un nuevo blip. Esto es útil cuando se reinicia el script para evitar blips duplicados.

In this example, it shows how to clear all blips created by the current script before adding a new blip. This is useful when the script is restarted to avoid duplicate blips.