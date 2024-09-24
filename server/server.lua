local CoreName
Citizen.CreateThread(function()
  local coreResources = {"vorp_core", "rsg-core", "redem_roleplay"}
  for _, resourceName in ipairs(coreResources) do
      if GetResourceState(resourceName) == "started" then
        print(resourceName.." version starded")
        CoreName = resourceName 
        return
      end
  end
  CoreName = "Error! no version found" 
end)


Citizen.CreateThread(function()
	Wait(1000)
	if CoreName == "vorp_core" then
		VORPcore = exports.vorp_core:GetCore() 
	elseif CoreName == "rsg-core" then
		RSGCore = exports['rsg-core']:GetCoreObject()
	end

end)


RegisterServerEvent('lumen_npcdoctor:checkDoctosOnline')
AddEventHandler('lumen_npcdoctor:checkDoctosOnline', function()
	local _src = source
    if Config.jobList[1] ~= nil then
        local pass = true
		if CoreName == "vorp_core" then
        	CharacterJ = VORPcore.getUser(_src).getUsedCharacter
        	jobJ = CharacterJ.job
		elseif CoreName == "rsg-core" then
			Player = RSGCore.Functions.GetPlayer(_src)
			jobJ = Player.PlayerData.job.name
		end

        for k, v in pairs(Config.jobList) do
			
          if jobJ == v then
                pass = false
                break
            end
        end

        if not pass then 
			TriggerClientEvent('chat:addMessage',_src ,{ color = { 255, 255, 255 }, multiline = true,args = { Config.Text[1]}})
            return 
        end
    end
	TriggerClientEvent('lumen_npcdoctor:enviarNpcCL', _src)
    discordLog(_src)
	
end) 

RegisterServerEvent('lumen_npcdoctor:revivirTgt')
AddEventHandler('lumen_npcdoctor:revivirTgt', function()
	local _source = source
	if CoreName == "vorp_core" then
		TriggerClientEvent('vorp:resurrectPlayer', _source)
	elseif  CoreName == "rsg-core" then
        TriggerClientEvent('rsg-medic:client:playerRevive', _source)
	end

end)

function discordLog(_source)
	local logs = Config.webHook 
	local name = GetPlayerName(_source)
	local steamhex = GetPlayerIdentifier(_source)
	local connect = {
		{
			["color"] = "65331",
			["title"] = "Name: "..name.." | STEAM: "..steamhex,
			["description"] = Config.Text[3],
		}
	}
	PerformHttpRequest(logs, function(err, text, headers) end, 'POST', json.encode({embeds = connect}), { ['Content-Type'] = 'application/json' })
end
