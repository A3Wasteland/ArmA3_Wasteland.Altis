// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Name: score_defines.hpp
//	@file Author: AgentRev

#define scoreGUI_idd 43001

#define scoreGUI_ID_Offset(ID) (ID * 100)

#define scoreGUI_PList_Length 10

#define scoreGUI_PListEntry(ID) (43100 + scoreGUI_ID_Offset(ID))
#define scoreGUI_PListEntry_BG(ID) (scoreGUI_PListEntry(ID) + 1)
#define scoreGUI_PListEntry_TColor(ID) (scoreGUI_PListEntry(ID) + 2)
#define scoreGUI_PListEntry_Rank(ID) (scoreGUI_PListEntry(ID) + 3)
#define scoreGUI_PListEntry_Name(ID) (scoreGUI_PListEntry(ID) + 4)
#define scoreGUI_PListEntry_PKills(ID) (scoreGUI_PListEntry(ID) + 5)
#define scoreGUI_PListEntry_AIKills(ID) (scoreGUI_PListEntry(ID) + 6)
#define scoreGUI_PListEntry_Deaths(ID) (scoreGUI_PListEntry(ID) + 7)
#define scoreGUI_PListEntry_Revives(ID) (scoreGUI_PListEntry(ID) + 8)
#define scoreGUI_PListEntry_Captures(ID) (scoreGUI_PListEntry(ID) + 9)

#define scoreGUI_PRespawnTimer 49501
#define scoreGUI_PRespawnTimerText 49502

#define scoreGUI_TList_Length 5

#define scoreGUI_TListEntry(ID) (46100 + scoreGUI_ID_Offset(ID))
#define scoreGUI_TListEntry_BG(ID) (scoreGUI_TListEntry(ID) + 1)
#define scoreGUI_TListEntry_TColor(ID) (scoreGUI_TListEntry(ID) + 2)
#define scoreGUI_TListEntry_Rank(ID) (scoreGUI_TListEntry(ID) + 3)
#define scoreGUI_TListEntry_Name(ID) (scoreGUI_TListEntry(ID) + 4)
#define scoreGUI_TListEntry_PKills(ID) (scoreGUI_TListEntry(ID) + 5)
#define scoreGUI_TListEntry_Deaths(ID) (scoreGUI_TListEntry(ID) + 6)
#define scoreGUI_TListEntry_Territories(ID) (scoreGUI_TListEntry(ID) + 7)

#define scoreGUI_Entry_BGColor_Default 0, 0, 0, 0.4
#define scoreGUI_Entry_BGColor_Default2 0.1, 0.1, 0.1, 0.4
#define scoreGUI_Entry_BGColor_Player 1, 0.7, 0.1, 0.4 // 0.6, 0.55, 0.1, 0.4
#define scoreGUI_Entry_BGColor_Group 0.2, 0.4, 0.1, 0.4
