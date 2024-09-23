

RegisterCommand(Config.commandDoctor, function(source, args)
    if IsEntityDead(PlayerPedId()) then
        TriggerServerEvent('lumen_npcdoctor:checkDoctosOnline')
    else
        TriggerEvent("lumen_npcdoctor:ShowObjective", Config.Text[2], 4000)
    end

end)



RegisterNetEvent('lumen_npcdoctor:enviarNpcCL')
AddEventHandler('lumen_npcdoctor:enviarNpcCL', function ()
    if GetCurentTownName() == "fuera" then
        Citizen.CreateThread(function()
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local npc = GetClosestPed(pedCoords.x,pedCoords.y,pedCoords.z)
            local createhorse = GetClosestPed(pedCoords.x,pedCoords.y,pedCoords.z)
            local  x, y, z = table.unpack( GetOffsetFromEntityInWorldCoords( ped, 0.0, 40.0, 0.3 ) )
            local horseModel =  GetHashKey(Config.HorseModel)
            local pedModel = GetHashKey(Config.DoctorModel)
            RequestModel(horseModel)
            RequestModel(pedModel)
            while not HasModelLoaded(horseModel) or not HasModelLoaded(pedModel) do
                Wait(500)
            end
            local foundground, groundZ, normal = GetGroundZAndNormalFor_3dCoord(x, y, 9999 + 0.0)
            createhorse = CreatePed( horseModel, x, y, groundZ, heading, true, true, false, false)
            SetPedOutfitPreset(createhorse, 0, 0)
            SetPedConfigFlag(createhorse, 297, true) 
            SetPedConfigFlag(createhorse, 312, true)
            npc = CreatePedOnMount( createhorse, pedModel, -1, true, true, false, false)
            SetPedOutfitPreset(createdped, 0)
            TaskGoToEntity(createhorse ,PlayerPedId() ,-1 , 4.5, 1.1, 0.0)
            while Vdist(GetEntityCoords(createhorse), GetEntityCoords(PlayerPedId())) > 6.5 do
                if IsPedOnMount(createhorse) then
                    TaskGoToEntity(createhorse ,PlayerPedId() ,-1 , 4.5, 2.0, 0.0)
                end
                Wait(10)
            end
            Citizen.InvokeNative( 0x48E92D3DDE23C23A ,npc , 1.0, 0 , 0 , 0 , 0 )
            Wait(4000)
            TaskGoToEntity(npc ,PlayerPedId() ,-1 , 1.0, 1.0, 0.0)
            while Vdist(GetEntityCoords(npc), GetEntityCoords(PlayerPedId())) > 1.5 do
                if IsPedOnMount(npc) then
                    TaskGoToEntity(npc ,PlayerPedId() ,-1 , 1.0, 1.0, 0.0)
                
                end
            
                Wait(10)
            end
            FreezeEntityPosition( npc , true  )
            PlayAnim("mech_revive@unapproved", "revive",npc)
			Wait(5000)
            TriggerServerEvent('lumen_npcdoctor:revivirTgt')
            FreezeEntityPosition( npc , false  )
            TaskGoToEntity(npc ,createhorse ,-1 , 1.0, 1.0, 0.0)
            Wait(4000)
            Citizen.InvokeNative( 0x028F76B6E78246EB, npc, createhorse ,-1 , false )
            TaskWanderStandard(npc , 10.0, 10)
            TaskWanderStandard(createhorse , 10.0, 10)
            Wait(10000)
            SetModelAsNoLongerNeeded(horseModel)
            SetModelAsNoLongerNeeded(pedModel)
            DeleteEntity(npc)
            DeleteEntity(createhorse)
        
        end)
    else
        Citizen.CreateThread(function()
            local ped = PlayerPedId()
            local pedCoords = GetEntityCoords(ped)
            local npc = GetClosestPed(pedCoords.x,pedCoords.y,pedCoords.z)
            local  x, y, z = table.unpack( GetOffsetFromEntityInWorldCoords( ped, 0.0, 6.0, 0.3 ) )
            local pedModel = GetHashKey(Config.DoctorModel)       
            RequestModel(pedModel)
            while not HasModelLoaded(pedModel) do
                Wait(500)
            end
            local foundground, groundZ, normal = GetGroundZAndNormalFor_3dCoord(x, y, 9999 + 0.0)
            npc = CreatePed( pedModel, x, y, groundZ, heading, true, true, false, false)
	        SetPedOutfitPreset(npc, 0)
            TaskGoToEntity(npc ,PlayerPedId() ,4000 , 0.1, 2.0, 1073741824, 0)
            Wait(4000)
            FreezeEntityPosition( npc, true  )
            PlayAnim("mech_revive@unapproved", "revive",npc)
			Wait(5000)
            TriggerServerEvent('lumen_npcdoctor:revivirTgt')
            FreezeEntityPosition( npc , false )
            Wait(1000)
            TaskWanderStandard(npc , 10.0, 10)
            Wait(10000)
            SetModelAsNoLongerNeeded(pedModel)
            DeleteEntity(npc)
        end) 
    end
    

end)


function  GetClosestPed(x,y,z)
    local itemSet = CreateItemset(true)
    local size = Citizen.InvokeNative(0x59B57C4B06531E1E, x,y,z, 40.0, itemSet, 1, Citizen.ResultAsInteger())
    local playerped = PlayerPedId()
    if size > 0 then
        for index = 0, size - 1 do
            local entity = GetIndexedItemInItemset(index, itemSet)
            if not IsPedAPlayer(entity) then
                if not IsEntityDead(entity) then
                    if Vdist(GetEntityCoords(playerped) , GetEntityCoords(entity) ) > 8.0 then
                        if GetPedType(entity) == 4 or GetPedType(entity) == 5 and IsPedOnFoot(entity) then
                            return entity
                        end
                    end
                end
            end
        end
    else end
    if IsItemsetValid(itemSet) then
        DestroyItemset(itemSet)
    end
end


function GetCurentTownName()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local town_hash = Citizen.InvokeNative(0x43AD8FC02B429D33, pedCoords, 1)
    if town_hash == GetHashKey("Annesburg") then
        return "Annesburg"
    elseif town_hash == GetHashKey("Armadillo") then
        return "Armadillo"
    elseif town_hash == GetHashKey("Blackwater") then
        return "Blackwater"
    elseif town_hash == GetHashKey("BeechersHope") then
        return "BeechersHope"
    elseif town_hash == GetHashKey("Braithwaite") then
        return "Braithwaite"
    elseif town_hash == GetHashKey("Butcher") then
        return "Butcher"
    elseif town_hash == GetHashKey("Caliga") then
        return "Caliga"
    elseif town_hash == GetHashKey("cornwall") then
        return "Cornwall"
    elseif town_hash == GetHashKey("Emerald") then
        return "Emerald"
    elseif town_hash == GetHashKey("lagras") then
        return "lagras"
    elseif town_hash == GetHashKey("Manzanita") then
        return "Manzanita"
    elseif town_hash == GetHashKey("Rhodes") then
        return "Rhodes"
    elseif town_hash == GetHashKey("Siska") then
        return "Siska"
    elseif town_hash == GetHashKey("StDenis") then
        return "SaintDenis"
    elseif town_hash == GetHashKey("Strawberry") then
        return "Strawberry"
    elseif town_hash == GetHashKey("Tumbleweed") then
        return "Tumbleweed"
    elseif town_hash == GetHashKey("valentine") then
        return "Valentine"
    elseif town_hash == GetHashKey("VANHORN") then
        return "Vanhorn"
    elseif town_hash == GetHashKey("Wallace") then
        return "Wallace"
    elseif town_hash == GetHashKey("wapiti") then
        return "Wapiti"
    elseif town_hash == GetHashKey("AguasdulcesFarm") then
        return "Aguasdulces Farm"
    elseif town_hash == GetHashKey("AguasdulcesRuins") then
        return "Aguasdulces Ruins"
    elseif town_hash == GetHashKey("AguasdulcesVilla") then
        return "Aguasdulces Villa"
    elseif town_hash == GetHashKey("Manicato") then
        return "Manicato"
    else
        return "fuera"
    end
end

function PlayAnim(dic, anim,npc)
    RequestAnimDict(dic)
    while not (HasAnimDictLoaded(dic)) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(npc, dic, anim, 1.0, 8.0, 8.0, 8, 0.0,  false, false, false, '', false)
    Citizen.InvokeNative(0x6585D955A68452A5, npc)
    Citizen.InvokeNative(0x9C720776DAA43E7E, npc)
    Citizen.InvokeNative(0x8FE22675A5A45817, npc)
end
