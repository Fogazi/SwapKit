/*
	Function Name: fnc_get_toolbelt
	Function Description: Get Toolbelt Items
	Function Parameters: Unit
	Function Return: Array of Toolbelt Items
*/
	private["_unit","_weapons","_selection","_toolArray","_tools"];
	
	_unit = _this select 0;
	_weapons = weapons _unit;
	_toolArray = [];
	
	_tools = ["ItemToolbox","ItemEtool","ItemMatchbox","ItemHatchet","ItemKnife","ItemFlashlight","ItemFlashlightRed","ItemWatch","ItemRadio","ItemCompass","ItemGPS","ItemMap","ItemMachete","ItemCrowbar","ItemFishingPole","ItemSledge","ItemKeyKit","ItemMatchbox_DZE","ItemHatchet_DZE"];
	
	{
		if (_x in _tools) then {
			if (count _toolArray == 0) then {
				_toolArray = [_x];
			} else {
				if(!(_x in _toolArray)) then {
					_toolArray set [count _toolArray,_x];
				};
			};
		};
	} forEach _weapons;
	
	_toolArray;
