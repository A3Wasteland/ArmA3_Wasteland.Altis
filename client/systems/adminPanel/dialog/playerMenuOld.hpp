class PlayersMenu
{
	idd=-1;
    name="PlayersMenu";       
	movingEnable=1;
	controlsBackground[]={PlayersMenu_background};
	objects[]={};
	controls[]={PlayersMenu_playerName, PlayersMenu_options, PlayersMenu_editbox, PlayersMenu_activate1, PlayersMenu_activate2, PlayersMenu_activate3, PlayersMenu_1,PlayersMenu_2,PlayersMenu_3,PlayersMenu_4};
        
        
	class PlayersMenu_playerName:w_RscText
	{
		idc=-1;
		text="Players Menu";
		x=0.15;
		y=-0.2;
		w=0.10;
		h=0.03;
	};

	class PlayersMenu_options:w_Rsclist
	{
		idc=13371;
		onLBSelChanged="[2,_this select 1] execVM ""client\systems\adminPanel\importvalues.sqf"";";
		x=-0.38;
		y=-0.13;
		w=1.72;
		h=0.47;
	};
	class PlayersMenu_1:w_RscText
	{
		idc=38861;
		text="Items: ";
		x=-0.38;
		y=0.49;
		w=2.0;
		h=0.04;
	};
	class PlayersMenu_2:w_RscText
	{
		idc=38862;
		text="Current Weapon: ";
		x=-0.38;
		y=0.53;
		w=2.0;
		h=0.04;
	};
	class PlayersMenu_3:w_RscText
	{
		idc=38863;
		text="Magazines: ";
		x=-0.38;
		y=0.57;
		w=2.0;
		h=0.04;
	};
	class PlayersMenu_4:w_RscText
	{
		idc=38864;
		text="Position: ";
		x=-0.38;
		y=0.61;
		w=2.0;
		h=0.04;
	};
	class PlayersMenu_activate1:RscButton
	{
		idc=-1;
		text="Kick";
		action="[0] execVM ""client\systems\adminPanel\playerSelect.sqf"";";
		x=0.75;
		y=0.44;
		w=0.15;
		h=0.05;
	};
	class PlayersMenu_activate2:RscButton
	{
		idc=19001;
		text="Cam";
		action="[1] execVM ""client\systems\adminPanel\playerSelect.sqf"";";
		x=0.92;
		y=0.44;
		w=0.15;
		h=0.05;
	};
	class PlayersMenu_activate3:RscButton
	{
		idc=-1;
		text="Warn";
		action="[2] execVM ""client\systems\adminPanel\playerSelect.sqf"";";
		x=1.10;
		y=0.44;
		w=0.15;
		h=0.05;
	};
	class PlayersMenu_editbox:w_RscEdit
	{
		idc=19000;
		x=0.49;
		y=0.37;
		w=0.75;
		h=0.05;
	};
	class PlayersMenu_background:w_RscBackground
	{
		idc=-1;
		x=-0.40;
		y=-0.20;
		w=1.75;
		h=1.00;
	};
};