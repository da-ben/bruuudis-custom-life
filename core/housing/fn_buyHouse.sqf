/*
	File: fn_buyHouse.sqf
	Author: John "Paratus" VanderZwet
	
	Description:
	Purchases a house and initiates DB entry
*/
private["_house", "_buildingID", "_buildingName", "_owners", "_isLocked", "_uid", "_price"];

_house = cursorTarget;

if (player distance _house > 20) exitWith {};
if (!(_house isKindOf "House")) exitWith {};

_owners = _house getVariable["life_homeOwners", []];
_uid = getPlayerUID player;
_price = [typeOf _house] call life_fnc_housePrice;
_buildingID = [_house] call life_fnc_getBuildID;
_buildingName = getText(configFile >> "CfgVehicles" >> (typeOf _house) >> "displayName");

if (!license_civ_home) exitWith {hint "You do not have a home owners license!";};
if (count life_houses > 4) exitWith {hint "You may only own five houses at one time.";};
if (_price < 0 || _buildingID in life_public_houses || format["%1", _owners] != "[]") exitWith{hint "This building is not for sale";};
if (life_atmcash < _price) exitWith {hint format["You do not have $%1 in your bank to purchase %2",[_price] call life_fnc_numberText,_buildingName];};

_house setVariable["life_homeOwners", [_uid], true];
_house setVariable["containers", [], true];
["atm","take",_price] call life_fnc_updateCash;
titleText[format["You have purchased %1 for %2!", _buildingName, [_price] call life_fnc_numberText],"PLAIN"];

//[[2, player, format["Purchased house %1 for %2 at %3", _buildingName, _price, position _house]],"ASY_fnc_logIt",false,false] spawn BIS_fnc_MP;

closeDialog 0;
{
	deleteMarkerLocal _x;
}forEach life_houses_markers;

life_houses_markers = [];
life_houses set [count life_houses, [position _house, _uid, []]];
		
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

[[_buildingID, _uid, [], position _house],"BRUUUDIS_fnc_insertHouse",false,false] spawn BIS_fnc_MP;
[] call life_fnc_sessionUpdate;

