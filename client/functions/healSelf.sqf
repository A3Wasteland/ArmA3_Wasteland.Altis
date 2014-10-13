if ("FirstAidKit" in (items player)) then
{
	player removeItem "FirstAidKit";
	
	if (animationState player != "AinvPknlMstpSlayWrflDnon_medic") then 
	{ // Keep the player locked in medic animation for the full duration of the placement.
		player switchMove "AinvPknlMstpSlayWrflDnon_medic";
	};
	//player playMove ([player, "AinvPknlMstpSlayWrflDnon_medic", "putdown"] call getFullMove);
	player setDamage 0;
}
else
{
	[ format["<t size='0.75' color='#ffff00'>FirstAidKit required</t>"], 0,1,5,0,0,301] spawn bis_fnc_dynamicText;
}

if ("MediKit" in (items player)) then
{	
	if (animationState player != "AinvPknlMstpSlayWrflDnon_medic") then 
	{ // Keep the player locked in medic animation for the full duration of the placement.
		player switchMove "AinvPknlMstpSlayWrflDnon_medic";
	};
	//player playMove ([player, "AinvPknlMstpSlayWrflDnon_medic", "putdown"] call getFullMove);
	player setDamage 0;
}
else
{
	[ format["<t size='0.75' color='#ffff00'>FirstAidKit or required</t>"], 0,1,5,0,0,301] spawn bis_fnc_dynamicText;
}