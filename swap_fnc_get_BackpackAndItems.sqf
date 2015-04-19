/*
	Function Name: fnc_get_backpackAndItems
	Function Description: Get Backpack and Items
	Function Parameters: Unit
	Function Return: Array (Backpack and Backpack Items)
	Function Return Format: ["BackpackType",[ArrayofWeapons],[ArrayofMags]]
*/
	private ["_bpPlayerObject","_bpPlayerType","_bpPlayerReturn","_bpPlayerWeapons","_bpPlayerMags"];
	
	_unit = _this select 0;
	
	_bpPlayerObject = unitBackpack _unit;
	_bpPlayerType = typeOf _bpPlayerObject;
	
	_bpPlayerReturn = [];
	
	if(_bpPlayerType != "") then {
	
		_bpPlayerReturn = _bpPlayerReturn + [_bpPlayerType];
		
		_bpPlayerWeapons = getWeaponCargo unitBackpack _unit;
		_bpPlayerMags = getMagazineCargo unitBackpack _unit;
		
		if(count _bpPlayerWeapons > 0) then {
			_bpPlayerReturn = _bpPlayerReturn set [count _bpPlayerReturn,_bpPlayerWeapons];
		};
		if(count _bpPlayerMags > 0) then {
			_bpPlayerReturn = _bpPlayerReturn set [count _bpPlayerReturn,_bpPlayerMags];
		};
	};

	_bpPlayerReturn;
