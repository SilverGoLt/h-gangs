Utils = {}

Utils.loadGangs = function ()
    local result = MySQL.query.await('SELECT * FROM gangs')

    if result then
        for i = 1, #result do
            local gInfo = result[i]
            local gang = gang.new(gInfo.name, json.decode(gInfo.members))
        end
    
        print('[HGANGS] Loaded ' .. gang.count .. ' gangs.')
    end
end


---Create Gang
---@param source integer Player Source
---@param name string Gang Name
---@return boolean
Utils.createGang = function (source, name)
    local member = Utils.findMemberGang(source)
    local isTaken = Utils.checkNameTaken(name)


    if not member and not isTaken then
        exports.ox_inventory:RemoveItem(source, 'money', Config.requiredMoney)
        gang.new(name, {})
        local obj = gang(name)
        obj:addMember(source, 'owner')
        local insert = MySQL.query.await('INSERT INTO gangs (name, members) VALUES (?, ?)', {
            name,
            json.encode(obj.members)
        })

        if not insert then
            print('[HGANGS] Failed to create gang: '..name)
            return false
        end

        Utils.registerStash(name)

        Shared.ServerNotify(source,
            'Gang System',
            string.format(Locale.gangCreated, name),
            'success'
        )

        return true
    elseif member then
        Shared.ServerNotify(source,
            'Gang System',
            Locale.inGang,
            'error'
        )
        return false
    else
        Shared.ServerNotify(source,
            'Gang System',
            Locale.gangTaken,
            'error'
        )
        return false
    end
end

-- Gang Stashes loading
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
        Wait(0)
        Utils.registerStashes()
    end
end)

---Registers Gang Stashes
Utils.registerStashes = function ()
    local Gangs = MySQL.query.await('SELECT * FROM gangs')

    for k,v in pairs(Gangs) do
        exports.ox_inventory:RegisterStash(v.name..'-storage', v.name, 500, 5000 * 1000, nil, nil, vec3(1605.0780, 3584.5776, 34.4348))
    end
end

---Register a gang stash (On Creation)
---@param name any
Utils.registerStash = function (name)
    exports.ox_inventory:RegisterStash(name..'-storage', name, 500, 5000 * 1000, nil, nil, vec3(1605.0780, 3584.5776, 34.4348))
end

---Returns gang by name
Utils.getGang = function (name)
    for k, v in pairs(gang.list) do
        if v.name == name then
            return v.name
        end
    end
end

---Checks if a gang name is already taken
Utils.checkNameTaken = function(name)
    for k,v in pairs(gang.list) do
        if v.name == name then
            return true
        end
    end

    return false
end

---Checks if a player is in a gang
---@param source integer Player Source
---@return any Gang Name or false
Utils.findMemberGang = function(source)
    for k,v in pairs(gang.list) do
        local obj = gang(v.name)
        local member = obj:findMember(GetPlayerIdentifier(source, 0))
        if member then
            return v.name
        end
    end

    return false
end