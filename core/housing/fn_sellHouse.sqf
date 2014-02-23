/*
	File: fn_sellHouse.sqf
	Author: John "Paratus" VanderZwet
	
	Description:
	Sell a house and initiates DB removal
*/
private["_house", "_buildingID", "_buildingName", "_owners", "_isLocked", "_uid", "_price", "_val", "_i", "_j"];

_house = cursorTarget;

if (player distance _house > 20) exitWith {};
if (!(_house isKindOf "House")) exitWith {};

_owners = _house getVariable["life_homeOwners", []];
_uid = getPlayerUID player;
_price = [typeOf _house] call life_fnc_housePrice;
_buildingID = [_house] call life_fnc_getBuildID;
_buildingName = getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName");
_price = _price * 0.75; // 75% of buy price for sale

if (!(_uid in _owners)) exitWith {hint "You do not own this property!";};

_owners = _owners - [_uid];
_house setVariable["life_homeOwners", _owners, true];
["atm","add",_price] call life_fnc_updateCash;
titleText[format["You have sold %1 for $%2!", _buildingName, [_price] call life_fnc_numberText],"PLAIN"];

closeDialog 0;

//[[2, player, format["Sold house %1 for %2 at %3", _buildingName, _price, position _house]],"ASY_fnc_logIt",false,false] spawn BIS_fnc_MP;
_j = 0;	
{	
	if((typeName _x) == "ARRAY") then {
		_house2 = nearestObject [_x select 0, "House_F"];
		diag_log format ["position _house  : %1 (%2), %3 (%4)", (position _house) select 0, typeName ((position _house) select 0), (position _house) select 1, typeName ((position _house) select 1)];
		diag_log format ["_x select 0  : %1 (%2), %3 (%4)", (_x select 0), typeName (_x select 0), (_x select 1), typeName (_x select 1)];
		//(_x select 0) = call compile format["%1", (_x select 0)];
		diag_log format ["_x select 0  : %1 (%2), %3 (%4)", (_x select 0), typeName (_x select 0), (_x select 1), typeName (_x select 1)];
		if(((position _house) select 0) == ((position _house2) select 0) AND ((position _house) select 1) == ((position _house2) select 1)) then {
			diag_log "HAUS POSITION GEFUNDEN";
			life_houses set [_j, -1];
			life_houses = life_houses - [-1];
		};		
	};	
	_j = _j + 1;
}forEach life_houses;
diag_log format ["LIFE_HOUSES  : %1", life_houses];
diag_log format ["LIFE_HOUSES MARKERS : %1", life_houses_markers];
{
	deleteMarkerLocal _x;
}forEach life_houses_markers;

life_houses_markers = [];
diag_log format ["LIFE_HOUSES MARKERS : %1", life_houses_markers];

for "_i" from 1 to (count life_houses) do
{
	if(typeName ((life_houses select (_i-1)) select 0) == "ARRAY") then {		
		_house = nearestObject [((life_houses select (_i-1)) select 0), "House_F"];
		_marker = createMarkerLocal [format["house_%1", _i], ((life_houses select (_i-1)) select 0)];
		_marker setMarkerTextLocal getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName");
		_marker setMarkerShapeLocal "ICON";
		_marker setMarkerColorLocal "ColorBlue";
		_marker setMarkerTypeLocal "mil_end";
		
		life_houses_markers set [count life_houses_markers, _marker];
	};
};
[[_buildingID, position _house],"BRUUUDIS_fnc_deleteHouse",false,false] spawn BIS_fnc_MP;
[] call life_fnc_sessionUpdate;

