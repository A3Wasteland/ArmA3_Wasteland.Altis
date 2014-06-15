//	@file Version: 1.0
//	@file Name: payload.sqf
//	@file Author: Originally made by AXA from OpenDayZ.net, improved by AgentRev
//	@file Created: 01/06/2013 21:31

if (isDedicated) exitWith {};

private ["_cheatFlag", "_cfgPatches", "_patchClass", "_defaultRecoil", "_currentRecoil", "_recoilDifference", "_loopCount", "_sign"];

waitUntil {!isNull player};
_defaultRecoil = unitRecoilCoefficient player;

// diag_log "ANTI-HACK 0.8.0 starting...";

_cfgPatches = configFile >> "CfgPatches";

for "_i" from 0 to (count _cfgPatches - 1) do
{
    _patchClass = _cfgPatches select _i;
	
    if (isClass _patchClass && {(toLower configName _patchClass) in ["devcon","loki_lost_key"]}) then
    {
        _cheatFlag = ["hacking addon", configName _patchClass];
    };
};

// diag_log "ANTI-HACK 0.8.0: Starting loop!";

_loopCount = 24;

while { true } do
{			
	waitUntil {time > 0.1};
	
	if (isNil "_cheatFlag" && _loopCount >= 24) then 
	{
		_loopCount = 0;
		
		{
			if (!isNil _x) exitWith
			{
				// diag_log "ANTI-HACK 0.8.0: Found a hack variable!";
				
				_cheatFlag = ["hack variable", _x];
			};
			sleep 0.01;
			
		} forEach ["fzhgdhhbzfhzfghz", "dgbfzhg5ey456w6s", "asdsgxfvzv5345", "dadsasdsada", "aw235resfzdfcs", "d3245resfrsd", "iBeFlying", "feastge4rt636te5", "sfsdfsdf4333", "dayz_godmode", "Hack_Pos_Orig", "sdgff4535hfgvcxghn", "REdasfsfwef", "dfhfgkjjhkhjkdgfg", "activeITEMlistanzahl", "g0dmode", "adadadad23444", "poiuytfczsvtg", "Pro_RE", "xyzaa", "HaxSmokeOn", "Lysto_Lyst", "pathtoscrdir", "ewrfdfcsf", "Ug8YtyGyvguGF", "sr3453sdfsfe33", "rgyehgdrfhg", "d121435rdsczcawddawdsf", "qofjqpofq", "fsfw34r534fsedsf", "adawredzfdsf", "c0lorthem", "srgte54y6rdgtrg", "shnmenu", "letmeknow", "DAYZ_CA1_Lollipops", "oighijkfcjloypysh", "fazelist", "faze_fill", "dfgrgdrfgretg345t345", "inf_ammo_loop_infiSTAR", "Wookie_Pro_RE", "awrdw4355345sfs", "Wookie_Init_Menu", "asdr432r5edfsad", "fsfgdggdzgfd", "fdsgdr42424ZombieColor", "TTT5OptionNR", "adasdawer4w3r", "hthxhzhgcbcxvb", "sdfwesrfwesf233", "dsagfgbdfhgsd", "htrukilojhkukvh", "d4t365tearfsafgrg", "ddsfsdfv", "faze_funcs_inited", "godlol", "fetg5e4ytdrg", "Lystic_Init", "Lystic_Exec", "faze_getControl", "vehicleg0dv3_BushWookie", "dsfsgfsfsdfsdf", "yer652374rfd", "t0ggl3", "d45y6w45ytrdfragsrega", "morphm3", "sgdfgzgdzfrgfdg", "q25t3qttsdfaf", "fsdddInfectLOL", "lkjhgfuyhgfd", "cargod", "Wep_Spawn_Shitt", "faze_hax_dbclick", "fzgrfg4536tq3tds", "dawerdsczcdsf", "gdzhzthtdhxthh6757", "W00kie_Pro_RE", "fdsgdr42424", "battleHIGH_vehpub", "sdsf45t3rsgfd", "hdtrhyztyh", "MenuInitLol", "few3t5364etsfg", "adadgvdthw54y64", "sfsefse", "eeeeeeewwwwwwwww", "efr4243234", "faze_initMenu", "adawedr3q4r3w2qr4", "xZombieBait", "eyghrdfyh", "W00kie_Init_Menu", "awdet3465taddd", "rainbow_var", "iluio9pilkgvuk", "awer234rrsdfcsd", "W_O_O_K_I_E_Pro_RE", "toggle_keyEH", "dawr5wdfsf23", "sgstgr4stwe4t", "gffffffffffffffh", "LOKI_GUI_Key_Color", "rdgfdzgzrfgr", "gzgdghragfzdgvdz", "sdfxdcfs3", "infi_STAR_exec", "xtags_star_xx", "ChangingBullets_xx", "ljkluilufgdsgzgzdrf324", "hgjghjfrdfeewrferrt43", "byebyezombies", "adr4w5trsdef", "wadgrfgzrd", "igodokxtt", "unlimammo", "tw4etinitMenu", "plrshldblckls", "dasd324r245rdsfs", "Monky_funcs_inited", "fuckmegrandma", "qopfkqpofqk", "da124q3easds", "awdadr3q42", "awde3q4erasd", "ShadowyFaz3VehZ", "Veh_Spawn_Shitt", "wuat_fpsMonitor", "sfg4w3t5esfsdf", "asdw435r325efdsd", "Monky_hax_toggled", "asd34r253453453", "mehatingjews", "da342szvcxzcvx", "W_0_0_K_I_E_Pro_RE", "InfiniteAmmo", "debug_star_colorful", "fryt5tytfshyfkj", "sfewsrw", "W00kieMenu_hax_toggled", "AntiAntiAntiAntiHax", "thuytshujsr65uy", "adawdawe21", "ad44234efdzsf", "ffafsafafsfsgol", "shth654436tj", "gyjjgcjcj", "GodLolPenis", "vehiclegooov3ood_BushWookie", "htjhytu6waqe3q45", "y6sretysrt", "ANTI_ANTI_HAX", "antiantiantiantih4x", "monkytp", "hax_toggled", "yiukfligzsgargfrae", "omgwtfbbq", "asdddddddddddad", "bowonky", "dontAddToTheArray", "adddaaaaaaaaa", "fesf4535teaf", "rainbowbitch", "ads2542345esfds", "n0clip", "saddaaaaaaaadd23", "fefq34tqtrafg", "f313131FukDaPolice1324e", "BigFuckinBullets", "lmzsjgnas"];
	};
	
	if (isNil "_cheatFlag") then 
	{
		// diag_log "ANTI-HACK 0.8.0: Recoil hack check started!";
		
		_currentRecoil = unitRecoilCoefficient player;
		
		if ((_currentRecoil < _defaultRecoil - 0.001 || _currentRecoil > _defaultRecoil + 0.001) && {_defaultRecoil != -1 && _currentRecoil != -1}) then
		{
			// diag_log "ANTI-HACK 0.8.0: Detected recoil hack!";
			
			_recoilDifference = ((_currentRecoil / _defaultRecoil) - 1) * 100;
			_sign = "";
			
			switch (true) do
			{
				case (_recoilDifference > 0): { _sign = "+" };
				case (_recoilDifference < 0): { _sign = "-" };
			};
			
			_cheatFlag = ["recoil hack", _sign + (str ceil abs _recoilDifference) + "% difference"];
		};
	};
	
	if (!isNil "_cheatFlag") exitWith
	{
		waitUntil {time > 0.1};
		
		//diag_log str [profileName, getPlayerUID player, _cheatFlag select 0, _cheatFlag select 1];
		
		[[profileName, getPlayerUID player, _cheatFlag select 0, _cheatFlag select 1, _flagChecksum], "flagHandler", false, false] call TPG_fnc_MP;
		[getPlayerUID player, _flagChecksum] call clientFlagHandler;
	};
	
	sleep 5;
	_loopCount = _loopCount + 1;
};
