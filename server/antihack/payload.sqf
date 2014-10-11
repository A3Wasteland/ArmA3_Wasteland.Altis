//	@file Version: 1.0
//	@file Name: payload.sqf
//	@file Author: Originally made by AXA from OpenDayZ.net, improved by AgentRev
//	@file Created: 01/06/2013 21:31

if (isDedicated) exitWith {};

private ["_cheatFlag", "_cfgPatches", "_patchClass", "_minRecoil", "_currentRecoil", "_loopCount"];

waitUntil {!isNull player};

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

if (isNil "_cheatFlag") then
{
	_mpInterruptCfg = configFile >> "RscDisplayMPInterrupt";

	{
		for "_i" from 0 to (count _x - 1) do
		{
			_ctrlCfg = _x select _i;
			if (getText (_ctrlCfg >> "action") != "" || getText (_ctrlCfg >> "onButtonClick") != "") exitWith
			{
				_ctrlText = toArray getText (_ctrlCfg >> "text");
				_ctrlText resize 64;
				_cheatFlag = ["hack menu", format ["foreign Esc menu button '%1'", toString _ctrlText]];
			};
		};

		if (!isNil "_cheatFlag") exitWith {};
	}
	forEach
	[
		configFile >> "RscDisplayMPInterrupt" >> "controls",
		configFile >> "RscDisplayMPInterrupt" >> "controlsBackground"
	];
};

if (isNil "_cheatFlag") then
{
	// Hack menu validator based on Tonic's SpyGlass
	_flagChecksum spawn
	{
		_flagChecksum = _this;
		_mainScope = call generateKey;
		scopeName _mainScope;

		private "_cheatFlag";

		while {true} do
		{
			_isAdmin = serverCommandAvailable "#kick";

			if (!isNull findDisplay 3030) exitWith
			{
				_cheatFlag = "RscConfigEditor_Main (Wookie)";
			};
			if (!isNull findDisplay 125) exitWith
			{
				_cheatFlag = "RscDisplayEditDiaryRecord (Gladtwoown)";
			};
			if (!isNull findDisplay 69) exitWith
			{
				_cheatFlag = "RscDisplayPort (Itsyuka)";
			};
			if (!isNull findDisplay 19) exitWith
			{
				_cheatFlag = "RscDisplayIPAddress";
			};
			if (!isNull findDisplay 71) exitWith
			{
				_cheatFlag = "RscDisplayFilter";
			};
			if (!isNull findDisplay 132) exitWith
			{
				_cheatFlag = "RscDisplayHostSettings";
			};
			if (!isNull findDisplay 32) exitWith
			{
				_cheatFlag = "RscDisplayIntel";
			};
			if (!isNull findDisplay 165) exitWith
			{
				_cheatFlag = "RscDisplayPublishMission";
			};
			if (!isNull findDisplay 157) exitWith
			{
				_cheatFlag = "RscDisplayPhysX3Debug (Itsyuka)";
			};
			if (!isNull findDisplay 2727) exitWith
			{
				_cheatFlag = "RscDisplayLocWeaponInfo";
			};
			if (!isNull findDisplay 30) exitWith
			{
				_cheatFlag = "RscDisplayTemplateLoad (Gladtwoown)";
			};
			if (!isNull findDisplay 64) exitWith
			{
				_cheatFlag = "RscDisplayPassword";
			};
			if (!isNull (findDisplay 49 displayCtrl 0)) exitWith
			{
				_cheatFlag = "RscDisplayInterruptEditorPreview";
			};
			/*if (!isNull findDisplay 17 && !isServer) exitWith // minor chances of false positive
			{
				_cheatFlag = "RscDisplayRemoteMissions (Wookie)";
			};*/
			if (!isNull findDisplay 316000 && !_isAdmin) exitWith
			{
				_cheatFlag = "Debug console"; // RscDisplayDebugPublic
			};
			if (!isNull (uiNamespace getVariable ["RscDisplayArsenal", displayNull]) && !_isAdmin) exitWith
			{
				_cheatFlag = "Virtual Arsenal";
			};
			if (!isNull findDisplay 148) then
			{
				sleep 0.5;
				if (lbSize 104 - 1 > 3) then
				{
					_cheatFlag = "RscDisplayConfigureControllers (JME 313)";
					breakTo _mainScope;
				};
			};
			if (!isNull findDisplay 54) then
			{
				sleep 0.5;
				if (buttonAction 1 != "" || buttonAction 2 != "" || _title != localize "STR_A3_RscDisplayInsertMarker_Title") then
				{
					_cheatFlag = "RscDisplayInsertMarker (JME)";
					breakTo _mainScope;
				};
			};
			if (!isNull findDisplay 131) then
			{
				sleep 0.5;
				(findDisplay 131 displayCtrl 102) ctrlRemoveAllEventHandlers "LBDblClick";
				(findDisplay 131 displayCtrl 102) ctrlRemoveAllEventHandlers "LBSelChanged";

				{
					if (_x select 0 != _x select 1) exitWith
					{
						_cheatFlag = "RscDisplayConfigureAction";
						breakTo _mainScope;
					};
				}
				forEach
				[
					[buttonAction 1, ""],
					[buttonAction 107, ""],
					[buttonAction 104, ""],
					[buttonAction 106, ""],
					[buttonAction 109, ""],
					[buttonAction 105, ""],
					[buttonAction 108, ""],
					[ctrlText 1000, localize "$STR_A3_RscDisplayConfigureAction_Title"]
				];
			};
		};

		[[profileName, getPlayerUID player, "hack menu", _cheatFlag, _flagChecksum], "A3W_fnc_flagHandler", false, false] call  A3W_fnc_MP;

		waitUntil {time > 0.1};

		[getPlayerUID player, _flagChecksum] call A3W_fnc_clientFlagHandler;
	};
};

// diag_log "ANTI-HACK 0.8.0: Starting loop!";

_loopCount = 24; // _loopCount >= 24 means every 2 minutes

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

		} forEach ["fzhgdhhbzfhzfghz", "dgbfzhg5ey456w6s", "asdsgxfvzv5345", "dadsasdsada", "aw235resfzdfcs", "d3245resfrsd", "iBeFlying", "feastge4rt636te5", "sfsdfsdf4333", "dayz_godmode", "Hack_Pos_Orig", "sdgff4535hfgvcxghn", "REdasfsfwef", "dfhfgkjjhkhjkdgfg", "activeITEMlistanzahl", "Detected_Remote_Execution", "g0dmode", "adadadad23444", "poiuytfczsvtg", "Pro_RE", "xyzaa", "HaxSmokeOn", "Lysto_Lyst", "pathtoscrdir", "ewrfdfcsf", "Ug8YtyGyvguGF", "sr3453sdfsfe33", "rgyehgdrfhg", "d121435rdsczcawddawdsf", "qofjqpofq", "fsfw34r534fsedsf", "adawredzfdsf", "c0lorthem", "srgte54y6rdgtrg", "shnmenu", "letmeknow", "DAYZ_CA1_Lollipops", "oighijkfcjloypysh", "fazelist", "faze_fill", "PL4YER_CANN0N_T0GGLE", "dfgrgdrfgretg345t345", "aKTitans", "inf_ammo_loop_infiSTAR", "Wookie_Pro_RE", "awrdw4355345sfs", "Wookie_Init_Menu", "asdr432r5edfsad", "fsfgdggdzgfd", "fdsgdr42424ZombieColor", "TTT5OptionNR", "adasdawer4w3r", "hthxhzhgcbcxvb", "sdfwesrfwesf233", "dsagfgbdfhgsd", "htrukilojhkukvh", "d4t365tearfsafgrg", "ddsfsdfv", "faze_funcs_inited", "godlol", "fetg5e4ytdrg", "Lystic_Init", "Lystic_Exec", "faze_getControl", "vehicleg0dv3_BushWookie", "dsfsgfsfsdfsdf", "yer652374rfd", "t0ggl3", "d45y6w45ytrdfragsrega", "morphm3", "sgdfgzgdzfrgfdg", "q25t3qttsdfaf", "fsdddInfectLOL", "lkjhgfuyhgfd", "cargod", "abcdefGEH", "Wep_Spawn_Shitt", "faze_hax_dbclick", "fzgrfg4536tq3tds", "dawerdsczcdsf", "gdzhzthtdhxthh6757", "W00kie_Pro_RE", "fdsgdr42424", "battleHIGH_vehpub", "sdsf45t3rsgfd", "hdtrhyztyh", "MenuInitLol", "few3t5364etsfg", "adadgvdthw54y64", "sfsefse", "eeeeeeewwwwwwwww", "wierdo", "efr4243234", "faze_initMenu", "adawedr3q4r3w2qr4", "xZombieBait", "eyghrdfyh", "W00kie_Init_Menu", "awdet3465taddd", "rainbow_var", "iluio9pilkgvuk", "awer234rrsdfcsd", "W_O_O_K_I_E_Pro_RE", "toggle_keyEH", "JME_M_E_N_U_initMenu", "dawr5wdfsf23", "sgstgr4stwe4t", "gffffffffffffffh", "LOKI_GUI_Key_Color", "rdgfdzgzrfgr", "gzgdghragfzdgvdz", "MPGHALLDAYEVRYDAY47LETSDOTHISBBYYAAAAAAA", "sdfxdcfs3", "infi_STAR_exec", "xtags_star_xx", "ChangingBullets_xx", "ljkluilufgdsgzgzdrf324", "hgjghjfrdfeewrferrt43", "byebyezombies", "Root_Main4", "adr4w5trsdef", "wadgrfgzrd", "igodokxtt", "unlimammo", "tw4etinitMenu", "plrshldblckls", "dasd324r245rdsfs", "Jme_Is_God", "Monky_funcs_inited", "fuckmegrandma", "qopfkqpofqk", "da124q3easds", "awdadr3q42", "awde3q4erasd", "ShadowyFaz3VehZ", "Veh_Spawn_Shitt", "wuat_fpsMonitor", "sfg4w3t5esfsdf", "asdw435r325efdsd", "Monky_hax_toggled", "asd34r253453453", "mehatingjews", "da342szvcxzcvx", "W_0_0_K_I_E_Pro_RE", "InfiniteAmmo", "debug_star_colorful", "fryt5tytfshyfkj", "sfewsrw", "W00kieMenu_hax_toggled", "AntiAntiAntiAntiHax", "thuytshujsr65uy", "adawdawe21", "ad44234efdzsf", "ffafsafafsfsgol", "shth654436tj", "gyjjgcjcj", "GodLolPenis", "vehiclegooov3ood_BushWookie", "htjhytu6waqe3q45", "y6sretysrt", "ANTI_ANTI_HAX", "antiantiantiantih4x", "riasgremory_G0d_Mode", "monkytp", "hax_toggled", "JJJJ_MMMM___EEEEEEE_INIT_MENU", "yiukfligzsgargfrae", "B0X_CANN0N_T0GGLE", "omgwtfbbq", "asdddddddddddad", "bowonky", "dontAddToTheArray", "adddaaaaaaaaa", "fesf4535teaf", "rainbowbitch", "ads2542345esfds", "n0clip", "saddaaaaaaaadd23", "fefq34tqtrafg", "f313131FukDaPolice1324e", "BigFuckinBullets", "lmzsjgnas"];
	};

	if (isNil "_cheatFlag" && _loopCount >= 24) then
	{
		// Diplay validator based on Tonic's SpyGlass
		{
			_rscName = _x select 0;
			_onLoadValid = _x select 1;
			_onUnloadValid = _x select 2;

			_onLoad = getText (configFile >> _rscName >> "onLoad");
			_onUnload = getText (configFile >> _rscName >> "onUnload");

			if (_onLoad != _onLoadValid || _onUnload != _onUnloadValid) exitWith
			{
				_cheatFlag = ["memory editing", _rscName];
			};
			sleep 0.01;
		}
		forEach
		[
			["RscDisplayAVTerminal", "[""onLoad"",_this,""RscDisplayAVTerminal"",'IGUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayAVTerminal"",'IGUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayConfigureAction", "[""onLoad"",_this,""RscDisplayConfigureAction"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayConfigureAction"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayConfigureControllers", "[""onLoad"",_this,""RscDisplayConfigureControllers"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayConfigureControllers"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayControlSchemes", "[""onLoad"",_this,""RscDisplayControlSchemes"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayControlSchemes"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayCustomizeController", "[""onLoad"",_this,""RscDisplayCustomizeController"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayCustomizeController"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayDebriefing", "[""onLoad"",_this,""RscDisplayDebriefing"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayDebriefing"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayDiary", "[""onLoad"",_this,""RscDiary"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDiary"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayGameOptions", "[""onLoad"",_this,""RscDisplayGameOptions"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayGameOptions"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayGetReady", "[""onLoad"",_this,""RscDiary"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDiary"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayInterrupt", "[""onLoad"",_this,""RscDisplayInterrupt"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayInterrupt"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayInventory", "[""onLoad"",_this,""RscDisplayInventory"",'IGUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayInventory"",'IGUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayJoystickSchemes", "[""onLoad"",_this,""RscDisplayJoystickSchemes"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayJoystickSchemes"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayLoading", "[""onLoad"",_this,""RscDisplayLoading"",'Loading'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayLoading"",'Loading'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayLoadMission", "[""onLoad"",_this,""RscDisplayLoading"",'Loading'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayLoading"",'Loading'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayMicSensitivityOptions", "[""onLoad"",_this,""RscDisplayMicSensitivityOptions"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayMicSensitivityOptions"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayOptions", "[""onLoad"",_this,""RscDisplayOptions"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayOptions"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayOptionsAudio", "[""onLoad"",_this,""RscDisplayOptionsAudio"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayOptionsAudio"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayOptionsLayout", "[""onLoad"",_this,""RscDisplayOptionsLayout"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayOptionsLayout"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayOptionsVideo", "[""onLoad"",_this,""RscDisplayOptionsVideo"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayOptionsVideo"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayStart", "[""onLoad"",_this,""RscDisplayLoading"",'Loading'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayLoading"",'Loading'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
			["RscDisplayVehicleMsgBox", "[""onLoad"",_this,""RscDisplayVehicleMsgBox"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""", "[""onUnload"",_this,""RscDisplayVehicleMsgBox"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""]
		];
	};

	if (isNil "_cheatFlag") then
	{
		// diag_log "ANTI-HACK 0.8.0: Recoil hack check started!";

		_currentRecoil = unitRecoilCoefficient player;
		_minRecoil = (["A3W_antiHackMinRecoil", 1.0] call getPublicVar) - 0.001;

		if (_currentRecoil < _minRecoil && _currentRecoil != -1) then
		{
			// diag_log "ANTI-HACK 0.8.0: Detected recoil hack!";

			_cheatFlag = ["recoil hack", str ceil (_currentRecoil * 100) + "% recoil"];
		};
	};

	if (!isNil "_cheatFlag") exitWith
	{
		//diag_log str [profileName, getPlayerUID player, _cheatFlag select 0, _cheatFlag select 1];

		[[profileName, getPlayerUID player, _cheatFlag select 0, _cheatFlag select 1, _flagChecksum], "A3W_fnc_flagHandler", false, false] call A3W_fnc_MP;

		waitUntil {time > 0.1};

		[getPlayerUID player, _flagChecksum] call A3W_fnc_clientFlagHandler;
	};

	sleep 5;
	_loopCount = _loopCount + 1;
};
