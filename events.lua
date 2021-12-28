local listeners = {}

events = {
  on = function(eventName, callback)
    local callbacks = listeners[eventName] or {}
    table.insert(callbacks, callback)

    listeners[eventName] = callbacks

    return events
  end,

  trigger = function(eventName)
    local callbacks = listeners[eventName] or {}

    for i,callback in ipairs(callbacks) do
      callback()
    end
  end
}
