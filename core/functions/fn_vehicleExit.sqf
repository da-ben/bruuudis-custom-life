/*
	File: fn_vehicleExit.sqf
	Author: Skalicon
	
	Description: 
*/
private["_vehicle","_position","_unit"];
_vehicle = _this select 0;
_position = _this select 1;
_unit = _this select 2;

_vehicle setVariable["idleTime",time,true];
_vehicle setVariable["spawned",false,true];
if (_unit getVariable"restrained") then{_vehicle setVariable["isTransporting",false,true];};