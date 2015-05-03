/*
	Function Name: fnc_add_magazines
	Function Description: Add Magazines to Unit
	Function Parameters: Unit
	Function Return: Nothing
*/
	private["_unit","_magazineArray","_magslot","_type","_count"];
	
	_unit = _this select 0;
	_magazineArray = _this select 1;
	_type = _this select 3;

	_count = 0;
	for [{_i=0}, {_i < count _magazineArray}, {_i = _i + 1}] do {
		_magslot = _magazineArray select _count;
		if(_type == "magazine") then {
			_unit addMagazine _magslot;
		};
		if(_type == "weapon") then {
			_unit addWeapon _magslot;
		};
		_count = _count + 1;
	};
