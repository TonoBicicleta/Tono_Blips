fx_version 'cerulean'

games {"gta5"}
author 'Toño#0001'
description 'FiveM Blips Creations In Game'
lua54 'yes'
version '1.0.0'

server_script {
    "Config/*.lua",
    "Server/*.lua"
}

client_script {
    "Locale/*.lua",
    "Config/*.lua",
    "Cliente/*.lua"
}

ui_page "Cliente/nui/index.html"
files {
    'Cliente/nui/index.html',
    'Cliente/nui/app.js',
    'Cliente/nui/app.css',
    'Cliente/nui/reset.css',
    'Cliente/nui/blips/*.png'
}
