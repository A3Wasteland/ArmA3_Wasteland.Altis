// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: ui_toolkit.hpp
//	@file Author: AgentRev

// Arma UI Mini Toolkit v1.0 by AgentRev

// Uncomment the define below if you want your UIs to scale according to the UI size selected by the user
//#define FOLLOW_UI_SIZE

// Uncomment the define below if you want your UIs to scale according to the resolution selected by the user
#define FOLLOW_RESOLUTION

// This is the percentage from the dev resolution that the UI must start compensating in order to stay at a reasonable size (ex: UI cannot get smaller than 75% from the dev resolution)
#define FOLLOW_RES_LOWER_CAP 0.75

// Effects:
// FOLLOW_UI_SIZE only = UI will be scaled according to the user's UI size, relative from UI_SIZE_DEV below, regardless of the resolution (not recommended)
// FOLLOW_RESOLUTION only = UI will be scaled according to the resolution, relative from RES_Y_DEV below, regardless of the user's UI size
// both commented = UI will be the same size in pixels across all UI sizes and resolutions
// both uncommented = UI will be scaled according to the resolution, then scaled according to the user's UI size

// ----- Interface size & resolution -----
#define UI_VSMALL 0.47
#define UI_SMALL 0.55
#define UI_NORMAL 0.7
#define UI_LARGE 0.85
#define UI_VLARGE 1.0

#define UI_SIZE_DEV UI_SMALL // If you want your text to stay the same size across all UI sizes, change this to your UI size
#define UI_SIZE (getResolution select 5) // Interface size selected in game options

#define RES_Y_DEV 1080 // If you want your UIs to stay the same size across all resolutions, change this to your game's resolution height
#define RES_Y (getResolution select 1) // Resolution height in pixels

// ----- Safezone & scales -----
#define SZ_LEFT safezoneX      // X left
#define SZ_RIGHT (1 - SZ_LEFT) // X right
#define SZ_TOP safezoneY       // Y top
#define SZ_BOTTOM (1 - SZ_TOP) // Y bottom

// Determine if UI & text scales are relative to UI size
#ifdef FOLLOW_UI_SIZE
	#define UI_SCALE (UI_SIZE / UI_SIZE_DEV) // Constant UI scale across all UI sizes
	#define TEXT_SCALE_UI 1 // Regular text scale
#else
	#define UI_SCALE 1 // Regular UI scale
	#define TEXT_SCALE_UI (UI_SIZE_DEV / UI_SIZE) // Compensate text scale against UI size
#endif

// Determine if UI scale is relative to resolution
#ifdef FOLLOW_RESOLUTION
	#define RES_SCALE (((RES_Y_DEV * FOLLOW_RES_LOWER_CAP) / RES_Y) max 1) // Regular UI scale, with lower cap
#else
	#define RES_SCALE (RES_Y_DEV / RES_Y) // Constant UI scale across all resolutions below dev resolution
#endif

#define TEXT_SCALE (TEXT_SCALE_UI * RES_SCALE) // Compensate text scale against resolution

// Set scales
#define SZ_SCALE_ABS (safezoneW min safezoneH)
#define SZ_SCALE (SZ_SCALE_ABS * RES_SCALE * UI_SCALE) // the smallest safezone is used for size ref (because W < H if ratio < 4/3)
#define X_SCALE (SZ_SCALE * 0.75) // cancels 4/3 ratio applied on X and W values by engine, so that X and Y have a uniform scale
#define Y_SCALE (SZ_SCALE * 1.0)

// Offsets
#define X_OFFSET 0
#define Y_OFFSET 0

// Positions relative to top left, plus above offsets
#define X_POS(VALUE) (SZ_LEFT + ((VALUE + X_OFFSET) * X_SCALE)) // stretches X value to full screen width
#define Y_POS(VALUE) (SZ_TOP + ((VALUE + Y_OFFSET) * Y_SCALE)) // stretches Y value to full screen height

// Function to find child offset relative to parent pos for centering inside
#define CENTER(PARENT_SIZE,CHILD_SIZE) (((PARENT_SIZE) / 2) - ((CHILD_SIZE) / 2))
