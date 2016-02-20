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
#define groupManagementAcceptButton 55518
#define groupManagementDeclineButton 55519
#define groupManagementInviteText 55520

class GroupManagement {

	idd = groupManagementDialog;
	movingEnable = true;
	enableSimulation = true;

	class controlsBackground {

		class MainBG : IGUIBack {
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0.6};

			moving = true;
			x = 0.0; y = 0.1;
			w = 0.745; h = 0.65;
		};

		class TopBar: IGUIBack
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {A3W_UICOLOR_R, A3W_UICOLOR_G, A3W_UICOLOR_B, 0.8};

			x = 0.0; y = 0.1;
			w = 0.745; h = 0.05;
		};

		class MainTitle : w_RscText {
			idc = -1;
			text = "Group Management";
			sizeEx = 0.04;
			shadow = 2;
			x = 0.260; y = 0.10;
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

		class InviteText: w_RscStructuredText
		{
			idc = groupManagementInviteText;
			text = "";
			size = 0.025;

			x = 0.255; y = 0.500;
			w = 0.235; h = 0.075;
		};
	};

	class controls {

		class PlayerListBox : w_Rsclist {
			idc = groupManagementPlayerList;
			onLBSelChanged = "[] execVM 'client\systems\groups\playerSelectChange.sqf'";
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
			onButtonClick = "closeDialog 0; groupManagmentActive = false;";
			x = 0.02; y = 0.662;
			w = 0.125; h = 0.033 * safezoneH;
		};

		class InviteButton : w_RscButton {
			idc = groupManagementInviteButton;
			text = "Invite";
			onButtonClick = "[] execVM 'client\systems\groups\inviteToGroup.sqf'";
			x = 0.3075; y = 0.200;
			w = 0.14; h = 0.033 * safezoneH;
		};

		class PromoteButton : w_RscButton {
			idc = groupManagementPromoteButton;
			text = "Promote";
			onButtonClick = "[] execVM 'client\systems\groups\promotePlayer.sqf'";
			x = 0.3075; y = 0.270;
			w = 0.14; h = 0.033 * safezoneH;
		};

		class KickButton : w_RscButton {
			idc = groupManagementKickButton;
			text = "Kick";
			onButtonClick = "[] execVM 'client\systems\groups\kickFromGroup.sqf'";
			x = 0.3075; y = 0.340;
			w = 0.14; h = 0.033 * safezoneH;
		};

		class DisbandButton : w_RscButton {
			idc = groupManagementDisbandButton;
			text = "Disband";
			onButtonClick = "[] execVM 'client\systems\groups\disbandGroup.sqf'";
			x = 0.3075; y = 0.410;
			w = 0.14; h = 0.033 * safezoneH;
		};

		class LeaveButton : w_RscButton {
			idc = groupManagementLeaveButton;
			text = "Leave";
			onButtonClick = "[] execVM 'client\systems\groups\leaveGroup.sqf'";
			x = 0.3075; y = 0.480;
			w = 0.14; h = 0.033 * safezoneH;
		};

		class AcceptInviteButton : w_RscButton {
			idc = groupManagementAcceptButton;
			text = "Accept";
			onButtonClick = "[] execVM 'client\systems\groups\acceptGroupInvite.sqf'";
			x = 0.275; y = 0.625 - 0.0255 * safezoneH;
			w = 0.100; h = 0.033 * safezoneH;
		};

		class DeclineInviteButton : w_RscButton {
			idc = groupManagementDeclineButton;
			text = "Decline";
			onButtonClick = "[] execVM 'client\systems\groups\declineGroupInvite.sqf'";
			x = 0.375; y = 0.625 - 0.0255 * safezoneH;
			w = 0.100; h = 0.033 * safezoneH;
		};
	};
};

