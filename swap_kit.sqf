////////////////////////////////////////////////////////
//                                                    //
//        Swap Kit Script - Created by Fogazi         //
//                  fogazi@gmail.com                  //
//                      v1.2                          //
//                                                    //
////////////////////////////////////////////////////////

private["_body", "_isBuried", "_grave", "_graveCross", "_bodyBp", "_bpWpns", "_bp_Mags"];
_body = _this select 3;
_isBuried = _body getVariable ["isBuried", false];
_hasHarvested = _body getVariable["meatHarvested",false];
_name = _body getVariable["bodyName","unknown"];
_plr = player;
	
_plr removeAction s_player_swap_human;
s_player_swap_human = -1;

if (!_isBuried) then {
	if (!_hasHarvested) then {
		_body setVariable["isBuried", true, true];
		_plr playActionNow "Medic";
		sleep 7;
		
		sk_myBackpack = unitBackpack _body;
		_bodyBp = (typeOf sk_myBackpack);
		
		if(_bodyBp != "") then {
			_bpWpns = getWeaponCargo unitBackpack _body;
			_bp_Mags = getMagazineCargo unitBackpack _body;
		};
		
		removeBackpack _plr;
		removeAllItems _plr;
		removeAllWeapons _plr;
		
		_plr addBackpack _bodyBp;
		_bp = unitBackpack _plr;
		
		_plrMagazines = magazines _body;
		_plrWeapons = weapons _body;
		
		_magazineCount = 0;
		for [{_i=0}, {_i < count _plrMagazines}, {_i = _i + 1}] do {
			_magslot = _plrMagazines select _magazineCount;
			_plr addMagazine _magslot;
			_magazineCount = _magazineCount + 1;
		};
		_weaponCount = 0;
		for [{_i=0}, {_i < count _plrWeapons}, {_i = _i + 1}] do {
			_gunslot = _plrWeapons select _weaponCount;
			_plr addWeapon _gunslot;
			_weaponCount = _weaponCount + 1;
		};
		if((primaryWeapon _plr) != "") then {
			private["_type", "_muzzles"];
			_type = primaryWeapon _plr;
			_muzzles = getArray(configFile >> "cfgWeapons" >> _type >> "muzzles");
			if(count _muzzles > 1) then {
				_plr selectWeapon (_muzzles select 0);
			} else {
				_plr selectWeapon _type;
			};
		};
		reload _plr;
		
		if(_bodyBp != "") then {
			_bpWpnsTypes = [];
			_bpWpnsQtys = [];
			if (count _bpWpns > 0) then {
				_bpWpnsTypes = _bpWpns select 0;
				_bpWpnsQtys = _bpWpns select 1;
			};
			_counter = 0;
			{ _bp addWeaponCargoGlobal [_x,(_bpWpnsQtys select _counter)];
			_counter = _counter + 1;
			} forEach _bpWpnsTypes;
			_bp_MagsTypes = [];
			_bp_MagsQtys = [];
			if (count _bp_Mags > 0) then {
				_bp_MagsTypes = _bp_Mags select 0;
				_bp_MagsQtys = _bp_Mags select 1;
			};
			_counter = 0; 
			{ _bp addMagazineCargoGlobal [_x,(_bp_MagsQtys select _counter)];
			_counter = _counter + 1;
			} forEach _bp_MagsTypes;
		};
		sleep 4;
		_position = getPosASL _body;
		deleteVehicle _body;
		_grave = createVehicle ["Grave", _position, [], 0, "CAN_COLLIDE"];
		_grave setpos [(getposASL _grave select 0),(getposASL _grave select 1), 0];
		_graveCrosstype = ["GraveCross1","GraveCross2","GraveCrossHelmet"]  call BIS_fnc_selectRandom;
		_graveCross = createVehicle [_graveCrosstype, _position, [], 0, "CAN_COLLIDE"];
		_graveCross setpos [(getposASL _graveCross select 0),(getposASL _graveCross select 1)-1.2, 0];
		_swapKitMessage = format["Thank you %1, your kit shall serve me well", _name];
		cutText [_swapKitMessage, "PLAIN DOWN"];
		_alertZ = [_plr, 50, true, (getposASL _plr)] spawn player_alertZombies;
	} else {
		cutText ["This body has been mutilated, the gear is no good", "PLAIN DOWN"];
	};													
} else {
	cutText ["This body has been buried, feel free to pick through the remains", "PLAIN DOWN"];
};
