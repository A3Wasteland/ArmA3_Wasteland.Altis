//	@file Name: RscTitles.hpp
//	@file Author: xx-LSD-xx, AgentRev

class lsd_Rsc_nvHint
{
	idd = -1;
	onLoad = "uiNamespace setVariable ['lsd_Rsc_nvHint', _this select 0]";
	movingEnable = 0;
	fadeIn = 0;
	fadeOut = 0.500000;
	duration = 1;

	class Controls
	{
		class lsd_Rsc_nvHint_Label
		{
			idc = -1;
			type = 0;
			style = 2;
			x = 0;
			y = "(safeZoneH * 0.750) + safeZoneY + 0.005";
			w = 1;
			h = 0.033000;
			colorBackground[] = {0, 0, 0, 0};
			colorText[] = {1, 1, 1, 1};
			font = "TahomaB";
			sizeEx = 0.024000;
			text = "NV Intensity:";
			shadow = 2;
		};

		class lsd_Rsc_nvHint_Text
		{
			idc = 1;
			type = 13;
			style = 2;
			x = 0;
			y = "(safeZoneH * 0.750) + safeZoneY + 0.033";
			w = 1;
			h = 0.040000;
			colorBackground[] = {0, 0, 0, 0};
			colorText[] = {1, 1, 1, 1};
			font = "PuristaMedium";
			size = 0.039210;
			text = "";
			shadow = 2;
			lineSpacing = 1;

			class Attributes {
				align = "center";
			};
		};
	};
};
