AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print('[HGANGS] Core loaded')
        Utils.loadGangs()
    end
end)

RegisterNetEvent('esx:onPlayerJoined')
AddEventHandler('esx:onPlayerJoined', function()
    local gName = Utils.findMemberGang(source)
    if gName then
        local obj = gang(gName)
        local member = obj:findMember(GetPlayerIdentifier(source, 0))

        if member then
            Player(source).state.gang = obj.name
        end
    end
end)

-- Debug Commands
if Config.Debug then

    RegisterCommand('getGang', function(source)
        print(Player(source).state.gang)
    end, false)

    RegisterCommand('setOwner', function(source, args)
        local target = args[1]
        local name = args[2]

        local obj = gang(name)
        if not obj then print("[GANGS] Couldn't find gang: "..name) return end

        if obj then
            local set = obj:setOwner(target)
            if set then
                obj:saveGang()
            end
        end
    end, false)

end

RegisterCommand('addMember', function(source, args)
    local src = source
    local name = Player(source).state.gang
    local obj = gang(name)
    local Member = obj:findMember(GetPlayerIdentifier(source, 0))
    local target = args[1]

    if obj and Member then
        if Member.rank == 'owner' then
            local tGang = Utils.findMemberGang(target)
            if not tGang then
                obj:addMember(target, 'member')
            else
                Shared.ServerNotify(src,
                    'Gang System',
                    Locale.playerInGang,
                    'warning'
                )
            end
        end
    end
end, false)

RegisterCommand('leaveGang', function (source)
    local src = source

    local gName = Utils.findMemberGang(src)

    if gName then
        local obj = gang(gName)
        local member = obj:findMember(GetPlayerIdentifier(src, 0))
        if member then
            Player(src).state.gang = nil
            obj:removeMember(member.identifier)
            obj:saveGang()

            Shared.ServerNotify(src,
                'Gang System',
                Locale.playerLeave,
                'success'
            )
            return true
        else
            return false
        end
    end
end, false)

--[[
    Server Callbacks
]]
lib.callback.register('gangs:createGang', function (src, name)
    if src > 0 then
        if #name > 4 then
            Utils.createGang(src, name)
            return true
        else
            print('[DEBUG] Too short name')
            return false
        end
    else
        return false
    end
end)