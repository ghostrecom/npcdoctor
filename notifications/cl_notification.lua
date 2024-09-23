
RegisterNetEvent('lumen_npcdoctor:NotifyLeft')
AddEventHandler('lumen_npcdoctor:NotifyLeft', function(firsttext, secondtext, dict, icon, duration)
    local _dict = dict
    local _icon = icon
    if not LoadTexture(_dict) then
        _dict = "generic_textures"
        LoadTexture(_dict)
        _icon = "tick"
    end
    TriggerEvent("lumen_npcdoctor:ShowAdvancedNotificationJS",tostring(firsttext), tostring(secondtext), tostring(_dict), tostring(_icon), tonumber(duration))
end)

function LoadTexture(dict)
    if Citizen.InvokeNative(0x7332461FC59EB7EC, dict) then
        RequestStreamedTextureDict(dict, true)
        while not HasStreamedTextureDictLoaded(dict) do
            Wait(1)
        end
        return true
    else
        return false
    end
end

