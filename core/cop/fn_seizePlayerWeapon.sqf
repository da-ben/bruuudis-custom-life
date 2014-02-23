/*
	File: fn_seizePlayerWeapon.sqf
	Author: Skalicon
	
	Description:
	Preforms the seizePlayerWeaponAction script on the cursorTarget
*/
[[],"life_fnc_seizePlayerWeaponAction",cursorTarget,false] spawn life_fnc_MP;
//titleText format["Seized weapons from %1", name cursorTarget];
[[52, player, format["Requizada un arma de %1", name cursorTarget]],"STS_fnc_logIt",false,false] spawn life_fnc_MP;