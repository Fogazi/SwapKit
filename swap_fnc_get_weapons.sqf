/*
	Function Name: fnc_get_weapons
	Function Description: Get Weapons
	Function Parameters: Unit
	Function Return: Array of Weapons 
	Function Return Format: [[ArrayofWeapons]]
*/
	private["_unit","_weapons","_returnArray"];
	
	_unit = _this select 0;
	_weapons = weapons _unit;
	_returnArray = [];
	
	if(count _weapons > 0) then {
		_returnArray = _weapons;
	};
	
	systemchat(format["Return array of swap_fnc_get_weapons: %1", _returnArray]);
	
	_returnArray;
