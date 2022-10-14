fx_version 'bodacious'

game 'gta5'

author 'Haroki'

lua54 'yes'

shared_script {
    '@es_extended/imports.lua',
    'config.lua',
    'shared/*.lua',
    '@ox_lib/init.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/utils.lua',
    'server/class/gang.lua',
    'server/main.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    'client/*.lua',
}