/*
	Function Name: fnc_get_items
	Function Description: Get Items
	Function Parameters: Unit
	Function Return: Array of Items 
	Function Return Format: [[ArrayofItems]]
*/
	private["_unit","_items","_returnArray"];
	
	_unit = _this select 0;
	_items = magazines _unit;
	_returnArray = [];

	if(count _items > 0) then {
		_returnArray = _items;
	};
	
	_returnArray;
