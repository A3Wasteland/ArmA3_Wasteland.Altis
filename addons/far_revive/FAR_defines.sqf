// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//------------------------------------------//
// Parameters - Feel free to edit these
//------------------------------------------//

// Unused
#define SCRIPT_VERSION "1.5"

// Seconds until unconscious unit bleeds out and dies. Set to 0 to disable.
#define FAR_BleedOut ((["A3W_bleedingTime", 60] call getPublicVar) max 10)

// Broadcast notifications when player is injured and becomes unconscious (overriden by server difficulty's DeathMessages setting)
#define FAR_EnableDeathMessages true

// If enabled, unconscious units will not be able to use ACRE radio, hear other people or use proximity chat
#define FAR_MuteACRE false

/*
	0 = Only medics can revive
	1 = All units can revive
	2 = Same as 1 but a medikit is required to revive
*/
#define FAR_ReviveMode 2

// cutText layer
#define FAR_cutTextLayer 7890

// Damage multiplier applied to units when inconscious
#define FAR_DamageMultiplier 0.001

// Functions
#define UNCONSCIOUS(UNIT) (UNIT getVariable ["FAR_isUnconscious", 0] == 1)
#define STABILIZED(UNIT) (UNIT getVariable ["FAR_isStabilized", 0] == 1)
#define DRAGGED_BY(UNIT) (UNIT getVariable ["FAR_draggedBy", objNull])
#define DRAGGED(UNIT) (!isNull DRAGGED_BY(UNIT))
#define TREATED_BY(UNIT) (UNIT getVariable ["FAR_treatedBy", objNull])
#define BEING_TREATED(UNIT) (!isNull TREATED_BY(UNIT))
#define TREATING(UNIT) (UNIT getVariable ["FAR_isTreating", objNull])
#define IS_TREATING(UNIT) (!isNull TREATED_BY(UNIT))
#define IS_MEDICAL_VEHICLE(VEH) (round getNumber (configfile >> "CfgVehicles" >> typeOf VEH >> "attendant") > 0)
#define IS_MEDIC(UNIT) ((FAR_ReviveMode > 0 || {IS_MEDICAL_VEHICLE(UNIT)}) && (FAR_ReviveMode != 2 || {"Medikit" in items UNIT}))

// For HandleRevive and HandleStabilize
#define CAN_PERFORM (alive player && !UNCONSCIOUS(player) && UNCONSCIOUS(_target))
