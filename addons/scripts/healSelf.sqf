//	@file Name: healSelf.sqf
//	@file Author: Cael817

if ("FirstAidKit" in (items player) && vehicle player != player) then
{
	player removeItem "FirstAidKit";
	//sleep 1;
	//player removeItem "FirstAidKit";
	
	sleep 5;
	player setDamage 0;
}
else
{
	if (animationState player != "AinvPknlMstpSlayWrflDnon_medic") then 
	{ // Keep the player locked in medic animation for the full duration of the placement.
		player switchMove "AinvPknlMstpSlayWrflDnon_medic";
	};
	
	sleep 5;
	player setDamage 0;
	sleep 1;
	player removeItem "FirstAidKit";
}