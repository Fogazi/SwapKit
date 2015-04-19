/*
	Function Name: fnc_swap_toolbelt
	Function Description: Swap Toolbelt of Player and Body
	Function Parameters: Unit
	Function Return: Nothing
*/
	private["_newPweapons","_newBweapons","_newBtoolbelt","_newPtoolbelt","_type", "_muzzles"];
	
	{
		_newPweapons = player_weapons - [_x];
	} forEach player_toolbelt;
	
	{
		_newBweapons = body_weapons - [_x];
	} forEach body_toolbelt;
	
	{
		_newBweapons set [count body_weapons,_x];
	} forEach player_toolbelt;
	
	{
		_newPweapons set [count player_weapons,_x];
	} forEach body_toolbelt;
	
	[_plr,_newPweapons,"weapon"] call fnc_add_magazinesAndWeapons;
	[_body,_newBweapons,"weapon"] call fnc_add_magazinesAndWeapons;
	
	if((primaryWeapon _plr) != "") then {
		_type = primaryWeapon _plr;
		_muzzles = getArray(configFile >> "cfgWeapons" >> _type >> "muzzles");
		if(count _muzzles > 1) then {
			_plr selectWeapon (_muzzles select 0);
		} else {
			_plr selectWeapon _type;
		};
	};
	reload _plr;
