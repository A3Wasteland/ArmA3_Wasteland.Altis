class RscBackground {
	type = 0;
	IDC = -1;
	style = 512;
	x = 0;
	y = 0;
	w = 1;
	h = 1;
	text = "";
	ColorBackground[] = {0.48, 0.5, 0.35, 1};
	ColorText[] = {0.1, 0.1, 0.1, 1};
	font = "TahomaB";
	SizeEx = 1;
};

class RscCombo {
	access = 0;
	type = 4;
	style = 0;
	colorSelect[] = {0.023529, 0, 0.0313725, 1};
	colorText[] = {0.023529, 0, 0.0313725, 1};
	colorBackground[] = {0.95, 0.95, 0.95, 1};
	colorScrollbar[] = {0.023529, 0, 0.0313725, 1};
	soundSelect[] = {"", 0.1, 1};
	soundExpand[] = {"", 0.1, 1};
	soundCollapse[] = {"", 0.1, 1};
	maxHistoryDelay = 1;
	x = 0;
	y = 0;
	w = 0.12;
	h = 0.035;
	colorSelectBackground[] = {0.543, 0.5742, 0.4102, 1};
	arrowEmpty = "\ca\ui\data\ui_arrow_combo_ca.paa";
	arrowFull = "\ca\ui\data\ui_arrow_combo_active_ca.paa";
	wholeHeight = 0.45;
	color[] = {0, 0, 0, 0.6};
	colorActive[] = {0, 0, 0, 1};
	colorDisabled[] = {0, 0, 0, 0.3};
	font = "TahomaB";
	sizeEx = 0.03921;
	class ComboScrollBar {
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\ca\ui\data\ui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\ui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\ui_arrow_top_ca.paa";
		border = "\ca\ui\data\ui_border_scroll_ca.paa";
	};

};

class RscEdit {
	access = 0;
	type = 2;
	h = 0.04;
	colorBackground[] = {0, 0, 0, 1};
	colorText[] = {0.95, 0.95, 0.95, 1};
	colorSelection[] = {0.543, 0.5742, 0.4102, 1};
	autocomplete = "";
	text = "";
	size = 0.2;
	style = "0x00 + 0x40";
	font = "TahomaB";
	sizeEx = 0.03921;
};

class RscIGUIListBox {
	color[] = {1, 1, 1, 1};
	colorText[] = {0.6, 0.8392, 0.4706, 1};
	colorScrollbar[] = {0.95, 0.95, 0.95, 1};
	colorSelect[] = {0.023529, 0, 0.0313725, 1};
	colorSelect2[] = {0.023529, 0, 0.0313725, 1};
	colorSelectBackground[] = {0.6, 0.8392, 0.4706, 1};
	colorSelectBackground2[] = {0.6, 0.8392, 0.4706, 1};
	period = 0;
	colorBackground[] = {0, 0, 0, 1};
	sizeEx = 0.034;

	// Values from class: RscListBox //

	access = 0;
	w = 0.4;
	h = 0.4;
	rowHeight = 0;
	soundSelect[] = {"", 0.1, 1};
	arrowEmpty = "#(argb,8,8,3)color(1,1,1,1)";
	arrowFull = "#(argb,8,8,3)color(1,1,1,1)";
	type = 5;
	style = 16;
	font = "TahomaB";
	maxHistoryDelay = 1;
	autoScrollSpeed = -1;
	autoScrollDelay = 5;
	autoScrollRewind = 0;

	class ListScrollBar {
		color[] = {1, 1, 1, 0.6};
		colorActive[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.3};
		thumb = "\ca\ui\data\igui_scrollbar_thumb_ca.paa";
		arrowFull = "\ca\ui\data\igui_arrow_top_active_ca.paa";
		arrowEmpty = "\ca\ui\data\igui_arrow_top_ca.paa";
		border = "\ca\ui\data\igui_border_scroll_ca.paa";
	};
};

class RscStandardDisplay {
	access = 0;
	movingEnable = 1;
	enableSimulation = 1;
	enableDisplay = 1;
};

class RscText {
	access = 0;
	type = 0;
	idc = -1;
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {0.543, 0.5742, 0.4102, 1};
	text = "";
	x = 0;
	y = 0;
	h = 0.037;
	w = 0.3;
	style = 256;
	font = "TahomaB";
	SizeEx = 0.03921;
};

class RscTitle : RscText {
	style = 2;
	x = 0.15;
	y = 0.06;
	w = 0.7;

	// Values from class: RscText //

	access = 0;
	type = 0;
	idc = -1;
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {0.543, 0.5742, 0.4102, 1};
	text = "";
	h = 0.037;
	font = "TahomaB";
	SizeEx = 0.03921;
};

class RscShortcutButton {
	x = 0.1;
	y = 0.1;
	shortcuts[] = {};
	textureNoShortcut = "#(argb,8,8,3)color(0,0,0,0)";
	color[] = {0.543, 0.5742, 0.4102, 1};
	color2[] = {0.95, 0.95, 0.95, 1};
	colorFocused[] = {0.543, 0.5742, 0.4102, 1};
	colorDisabled[] = {1, 1, 1, 0.25};
	colorBackground[] = {1, 1, 1, 1};
	colorBackground2[] = {1, 1, 1, 0.4};
	colorBackgroundFocused[] = {1, 1, 1, 1};
	type = 16;
	idc = -1;
	style = 0;
	default = 0;
	w = 0.183825;
	h = 0.104575;
	periodFocus = 1.2;
	periodOver = 0.8;
	animTextureNormal = "\ca\ui\data\ui_button_normal_ca.paa";
	animTextureDisabled = "\ca\ui\data\ui_button_disabled_ca.paa";
	animTextureOver = "\ca\ui\data\ui_button_over_ca.paa";
	animTextureFocused = "\ca\ui\data\ui_button_focus_ca.paa";
	animTexturePressed = "\ca\ui\data\ui_button_down_ca.paa";
	animTextureDefault = "\ca\ui\data\ui_button_default_ca.paa";
	period = 0.4;
	font = "TahomaB";
	size = 0.03921;
	sizeEx = 0.03921;
	text = "";
	soundEnter[] = {"", 0.09, 1};
	soundPush[] = {"", 0.09, 1};
	soundClick[] = {"\ca\ui\data\sound\new1", 0.07, 1};
	soundEscape[] = {"", 0.09, 1};
	action = "";

	class Attributes {
		font = "TahomaB";
		color = "#E5E5E5";
		align = "left";
		shadow = "true";
	};

	class AttributesImage {
		font = "TahomaB";
		color = "#E5E5E5";
		align = "left";
	};

	class HitZone {
		left = 0.004;
		top = 0.029;
		right = 0.004;
		bottom = 0.029;
	};

	class ShortcutPos {
		left = 0.0145;
		top = 0.026;
		w = 0.0392157;
		h = 0.0522876;
	};

	class TextPos {
		left = 0.025;
		top = 0.034;
		right = 0.005;
		bottom = 0.005;
	};
};

class RscIGUIShortcutButton : RscShortcutButton {
	w = 0.183825;
	h = 0.0522876;
	style = 2;
	color[] = {1, 1, 1, 1};
	color2[] = {1, 1, 1, 0.85};
	colorBackground[] = {1, 1, 1, 1};
	colorbackground2[] = {1, 1, 1, 0.85};
	colorDisabled[] = {1, 1, 1, 0.4};
	animTextureNormal = "\ca\ui\data\igui_button_normal_ca.paa";
	animTextureDisabled = "\ca\ui\data\igui_button_disabled_ca.paa";
	animTextureOver = "\ca\ui\data\igui_button_over_ca.paa";
	animTextureFocused = "\ca\ui\data\igui_button_focus_ca.paa";
	animTexturePressed = "\ca\ui\data\igui_button_down_ca.paa";
	animTextureDefault = "\ca\ui\data\igui_button_normal_ca.paa";

	// Values from class: RscShortcutButton //

	x = 0.1;
	y = 0.1;
	shortcuts[] = {};
	textureNoShortcut = "#(argb,8,8,3)color(0,0,0,0)";
	type = 16;
	idc = -1;
	default = 0;
	periodFocus = 1.2;
	periodOver = 0.8;
	period = 0.4;
	font = "TahomaB";
	size = 0.03921;
	sizeEx = 0.03921;
	text = "";
	soundEnter[] = {"", 0.09, 1};
	soundPush[] = {"", 0.09, 1};
	soundClick[] = {"\ca\ui\data\sound\new1", 0.07, 1};
	soundEscape[] = {"", 0.09, 1};
	action = "";

	class Attributes {
		font = "TahomaB";
		color = "#E5E5E5";
		align = "center";
		shadow = "true";
	};

	class HitZone {
		left = 0.002;
		top = 0.003;
		right = 0.002;
		bottom = 0.016;
	};

	class ShortcutPos {
		left = -0.006;
		top = -0.007;
		w = 0.0392157;
		h = 0.0522876;
	};

	class TextPos {
		left = 0.02;
		top = 0;
		right = 0.002;
		bottom = 0.016;
	};
};
