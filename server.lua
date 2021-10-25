


discord = {
    ['webhook'] = 'webhooklink',
    ['name'] = 'FIB Heist Logs',
    ['image'] = 'https://cdn.discordapp.com/attachments/774536621802389544/899986988386623498/logo.png'
}


ESX.RegisterServerCallback('AlenFIB:MathCops', function(source, cb)
    local Players = ESX.GetPlayers()
    local cops = 0
    for i = 1, #Players do
        local Player = ESX.GetPlayerFromId(Players[i])
        if Player.job.name == 'police' then
            cops = cops + 1
        end
    end
    cb(cops)
end)

RegisterServerEvent('Fib_SV:PlayOnSourceTest')
AddEventHandler('Fib_SV:PlayOnSourceTest', function(soundFile, soundVolume)
    TriggerClientEvent('Fib_CL:PlayOnOneTest', source, soundFile, soundVolume)
end)

RegisterServerEvent('AlenFIB:Done')
AddEventHandler('AlenFIB:Done', function(cash)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier() .. ' - ' .. Player.job.name, ' Is doing the FIB Heist')
    Player.addInventoryItem('printedcash',Config['PrintedCash'])
end)

RegisterServerEvent('AlenFIB:Reward')
AddEventHandler('AlenFIB:Reward', function(cash)
    local src = source
    local Player = ESX.GetPlayerFromId(src)
    if Player.getInventoryItem('printedcash') ~= nil then
        Player.removeInventoryItem('printedcash',1)
        Player.addMoney(Config['Reward'])
        TriggerClientEvent('mythic_notify:client:SendAlert', src, { type = 'inform', text = "You have successfully completed the Mission and you have earned your reward you can now go back to Los Santos"})
        sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier() .. ' - ' .. Player.job.name, ' Claimed his/her reward for the FIB Heist Mission')
    end
end)

RegisterServerEvent('AlenFIB:PoliceCall')
AddEventHandler('AlenFIB:PoliceCall', function()
    local Players = ESX.GetPlayers()
    for i = 1, #Players do
        local Player = ESX.GetPlayerFromId(Players[i])
        if Player.job.name == 'police' then
            TriggerClientEvent('AlenFIB:Test', Players[i])
        end
    end
end)

ESX.RegisterServerCallback('AlenFIB:check', function(source, cb)
	cb(true)
end)

ESX.RegisterServerCallback('AlenFIB:JustLock', function(source, cb)
	cb(locked)
end)

RegisterServerEvent('AlenFIB:FreezeIt')
AddEventHandler('AlenFIB:FreezeIt', function(status)
	xd = status
	TriggerCleitnEvent('AlenFIB:OnDoorUpdate', -1, xd)
end)

RegisterServerEvent('AlenFIB:OpenDoor')
AddEventHandler('AlenFIB:OpenDoor', function()
	locked = false
	TriggerClientEvent('AlenFIB:LockStatus', -1, locked)
end)

RegisterServerEvent('AlenFIB:PoliceLock')
AddEventHandler('AlenFIB:PoliceLock', function()
	local src = source
	local Player = ESX.GetPlayerFromId(src)
	if Player.job.name == 'police' then
		locked = true
		TriggerClientEvent('AlenFIB:LockStatus', -1, locked)
	end
end)

RegisterCommand("travelny", function(source, args, rawCommand)
    local source = source
    local Player = ESX.GetPlayerFromId(source)
    if (Player.job.name == "police") then
        TriggerClientEvent('flypolice', source)
        sendtodiscordaslog(Player.getName() ..  ' - ' .. Player.getIdentifier() .. ' - ' .. Player.job.name, ' Officer Reached North Yankton')
      end
end, false)

RegisterCommand("lockfib", function(source, args, rawCommand)
    local source = source
    local Player = ESX.GetPlayerFromId(source)
    if (Player.job.name == "police") then
        locked = true
		TriggerClientEvent('AlenFIB:LockStatus', -1, locked)
      end
end, false)

function sendtodiscordaslog(name, message)
    local data = {
        {
            ["color"] = '3553600',
            ["title"] = "**".. name .."**",
            ["description"] = message,
        }
    }
    PerformHttpRequest(discord['webhook'], function(err, text, headers) end, 'POST', json.encode({username = discord['name'], embeds = data, avatar_url = discord['image']}), { ['Content-Type'] = 'application/json' })
end
