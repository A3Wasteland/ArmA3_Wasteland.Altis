// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2017 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: killFeed_defines.hpp
//	@file Author: AgentRev

#define A3W_killFeed_IDD 42001
#define A3W_killFeed_feedText_IDC 1000

#define A3W_killFeedMenu_IDD 8923

#define A3W_killFeedMenu_RefreshButton_IDC 10
#define A3W_killFeedMenu_ResetButton_IDC 11

#define A3W_killFeedMenu_MaxKillsSlider_IDC 101
#define A3W_killFeedMenu_MaxKillsEdit_IDC 102
#define A3W_killFeedMenu_FadeTimeSlider_IDC 111
#define A3W_killFeedMenu_FadeTimeEdit_IDC 112
#define A3W_killFeedMenu_ShowIconsCheck_IDC 121
#define A3W_killFeedMenu_ShowChatCheck_IDC 131
#define A3W_killFeedMenu_OffsetXSlider_IDC 141
#define A3W_killFeedMenu_OffsetXEdit_IDC 142
#define A3W_killFeedMenu_OffsetYSlider_IDC 151
#define A3W_killFeedMenu_OffsetYEdit_IDC 152
#define A3W_killFeedMenu_OpacitySlider_IDC 161
#define A3W_killFeedMenu_OpacityEdit_IDC 162

#define A3W_killFeedMenu_LogList_IDC 1000
#define A3W_killFeedMenu_LogLimitList_IDC 1001


#define A3W_killFeed_maxKills_defaultVal 10
#define A3W_killFeed_fadeTime_defaultVal 60
#define A3W_killFeed_showIcons_defaultVal true
#define A3W_killFeed_showChat_defaultVal false
#define A3W_killFeed_offsetX_defaultVal 0
#define A3W_killFeed_offsetY_defaultVal 0
#define A3W_killFeed_opacity_defaultVal 0.75

#define A3W_killFeed_selfColorArr [1,0.85,0,1] // gold
#define A3W_killFeed_selfColorHex "#FFD900" // gold
#define A3W_killFeed_groupColorArr [0.45,0.85,0.35,1] // green
#define A3W_killFeed_groupColorHex "#73D959" // green
#define A3W_killFeed_textColorHex(TXT,HEX) (format ["<t color='%1'>%2</t>", HEX, TXT])
