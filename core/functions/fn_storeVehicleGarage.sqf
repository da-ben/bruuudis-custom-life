/*
	File: fn_storeVehicleGarage.sqf
	Author: Skalicon
	
	Description:
	Handles everything that happens when you store a vehicle in the garage.
*/
private["_nearVehicle","_near","_uid"];
_nearVehicle = objNull;
if ((player distance cursorTarget) > 5) exitWith {hint"You are too far away to use this NPC."};
if (vehicle player != player) exitWith {hint"You cannot use this npc while in a vehicle."};
_near = nearestObjects[(getPos (_this select 0)),["Car","Ship","Air"],200];
{
	_uid = _x getVariable["dbInfo",[""]] select 0;
	if (_uid == getPlayerUID player) exitWith {_nearVehicle = _x;};
} foreach _near;

if(isNull _nearVehicle) exitWith{hint "You don't own any nearby vehicles.";};

[[_nearVehicle,false,(_this select 1)],"DB_fnc_storeVehicle",false,false] spawn BIS_fnc_MP;
hint "The server is trying to store the vehicle please wait....";
life_garage_store = true;