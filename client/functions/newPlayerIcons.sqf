//	@file Version: 0.9
//	@file Name: playericons.sqf
//	@file Author: [404] Pulse
//	@file Created: 01/01/2012
//	@file Description: Creating and displaying the icons above team or group.

#define icons_idc 46300

#define ICON_fadeDistance 750
#define ICON_limitDistance 1250

FZF_ICHud_Zoom = 0.05;
FZF_ICHud_Scale = 1.0;
FZF_ICHud_Centre = [150, 150];
FZF_ICHud_Customised = false;
FZF_ICHud_Layer = 609;

FZF_IC_Icons = 
{
	private ["_units", "_groupOnly", "_index", "_HUD_ICON"];
	
	if (playerSide == INDEPENDENT) then
	{
		_units = units player;
		_groupOnly = true;
	}
	else
	{
		_units = allUnits;
		_groupOnly = false;
	};
	
	_index = 0;
	
	{
		if (_x != player && {side _x == playerSide || {_groupOnly}}) then
		{
			private ["_unit", "_pos", "_distance", "_pIcon"];
			
			_unit = _x;
			_pos = getPos _unit;
			_distance = _pos distance player;
			
			if (_distance < ICON_limitDistance) then // rules out the player and players too far away.
			{
				_pos set [2, (_pos select 2) + 1.5];
				_screen = worldToScreen _pos;			
				
				if (count _screen > 1) then // Dont calculate if they are not on the screen
				{
					_sx = _screen select 0;
					_sy = _screen select 1;
					
					switch (if (alive _unit) then { side _unit } else { playerSide }) do
					{
						case BLUFOR:		{ _pIcon = _bluIcon };
						case OPFOR:			{ _pIcon = _opfIcon };
						case INDEPENDENT:	{ _pIcon = _indIcon };						
					};
					
					_HUD_ICON = _FZF_IC_Hud_Disp displayCtrl (icons_idc + _index);
					_HUD_ICON ctrlSetStructuredText _pIcon;
					_HUD_ICON ctrlSetPosition [_sx, _sy, 0.4, 0.65];
					_HUD_ICON ctrlSetScale (0.35 - ((_distance / ICON_limitDistance) * 0.25));
					_HUD_ICON ctrlSetFade (0 max (((1 / (ICON_limitDistance - ICON_fadeDistance)) * _distance) - (ICON_limitDistance / ICON_fadeDistance)));
					_HUD_ICON ctrlCommit 0;
					_HUD_ICON ctrlShow true;
				}
				else
				{
					_HUD_ICON = _FZF_IC_Hud_Disp displayCtrl (icons_idc + _index);
					_HUD_ICON ctrlShow false;
				};
			}
			else
			{
				_HUD_ICON = _FZF_IC_Hud_Disp displayCtrl (icons_idc + _index);
				_HUD_ICON ctrlShow false;
			};
		
			_index = _index + 1;
		};
	} forEach _units;
	
	if (!isNil "FZF_IC_Hud_pIcons_count") then
	{
		for "_oldIcon" from _index to (FZF_IC_Hud_pIcons_count - 1) do
		{
			_HUD_ICON = _FZF_IC_Hud_Disp displayCtrl (icons_idc + _oldIcon);
			_HUD_ICON ctrlShow false;
		};
	};
	
	FZF_IC_Hud_pIcons_count = _index;
};

FZF_IC_Hud_Debug =
{
	private ["_icon_text","_plIcon"];	
	_plIcon = "client\icons\igui_side_blufor_ca.paa";
	_icon_text = format ["<t align='left'><img image='%1'/>%2<br/></t>", _plIcon ,name cursorTarget];
//	_icon_text = "<t align='left'>Test</t>";
//	_icon_text = format["<t size='1.5' shadow='2' color='#689D22'>%1</t>",name cursorTarget];
	_screen = worldToScreen (getpos player);
	if((count _screen) > 1) then {
		_sx = _screen select 0;
		_sy = _screen select 1;
		
		HUD_TEXT ctrlSetPosition [_sx, _sy, 0.4, 0.65];
	//	HUD_TEXT ctrlSetPosition [0.5, 0.5, 0.4, 0.65];
		HUD_TEXT ctrlSetStructuredText parseText _icon_text;
		player sideChat _icon_text;
		HUD_TEXT ctrlCommit 0;
		
	};
};

#define SHOW_HUD (alive player && {!visibleMap} && {showPlayerIcons} && {count allUnits > 1} && {isNil "BIS_DEBUG_CAM"})

FZF_IC_INIT =
{	
	if (!isNil "FZF_IC_Handle") then
	{
		terminate FZF_IC_Handle;
	};

	FZF_IC_Handle = [] spawn
	{
		disableSerialization;
		private ["_bluIcon", "_opfIcon", "_indIcon", "_FZF_IC_Hud_Disp"];
		
		_bluIcon = parseText "<t align='left'><img image='client\icons\igui_side_blufor_ca.paa'/></t>";
		_opfIcon = parseText "<t align='left'><img image='client\icons\igui_side_opfor_ca.paa'/></t>";
		_indIcon = parseText "<t align='left'><img image='client\icons\igui_side_indep_ca.paa'/></t>";
		
		sleep 1;
		while {true} do
		{
			waitUntil {sleep 1; SHOW_HUD};
			FZF_ICHud_Layer cutRsc ["FZF_ICHud_Rsc", "PLAIN"];
			_FZF_IC_Hud_Disp = uiNamespace getVariable "FZF_IC_Hud_Disp";
			
			while {SHOW_HUD} do
			{
				call FZF_IC_Icons;
				sleep 0.01;
			};
			
			FZF_ICHud_Layer cutText ["", "PLAIN"];
		};
	};	
};

FZF_ICHud_Load =
{
	with uiNamespace do { FZF_IC_Hud_Disp = _this select 0 };
};
