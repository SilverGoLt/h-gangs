Utils.createGang = function ()
  local Cash = exports.ox_inventory:Search('count', 'money')
  if Cash < Config.requiredMoney then
    Shared.ClientNotify(
      'Gang System',
      'You do not have enough money to create a gang.',
      'warning'
    ) -- TODO: Add Notification support
  else
    local input = lib.inputDialog('Gang Creation', {'Gang Name'})
    if not input then return end
    local gangName = input[1]
    if not gangName then return end
    
    local create = lib.callback.await('gangs:createGang', false, gangName)

    if not create then
      return
    end
  end
end