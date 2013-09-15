/*
	@file Version: 1.0
	@file Name: hud.hpp
	@file Author: [404] Deadbeat, [KoS] Bewilderbeest
	@file Created: 11/09/2012 04:23
	@file Args:
*/

#define hud_status_idc 3600
#define hud_vehicle_idc 3601
#define hud_activity_icon_idc 3602
#define hud_activity_textbox_idc 3603

class WastelandHud {
	idd = -1;
    fadeout=0;
    fadein=0;
	duration = 20;
	name= "WastelandHud";
	onLoad = "uiNamespace setVariable ['WastelandHud', _this select 0]";
	
	class controlsBackground {
		class WastelandHud_Vehicle:w_RscText
		{
			idc = hud_vehicle_idc;
			type = CT_STRUCTURED_TEXT;
			size = 0.040;
			x = safeZoneX + (safeZoneW * (1 - (0.42 / SafeZoneW)));
			y = safeZoneY + (safeZoneH * (1 - (0.33 / SafeZoneH)));
			w = 0.4; h = 0.65;
			colorText[] = {1,1,1,1};
			lineSpacing = 3;
			colorBackground[] = {0,0,0,0};
			text = "";
			shadow = 2;
			class Attributes {
				align = "right";
			};
		};
		class WastelandHud_Status:w_RscText
		{
			idc = hud_status_idc;
			type = CT_STRUCTURED_TEXT;
			size = 0.040;
			x = safeZoneX + (safeZoneW * (1 - (0.16 / SafeZoneW)));
			y = safeZoneY + (safeZoneH * (1 - (0.22 / SafeZoneH)));
			w = 0.14; h = 0.22;
			colorText[] = {1,1,1,1};
			lineSpacing = 3;
			colorBackground[] = {0,0,0,0};
			text = "";
			shadow = 2;
			class Attributes {
				align = "right";
			};
		};
		class WastelandHud_ActivityIcon:w_RscText
		{
			idc = hud_activity_icon_idc;
			type = CT_STRUCTURED_TEXT;
			size = 0.03;
			x = safeZoneX + (safeZoneW * 0.007);
			y = safeZoneY + (safeZoneH * 0.011);
			w = (0.06 * 3/4) * safezoneW;
			h = 0.05 * safezoneH;
			colorText[] = {1,1,1,1};
			lineSpacing = 2;
			colorBackground[] = {0,0,0,0};
			text = "";
			shadow = 2;
			class Attributes {
				align = "center";
				valign = "middle";
			};
		};
		class WastelandHud_ActivityTextBox:w_RscText
		{
			idc = hud_activity_textbox_idc;
			type = CT_STRUCTURED_TEXT;
			size = 0.03;
			x = safeZoneX + (safeZoneW * 0.055);
			y = safeZoneY + (safeZoneH * 0.011);
			w = 0.18 * safezoneW;
			h = 0.05 * safezoneH;
			colorText[] = {1,1,1,1};
			lineSpacing = 2;
			colorBackground[] = {0,0,0,0};
			text = "";
			shadow = 1;
			class Attributes {
				align = "left";
				valign = "middle";
			};
		};
	};
};
