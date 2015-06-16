// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: payload.sqf
//	@file Author: AgentRev, Tonic, AWA (OpenDayZ.net)
//	@file Created: 01/06/2013 21:31

if (isDedicated) exitWith {};

private ["_flagChecksum", "_rscParams", "_cheatFlag", "_cfgPatches", "_escCheck", "_patchClass", "_patchName", "_ctrlCfg", "_memAnomaly", "_minRecoil", "_currentRecoil", "_loopCount"];
_flagChecksum = _this select 0;
_rscParams = _this select 1;

waitUntil {!isNull player};

if (!hasInterface && typeOf player == "HeadlessClient_F") exitWith {};

// diag_log "ANTI-HACK starting...";

_cfgPatches = configFile >> "CfgPatches";
_escCheck = true;

for "_i" from 0 to (count _cfgPatches - 1) do
{
	_patchClass = _cfgPatches select _i;

	if (isClass _patchClass) then
	{
		_patchName = toLower configName _patchClass;

		if (_patchName in ["devcon","loki_lost_key"]) exitWith
		{
			_cheatFlag = ["hacking addon", configName _patchClass];
		};

		if (_patchName in
		[
			"rhs_main", // RHS - Game Options
			"mcc_sandbox", // MCC keys
			"agm_core", // AGM Options
			"ace_optionsmenu" // ACE Options
		])
		then { _escCheck = false };
	};
};

if (isNil "_cheatFlag" && _escCheck) then
{
	{
		for "_i" from 0 to (count _x - 1) do
		{
			_ctrlCfg = _x select _i;
			if (getText (_ctrlCfg >> "action") != "" || getText (_ctrlCfg >> "onButtonClick") != "") exitWith
			{
				_cheatFlag = ["hack menu", format ["foreign Esc menu button '%1'", (getText (_ctrlCfg >> "text")) select [0, 64]]];
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
		disableSerialization;
		scopeName "sendFlag";
		private "_cheatFlag";

		_flagChecksum = _this;

		while {true} do
		{
			{
				if (!isNull findDisplay (_x select 0)) then
				{
					_cheatFlag = _x select 1;
					breakTo "sendFlag";
				};
			}
			forEach
			[
				[19, "RscDisplayIPAddress"],
				[30, "RscDisplayTemplateLoad (Gladtwoown)"],
				[32, "RscDisplayIntel"],
				[64, "RscDisplayPassword (ShadowyFaze)"],
				[69, "RscDisplayPort"],
				[71, "RscDisplayFilter (Gladtwoown)"],
				[125, "RscDisplayEditDiaryRecord (Gladtwoown)"],
				[132, "RscDisplayHostSettings"],
				[165, "RscDisplayPublishMission"],
				[166, "RscDisplayPublishMissionSelectTags (Gladtwoown)"],
				[167, "RscDisplayFileSelect (Lystic)"],
				[2727, "RscDisplayLocWeaponInfo"],
				[3030, "RscConfigEditor_Main (ShadowyFaze)"]
			];

			_isAdmin = serverCommandAvailable "#kick";

			if (!isNull (findDisplay 49 displayCtrl 0)) exitWith { _cheatFlag = "RscDisplayInterruptEditorPreview" };
			if (!isNull findDisplay 17 && !isServer && !_isAdmin) exitWith { _cheatFlag = "RscDisplayRemoteMissions (Wookie)" };
			if (!isNull findDisplay 316000 && !_isAdmin) exitWith { _cheatFlag = "Debug console" }; // RscDisplayDebugPublic
			if (!isNull (uiNamespace getVariable ["RscDisplayArsenal", displayNull]) && !_isAdmin) exitWith { _cheatFlag = "Virtual Arsenal" };
			if (!isNull findDisplay 157 && isNull (uiNamespace getVariable ["RscDisplayModLauncher", displayNull])) exitWith { _cheatFlag = "RscDisplayPhysX3Debug" };

			_display = findDisplay 54;
			if (!isNull _display) then
			{
				sleep 0.5;
				{
					if (_x && !isNull _display) then
					{
						_cheatFlag = "RscDisplayInsertMarker (JME)";
						breakTo "sendFlag";
					};
				}
				forEach
				[
					(toLower ctrlText (_display displayCtrl 1001) != toLower localize "STR_A3_RscDisplayInsertMarker_Title"),
					{if (buttonAction (_display displayCtrl _x) != "") exitWith {true}; false} forEach [1,2]
				];
			};

			_display = findDisplay 148;
			if (!isNull _display) then
			{
				sleep 0.5;
				{
					(_display displayCtrl _x) ctrlRemoveAllEventHandlers "LBDblClick";
					(_display displayCtrl _x) ctrlRemoveAllEventHandlers "LBSelChanged";
				} forEach [103, 104];

				{
					if (_x && !isNull _display) then
					{
						_cheatFlag = "RscDisplayConfigureControllers (JME)";
						breakTo "sendFlag";
					};
				}
				forEach
				[
					(toLower ctrlText (_display displayCtrl 1001) != toLower localize "str_opt_customizable_controllers"),
					(toLower ctrlText (_display displayCtrl 1002) != toLower localize "str_opt_controllers_scheme")
				];
			};

			_display = findDisplay 131;
			if (!isNull _display) then
			{
				sleep 0.5;
				(_display displayCtrl 102) ctrlRemoveAllEventHandlers "LBDblClick";
				(_display displayCtrl 102) ctrlRemoveAllEventHandlers "LBSelChanged";

				{
					if (_x && !isNull _display) then
					{
						_cheatFlag = "RscDisplayConfigureAction";
						breakTo "sendFlag";
					};
				}
				forEach
				[
					(toLower ctrlText (_display displayCtrl 1000) != toLower localize "STR_A3_RscDisplayConfigureAction_Title"),
					{if (buttonAction (_display displayCtrl _x) != "") exitWith {true}; false} forEach [1,104,105,106,107,108,109]
				];
			};

			_display = findDisplay 163;
			if (!isNull _display) then
			{
				sleep 0.5;
				(_display displayCtrl 101) ctrlRemoveAllEventHandlers "LBDblClick";
				(_display displayCtrl 101) ctrlRemoveAllEventHandlers "LBSelChanged";

				{
					if (_x && !isNull _display) then
					{
						_cheatFlag = "RscDisplayControlSchemes (JME)";
						breakTo "sendFlag";
					};
				}
				forEach
				[
					(toLower ctrlText (_display displayCtrl 1000) != toLower localize "STR_DISP_OPTIONS_SCHEME"),
					{if (buttonAction (_display displayCtrl _x) != "") exitWith {true}; false} forEach [1,2]
				];
			};

			sleep 1;
		};

		[[profileName, getPlayerUID player, "hack menu", _cheatFlag, _flagChecksum], "A3W_fnc_flagHandler", false] call A3W_fnc_MP;

		waitUntil {alive player};

		[getPlayerUID player, _flagChecksum] call A3W_fnc_clientFlagHandler;
	};

	// Decode _rscParams
	{
		_x set [1, toString (_x select 1)];
		_x set [2, toString (_x select 2)];
	} forEach _rscParams;
};

// diag_log "ANTI-HACK: Starting loop!";

_loopCount = 12; // _loopCount >= 12 means every minute

while { true } do
{
	waitUntil {time > 0};

	if (_loopCount >= 12) then
	{
		if (isNil "_cheatFlag") then
		{
			{
				if (!isNil _x) exitWith
				{
					// diag_log "ANTI-HACK: Found a hack variable!";

					_cheatFlag = ["hack variable", _x];
				};
				sleep 0.01;
			} forEach ["DurkSintax_Pro_RE", "iBeFlying", "dayz_godmode", "var_curCheatMenu", "Main_Fury_Menu_", "Hack_Pos_Orig", "REdasfsfwef", "ly_re_onetime", "XXMMWW_keybinds", "FUNMENUON", "JJMMEE_INIT_MENU", "activeITEMlistanzahl", "Detected_Remote_Execution", "g0dmode", "Pro_RE", "FireTide_Menu", "fn_runCheat", "xyzaa", "GOLDENS_GLOBAL_SHIT_YEAH", "HaxSmokeOn", "Lysto_Lyst", "pathtoscrdir", "ewrfdfcsf", "Ug8YtyGyvguGF", "LYSTIC_MENU_LOADED", "qofjqpofq", "c0lorthem", "shnmenu", "letmeknow", "DAYZ_CA1_Lollipops", "TONIC_HAS_A_GAPER_NUKE_2", "fazelist", "S_NyanCat_Toggle", "faze_fill", "PL4YER_CANN0N_T0GGLE", "aKTitans", "Fury_Are_G0ds", "LY_Exec", "inf_ammo_loop_infiSTAR", "youoiuoiasdfsd8433fadsfasd_Koko__hkeys", "Wookie_Pro_RE", "nook3_vars", "Wookie_Init_Menu", "TTT5OptionNR", "Team_Fury_Reck_Prebs", "faze_funcs_inited", "mein1", "biggies_pro_re", "godlol", "Lystic_Init", "FAG_NEON", "Lystic_Exec", "faze_getControl", "Fanatic_Menu", "vehicleg0dv3_BushWookie", "earthBob", "t0ggl3", "morphm3", "fsdddInfectLOL", "cargod", "Init_Menu_Fury", "abcdefGEH", "RandyRandRanderson", "Wep_Spawn_Shitt", "Fury_Nuke", "faze_hax_dbclick", "LY_Init", "W00kie_Pro_RE", "LY_fly", "fdsgdr42424", "battleHIGH_vehpub", "WHY_ARE_THERE_SO_MANY_FISH_IN_THE_BIG_BLUE_OCEAN", "MenuInitLol", "wierdo", "mdh_ash", "faze_initMenu", "SG_Turtz_Are_H000t", "fuckfestv2", "UuuNIX_M_I_S_S_I_L_E_Z", "xZombieBait", "W00kie_Init_Menu", "rainbow_var", "biggies_menu_open", "HAAJASDOKAD_mein", "CharlieSheenkeybinds", "POOP_Main", "colt_lmaoooo", "W_O_O_K_I_E_Pro_RE", "toggle_keyEH", "JME_M_E_N_U_initMenu", "dawr5wdfsf23", "FURY_IS_SEXC", "LOKI_GUI_Key_Color", "MPGHALLDAYEVRYDAY47LETSDOTHISBBYYAAAAAAA", "infi_STAR_exec", "M_R_IRecommend", "xtags_star_xx", "ChangingBullets_xx", "byebyezombies", "Root_Main4", "igodokxtt", "unlimammo", "tw4etinitMenu", "TORNADO_NOT_MOVE_NIGGA", "HydroxusRandomVarSwag2222", "oh_nmoe_pls", "Team_OMFG_WE_ARE_SEXC", "plrshldblckls", "Jme_Is_God", "Monky_funcs_inited", "SOMEONE_dsfnsjf", "fuckmegrandma", "qopfkqpofqk", "ShadowyFaz3VehZ", "Veh_Spawn_Shitt", "backtomenu", "wuat_fpsMonitor", "Monky_hax_toggled", "mehatingjews", "InfiniteAmmo", "PersonWhomMadeThisCorroded_Init", "nuke_vars", "debug_star_colorful", "SOMEONE_DurkSintax_Pro_RE", "neo_fnc_throw", "W00kieMenu_hax_toggled", "AntiAntiAntiAntiHax", "Dummy_Menu", "XMVJEIUI133794_mein", "aim", "GodLolPenis", "MainMenubyThirtySix", "vehiclegooov3ood_BushWookie", "biggies_scroll_open", "ANTI_ANTI_HAX", "Fire_ZeusMode", "antiantiantiantih4x", "riasgremory_G0d_Mode", "BigFuckinBullets_0202020DDDEEDED", "monkytp", "hax_toggled", "SOMEONE_Sweg_all_day", "JJJJ_MMMM___EEEEEEE_INIT_MENU", "B0X_CANN0N_T0GGLE", "omgwtfbbq", "bowonky", "ExtasyMenu_Binds", "PRO_SKILLZ_2015_ALLDAY_Noobs", "dontAddToTheArray", "rainbowbitch", "n0clip", "GLASS911_Init", "fuckfest", "BigFuckinBullets", "lmzsjgnas"];
		};

		if (isNil "_cheatFlag" && isNil "_memAnomaly") then
		{
			// Diplay validator based on Tonic's SpyGlass
			{
				_rscName = _x select 0;
				_onLoadValid = _x select 1;
				_onUnloadValid = _x select 2;

				_onLoad = getText (configFile >> _rscName >> "onLoad");
				_onUnload = getText (configFile >> _rscName >> "onUnload");

				{
					if (_x select 1 != _x select 2) exitWith
					{
						[[[toArray getPlayerUID player, _rscName, _x], _flagChecksum], "A3W_fnc_logMemAnomaly", false, false] call A3W_fnc_MP;
						_memAnomaly = true;
					};
				}
				forEach
				[
					["onLoad", _onLoad, _onLoadValid],
					["onUnload", _onUnload, _onUnloadValid]
				];

				if (!isNil "_memAnomaly") exitWith {};

				sleep 0.01;
			} forEach _rscParams;
		};

		_loopCount = 0;
	};

	if (isNil "_cheatFlag") then
	{
		// diag_log "ANTI-HACK: Recoil hack check started!";

		_currentRecoil = unitRecoilCoefficient player;
		_minRecoil = ((["A3W_antiHackMinRecoil", 1.0] call getPublicVar) max 0.02) - 0.001;

		if (_currentRecoil < _minRecoil && _currentRecoil != -1) then
		{
			// diag_log "ANTI-HACK: Detected recoil hack!";

			_cheatFlag = ["recoil hack", str ceil (_currentRecoil * 100) + "% recoil"];
		};
	};

	if (!isNil "_cheatFlag") exitWith
	{
		//diag_log str [profileName, getPlayerUID player, _cheatFlag select 0, _cheatFlag select 1];

		[[profileName, getPlayerUID player, _cheatFlag select 0, _cheatFlag select 1, _flagChecksum], "A3W_fnc_flagHandler", false, false] call A3W_fnc_MP;

		waitUntil {alive player};

		[getPlayerUID player, _flagChecksum] call A3W_fnc_clientFlagHandler;
	};

	sleep 5;
	_loopCount = _loopCount + 1;
};
