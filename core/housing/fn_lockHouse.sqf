#include <macro.h>
/*
	File: fn_lockHouse.sqf
	Author: John "Paratus" VanderZwet
	
	Description:
	Toggles locks on all doors of selected house
*/
private["_house", "_buildingName", "_type", "_owners", "_isLocked", "_uid", "_index", "_soundFile", "_numDoors"];

_house = cursorTarget;
_isLocked = _house getVariable["life_locked", 0];
_owners = _house getVariable["life_homeOwners", []];
_uid = getPlayerUID player;
_buildingID = [_house] call life_fnc_getBuildID;

if (!(_uid in _owners)&&(__GETC__(life_coplevel) < 4)) exitWith {};
if (player distance cursorTarget > 20) exitWith {};
if (_house isKindOf "House") then
{
	_buildingName = getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName");
	_numDoors = getNumber(configFile >> "CfgVehicles" >> (typeOf _house) >> "numberOfDoors");
	_type = typeOf _house;
	if (_numDoors < 1) exitWith {hint "You can't lock a building with no doors!";};
	
	if (_isLocked == 1) then
	{
		_isLocked = 0;
		hint format["Unlocked all doors of %1.", _buildingName];
	}
	else
	{
		_isLocked = 1;
		hint format["Locked all doors of %1.", _buildingName];
	};
	_house setVariable["life_locked", _isLocked, true];
	
	for "_i" from 1 to _numDoors do
	{
		_house setVariable[format["bis_disabled_Door_%1", _i], _isLocked, true];
	};
	
	[[_buildingID, _isLocked, position _house],"DB_fnc_updateHouse",false,false] spawn BIS_fnc_MP;
	//[[23, player, format["Set locks for house at %1 to %2", position _house, _isLocked]],"ASY_fnc_logIt",false,false] spawn BIS_fnc_MP;
	
	if (_isLocked == 1) then { _soundFile = "lock"; }
	else { _soundFile = "unlock"; };
	[[player, _soundFile, 10],"life_fnc_playSound",true,false] spawn BIS_fnc_MP;
};