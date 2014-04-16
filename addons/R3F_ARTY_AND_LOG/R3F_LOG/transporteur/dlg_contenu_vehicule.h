/**
 * Interface d'affichage du contenu du véhicule
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "dlg_constantes.h"

class R3F_LOG_dlg_contenu_vehicule
{
	idd = R3F_LOG_IDD_dlg_contenu_vehicule;
	name = "R3F_LOG_dlg_contenu_vehicule";
	movingEnable = false;
	
	controlsBackground[] = {R3F_LOG_dlg_CV_arriere_plan};
	objects[] = {};
	controls[] =
	{
		R3F_LOG_dlg_CV_titre,
		
		R3F_LOG_dlg_CV_capacite_vehicule,
		R3F_LOG_dlg_CV_liste_contenu,
		
		R3F_LOG_dlg_CV_credits,
		R3F_LOG_dlg_CV_btn_decharger,
		R3F_LOG_dlg_CV_btn_fermer
	};
	
	// Définition des classes de base
	class R3F_LOG_dlg_CV_texte
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_LEFT;
		x = 0.0; w = 0.3;
		y = 0.0; h = 0.03;
		sizeEx = 0.023;
		colorBackground[] = {0.5, 0.5, 0.5, 0};
		colorText[] = {0.85, 0.85, 0.85, 1};
		font = "PuristaMedium";
		text = "";
	};
	
	class R3F_LOG_dlg_CV_btn
	{
		idc = -1;
		type = 16;
		style = 0;
		
		text = "btn";
		action = "";
		
		x = 0;
		y = 0;
		
		w = 0.23;
		h = 0.11;
		
		size = 0.03921;
		sizeEx = 0.03921;
		
		color[] = {0.543, 0.5742, 0.4102, 1.0};
		color2[] = {0.95, 0.95, 0.95, 1};
		colorFocused[] = {0.543, 0.5742, 0.4102, 1.0};
		colorBackground[] = {1, 1, 1, 1};
		colorbackground2[] = {1, 1, 1, 0.4};
		colorBackgroundFocused[] = {1, 1, 1, 1};
		colorDisabled[] = {1, 1, 1, 0.25};
		periodFocus = 1.2;
		periodOver = 0.8;
		
		class HitZone 
		{
			left = 0.004;
			top = 0.029;
			right = 0.004;
			bottom = 0.029;
		};
		
		class ShortcutPos 
		{
			left = 0.0145;
			top = 0.026;
			w = 0.0392157;
			h = 0.0522876;
		};
		
		class TextPos 
		{
			left = 0.05;
			top = 0.019;
			right = 0.005;
			bottom = 0.005;
		};
		
		textureNoShortcut = "";
		animTextureNormal = "client\ui\igui_button_normal_ca.paa";
		animTextureDisabled = "client\ui\igui_button_disabled_ca.paa";
		animTextureOver = "client\ui\igui_button_over_ca.paa";
		animTextureFocused = "client\ui\igui_button_focus_ca.paa";
		animTexturePressed = "client\ui\igui_button_down_ca.paa";
		animTextureDefault = "client\ui\igui_button_normal_ca.paa";
		period = 0.4;
		font = "PuristaMedium";
		
		soundEnter[] = {"\A3\ui_f\data\Sound\MOUSE2", 0.09, 1};
		soundPush[] = {"\A3\ui_f\data\Sound\NEW1", 0.09, 1};
		soundClick[] = {"\A3\ui_f\data\Sound\MOUSE3", 0.07, 1};
		soundEscape[] = {"\A3\ui_f\data\Sound\MOUSE1", 0.09, 1};
		
		class Attributes 
		{
			font = "PuristaMedium";
			color = "#E5E5E5";
			align = "left";
			shadow = "true";
		};
		
		class AttributesImage 
		{
			font = "PuristaMedium";
			color = "#E5E5E5";
			align = "left";
			shadow = "true";
		};
	};
	
	class R3F_LOG_dlg_CV_liste
	{
		type = CT_LISTBOX;
		style = ST_LEFT;
		idc = -1;
		text = "";
		w = 0.275;
		h = 0.04;
		colorSelect[] = {1, 1, 1, 1};
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0.5,0.5,0.5,1};
		colorSelectBackground[] = {0, 0, 0, 1};
		colorScrollbar[] = {0.2, 0.2, 0.2, 1};
		arrowEmpty = "client\ui\ui_arrow_combo_ca.paa";
        arrowFull = "client\ui\ui_arrow_combo_active_ca.paa";
		wholeHeight = 0.45;
		rowHeight = 0.06;
		color[] = {0.8, 0.8, 0.8, 1};
		colorActive[] = {0,0,0,1};
		colorDisabled[] = {0,0,0,0.3};
		font = "PuristaMedium";
		sizeEx = 0.035;
		soundSelect[] = {"",0.1,1};
		soundExpand[] = {"",0.1,1};
		soundCollapse[] = {"",0.1,1};
		maxHistoryDelay = 1;
		autoScrollSpeed = -1;
		autoScrollDelay = 5;
		autoScrollRewind = 0;
		
		class ListScrollBar
		{
			color[] = {1, 1, 1, 0.6};
			colorActive[] = {1, 1, 1, 1};
			colorDisabled[] = {1, 1, 1, 0.3};
			thumb = "client\ui\ui_scrollbar_thumb_ca.paa";
			arrowFull = "client\ui\ui_arrow_top_active_ca.paa";
			arrowEmpty = "client\ui\ui_arrow_top_ca.paa";
			border = "client\ui\ui_border_scroll_ca.paa";
		};
	};
	// FIN Définition des classes de base
	
	
	class R3F_LOG_dlg_CV_arriere_plan
	{
		/*idc = -1;
		type = CT_STATIC;
		style = ST_PICTURE;*/
		x = 0.2375; w = 0.5;
		y = 0.1; h = 0.68;
		/*colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		text = "\ca\ui\data\ui_gameoptions_background_ca.paa";
		font = "PuristaMedium";
		sizeEx = 0.032;*/
		colorBackground[] = {0, 0, 0, 0.6};
		text              = "";
		type              = CT_STATIC;
		idc               = -1;
		style             = ST_LEFT;
		font              = "PuristaMedium";
		colorText[]       = {1, 1, 1, 1};
		sizeEx            = 0.04;
	};
	
	class R3F_LOG_dlg_CV_titre : R3F_LOG_dlg_CV_texte
	{
		idc = R3F_LOG_IDC_dlg_CV_titre;
		x = 0.28; w = 0.4;
		y = 0.125; h = 0.05;
		sizeEx = 0.05;
		text = "";
	};
	
	class R3F_LOG_dlg_CV_capacite_vehicule : R3F_LOG_dlg_CV_texte
	{
		idc = R3F_LOG_IDC_dlg_CV_capacite_vehicule;
		x = 0.255; w = 0.4;
		y = 0.185; h = 0.03;
		sizeEx = 0.03;
		text = "";
	};
	
	class R3F_LOG_dlg_CV_liste_contenu : R3F_LOG_dlg_CV_liste
	{
		idc = R3F_LOG_IDC_dlg_CV_liste_contenu;
		x = 0.26; w = 0.45;
		y = 0.22; h = 0.44;
		onLBDblClick = "execVM ""addons\R3F_ARTY_AND_LOG\R3F_LOG\transporteur\decharger.sqf"";";
	};
	
	class R3F_LOG_dlg_CV_credits : R3F_LOG_dlg_CV_texte
	{
		idc = R3F_LOG_IDC_dlg_CV_credits;
		x = 0.250; w = 0.19;
		y = 0.737; h = 0.02;
		sizeEx = 0.02;
		colorText[] = {0.5, 0.5, 0.5, 0.75};
		text = "";
	};
	
	class R3F_LOG_dlg_CV_btn_decharger : R3F_LOG_dlg_CV_btn
	{
		idc = R3F_LOG_IDC_dlg_CV_btn_decharger;
		x = 0.355; w = 0.18;
		y = 0.66;
		sizeEx = 0.02;
		text = "";
		action = "execVM ""addons\R3F_ARTY_AND_LOG\R3F_LOG\transporteur\decharger.sqf"";";
	};
	
	class R3F_LOG_dlg_CV_btn_fermer : R3F_LOG_dlg_CV_btn
	{
		idc = R3F_LOG_IDC_dlg_CV_btn_fermer;
		x = 0.537; w = 0.16;
		y = 0.66;
		text = "";
		action = "closeDialog 0;"; 
	};
};