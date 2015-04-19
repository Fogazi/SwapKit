/*
	File Name: swap_kit.sqf
	File Created: 19/04/2015
	File Version: 1.1
	File Author: Fogazi
	File Contributor: Martin
	File Last Edit Date: 19/04/2015
	File Description: Swap Kits of Player and _body
*/

private["_body", "_isBuried", "_hasHarvested", "_name", "_plr", "_grave", "_graveCross"];
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
kitSelectionArray = [];

fnc_swap_actions = {

	kitMenu =
	{
		private ["_kitMenu","_kitArray"];
		_kitMenu = [["",true], ["I've got these Missions for you:", [-1], "", -5, [["expression", ""]], "1", "0"]];
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
			
			[_plr,_bodyMagArr,"magazine"] call fnc_add_magazinesAndWeapons;
			[_body,_playerMagArr,"magazine"] call fnc_add_magazinesAndWeapons;
			
			[_plr,_bodyWeaponArr,"weapon"] call fnc_add_magazinesAndWeapons;
			[_body,_playerWeaponArr,"weapon"] call fnc_add_magazinesAndWeapons;
			
			[_plr,"player"] call fnc_add_BackPackItems;
			[_plr,"body"] call fnc_add_BackPackItems;
			

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
			[_plr,"player"] call fnc_add_BackPackItems;
			[_plr,"body"] call fnc_add_BackPackItems;
		};
		
		if (swapKitSelect == "Swap Weapons") exitWith {
			[_plr,_bodyWeaponArr,"weapon"] call fnc_add_magazinesAndWeapons;
			[_body,_playerWeaponArr,"weapon"] call fnc_add_magazinesAndWeapons;
		};
		
		if (swapKitSelect == "Swap Items") exitWith {
			[_plr,_bodyMagArr,"magazine"] call fnc_add_magazinesAndWeapons;
			[_body,_playerMagArr,"magazine"] call fnc_add_magazinesAndWeapons;
		};
		
	};
	
};

/*
	Function Name: fnc_get_all
	Function Description: Get Weapons and items
	Function Parameters: Unit
	Function Return: Array of Weapons and Items (without Backpack)
	Function Return Format: [[ArrayofWeapons],[ArrayofMags]]
*/
fnc_get_all = {
	private["_unit","_weapons","_items","_returnArray"];
	
	_unit = _this select 0;
	_weapons = weapons _unit;
	_items = magazines _unit;
	_returnArray = [];
	
	if(count _weapons > 0) then {
		_returnArray set [count _returnArray,_weapons];
	};
	
	if(count _items > 0) then {
		_returnArray set [count _returnArray,_items];
	};
	
	_returnArray
};

/*
	Function Name: fnc_get_toolbelt
	Function Description: Get Toolbelt Items
	Function Parameters: Unit
	Function Return: Array of Toolbelt Items
*/
fnc_get_toolbelt = {
	private["_unit","_weapons","_toolArray","_tools"];
	
	_unit = _this select 0;
	_weapons = weapons _unit;
	_toolArray = [];
	
	_tools = ["ItemToolbox","ItemEtool","ItemMatchbox","ItemHatchet","ItemKnife","ItemFlashlight","ItemFlashlightRed","ItemWatch","ItemRadio","ItemCompass","ItemGPS","ItemMap","ItemMachete","ItemCrowbar","ItemFishingPole","ItemSledge","ItemKeyKit","ItemMatchbox_DZE","ItemHatchet_DZE"];
	
	{
		if ((_weapons in _tools) && !(_weapons in _toolArray)) then {
			_toolArray set [count _toolArray,_x];
		};
	} forEach _weapons;
	
	_toolArray
};

/*
	Function Name: fnc_get_backpackAndItems
	Function Description: Get Backpack and Items
	Function Parameters: Unit
	Function Return: Array (Backpack and Backpack Items)
	Function Return Format: ["BackpackType",[ArrayofWeapons],[ArrayofMags]]
*/
fnc_get_backpackAndItems = {
	private ["_bpPlayerObject","_bpPlayerType","_bpPlayerReturn","_bpPlayerWeapons","_bpPlayerMags"];
	
	_unit = _this select 0;
	
	_bpPlayerObject = unitBackpack _unit;
	_bpPlayerType = typeOf _bpPlayerObject;
	
	_bpPlayerReturn = [];
	
	if(_bpPlayerType != "") then {
	
		_bpPlayerReturn = _bpPlayerReturn set [count _bpPlayerReturn,_bpPlayerType];
		
		_bpPlayerWeapons = getWeaponCargo unitBackpack _unit;
		_bpPlayerMags = getMagazineCargo unitBackpack _unit;
		
		if(count _bpPlayerWeapons > 0) then {
			_bpPlayerReturn = _bpPlayerReturn set [count _bpPlayerReturn,_bpPlayerWeapons];
		};
		if(count _bpPlayerMags > 0) then {
			_bpPlayerReturn = _bpPlayerReturn set [count _bpPlayerReturn,_bpPlayerMags];
		};
	};

	_bpPlayerReturn
};

/*
	Function Name: fnc_get_weapons
	Function Description: Get Weapons
	Function Parameters: Unit
	Function Return: Array of Weapons 
	Function Return Format: [[ArrayofWeapons]]
*/
fnc_get_weapons = {
	private["_unit","_weapons","_returnArray"];
	
	_unit = _this select 0;
	_weapons = weapons _unit;
	_returnArray = [];
	
	if(count _weapons > 0) then {
		_returnArray set [count _returnArray,_weapons];
	};
	
	_returnArray
};

/*
	Function Name: fnc_get_items
	Function Description: Get Items
	Function Parameters: Unit
	Function Return: Array of Items 
	Function Return Format: [[ArrayofItems]]
*/
fnc_get_items = {
	private["_unit","_items","_returnArray"];
	
	_unit = _this select 0;
	_items = magazines _unit;
	_returnArray = [];

	if(count _items > 0) then {
		_returnArray set [count _returnArray,_items];
	};
	
	_returnArray
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

/*
	Function Name: fnc_add_magazines
	Function Description: Add Magazines to Unit
	Function Parameters: Unit
	Function Return: Nothing
*/
fnc_add_magazinesAndWeapons = {
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
};

/*
	Function Name: fnc_add_Weapons
	Function Description: Add Weapons to Unit
	Function Parameters: Unit
	Function Return: Nothing
*/
fnc_add_BackPackItems = {
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
};

/*
	Function Name: fnc_swap_toolbelt
	Function Description: Swap Toolbelt of Player and Body
	Function Parameters: Unit
	Function Return: Nothing
*/
fnc_swap_toolbelt = {
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
		
		if (count body_all > 0) then {
			kitSelectionArray = kitSelectionArray set [count kitSelectionArray,"Swap All"];
		};
		if (count body_toolbelt > 0) then {
			kitSelectionArray = kitSelectionArray set [count kitSelectionArray,"Swap Toolbelt"];
		};
		if (count body_backpack > 0) then {
			kitSelectionArray = kitSelectionArray set [count kitSelectionArray,"Swap Backpack"];
		};
		if (count body_weapons > 0) then {
			kitSelectionArray = kitSelectionArray set [count kitSelectionArray,"Swap Weapons"];
		};
		if (count body_items > 0) then {
			kitSelectionArray = kitSelectionArray set [count kitSelectionArray,"Swap Items"];
		};
		
		[] spawn fnc_swap_actions;
		
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
		cutText ["This _body has been mutilated, the gear is no good", "PLAIN DOWN"];
	};													
} else {
	cutText ["This _body has been buried, feel free to pick through the remains", "PLAIN DOWN"];
};
