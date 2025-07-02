ESX = {}
ESX.Players = {}
ESX.Jobs = {}
ESX.Items = {}
Core = {}
Core.UsableItemsCallbacks = {}
Core.ServerCallbacks = {}
Core.TimeoutCount = -1
Core.CancelledTimeouts = {}
Core.RegisteredCommands = {}
Core.Pickups = {}
Core.PickupId = 0

AddEventHandler('esx:getSharedObject', function(cb)
	cb(ESX)
end)

exports('getSharedObject', function()
	return ESX
end)

if GetResourceState('ox_inventory') ~= 'missing' then
	Config.OxInventory = true
	SetConvarReplicated('inventory:framework', 'esx')
	SetConvarReplicated('inventory:weight', Config.MaxWeight * 1000)
end

local function StartDBSync()
	CreateThread(function()
		while true do
			Wait(10 * 60 * 1000)
			Core.SavePlayers()
		end
	end)
end

MySQL.ready(function()
	if not Config.OxInventory then
		local items = MySQL.query.await('SELECT * FROM items')
		for k, v in ipairs(items) do
			ESX.Items[v.name] = {
				label = v.label,
				weight = v.weight,
				rare = v.rare,
				canRemove = v.can_remove
			}
		end
	else
		TriggerEvent('__cfx_export_ox_inventory_Items', function(ref)
			if ref then
				ESX.Items = ref()
			end
		end)

		AddEventHandler('ox_inventory:itemList', function(items)
			ESX.Items = items
		end)

		while not next(ESX.Items) do Wait(0) end
	end

	local Jobs = {}
	local jobs = MySQL.query.await('SELECT * FROM jobs')

	for _, v in ipairs(jobs) do
		Jobs[v.name] = v
		Jobs[v.name].grades = {}
	end

	local jobGrades = MySQL.query.await('SELECT * FROM job_grades')

	for _, v in ipairs(jobGrades) do
		if Jobs[v.job_name] then
			Jobs[v.job_name].grades[tostring(v.grade)] = v
		else
			print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
		end
	end

	for _, v in pairs(Jobs) do
		if ESX.Table.SizeOf(v.grades) == 0 then
			Jobs[v.name] = nil
			print(('[^3WARNING^7] Ignoring job ^5"%s"^0due to no job grades found'):format(v.name))
		end
	end

	if not Jobs then
		-- Fallback data, if no jobs exist
		ESX.Jobs['unemployed'] = {
			label = 'Unemployed',
			grades = {
				['0'] = {
					grade = 0,
					label = 'Unemployed',
					salary = 200,
					skin_male = {},
					skin_female = {}
				}
			}
		}
	else
		ESX.Jobs = Jobs
	end

	print('[^2INFO^7] ESX ^5Legacy^0 initialized')
	StartDBSync()
	StartPayCheck()
end)

RegisterServerEvent('esx:clientLog')
AddEventHandler('esx:clientLog', function(msg)
	if Config.EnableDebug then
		print(('[^2TRACE^7] %s^7'):format(msg))
	end
end)

local srequests = {}
RegisterServerEvent('esx:triggerServerCallback')
AddEventHandler('esx:triggerServerCallback', function(name, requestId, ...)
    local _source = source
    if not name or not requestId then
     ----   DropPlayer(_source, "Triggered callback without name or id")
        return
    end
    local identifier = GetPlayerIdentifier(_source)
    ----if HandleSpam(identifier, name) then return end

    ESX.TriggerServerCallback(name, requestID, _source, function(...)
        TriggerClientEvent('esx:serverCallback', _source, requestId, ...)
    end, ...)
end)

function HandleSpam(identifier, name)
	local prevReq = srequests[identifier]
	if not prevReq then
	  srequests[identifier] = {}
	  prevReq = srequests[identifier]
	end
  
	local tirggerTime = os.time
	local prevTime = getSpecificRequestTime(identifier, name)
  
	if tirggerTime - prevReq < 1000 then
	  print(identifier, "spamming request", name)
	  --DropPlayer(_source, "please do not spam requests!")
	  return true
	end
	return false
  end

function getSpecificRequestTime(identifier, name)
    if srequests[identifier][name] then
        return srequests[identifier][name]
    else
        srequests[identifier][name] = os.time()
        Citizen.SetTimeout(1000, function()
            if srequests[identifier][name] then
                srequests[identifier][name] = nil
            end
        end)
        return 0
    end
end

AddEventHandler('esx:playerDropped', function(id)
    local identifier = GetPlayerIdentifier(id)
    if srequests[identifier] then
        srequests[identifier] = nil
    end
end)

            -- Jobs Creator integration (jobs_creator)
            RegisterNetEvent('esx:refreshJobs')
            AddEventHandler('esx:refreshJobs', function()
                MySQL.Async.fetchAll('SELECT * FROM jobs', {}, function(jobs)
                    for k,v in ipairs(jobs) do
                        ESX.Jobs[v.name] = v
                        ESX.Jobs[v.name].grades = {}
                    end

                    MySQL.Async.fetchAll('SELECT * FROM job_grades', {}, function(jobGrades)
                        for k,v in ipairs(jobGrades) do
                            if ESX.Jobs[v.job_name] then
                                ESX.Jobs[v.job_name].grades[tostring(v.grade)] = v
                            else
                                print(('[es_extended] [^3WARNING^7] Ignoring job grades for "%s" due to missing job'):format(v.job_name))
                            end
                        end

                        for k2,v2 in pairs(ESX.Jobs) do
                            if ESX.Table.SizeOf(v2.grades) == 0 then
                                ESX.Jobs[v2.name] = nil
                                print(('[es_extended] [^3WARNING^7] Ignoring job "%s" due to no job grades found'):format(v2.name))
                            end
                        end
                    end)
                end)
            end)
        

            -- Jobs Creator integration (jobs_creator)
            ESX.ServerCallbacks = Core.ServerCallbacks
        