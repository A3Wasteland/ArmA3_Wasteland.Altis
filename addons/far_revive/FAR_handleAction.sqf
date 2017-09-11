// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************

// Parameters passed by the action
params ["_target", "", "", "_params"];
_params params ["_action"];

////////////////////////////////////////////////
// Handle actions
////////////////////////////////////////////////
switch (toLower _action) do
{
	case "action_revive":
	{
		[call FAR_FindTarget, _target] spawn FAR_HandleRevive;
	};

	case "action_stabilize":
	{
		[call FAR_FindTarget, _target] spawn FAR_HandleStabilize;
	};

	case "action_suicide":
	{
		player setDamage 1;
	};

	case "action_drag":
	{
		[call FAR_FindTarget] spawn FAR_Drag;
	};

	case "action_release":
	{
		[] spawn FAR_Release;
	};

	case "action_slay":
	{
		call FAR_Slay_Target;
	};

	case "action_load":
	{
		[] call FAR_Drag_Load_Vehicle;
	};

	case "action_eject":
	{
		[] call FAR_Eject_Injured;
	};
};
