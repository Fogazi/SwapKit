# SwapKit
Fogazi's Kit Swapping script for DayZ Epoch/Overpoch
////////////////////////////////////////////////////////
//                                                    //
//        Swap Kit Script - Created by Fogazi         //
//                  fogazi@gmail.com                  //
//                      v1.2                          //
//                                                    //
////////////////////////////////////////////////////////

The following script gives you the option to swap your kit with a dead AI or Player. No longer do you need to access the gear menu and slowly transfer all the items 1 at a time.
This is especially helpful in those situations where you are gunned down, spawn back in and get back to your corpse and swap your default spawn kit out for your original kit.
If you want to limit this script to only be able to swap kit with the players own dead body, scroll to the bottom for the change in code.

-WARNING- At this time when you select 'Swap Kit', you will get the complete kit and backpack of the dead AI/player. But what is currently in your inventory will be wiped from the server. 

Follow the instructions below to install the script.
This script was created on an Overpoch Lingor server but with a bit of know how, it should be able to be adapted to any server.
Email me with any bugs/features/improvements and I will endeavour to fix/add them.


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SwapKit Folder

	Create a folder in your root mission directory and call it 'scripts'.
	Create a folder inside the 'scripts' folder and call it SwapKit.
	Place the swap_kit.sqf inside the SwapKit folder.
	Alternatively place the script wherever you want and edit the path in the 'fn_selfActions.sqf'.
	
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
scriptcontrol.sqf:

	If you are using a "scriptcontrol.sqf", insert the following code on a new line after the last 'true;'.	
	
==Code Start==	
//Swap Kit Script
SwapKitScript = true;
==Code End==
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
variables.sqf:

	Insert the following code into your "variables.sqf" in the 'dayz_resetSelfActions = {' section.

==Code Start==	
s_player_swap_human = -1;
==Code End==
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn_selfActions.sqf:

	Insert the following code into your "fn_selfActions.sqf". It must be placed at least after the following line '_isAlive = alive _cursorTarget;'.
	Find that line using the find feature in your .sqf editor and then insert the code somewhere logical. For example: before an if statement or at the completion of an if statement.
	Do not nest it within another if statement as this will cause errors and likely won't work.
	
	If you are using a "scriptcontrol.sqf", none of the below needs to be changed.
	If you are not using a "scriptcontrol.sqf" then delete the first line and the last line of the following code. Not the lines with '/////' in them.
	
==Code Start==	
///////////////////////////////////////////////////Swap Kit Start///////////////////////////////////////////////////////////
if(SwapKitScript) then{
	if (!_isAlive && !_isZombie && !_isAnimal && _isMan && _canDo) then {
		if (s_player_swap_human < 0) then {
			s_player_swap_human = player addAction [format["<t color='#dddd00'>Swap Kit</t>"], "scripts\SwapKit\swap_kit.sqf",cursorTarget, 0, true, true, "", ""];
		};
	} else {
	
		player removeAction s_player_swap_human;
		s_player_swap_human = -1;
	};
};
///////////////////////////////////////////////////Swap Kit END///////////////////////////////////////////////////////////
==Code End==
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn_selfActions.sqf:
		
	Insert the following 2 lines into your engineering section down towards the bottom of your "fn_selfActions.sqf", this code removes the 'addAction' when you move away from your selected target.

==Code Start==	
player removeAction  s_player_swap_human;
s_player_swap_human = -1;
==Code End==
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

That's it, you should be right to start your server and be able to swap kits with any dead player or AI soldier/bandit etc etc.
WARNING If you do swap kit, your current kit is wiped. It does not get placed onto the dead body.

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
OPTIONAL From v1.2
Add option to only swap kit with the players own dead body.
	
	Find the following block of code in the fn_selfActions.sqf(this code will only be there if you followed the above instructions completely):
	
		==Code Start==	
		///////////////////////////////////////////////////Swap Kit Start///////////////////////////////////////////////////////////
		if(SwapKitScript) then{
			if (!_isAlive && !_isZombie && !_isAnimal && _isMan && _canDo) then {
				if (s_player_swap_human < 0) then {
					s_player_swap_human = player addAction [format["<t color='#dddd00'>Swap Kit</t>"], "scripts\SwapKit\swap_kit.sqf",cursorTarget, 0, true, true, "", ""];
				};
			} else {
			
				player removeAction s_player_swap_human;
				s_player_swap_human = -1;
			};
		};
		///////////////////////////////////////////////////Swap Kit END///////////////////////////////////////////////////////////
		==Code End==
		
	Replace with the following block of code.
	
		==Code Start==
		///////////////////////////////////////////////////Swap Start///////////////////////////////////////////////////////////
		if(SwapKitScript) then{
			_playerName = name player;
			_targetName = _cursorTarget getVariable["bodyName","unknown"];
			if (_playerName == _targetName) then {
				_playerBody = true; 
				if (!_isAlive && !_isZombie && !_isAnimal && _isMan && _canDo && _playerBody) then {
					if (s_player_swap_human < 0) then {
						s_player_swap_human = player addAction [format["<t color='#dddd00'>Swap Kit</t>"], "scripts\SwapKit\swap_kit.sqf",cursorTarget, 0, true, true, "", ""];
					};
				} else {
			
				player removeAction s_player_swap_human;
				s_player_swap_human = -1;
				};
			};
		};
		///////////////////////////////////////////////////Swap END///////////////////////////////////////////////////////////
		==Code End==
		
	Now the option to 'Swap Kit' will only display when a player is looking at his/her own dead body.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
