local ESX	 = nil

-- ESX
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	ESX.PlayerData = ESX.GetPlayerData()
end)







local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18, ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182, ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81, ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178, ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}



-- Player status
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)

		local playerStatus 
		local showPlayerStatus = 0
		playerStatus = { action = 'setStatus', status = {} }

		if Config.ui.showHealth == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['isdead'] = false

			playerStatus['status'][showPlayerStatus] = {
				name = 'health',
				value = GetEntityHealth(GetPlayerPed(-1)) - 100
			}

			if IsEntityDead(GetPlayerPed(-1)) then
				playerStatus.isdead = true
			end
		end

		if Config.ui.showArmor == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['status'][showPlayerStatus] = {
				name = 'armor',
				value = GetPedArmour(GetPlayerPed(-1)),
			}
		end

		if Config.ui.showStamina == true then
			showPlayerStatus = (showPlayerStatus+1)

			playerStatus['status'][showPlayerStatus] = {
				name = 'stamina',
				value = 100 - GetPlayerSprintStaminaRemaining(PlayerId()),
			}
		end

		--TriggerServerEvent('trew_hud_ui:getServerInfo')

		if showPlayerStatus > 0 then
			SendNUIMessage(playerStatus)
		end

	end
end)


-- Overall Info
--RegisterNetEvent('trew_hud_ui:setInfo')
--AddEventHandler('trew_hud_ui:setInfo', function(info)

Citizen.CreateThread(function()
	while true do
		Wait(1000)

		TriggerEvent('esx:getSharedObject', function(obj)
			ESX = obj
			ESX.PlayerData = ESX.GetPlayerData()
		end)

		local job = ESX.PlayerData.job.label .. ': ' .. ESX.PlayerData.job.grade_label
		local job2 = ESX.PlayerData.job2.label .. ': ' .. ESX.PlayerData.job2.grade_label
		local money = ESX.PlayerData.money
		local bankmoney = 0
		local blackmoney = 0
		for k,v in pairs(ESX.PlayerData.accounts) do
			if v.name == "bank" then
				bankmoney = v.money
			elseif v.name == "black_money" then
				blackmoney = v.money
			end
		end

		SendNUIMessage({ action = 'setText', id = 'job', value = job })
		--SendNUIMessage({ action = 'setText', id = 'job2', value = job2 })
		SendNUIMessage({ action = 'setMoney', id = 'wallet', value = money })
		--SendNUIMessage({ action = 'setMoney', id = 'bank', value = bankmoney })
		SendNUIMessage({ action = 'setMoney', id = 'blackMoney', value = blackmoney })
	

		local playerStatus 
		local showPlayerStatus = 0
		playerStatus = { action = 'setStatus', status = {} }


		if Config.ui.showHunger == true then
			showPlayerStatus = (showPlayerStatus+1)

			TriggerEvent('esx_status:getStatus', 'hunger', function(status)
				playerStatus['status'][showPlayerStatus] = {
					name = 'hunger',
					value = math.floor(100-status.getPercent())
				}
			end)

		end

		if Config.ui.showThirst == true then
			showPlayerStatus = (showPlayerStatus+1)

			TriggerEvent('esx_status:getStatus', 'thirst', function(status)
				playerStatus['status'][showPlayerStatus] = {
					name = 'thirst',
					value = math.floor(100-status.getPercent())
				}
			end)
		end

		if showPlayerStatus > 0 then
			SendNUIMessage(playerStatus)
		end
	end

end)

function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end


local toggleui = false

RegisterNetEvent("ui:toogleUi")
AddEventHandler("ui:toogleUi", function(status)
	ToogleUi(status)
end)

RegisterCommand('toggleui', function()
	ToogleUi()
end)

function ToogleUi(status)
	if not toggleui then
		SendNUIMessage({ action = 'element', task = 'disable', value = 'job' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'job2' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'society' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'bank' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'blackMoney' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'wallet' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'voice' })

		SendNUIMessage({ action = 'element', task = 'disable', value = 'health' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'armor' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'hunger' })
		SendNUIMessage({ action = 'element', task = 'disable', value = 'thirst' })
	else
		if (Config.ui.showJob == true) then
			SendNUIMessage({ action = 'element', task = 'enable', value = 'job' })
			SendNUIMessage({ action = 'element', task = 'enable', value = 'job2' })
		end
		if (Config.ui.showSocietyMoney == true) then
			SendNUIMessage({ action = 'element', task = 'enable', value = 'society' })
		end
		if (Config.ui.showBankMoney == true) then
			SendNUIMessage({ action = 'element', task = 'enable', value = 'bank' })
		end
		if (Config.ui.showBlackMoney == true) then
			SendNUIMessage({ action = 'element', task = 'enable', value = 'blackMoney' })
		end
		if (Config.ui.showWalletMoney == true) then
			SendNUIMessage({ action = 'element', task = 'enable', value = 'wallet' })
		end

		SendNUIMessage({ action = 'element', task = 'enable', value = 'health' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'armor' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'hunger' })
		SendNUIMessage({ action = 'element', task = 'enable', value = 'thirst' })
	end

	if status == nil then
		toggleui = not toggleui
	else
		toggleui = status
	end
end









exports('createStatus', function(args)
	local statusCreation = { action = 'createStatus', status = args['status'], color = args['color'], icon = args['icon'] }
	SendNUIMessage(statusCreation)
end)




exports('setStatus', function(args)
	local playerStatus = { action = 'setStatus', status = {
		{ name = args['name'], value = args['value'] }
	}}
	SendNUIMessage(playerStatus)
end)