	class balca_debug_control_group
	{
		idc = -1;
		type = 15;
		style = 0;
		class VScrollbar
		{
			color[] = {1, 1, 1, 1};
			width = 0.021;
			autoScrollSpeed = -1;
			autoScrollDelay = 5;
			autoScrollRewind = 0;
		};

		class HScrollbar
		{
			color[] = {1, 1, 1, 1};
			height = 0.028;
		};

		class ScrollBar
		{
			color[] = {1,1,1,0.6};
			colorActive[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.3};
			thumb = "#(argb,8,8,3)color(1,1,1,1)";
			arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
			arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
			border = "#(argb,8,8,3)color(1,1,1,1)";
		};
		x = 0;
		w = 1;
		y = 0;
		h = 1;
	};

	class balca_debug_combo {
		idc = -1;
		type = 4;
		style = 0;

		x = 0;
		y = 0;
		w = 0.12;
		h = str_height;

		font = "PuristaBold";
		sizeEx = 0.03;

		rowHeight = 0.1;
		wholeHeight = 0.4;

		class ComboScrollBar
		{
			color[] = {1,1,1,0.6};
			colorActive[] = {1,1,1,1};
			colorDisabled[] = {1,1,1,0.3};
			thumb = "#(argb,8,8,3)color(1,1,1,1)";
			arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
			arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
			border = "#(argb,8,8,3)color(1,1,1,1)";
		};

		colorSelect[] = {1, 1, 1, 1};
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0.543, 0.5742, 0.4102, 0.9};
		colorSelectBackground[] = {0.40, 0.43, 0.28, 0.9};
		colorScrollbar[] = {0.2, 0.2, 0.2, 1};

		soundSelect[] = {"", 0.1, 1};
		soundExpand[] = {"", 0.1, 1};
		soundCollapse[] = {"", 0.1, 1};
		maxHistoryDelay = 1;

		arrowEmpty = "";
		arrowFull = "";
		color[] = {0.1, 0.1, 0.1, 1};
		colorActive[] = {0,0,0,1};
		colorDisabled[] = {0,0,0,0.3};
	};

	class balca_debug_text
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_LEFT;
		x = 0.0; w = 0.3;
		y = 0.0; h = 0.03;
		sizeEx = 0.023;
		colorBackground[] = {0.5, 0.5, 0.5, 0};
		colorText[] = {0.85, 0.85, 0.85, 1};
		font = "PuristaBold";
		text = "";
	};

	class balca_debug_edit
	{
		type = CT_EDIT;
		style = ST_LEFT+ST_MULTI;
		idc = -1;
		font = "PuristaMedium";
		sizeEx = 0.026;
		htmlControl = true;
		lineSpacing = 0.004;
		x = 0.0; w = 0.3;
		y = 0.0; h = 0.06;
		colorText[] = {0.85, 0.85, 0.85, 1};
		colorSelection[] = {1, 1, 1, 1};
		colorDisabled[] = {0,0,0,0.3};
		autocomplete = "scripting";
		//text = "";
	};

	class balca_debug_image
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE+ST_KEEP_ASPECT_RATIO;
		x = 0.25; w = 0.1;
		y = 0.1; h = 0.1;
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "";
		font = "PuristaBold";
		sizeEx = 0.032;
	};

	class balca_debug_btn
	{
		idc = -1;
		type = 16;
		style = 0;

		text = "btn";
		action = "";

		x = 0;
		y = 0;

		w = 0.23;
		h = 0.06;

		size = 0.03921;
		sizeEx = 0.03921;

		color[] = {0.8314, 0.8784, 0.6275, 1.0};
		color2[] = {0.95, 0.95, 0.95, 1};
		colorFocused[] = {0.8314, 0.8784, 0.6275, 1.0};
		colorBackground[] = {1, 1, 1, 1};
		colorbackground2[] = {1, 1, 1, 0.4};
		colorBackgroundFocused[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.25};
		periodFocus = 1.2;
		periodOver = 0.8;

		class HitZone
		{
			left = 0.004;
			top = 0.004;
			right = 0.004;
			bottom = 0.004;
		};

		class ShortcutPos
		{
			left = 0.0145;
			top = 0.016;
			w = 0.03631;
			h = 0.01;
		};

		class TextPos
		{
			left = 0.03;
			top = 0.001;
			right = 0.005;
			bottom = 0.001;
		};

		textureNoShortcut = "";
		/*animTextureNormal = "client\ui\ui_button_normal_ca.paa";
		animTextureDisabled = "client\ui\ui_button_disabled_ca.paa";
		animTextureOver = "client\ui\ui_button_over_ca.paa";
		animTextureFocused = "client\ui\ui_button_focus_ca.paa";
		animTexturePressed = "client\ui\ui_button_down_ca.paa";
		animTextureDefault = "client\ui\ui_button_default_ca.paa";*/
		animTextureNormal = "client\ui\igui_button_normal_ca.paa";
		animTextureDisabled = "client\ui\igui_button_disabled_ca.paa";
		animTextureOver = "client\ui\igui_button_over_ca.paa";
		animTextureFocused = "client\ui\igui_button_focus_ca.paa";
		animTexturePressed = "client\ui\igui_button_down_ca.paa";
		animTextureDefault = "client\ui\igui_button_normal_ca.paa";
		animTextureNoShortcut = "client\ui\igui_button_normal_ca.paa";
		period = 0.4;
		font = "PuristaBold";

		soundEnter[] = {"\A3\ui_f\data\sound\RscButton\soundEnter", 0.09, 1};
		soundPush[] = {"\A3\ui_f\data\sound\RscButton\soundPush", 0.09, 1};
		soundClick[] = {"\A3\ui_f\data\sound\RscButton\soundClick", 0.07, 1};
		soundEscape[] = {"\A3\ui_f\data\sound\RscButton\soundEscape", 0.09, 1};

		class Attributes
		{
			font = "PuristaBold";
			color = "#E5E5E5";
			align = "left";
			shadow = "true";
		};

		class AttributesImage
		{
			font = "PuristaBold";
			color = "#E5E5E5";
			align = "left";
			shadow = "true";
		};
	};

	class balca_debug_list
	{
		type = CT_LISTBOX;
		style = 16;
		idc = -1;
		text = "";
		w = 0.275;
		h = 0.04;
		colorSelect[] = {1, 1, 1, 1};
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0.8,0.8,0.8,1};
		colorSelectBackground[] = {0.40, 0.43, 0.28, 0.5};
		colorScrollbar[] = {0.2, 0.2, 0.2, 1};
		arrowEmpty = "client\ui\ui_arrow_combo_ca.paa";
		arrowFull = "client\ui\ui_arrow_combo_active_ca.paa";
		wholeHeight = 0.45;
		rowHeight = 0.04;
		color[] = {0.7, 0.7, 0.7, 1};
		colorActive[] = {0,0,0,1};
		colorDisabled[] = {0,0,0,0.3};
		font = "PuristaBold";
		sizeEx = 0.023;
		soundSelect[] = {"",0.1,1};
		soundExpand[] = {"",0.1,1};
		soundCollapse[] = {"",0.1,1};
		maxHistoryDelay = 1;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;

		class ListScrollBar
		{
			color[] = {1, 1, 1, 1};
			colorActive[] = {1, 1, 1, 1};
			colorDisabled[] = {1, 1, 1, 1};
			thumb = "client\ui\ui_scrollbar_thumb_ca.paa";
			arrowFull = "client\ui\ui_arrow_top_active_ca.paa";
			arrowEmpty = "client\ui\ui_arrow_top_ca.paa";
			border = "client\ui\ui_border_scroll_ca.paa";
		};
	};

	class balca_debug_pict
	{
		/*idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;*/
		x = 0.25; w = 0.5;
		y = 0.1; h = 0.8;
		/*colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "\ca\ui\data\ui_gameoptions_background_ca.paa";
		font = "PuristaBold";
		sizeEx = 0.032;*/
		colorBackground[] = {0, 0, 0, 0.6};
		text              = "";
		type              = CT_STATIC;
		idc               = -1;
		style             = ST_LEFT;
		font              = "";
		colorText[]       = {1, 1, 1, 1};
		sizeEx            = 0.04;
	};

	class balca_debug_map {
		idc = -1;

		type=101;
		style=48;

		x = 0;
		y = 0;
		w = 1;
		h = 1;

		colorBackground[] = {1.00, 1.00, 1.00, 1.00};
		colorText[] = {0.00, 0.00, 0.00, 1.00};
		colorSea[] = {0.56, 0.80, 0.98, 0.50};
		colorForest[] = {0.60, 0.80, 0.20, 0.50};
		colorRocks[] = {0.50, 0.50, 0.50, 0.50};
		colorCountlines[] = {0.65, 0.45, 0.27, 0.50};
		colorMainCountlines[] = {0.65, 0.45, 0.27, 1.00};
		colorCountlinesWater[] = {0.00, 0.53, 1.00, 0.50};
		colorMainCountlinesWater[] = {0.00, 0.53, 1.00, 1.00};
		colorForestBorder[] = {0.40, 0.80, 0.00, 1.00};
		colorRocksBorder[] = {0.50, 0.50, 0.50, 1.00};
		colorPowerLines[] = {0.00, 0.00, 0.00, 1.00};
		colorNames[] = {0.00, 0.00, 0.00, 1.00};
		colorInactive[] = {1.00, 1.00, 1.00, 0.50};
		colorLevels[] = {0.00, 0.00, 0.00, 1.00};
		colorRailWay[] = {0.00, 0.00, 0.00, 1.00};
		colorOutside[] = {0.00, 0.00, 0.00, 1.00};

		font = "TahomaB";
		sizeEx = 0.040000;

		stickX[] = {0.20, {"Gamma", 1.00, 1.50} };
		stickY[] = {0.20, {"Gamma", 1.00, 1.50} };
		ptsPerSquareSea = 6;
		ptsPerSquareTxt = 8;
		ptsPerSquareCLn = 8;
		ptsPerSquareExp = 8;
		ptsPerSquareCost = 8;
		ptsPerSquareFor = "4.0f";
		ptsPerSquareForEdge = "10.0f";
		ptsPerSquareRoad = 2;
		ptsPerSquareObj = 10;

		fontLabel = "PuristaBold";
		sizeExLabel = 0.034000;
		fontGrid = "PuristaBold";
		sizeExGrid = 0.034000;
		fontUnits = "PuristaBold";
		sizeExUnits = 0.034000;
		fontNames = "PuristaBold";
		sizeExNames = 0.056000;
		fontInfo = "PuristaBold";
		sizeExInfo = 0.034000;
		fontLevel = "PuristaBold";
		sizeExLevel = 0.034000;

		text = "\ca\ui\data\map_background2_co.paa";

		maxSatelliteAlpha = 0;	 // Alpha to 0 by default
		alphaFadeStartScale = 1.0;
		alphaFadeEndScale = 1.1;   // Prevent div/0

		showCountourInterval=2;
		scaleDefault = 0.1;
		onMouseButtonClick = "";
		onMouseButtonDblClick = "";

		class CustomMark {
			icon = "\ca\ui\data\map_waypoint_ca.paa";
			color[] = {0, 0, 1, 1};
			size = 18;
			importance = 1;
			coefMin = 1;
			coefMax = 1;
		};

		class Legend {
			x = -1;
			y = -1;
			w = 0.340000;
			h = 0.152000;
			font = "PuristaBold";
			sizeEx = 0.039210;
			colorBackground[] = {0.906000, 0.901000, 0.880000, 0.800000};
			color[] = {0, 0, 0, 1};
		};

		class Bunker {
			icon = "\ca\ui\data\map_bunker_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 14;
			importance = "1.5 * 14 * 0.05";
			coefMin = 0.250000;
			coefMax = 4;
		};

		class Bush {
			icon = "\ca\ui\data\map_bush_ca.paa";
			color[] = {0.550000, 0.640000, 0.430000, 1};
			size = 14;
			importance = "0.2 * 14 * 0.05";
			coefMin = 0.250000;
			coefMax = 4;
		};

		class BusStop {
			icon = "\ca\ui\data\map_busstop_ca.paa";
			color[] = {0, 0, 1, 1};
			size = 10;
			importance = "1 * 10 * 0.05";
			coefMin = 0.250000;
			coefMax = 4;
		};

		class Command {
			icon = "\ca\ui\data\map_waypoint_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 18;
			importance = 1;
			coefMin = 1;
			coefMax = 1;
		};

		class Cross {
			icon = "\ca\ui\data\map_cross_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 16;
			importance = "0.7 * 16 * 0.05";
			coefMin = 0.250000;
			coefMax = 4;
		};

		class Fortress {
			icon = "\ca\ui\data\map_bunker_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 16;
			importance = "2 * 16 * 0.05";
			coefMin = 0.250000;
			coefMax = 4;
		};

		class Fuelstation {
			icon = "\ca\ui\data\map_fuelstation_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 16;
			importance = "2 * 16 * 0.05";
			coefMin = 0.750000;
			coefMax = 4;
		};

		class Fountain {
			icon = "\ca\ui\data\map_fountain_ca.paa";
			color[] = {0, 0.350000, 0.700000, 1};
			size = 12;
			importance = "1 * 12 * 0.05";
			coefMin = 0.250000;
			coefMax = 4;
		};

		class Hospital {
			icon = "\ca\ui\data\map_hospital_ca.paa";
			color[] = {0.780000, 0, 0.050000, 1};
			size = 16;
			importance = "2 * 16 * 0.05";
			coefMin = 0.500000;
			coefMax = 4;
		};

		class Chapel {
			icon = "\ca\ui\data\map_chapel_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 16;
			importance = "1 * 16 * 0.05";
			coefMin = 0.900000;
			coefMax = 4;
		};

		class Church {
			icon = "\ca\ui\data\map_church_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 16;
			importance = "2 * 16 * 0.05";
			coefMin = 0.900000;
			coefMax = 4;
		};

		class Lighthouse {
			icon = "\ca\ui\data\map_lighthouse_ca.paa";
			color[] = {0.780000, 0, 0.050000, 1};
			size = 20;
			importance = "3 * 16 * 0.05";
			coefMin = 0.900000;
			coefMax = 4;
		};

		class Quay {
			icon = "\ca\ui\data\map_quay_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 16;
			importance = "2 * 16 * 0.05";
			coefMin = 0.500000;
			coefMax = 4;
		};

		class Rock {
			icon = "\ca\ui\data\map_rock_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 12;
			importance = "0.5 * 12 * 0.05";
			coefMin = 0.250000;
			coefMax = 4;
		};

		class Ruin {
			icon = "\ca\ui\data\map_ruin_ca.paa";
			color[] = {0.780000, 0, 0.050000, 1};
			size = 16;
			importance = "1.2 * 16 * 0.05";
			coefMin = 1;
			coefMax = 4;
		};

		class SmallTree {
			icon = "\ca\ui\data\map_smalltree_ca.paa";
			color[] = {0.550000, 0.640000, 0.430000, 1};
			size = 12;
			importance = "0.6 * 12 * 0.05";
			coefMin = 0.250000;
			coefMax = 4;
		};

		class Stack {
			icon = "\ca\ui\data\map_stack_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 20;
			importance = "2 * 16 * 0.05";
			coefMin = 0.900000;
			coefMax = 4;
		};

		class Tree {
			icon = "\ca\ui\data\map_tree_ca.paa";
			color[] = {0.550000, 0.640000, 0.430000, 1};
			size = 12;
			importance = "0.9 * 16 * 0.05";
			coefMin = 0.250000;
			coefMax = 4;
		};

		class Tourism {
			icon = "\ca\ui\data\map_tourism_ca.paa";
			color[] = {0.780000, 0, 0.050000, 1};
			size = 16;
			importance = "1 * 16 * 0.05";
			coefMin = 0.700000;
			coefMax = 4;
		};

		class Transmitter {
			icon = "\ca\ui\data\map_transmitter_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 20;
			importance = "2 * 16 * 0.05";
			coefMin = 0.900000;
			coefMax = 4;
		};

		class ViewTower {
			icon = "\ca\ui\data\map_viewtower_ca.paa";
			color[] = {0, 0.900000, 0, 1};
			size = 16;
			importance = "2.5 * 16 * 0.05";
			coefMin = 0.500000;
			coefMax = 4;
		};

		class Watertower {
			icon = "\ca\ui\data\map_watertower_ca.paa";
			color[] = {0, 0.350000, 0.700000, 1};
			size = 32;
			importance = "1.2 * 16 * 0.05";
			coefMin = 0.900000;
			coefMax = 4;
		};

		class Waypoint {
			icon = "\ca\ui\data\map_waypoint_ca.paa";
			size = 20;
			color[] = {0, 0.900000, 0, 1};
			importance = "1.2 * 16 * 0.05";
			coefMin = 0.900000;
			coefMax = 4;
		};

		class Task {
			icon = "\ca\ui\data\map_waypoint_ca.paa";
			iconCreated = "#(argb,8,8,3)color(1,1,1,1)";
			iconCanceled = "#(argb,8,8,3)color(0,0,1,1)";
			iconDone = "#(argb,8,8,3)color(0,0,0,1)";
			iconFailed = "#(argb,8,8,3)color(1,0,0,1)";
			colorCreated[] = {1,1,1,1};
			colorCanceled[] = {1,1,1,1};
			colorDone[] = {1,1,1,1};
			colorFailed[] = {1,1,1,1};
			size = 20;
			color[] = {0, 0.900000, 0, 1};
			importance = "1.2 * 16 * 0.05";
			coefMin = 0.900000;
			coefMax = 4;
		};

		class WaypointCompleted {
			icon = "\ca\ui\data\map_waypoint_completed_ca.paa";
			size = 20;
			color[] = {0, 0.900000, 0, 1};
			importance = "1.2 * 16 * 0.05";
			coefMin = 0.900000;
			coefMax = 4;
		};

		class ActiveMarker {
			icon = "\ca\ui\data\map_waypoint_completed_ca.paa";
			size = 20;
			color[] = {0, 0.900000, 0, 1};
			importance = "1.2 * 16 * 0.05";
			coefMin = 0.900000;
			coefMax = 4;
		};
	};
