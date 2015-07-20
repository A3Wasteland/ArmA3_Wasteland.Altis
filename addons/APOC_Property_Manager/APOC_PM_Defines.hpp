class APOC_PM_Box
{
    type = CT_STATIC;
    idc = -1;
    style = ST_CENTER;
    shadow = 2;
    colorBackground[] = { 0.7,0.0,0.0, 0.5};
    colorText[] = {1,1,1,0.9};
    font = "PuristaLight";
    sizeEx = 0.03;
    text = "";
};

class APOC_PM_RscText
{
	access = 0;
	type = 0;
	idc = -1;
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {1, 1, 1, 1};
	text = "";
	fixedWidth = 0;
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = ST_MULTI;
	shadow = 1;
	colorShadow[] = {0, 0, 0, 0.5};
	font = "PuristaMedium";
	SizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	linespacing = 1;
};

class APOC_PM_RscButton
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {1, 1, 1, 1};
	colorDisabled[] = {0.4, 0.4, 0.4, 1};
	colorBackground[] =
	{
		"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.5])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.5])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",
		0.7
	};
	colorBackgroundDisabled[] = {0.95, 0.95, 0.95, 1};
	colorBackgroundActive[] =
	{
		"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.5])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.5])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",
		1
	};
	colorFocused[] =
	{
		"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.5])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.5])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",
		1
	};
	colorShadow[] = {0, 0, 0, 1};
	colorBorder[] = {0, 0, 0, 1};
	soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter", 0.09, 1};
	soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush", 0.09, 1};
	soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick", 0.09, 1};
	soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape", 0.09, 1};
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 2;
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	borderSize = 0;
};