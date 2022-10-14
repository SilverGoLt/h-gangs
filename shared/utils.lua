Shared = {}

Shared.ServerNotify = function (source, title, description, status)
  TriggerClientEvent('ox_lib:defaultNotify', source, {
    title = title,
    description = description,
    status = status
  })
end

Shared.ClientNotify = function (title, description, status)
  lib.defaultNotify({
      title = title,
      description = description,
      status = status
  })
end