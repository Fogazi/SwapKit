/*
	Function Name: fnc_add_Weapons
	Function Description: Add Weapons to Unit
	Function Parameters: Unit
	Function Return: Nothing
*/
	private["_unit","_target","_bodyBp","_bpWpns","_bpMags"];
	
	_unit = _this select 0;
	_target = _this select 1;

	if(_target == "player") then {
	
		_bpType = body_backpack select 0;
		_plr addBackpack _bpType;
		_bp = unitBackpack _plr;
		
		_bpWpns = body_backpack select 1;
		_bpMags = body_backpack select 2;
		
	};
	
	if(_target == "body") then {
	
		_bpType = player_backpack select 0;
		_body addBackpack _bpType;
		_bp = unitBackpack _body;
		
		_bpWpns = player_backpack select 1;
		_bpMags = player_backpack select 2;
		
	};
	
	if(_bpType != "") then {
		_bpWpnsTypes = [];
		_bpWpnsQtys = [];
			
		if (count _bpWpns > 0) then {
			_bpWpnsTypes = _bpWpns select 0;
			_bpWpnsQtys = _bpWpns select 1;
		};
			
		{ 
			_bp addWeaponCargoGlobal [_x,(_bpWpnsQtys select _forEachIndex)];
		} forEach _bpWpnsTypes;
			
		_bpMagsTypes = [];
		_bpMagsQtys = [];
			
		if (count _bpMags > 0) then {
			_bpMagsTypes = _bpMags select 0;
			_bpMagsQtys = _bpMags select 1;
		};
			
		{ 
			_bp addMagazineCargoGlobal [_x,(_bpMagsQtys select _forEachIndex)];
		} forEach _bpMagsTypes;
	};
