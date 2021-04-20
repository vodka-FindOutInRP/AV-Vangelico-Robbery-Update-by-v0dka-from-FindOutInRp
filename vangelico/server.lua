local cooldown = 0
local w = false
local wait = 10000

local stand = {
	-- x,y,z of stand h is heading  v is stand for debugging  -ax ay of animation location
	{x = -627.23, y = -234.98, z = 38.52, h=50.97, ax= -626.61, ay= -235.62, v=1, broken = false},
	{x = -627.67, y = -234.35, z = 38.52, h=232.01,ax= -628.19, ay= -233.54, v=2, broken = false},
	{x = -626.53, y = -233.52, z = 38.52, h=232.01,ax= -627.11, ay= -232.84, v=3, broken = false},
	{x = -626.09, y = -234.15, z = 38.52, h=45.05,ax= -625.50, ay= -234.92, v=4, broken = false}, 
	{x = -625.27, y = -238.31, z = 38.52, h=232.01,ax= -625.81, ay= -237.49, v=5, broken = false},
	{x = -626.26, y = -239.03, z = 38.52, h=232.01,ax= -626.82, ay= -238.41, v=6, broken = false},
	{x = -623.98, y = -230.73, z = 38.52, h=309.21,ax= -624.84, ay= -231.33, v=7, broken = false},
	{x = -622.50, y = -232.60, z = 38.52, h=309.21,ax= -623.55, ay= -233.28, v=8, broken = false},
	{x = -619.87, y = -234.82, z = 38.05, h=232.01,ax= -620.37, ay= -234.0, v=9, broken = false}, 
	{x = -618.79, y = -234.05, z = 38.05, h=232.01,ax= -619.40, ay= -233.13, v=10, broken = false},
	{x = -617.11, y = -230.20, z = 38.05, h=299.83,ax= -617.99, ay= -230.73, v=11, broken = false},
	{x = -617.87, y = -229.15, z = 38.05, h=299.83,ax= -618.85, ay= -229.86, v=12, broken = false},
	{x = -619.16, y = -227.18, z = 38.05, h=299.83,ax= -620.07, ay= -227.90, v=13, broken = false},
	{x = -619.99, y = -226.15, z = 38.05, h=299.83,ax= -620.84, ay= -226.85, v=14, broken = false},
	{x = -625.25, y = -227.24, z = 38.05, h=48.83,ax= -624.74, ay= -228.36, v=15, broken = false},
	{x = -624.27, y = -226.64, z = 38.05, h=48.83,ax= -623.71, ay= -227.53, v=16, broken = false},
	{x = -623.58, y = -228.57, z = 38.05, h=232.01,ax= -624.35, ay= -227.72, v=17, broken = false},
	{x = -621.48, y = -228.84, z = 38.05, h=128.82,ax= -620.57, ay= -228.39, v=18, broken = false},
	{x = -620.17, y = -230.90, z = 38.05, h=128.82,ax= -619.41, ay= -230.07, v=19, broken = false},
	{x = -620.60, y = -232.90, z = 38.05, h=35.14,ax= -619.87, ay= -233.88, v=20, broken = false}
}


ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



-- server event for when a stand(counter) has been smashed
RegisterServerEvent('av_vangelico:smash_counter')
AddEventHandler('av_vangelico:smash_counter', function(x,y,z,status)
	-- loop through table and check for the smashed one update its broken status
	for i=1, #stand do
		if stand[i].x == x and stand[i].y == y and stand[i].z == z then
			stand[i].broken = true
		end

	end
	-- tell all clients that it has now been broken so they cant break it
	TriggerClientEvent("av_vangelico:breakable_units",-1,stand)


end)



RegisterServerEvent('av_vangelico:effect')
AddEventHandler('av_vangelico:effect', function(carga)
	w = true
	print('^3[AV-Vangelico]: ^2Cooldown started^0')
	cooldown = os.time()
	TriggerClientEvent('av_vangelico:bombaFx',-1, carga)
	TriggerClientEvent("av_vangelico:breakable_units",-1,stand)
	-- tell all clients that the robbery has started
	TriggerClientEvent("av_vangelico:statusUpdate",-1,false)

end)

RegisterServerEvent("av_vangelico:timer",function()
	
	TriggerClientEvent("av_vangelico:change_timer_status",-1,true,false)
end)

RegisterServerEvent('av_vangelico:gas')
AddEventHandler('av_vangelico:gas', function()
	TriggerClientEvent('av_vangelico:smoke',-1)
	TriggerClientEvent('av_vangelico:notify',-1)
end)

RegisterServerEvent('av_vangelico:stand')
AddEventHandler('av_vangelico:stand', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.RewardMoney then
		xPlayer.addAccountMoney(Config.Account,Config.Money)
		xPlayer.showNotification(Config.Lang['stole']..'$'..Config.Money)
	end
	
	if Config.RewardItem then
		for i = 1, #Config.Items, 1 do
			item = Config.Items[i]
			xPlayer.addInventoryItem(item.item,item.amount)
			xPlayer.showNotification(Config.Lang['stole']..''..item.amount..' '..ESX.GetItemLabel(item.item))
		end
	end
end)

ESX.RegisterServerCallback('av_vangelico:cooldown', function(source,cb)
	local xPlayers = ESX.GetPlayers()
	local cops = 0
	
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])	
		if xPlayer.job.name == Config.PoliceJobName then
			cops = cops + 1
		end
	end
	if cops >= Config.MinPolice and not w then
		cb(false)
	else
		cb(true)
	end
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(wait)
		if w then
			wait = 1000
			if (os.time() - cooldown) > Config.Cooldown and cooldown ~= 0 then
				print('^3[AV-Vangelico]: ^2Cooldown finished^0')
				w = false
				for i=1, #stand do
					stand[i].broken = false
				end
				TriggerClientEvent("av_vangelico:statusUpdate",-1,stand)
				TriggerClientEvent("av_vangelico:change_timer_status",-1,true,false)
			end
		else
			wait = 10000
		end
	end
end)
--

