/*
	Function Name: fnc_get_all
	Function Description: Get Weapons and items
	Function Parameters: Unit
	Function Return: Array of Weapons and Items (without Backpack)
	Function Return Format: [[ArrayofWeapons],[ArrayofMags]]
*/
	private["_unit","_weapons","_items","_returnArray"];
	_unit = _this select 0;
	_weapons = weapons _unit;
	_items = magazines _unit;
	_returnArray = [];
	
	if(count _weapons > 0) then {
		if(count _returnArray == 0) then {
			_returnArray = _returnArray + [_weapons];
		} else {
			_returnArray set [count _returnArray,_weapons];
		};
	};
	
	if(count _items > 0) then {
		if(count _returnArray == 0) then {
			_returnArray = _returnArray + [_items];
		} else {
			_returnArray set [count _returnArray,_items];
		};
	};

	_returnArray;
