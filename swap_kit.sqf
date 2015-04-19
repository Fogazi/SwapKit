/*
	File Name: swap_kit.sqf
	File Created: 19/04/2015
	File Version: 1.1
	File Author: Fogazi
	File Contributor: Martin
	File Last Edit Date: 19/04/2015
	File Description: Swap Kits of Player and _body
*/

private["_body", "_isBuried", "_hasHarvested", "_name", "_plr", "_grave", "_graveCross","_j","_max"];
_body = _this select 3;
_isBuried = _body getVariable ["isBuried", false];
_hasHarvested = _body getVariable["meatHarvested",false];
_name = _body getVariable["_bodyName","unknown"];
_plr = player;
	
_plr removeAction s_player_swap_human;
s_player_swap_human = -1;

swapKitSelect = "";
exitscript = true;
snext = false;

fnc_swap_actions = {

	kitMenu =
	{
		private ["_kitMenu","_kitArray"];
		_kitMenu = [["",true], ["Select, what you want to Swap:", [-1], "", -5, [["expression", ""]], "1", "0"]];
		for "_i" from (_this select 0) to (_this select 1) do
		{
			_kitArray = [format['%1', kitSelectionArray select (_i)], [_i - (_this select 0) + 2], "", -5, [["expression", format ["swapKitSelect = kitSelectionArray select %1;", _i]]], "1", "1"];
			_kitMenu set [_i + 2, _kitArray];
		};
		_kitMenu set [(_this select 1) + 2, ["", [-1], "", -5, [["expression", ""]], "1", "0"]];
		if (count kitSelectionArray > (_this select 1)) then
		{
			_kitMenu set [(_this select 1) + 3, ["Next", [12], "", -5, [["expression", "snext = true;"]], "1", "1"]];
		} else {
			_kitMenu set [(_this select 1) + 3, ["", [-1], "", -5, [["expression", ""]], "1", "0"]];
		};
		_kitMenu set [(_this select 1) + 4, ["Exit", [13], "", -5, [["expression", "swapKitSelect = 'exitscript';"]], "1", "1"]];
		showCommandingMenu "#USER:_kitMenu";
	};
		
	/* Wait for the player to select a Key from the list */
	_j = 0;
	_max = 10;
	if (_max > 9) then {_max = 10;};
	while {swapKitSelect == ""} do {
		[_j, (_j + _max) min (count kitSelectionArray)] call kitMenu;
		_j = _j + _max;
		waitUntil {swapKitSelect != "" || snext};
		snext = false;
	};
		
	if (swapKitSelect != "exitscript") then {
		 if ((alive player) && {isNil {dayz_playerName}}) then {
			dayz_playerName = name player;
		};
	};
	
	call {
	
		if (swapKitSelect == "Swap All") exitWith {
			private["_playerWeaponArr","_bodyWeaponArr","_playerMagArr","_bodyMagArr","_body_backpackType","_player_backpackType"];
			[_plr] call fnc_remove_all;
			[_body] call fnc_remove_all;
			
			_playerWeaponArr = player_all select 0;
			_bodyWeaponArr = body_all select 0;
			
			_playerMagArr = player_all select 1;
			_bodyMagArr = body_all select 1;
			
			if (count _bodyMagArr > 0) then {
				[_plr,_bodyMagArr,"magazine"] call fnc_add_magazinesAndWeapons;
			};
			if (count _playerMagArr > 0) then {
				[_body,_playerMagArr,"magazine"] call fnc_add_magazinesAndWeapons;
			};
			if (count _bodyWeaponArr > 0) then {
				[_plr,_bodyWeaponArr,"weapon"] call fnc_add_magazinesAndWeapons;
			};
			if (count _playerWeaponArr > 0) then {
				[_body,_playerWeaponArr,"weapon"] call fnc_add_magazinesAndWeapons;
			};
			
			if (body_backpack select 0 != "") then {
				[_plr,"player"] call fnc_add_BackPackItems;
			};
			if (player_backpack select 0 != "") then {
				[_plr,"body"] call fnc_add_BackPackItems;
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

		};
		
		if (swapKitSelect == "Swap Toolbelt") exitWith {
			[] call fnc_swap_toolbelt;
		};
		
		if (swapKitSelect == "Swap Backpack") exitWith {
			if (body_backpack select 0 > "") then {
				[_plr,"player"] call fnc_add_BackPackItems;
			};
			if (player_backpack select 0 > "") then {
				[_plr,"body"] call fnc_add_BackPackItems;
			};
		};
		
		if (swapKitSelect == "Swap Weapons") exitWith {
			_playerWeaponArr = player_all select 0;
			_bodyWeaponArr = body_all select 0;
			
			if (count _bodyWeaponArr > 0) then {
				[_plr,_bodyWeaponArr,"weapon"] call fnc_add_magazinesAndWeapons;
			};
			if (count _playerWeaponArr > 0) then {
				[_body,_playerWeaponArr,"weapon"] call fnc_add_magazinesAndWeapons;
			};
		};
		
		if (swapKitSelect == "Swap Items") exitWith {
			_playerMagArr = player_all select 1;
			_bodyMagArr = body_all select 1;
			
			if (count _bodyMagArr > 0) then {
				[_plr,_bodyMagArr,"magazine"] call fnc_add_magazinesAndWeapons;
			};
			if (count _playerMagArr > 0) then {
				[_body,_playerMagArr,"magazine"] call fnc_add_magazinesAndWeapons;
			};
		};
		
	};
	
};

/*
	Function Name: fnc_remove_all
	Function Description: Remove all Weapons, Items and Backpacks
	Function Parameters: Unit
	Function Return: Nothing
*/
fnc_remove_all = {
	private["_unit","_items","_returnArray"];
	
	_unit = _this select 0;
		
		removeBackpack _unit;
		removeAllItems _unit;
		removeAllWeapons _unit;
};

if (!_isBuried) then {
	if (!_hasHarvested) then {
		_body setVariable["isBuried", true, true];
		//_plr playActionNow "Medic";
		sleep 7;
		
		sk_myBackpack = unitBackpack _body;
		_bodyBp = (typeOf sk_myBackpack);
		
		if(_bodyBp != "") then {
			_bpPlayerWpns = getWeaponCargo unitBackpack _body;
			_bpPlayer_Mags = getMagazineCargo unitBackpack _body;
		};
		
		player_all = [_plr] call fnc_get_all;
		body_all = [_body] call fnc_get_all;
		
		player_toolbelt = [_plr] call fnc_get_toolbelt;
		body_toolbelt = [_body] call fnc_get_toolbelt;
		
		player_backpack = [_plr] call fnc_get_backpackAndItems;
		body_backpack = [_body] call fnc_get_backpackAndItems;
		
		player_weapons = [_plr] call fnc_get_weapons;
		body_weapons = [_body] call fnc_get_weapons;
		
		player_items = [_plr] call fnc_get_items;
		body_items = [_body] call fnc_get_items;
		
		kitSelectionArray = ["Swap All"];
		
		if (count body_toolbelt > 0) then {
			kitSelectionArray = kitSelectionArray + ["Swap Toolbelt"];
		};
		if (count body_backpack > 0) then {
			kitSelectionArray = kitSelectionArray + ["Swap Backpack"];
		};
		if (count body_weapons > 0) then {
			kitSelectionArray = kitSelectionArray + ["Swap Weapons"];
		};
		if (count body_items > 0) then {
			kitSelectionArray = kitSelectionArray + ["Swap Items"];
		};
		
		[] spawn fnc_swap_actions;
		
		sleep 4;
		/**
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
		**/
	} else {
		cutText ["This _body has been mutilated, the gear is no good", "PLAIN DOWN"];
	};													
} else {
	cutText ["This _body has been buried, feel free to pick through the remains", "PLAIN DOWN"];
};
