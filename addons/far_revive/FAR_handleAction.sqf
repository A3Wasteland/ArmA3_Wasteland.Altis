// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
private ["_params", "_action"];

// Parameters passed by the action
_params = _this select 3;
_action = _params select 0;

////////////////////////////////////////////////
// Handle actions
////////////////////////////////////////////////
switch (toLower _action) do
{
	case "action_revive":
	{
		[cursorTarget] spawn FAR_HandleRevive;
	};

	case "action_stabilize":
	{
		[cursorTarget] spawn FAR_HandleStabilize;
	};

	case "action_suicide":
	{
		player setDamage 1;
	};

	case "action_drag":
	{
		[cursorTarget] spawn FAR_Drag;
	};

	case "action_release":
	{
		[] spawn FAR_Release;
	};
	
	case "action_gut":
	{
		[cursorTarget] spawn FAR_Gut;
	};
};
