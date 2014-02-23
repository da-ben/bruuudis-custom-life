/*
	File: fn_getSpawnMarker.sqf
	Author: Skalicon
	
	Description:
	Spawn marker thing but Skali forgot to put the header in it!
*/

private["_npc","_dist"];
_npc = _this select 0;
life_veh_sp = "";
{
	_pos = markerPos _x;
	_dist = (_npc) distance _pos;
	if(_dist <= 100) then{
		if(count(nearestObjects[(_pos),["Car","Ship","Air"],4]) == 0) then {
			if (life_veh_sp == "") then {
				life_veh_sp = _x;
			} else {
				if (_dist < (markerPos life_veh_sp) distance (_npc)) then{
					life_veh_sp = _x;
				};
			};
		};
	};
}foreach life_spawn_markers;
