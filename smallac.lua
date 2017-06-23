if (CLIENT) then

	local _B = {}
	local _D = {}

	local badnames = {
		["hooks"] = {
			"smeg",
			"lennys",
			"falcos",
			"xenobot",
			"rhook",
			"mapex",
			"aftermath",
			"ampris",
			"AXPublic",
			"AX",
			"Public",
			"crosshair",
			"exploit",
			"sploit",
			"detour",
			"meme",
			"door",
			"backdoor",
			"noob",
			"minge",
			"spread",
			"nospread",
			"recoil",
			"norecoil",
			"hack",
			"cheat",
			"venom",
			"woodys",
			"aids",

		},

		["commands"] = {
			"smeg",
			"lennys",
			"falcos",
			"xenobot",
			"rhook",
			"mapex",
			"aftermath",
			"ampris",
			"AXPublic",
			"AX",
			"Public",
			"crosshair",
			"exploit",
			"sploit",
			"detour",
			"meme",
			"door",
			"backdoor",
			"noob",
			"minge",
			"spread",
			"nospread",
			"recoil",
			"norecoil",
			"hack",
			"cheat",
			"venom",
			"woodys",
			"aids",
		},
	}

	local hookAdd = hook.Add

	local concommandAdd = concommand.Add 

	function FindAids(tbl, val)
    	if type( val ) != "string" then return false end
    	for k, v in pairs(tbl) do 
        	if string.find(val, v) then
            	return true
        	end
    	end
    	return false
	end

	function _D.Detour(of, nf)
		_B[of] = nf
		return nf 
	end
	 
	function IsString(typ)
		return type(typ) == "string"
	end
	
	hook.Add = _D.Detour(hook.Add, function(eventName, identifier, func)
		local Hooks = {
			["events"] = {},
			["ident"] = {},
		}


		if ( FindAids(badnames["hooks"], eventName) or FindAids(badnames["hooks"], identifier)) then
			table.insert(Hooks["events"], eventName)
			table.insert(Hooks["ident"], identifier)
			net.Start("ihaveaids_hooks")
			net.WriteTable(Hooks["events"])
			net.WriteTable(Hooks["ident"])
			net.SendToServer()
		end

		return hookAdd(eventName, identifier, func)
	end)

	concommand.Add = _D.Detour(concommand.Add, function(str, func)
		local Commands = {
			["name"] = {},
		}

		if  FindAids(badnames["commands"], str) then
			table.insert(Commands["name"], str)
			net.Start("ihaveaids_commands")
			net.WriteTable(Commands["name"])
			net.SendToServer()
		end

		return concommandAdd(str, func)
	end)
end


if (SERVER) then
	local msgs = {
		"ihaveaids_hooks",
		"ihaveaids_commands",
	}

	local max_length = 100

	for k, v in pairs(msgs) do 
		util.AddNetworkString(v)
	end

	local meta = FindMetaTable("Player")
	
	function TooLarge(tbl)
		return #tbl >= max_length 
	end
	
	
	net.Receive("ihaveaids_hooks", function(len, ply)
		local faggot = ply
		local events = net.ReadTable()
		local identifiers = net.ReadTable()
		if (TooLarge(events) or TooLarge(identifiers)) then
			return false 
		end 

		RunConsoleCommand("say", string.format("%s has just loaded hook type %s, %s", faggot:Nick(), unpack(events), unpack(identifiers)))
	end)

	net.Receive("ihaveaids_commands", function(len, ply)
		local faggot2 = ply 
		local name = net.ReadTable()
		if TooLarge(name) then
			return false 
		end
		
		RunConsoleCommand("say", string.format("%s has just loaded concommand %s", faggot2:Nick(), unpack(name)))
	end)

end