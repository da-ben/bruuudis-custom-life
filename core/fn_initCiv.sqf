/*
	File: fn_initCiv.sqf
	Author: Bryan "Tonic" Boardwine
	
	Description:
	Initializes the civilian.
*/
private["_spawnPos"];

civ_spawn_1 = nearestObjects[getMarkerPos  "civ_spawn_1", ["Land_i_House_Big_01_V1_F","Land_i_House_Small_01_V2_F","Land_i_House_Small_03_V1_F"],250];
civ_spawn_2 = nearestObjects[getMarkerPos  "civ_spawn_2", ["Land_i_House_Big_01_V1_F","Land_i_House_Small_01_V2_F","Land_i_House_Small_03_V1_F"],250];
civ_spawn_3 = nearestObjects[getMarkerPos  "civ_spawn_3", ["Land_i_House_Big_01_V1_F","Land_i_House_Small_01_V2_F","Land_i_House_Small_03_V1_F"],250];
civ_spawn_4 = nearestObjects[getMarkerPos  "civ_spawn_4", ["Land_i_House_Big_01_V1_F","Land_i_House_Small_01_V2_F","Land_i_House_Small_03_V1_F"],250];

{
	deleteMarkerLocal _x;
}forEach life_houses_markers;

for "_i" from 1 to (count life_houses) do
{
	_house = nearestObject [((life_houses select (_i-1)) select 0), "House_F"];
	_marker = createMarkerLocal [format["house_%1", _i], ((life_houses select (_i-1)) select 0)];
	_marker setMarkerTextLocal getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName");
	_marker setMarkerShapeLocal "ICON";
	_marker setMarkerColorLocal "ColorBlue";
	_marker setMarkerTypeLocal "mil_end";	
	diag_log format ["house : %1", _house];
	_positions = [_house] call life_fnc_countBuildingPositions;
	_containers = _house getVariable ["containers", []];
	
	if(count _containers > 0) then {
		{
			_pos = position _house;
			_pos = [(_pos select 0), (_pos select 1), (_pos select 2) + 1];
			_box = (_x select 2) createVehicle _pos;
			_box setVariable["storage", (_x select 3), true];
			_box setVariable["Trunk", [[],0], true];
			_box setPosATL _pos;
			clearWeaponCargo _box; 
		}forEach _containers;
	};
	
	life_houses_markers set [count life_houses_markers, _marker];
};

waitUntil {!(isNull (findDisplay 46))};

if(life_is_arrested) then
{
	life_is_arrested = false;
	[player,true] spawn life_fnc_jail;
}
	else
{
	[] call life_fnc_spawnMenu;
	waitUntil{!isNull (findDisplay 38500)}; //Wait for the spawn selection to be open.
	waitUntil{isNull (findDisplay 38500)}; //Wait for the spawn selection to be done.
};
player addRating 9999999;