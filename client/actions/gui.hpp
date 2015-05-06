// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
class ActionGUI : IGUIBack {
	idd = 10101;
	movingEnabled = false;
	controls[] = {MyProgressBar, MyButton, MyText};
	controlsBackground[] = {MyBackground};

	class MyProgressBar : RscProgressBar {
		idc = 10101;
		x = 0.2;
		y = 1;
		w = 0.5;
		h = 0.05;
	};

	class MyButton : w_RscButton {
		idc = -1;
		text = "Cancel";
		x = 0.71;
		y = 1;
		w = 0.09;
		h = 0.05;
		action = "a3w_actions_mutex = false; closeDialog 10101";
	};

	class MyText : RscStructuredText {
		idc = 10102;
		x = 0.2;
		y = 1.005;
		w = 0.5;
		h = 0.05;
		class Attributes {
			align = "center";
			valign = "middle";
		};
	};

	class MyBackground : IGUIBack {
		idc = -1;
		x = 0.19;
		y = 0.99;
		w = 0.62;
		h = 0.07;
	};
};
