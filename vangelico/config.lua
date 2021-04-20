Config = {}
Config.AirVent = {-635.94, -213.95, 53.54} -- First step
Config.AirVentDist = 15 -- Distance to show the ['air_vent'] text
Config.GasTime = 3 -- Time before removing the gas, in minutes
Config.RobTime = 5 -- How many minutes the thief has to rob the jewels before the robbery gets cancelled
Config.MinPolice = 0 -- Min amount of Cops online to trigger the robbery
Config.PoliceJobName = 'police'
Config.RewardMoney = false -- Give money?
Config.Account = 'black_money'
Config.Money = 1000 -- Money per stand
Config.RewardItem = true -- Reward item?
Config.Cooldown = 3600 -- 1 hour
Config.WeaponsWL = true -- Needs specific weapon to smash the glass?
Config.Weapons = { -- If player is using one of this weapons it will be able to smash the stands
	-1074790547, -- assault rifle
	-2067956739, -- crowbar
	-1786099057 -- bat
}



Config.Items = {
	{item = 'water', amount = 2},
	{item = 'bread', amount = 2}
}
Config.Lang = {
	['blip'] = 'Vangelico Jewelry',
	['air_vent'] = 'Inspect',
	['plant_gas'] = 'Press ~r~[E]~w~ to plant the bomb',
	['started'] = 'Vangelico Robbery Started',
	['police'] = 'Alarm Triggered at Vangelico Jewelry',
	['break'] = 'Press ~r~[E]~w~ to break the glass',
	['needs_weapon'] = 'You need something to break the glass',
	['stole'] = 'You stole ',
	['cooldown'] = 'Vangellico was recently robbed, try again later',
	
}
