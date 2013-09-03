/*
 * Alternative to stringtable.csv which is simpler to install for the mission maker.
 * Alternative au stringtable.csv qui est plus simple à installer pour le créateur de mission.
 */

#include "R3F_ARTY_disable_enable.sqf"
#include "R3F_LOG_disable_enable.sqf"

#ifdef R3F_ARTY_enable
#include "R3F_ARTY\fr_strings_lang.sqf"
#endif

#ifdef R3F_LOG_enable
#include "R3F_LOG\fr_strings_lang.sqf"
#endif

STR_R3F_ARTY_LOG_nom_produit = "[R3F] Artillery and Logistic";