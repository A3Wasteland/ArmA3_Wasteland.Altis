// ****************************************************************************************
// * This addon is licensed under the GNU Lesser GPL v3. Copyright © 2016 A3Wasteland.com *
// ****************************************************************************************
//	@file Name: defines.sqf
//	@file Author: AgentRev

#define STICKY_CHARGE_MAX_DIST 2.5 // max distance in meters of surface aimed at by player at which charges will stick to, if further then the charge will be placed on ground as usual
#define STICKY_CHARGE_ALLOWED_TYPES ["DemoCharge_Remote_Mag", "SatchelCharge_Remote_Mag"] // allowed magazine classnames
#define STICKY_CHARGE_ICON_COLOR [0, 1, 0, 1] // RGBA

#define STICKY_CHARGE_DUMMY_OBJ "Sign_Sphere10cm_F" // usage of dummy object is needed to guaranted pos & dir syncing and use setVariable
#define LINE_INTERSECT_BOMB(POS1,POS2,IGNORE) lineIntersectsSurfaces [POS1, POS2, player, IGNORE, true, 1, "FIRE", "VIEW"]
