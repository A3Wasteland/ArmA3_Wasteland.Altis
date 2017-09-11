// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: killFeed_gui.hpp
//	@file Author: AgentRev

#include "killFeed_defines.hpp"

class A3W_killFeed : IGUIBack
{
	idd = A3W_killFeed_IDD;
	name = "A3W_killFeed";
	fadeIn = 0;
	fadeOut = 0;
	duration = 1e11;
	movingEnabled = false;
	onLoad = "uiNamespace setVariable ['A3W_killFeed', _this select 0]";
	onUnload = "uiNamespace setVariable ['A3W_killFeed', nil]";
	controlsBackground[] = {};

	class Controls
	{
		class FeedText : w_RscStructuredText
		{
			idc = A3W_killFeed_feedText_IDC;
			text = "";
			size = "0.8 * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"; // 0.032
			shadow = 1;

			class Attributes
			{
				font = "RobotoCondensed";
				color = "#FFFFFF";
				align = "center";
			};

			// overriden by fn_killFeedRefresh.sqf
			x = safeZoneX;
			y = safeZoneY;
			w = safeZoneW;
			h = safeZoneH;
		};
	};
};
