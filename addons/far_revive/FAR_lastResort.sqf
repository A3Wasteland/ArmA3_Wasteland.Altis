// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: FAR_lastResort.sqf
//	@file Author: AgentRev

private ["_hasCharge", "_hasSatchel", "_hasCharge2", "_hasSatchel2", "_mineType", "_pos", "_mine"];

_hasCharge = "IEDUrbanSmall_Remote_Mag" in magazines player;
_hasSatchel = "IEDUrbanBig_Remote_Mag" in magazines player;
_hasCharge2 = "IEDLandSmall_Remote_Mag" in magazines player;
_hasSatchel2 = "IEDLandBig_Remote_Mag" in magazines player;

if !(player getVariable ["performingDuty", false]) then
{
	if (_hasCharge || _hasSatchel || _hasCharge2 || _hasSatchel2) then
	{
		if (["Perform your duty?", "", "Yes", "No"] call BIS_fnc_guiMessage) then
		{
			player setVariable ["performingDuty", true];
			playSound3D [call currMissionDir + "client\sounds\lastresort.wss", vehicle player, false, getPosASL player, 0.7, 1, 1000];

			switch (true) do
			{
				case (_hasCharge):
				{
					_mineType = "IEDUrbanSmall_F";
					player removeMagazine "IEDUrbanSmall_Remote_Mag";
				};
				case (_hasSatchel):
				{
					_mineType = "IEDUrbanBig_F";
					player removeMagazine "IEDUrbanBig_Remote_Mag";
				};
				case (_hasCharge2):
				{
					_mineType = "IEDLandSmall_F";
					player removeMagazine "IEDLandSmall_Remote_Mag";
				};
				case (_hasSatchel2):
				{
					_mineType = "IEDLandBig_F";
					player removeMagazine "IEDLandBig_Remote_Mag";
				};
			};

			sleep 1.75;

			_pos = getPosATL player;
			_pos set [2, (_pos select 2) + 0.5];

			_mine = createMine [_mineType, _pos, [], 0];
			_mine setDamage 1;
			player setDamage 1;
			player setVariable ["performingDuty", nil];
		};
	}
	else
	{
		titleText ["Get an explosive charge next time, my child.", "PLAIN", 0.5];
	};
};
