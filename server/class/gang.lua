local random = math.random

local gang = {
    count = 0,
    list = {}
}

setmetatable(gang, {
	__add = function(self, obj)
		self.list[obj.name] = obj
		self.count += 1
	end,

	__sub = function(self, obj)
		self.list[obj.name] = nil
		self.count -= 1
	end,

	__call = function(self, name)
		return self.list[name]
	end
})

local CGang = {}
CGang.__index = CGang

---Add member to gang
---@param source number Player Source
---@param rank string Member rank
---@return boolean Success
function CGang:addMember (source, rank)
    local member = {
        name = GetPlayerName(source),
        identifier = GetPlayerIdentifier(source, 0),
        rank = rank
    }

    self.members[#self.members+1] = member

    local state = Player(source).state

    if state then
        state.gang = self.name
    end

    return true
end

---Remove member from gang
---@param identifier string Player Identifier
---@return boolean Success
function CGang:removeMember (identifier)
    for k, v in pairs(self.members) do
        if v.identifier == identifier then
            self.members[k] = nil
            return true
        end
    end

    return false
end

---Set gang owner
function CGang:setOwner (source)
    local identifier = GetPlayerIdentifier(source, 0)

    for _,v in pairs(self.members) do
        if v.identifier == identifier then
            v.rank = 'owner'
            return true
        end
    end
    return false
end

---Save gang to database
function CGang:saveGang ()
    local result = MySQL.query.await('UPDATE gangs SET members = ? WHERE name = ?', {
        json.encode(self.members),
        self.name
    })

    if result then
        print('[HGANGS] Saved gang: '..self.name)
    end
end

function CGang:findMember (identifier)
    for k, v in pairs(self.members) do
        if v.identifier == identifier then
            return v
        end
    end
    return false
end

local i = 1
---Create gang
---@param name string Gang Name from DB
---@param members table Gang Members from DB
---@return number
function gang.new (name, members)
    local self = {
        name = name,
        members = members or {}
    }

    i += 1


    setmetatable(self, CGang)

    return gang + self
end

_ENV.gang = gang