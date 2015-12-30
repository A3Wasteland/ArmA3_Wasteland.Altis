// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: UniformPainter_optionSelect.sqf
//	@file Author: LouD / Cael817 for original script
//	@file Description: Paint script

#define Paint_Menu_option 17001
disableSerialization;

private ["_panelType","_displayPaint","_Paint_select","_money"];
_uid = getPlayerUID player;
if (!isNil "_uid") then
{
	_panelType = _this select 0;

	_displayPaint = uiNamespace getVariable ["Paint_Menu", displayNull];

	switch (true) do
	{
		case (!isNull _displayPaint): //Paint panel
		{
			_Paint_select = _displayPaint displayCtrl Paint_Menu_option;

			switch (lbCurSel _Paint_select) do
			{
				case 0:
				{
					closeDialog 0;					
					[0] execVM "addons\Painter\UniformPainter.sqf";
				};
				case 1:
				{
					closeDialog 0;					
					[1] execVM "addons\Painter\UniformPainter.sqf";
				};
				case 2:
				{
					closeDialog 0;					
					[2] execVM "addons\Painter\UniformPainter.sqf";
				};
				case 3:
				{
					closeDialog 0;					
					[3] execVM "addons\Painter\UniformPainter.sqf";
				};
				case 4:
				{
					closeDialog 0;					
					[4] execVM "addons\Painter\UniformPainter.sqf";
				};
				case 5:
				{
					closeDialog 0;					
					[5] execVM "addons\Painter\UniformPainter.sqf";
				};
				case 6:
				{
					closeDialog 0;					
					[6] execVM "addons\Painter\UniformPainter.sqf";
				};					
				case 7:
				{
					closeDialog 0;					
					[7] execVM "addons\Painter\UniformPainter.sqf";
				};
				case 8:
				{
					closeDialog 0;					
					[8] execVM "addons\Painter\UniformPainter.sqf";
				};
				case 9:
				{
					closeDialog 0;					
					[9] execVM "addons\Painter\UniformPainter.sqf";
				};	
				case 10:
				{
					closeDialog 0;					
					[10] execVM "addons\Painter\UniformPainter.sqf";
				};	
				case 11:
				{
					closeDialog 0;					
					[11] execVM "addons\Painter\UniformPainter.sqf";
				};	
				case 12:
				{
					closeDialog 0;					
					[12] execVM "addons\Painter\UniformPainter.sqf";
				};	
				case 13:
				{
					closeDialog 0;					
					[13] execVM "addons\Painter\UniformPainter.sqf";
				};
				case 14:
				{
					closeDialog 0;					
					[14] execVM "addons\Painter\UniformPainter.sqf";
				};	
				case 15:
				{
					closeDialog 0;					
					[15] execVM "addons\Painter\UniformPainter.sqf";
				};	
				case 16:
				{
					closeDialog 0;					
					[16] execVM "addons\Painter\UniformPainter.sqf";
				};	
			};
		};
	};
};
