// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: payload.sqf
//	@file Author: AgentRev, Tonic, AWA (OpenDayZ.net)
//	@file Created: 01/06/2013 21:31

if (isDedicated) exitWith {};

private ["_cheatFlag", "_cfgPatches", "_patchClass", "_ctrlCfg", "_minRecoil", "_currentRecoil", "_loopCount"];

waitUntil {!isNull player};

if (!hasInterface && typeOf player == "HeadlessClient_F") exitWith {};

// diag_log "ANTI-HACK starting...";

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
				[157, "RscDisplayPhysX3Debug"],
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
};

// diag_log "ANTI-HACK: Starting loop!";

_loopCount = 24; // _loopCount >= 24 means every 2 minutes

while { true } do
{
	waitUntil {time > 0};

	if (isNil "_cheatFlag" && _loopCount >= 24) then
	{
		_loopCount = 0;

		{
			if (!isNil _x) exitWith
			{
				// diag_log "ANTI-HACK: Found a hack variable!";

				_cheatFlag = ["hack variable", _x];
			};
			sleep 0.01;
		} forEach ["DurkSintax_Pro_RE", "iBeFlying", "dayz_godmode", "Main_Fury_Menu_", "Hack_Pos_Orig", "REdasfsfwef", "XXMMWW_keybinds", "FUNMENUON", "JJMMEE_INIT_MENU", "activeITEMlistanzahl", "Detected_Remote_Execution", "g0dmode", "Pro_RE", "xyzaa", "GOLDENS_GLOBAL_SHIT_YEAH", "HaxSmokeOn", "Lysto_Lyst", "pathtoscrdir", "ewrfdfcsf", "Ug8YtyGyvguGF", "LYSTIC_MENU_LOADED", "qofjqpofq", "c0lorthem", "shnmenu", "letmeknow", "DAYZ_CA1_Lollipops", "TONIC_HAS_A_GAPER_NUKE_2", "fazelist", "faze_fill", "PL4YER_CANN0N_T0GGLE", "aKTitans", "Fury_Are_G0ds", "LY_Exec", "inf_ammo_loop_infiSTAR", "Wookie_Pro_RE", "nook3_vars", "Wookie_Init_Menu", "TTT5OptionNR", "Team_Fury_Reck_Prebs", "faze_funcs_inited", "biggies_pro_re", "godlol", "Lystic_Init", "FAG_NEON", "Lystic_Exec", "faze_getControl", "vehicleg0dv3_BushWookie", "t0ggl3", "morphm3", "fsdddInfectLOL", "cargod", "abcdefGEH", "Wep_Spawn_Shitt", "Fury_Nuke", "faze_hax_dbclick", "LY_Init", "W00kie_Pro_RE", "fdsgdr42424", "battleHIGH_vehpub", "WHY_ARE_THERE_SO_MANY_FISH_IN_THE_BIG_BLUE_OCEAN", "MenuInitLol", "wierdo", "mdh_ash", "faze_initMenu", "fuckfestv2", "xZombieBait", "W00kie_Init_Menu", "rainbow_var", "biggies_menu_open", "HAAJASDOKAD_mein", "CharlieSheenkeybinds", "POOP_Main", "colt_lmaoooo", "W_O_O_K_I_E_Pro_RE", "toggle_keyEH", "JME_M_E_N_U_initMenu", "dawr5wdfsf23", "LOKI_GUI_Key_Color", "MPGHALLDAYEVRYDAY47LETSDOTHISBBYYAAAAAAA", "infi_STAR_exec", "M_R_IRecommend", "xtags_star_xx", "ChangingBullets_xx", "byebyezombies", "Root_Main4", "igodokxtt", "unlimammo", "tw4etinitMenu", "oh_nmoe_pls", "plrshldblckls", "Jme_Is_God", "Monky_funcs_inited", "fuckmegrandma", "qopfkqpofqk", "ShadowyFaz3VehZ", "Veh_Spawn_Shitt", "wuat_fpsMonitor", "Monky_hax_toggled", "mehatingjews", "InfiniteAmmo", "PersonWhomMadeThisCorroded_Init", "nuke_vars", "debug_star_colorful", "neo_fnc_throw", "W00kieMenu_hax_toggled", "AntiAntiAntiAntiHax", "XMVJEIUI133794_mein", "aim", "GodLolPenis", "vehiclegooov3ood_BushWookie", "biggies_scroll_open", "ANTI_ANTI_HAX", "antiantiantiantih4x", "riasgremory_G0d_Mode", "BigFuckinBullets_0202020DDDEEDED", "monkytp", "hax_toggled", "JJJJ_MMMM___EEEEEEE_INIT_MENU", "B0X_CANN0N_T0GGLE", "omgwtfbbq", "bowonky", "ExtasyMenu_Binds", "PRO_SKILLZ_2015_ALLDAY_Noobs", "dontAddToTheArray", "rainbowbitch", "n0clip", "GLASS911_Init", "fuckfest", "BigFuckinBullets", "lmzsjgnas"];
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
			["RscDisplayMainMap", "[""onLoad"",_this,""RscDiary"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf""","[""onUnload"",_this,""RscDiary"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"""],
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
