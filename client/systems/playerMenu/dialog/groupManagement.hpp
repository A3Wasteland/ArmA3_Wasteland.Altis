// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
#define groupManagementDialog 55510
#define groupManagementPlayerList 55511
#define groupManagementGroupList 55512
#define groupManagementPromoteButton 55513
#define groupManagementInviteButton 55514
#define groupManagementKickButton 55515
#define groupManagementDisbandButton 55516
#define groupManagementLeaveButton 55517

class GroupManagement {

	idd = groupManagementDialog;
	movingEnable = true;
	enableSimulation = true;

	class controlsBackground {

		class MainBG : w_RscPicture {
			idc = -1;
			text = "client\ui\ui_background_controlers_ca.paa";
			moving = true;
			x = 0.0; y = 0.1;
			w = 1.0; h = 0.65;
		};

		class MainTitle : w_RscText {
			idc = -1;
			text = "Group Management";
			sizeEx = 0.04;
			shadow = 2;
			x = 0.260; y = 0.112;
			w = 0.3; h = 0.05;
		};

		class InviteTitleText : w_RscText {
			idc = -1;
			text = "Players";
			sizeEx = 0.025;
			shadow = 2;
			x = 0.0875; y = 0.155;
			w = 0.3; h = 0.050;
		};

		class GroupTitleText : w_RscText {
			idc = -1;
			text = "Your Group";
			sizeEx = 0.025;
			shadow = 2;
			x = 0.5575; y = 0.155;
			w = 0.3; h = 0.050;
		};
	};

	class controls {

		class PlayerListBox : w_Rsclist {
			idc = groupManagementPlayerList;
			x = 0.020; y = 0.200;
			w = 0.235; h = 0.425;
		};

		class GroupListBox : w_Rsclist {
			idc = groupManagementGroupList;
			x = 0.490; y = 0.200;
			w = 0.235; h = 0.425;
		};

		class CloseButton : w_RscButton {
			idc = -1;
			text = "Close";
			onButtonClick = "closeDialog 0;";
			x = 0.02; y = 0.68;
			w = 0.125; h = 0.033 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};

		//class CreateGroupButton : w_RscButton {
		//	idc = groupManagementCreateButton;
		//	text = "Create Group";
		//	onButtonClick = "[] execVM 'client\systems\groups\createGroup.sqf'";
		//	x = 0.3075; y = 0.200;
		//	w = 0.125; h = 0.033 * safezoneH;
		//	color[] = {0.1,0.95,0.1,1};
		//};

		class PromotePlayerButton : w_RscButton {
			idc = groupManagementPromoteButton;
			text = "Promote";
			onButtonClick = "[] execVM 'client\systems\groups\promotePlayer.sqf'";
			x = 0.3075; y = 0.200;
			w = 0.125; h = 0.033 * safezoneH;
			color[] = {0.1,0.95,0.1,1};
		};

		class InviteButton : w_RscButton {
			idc = groupManagementInviteButton;
			text = "Invite";
			onButtonClick = "[] execVM 'client\systems\groups\inviteToGroup.sqf'";
			x = 0.3075; y = 0.250;
			w = 0.125; h = 0.033 * safezoneH;
			color[] = {0.1,0.95,0.1,1};
		};

		class KickButton : w_RscButton {
			idc = groupManagementKickButton;
			text = "Kick";
			onButtonClick = "[] execVM 'client\systems\groups\kickFromGroup.sqf'";
			x = 0.3075; y = 0.300;
			w = 0.125; h = 0.033 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};

		class DisbandButton : w_RscButton {
			idc = groupManagementDisbandButton;
			text = "Disband";
			onButtonClick = "[] execVM 'client\systems\groups\disbandGroup.sqf'";
			x = 0.3075; y = 0.350;
			w = 0.125; h = 0.033 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};

		class LeaveButton : w_RscButton {
			idc = groupManagementLeaveButton;
			text = "Leave Group";
			onButtonClick = "[] execVM 'client\systems\groups\leaveGroup.sqf'";
			x = 0.3075; y = 0.350;
			w = 0.125; h = 0.033 * safezoneH;
			color[] = {0.95,0.1,0.1,1};
		};
	};

};

