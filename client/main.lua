Utils = {}
local StoreNPC = nil
local loaded = false
RegisterCommand('createGang', function (source)
    Utils.createGang()
end, false)

RegisterNetEvent('esx:playerLoaded', function ()
    if not loaded then
        CreateGangWarehouse()
    end
end)

AddEventHandler('onResourceStart', function (resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if not loaded then
        CreateGangWarehouse()
    end
end)

CreateGangWarehouse = function ()    
    local npc = {
        name = 'Gang Warehouse',
        details = {
            pos = vec3(1605.0780, 3584.5776, 34.4348),
            heading = 302.1426,
            -- The interaction system automatically gets the hash key using joaat()
            model = 'g_m_y_mexgoon_03',
        },
        text = 'Sup homie, welcome back to the hood!',
        menu = {
            {
                label = "Open Storage",
                action = function()
                    -- Try open gang storage
                    local gang = LocalPlayer.state.gang

                    print(gang)
                    if gang then
                        exports.ox_inventory:openInventory('stash', {id = gang..'-storage'})
                    end
                end,
                type = 'confirm'
            },
            {
                label = "Close",
                type = 'close'
            }
        }
    }
    
    -- Returns a ID the same way as the Interactions
    StoreNPC = exports['h-interactions']:registerNPC(npc)
end