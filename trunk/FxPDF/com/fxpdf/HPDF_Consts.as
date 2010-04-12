/*
Copyright 2010 FxPDF.com

FxPDF is based on libHaru code originally developed & maintained by Takeshi Kanno (libHaru.org). 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package com.fxpdf
{
	import com.fxpdf.types.HPDF_LineCap;
	import com.fxpdf.types.HPDF_PageLayout;
	import com.fxpdf.types.HPDF_PageMode;
	import com.fxpdf.types.enum.HPDF_LineJoin;
	import com.fxpdf.types.enum.HPDF_TextRenderingMode;
	
	public class HPDF_Consts
	{
		public function HPDF_Consts()
		{
		}
		
		

		public	static	const	HPDF_TRUE : Number	=	1;
		public	static	const	HPDF_FALSE : Number	=	0;
		
		public	static	const	HPDF_OK	: Number	=	0	;
		public	static	const	HPDF_NOERROR	: Number	=	0;
		
		/*----- default values -------------------------------------------------------*/
		/* buffer size which is required when we convert to character string. */
		public	static	const	HPDF_TMP_BUF_SIZ : Number	=	            512;
		public	static	const	HPDF_SHORT_BUF_SIZ : Number	=	          32;
		public	static	const	HPDF_REAL_LEN : Number	=	               11;
		public	static	const	HPDF_INT_LEN : Number	=	               11;
		public	static	const	HPDF_TEXT_DEFAULT_LEN : Number	=	       256;
		public	static	const	HPDF_UNICODE_HEADER_LEN : Number	=	     2;
		public	static	const	HPDF_DATE_TIME_STR_LEN : Number	=	      23;
		
		/* length of each item defined in PDF */
		public	static	const	HPDF_BYTE_OFFSET_LEN : Number	=	        10;
		public	static	const	HPDF_OBJ_ID_LEN : Number	=	             7;
		public	static	const	HPDF_GEN_NO_LEN  : Number	=	            5;
		
		/* default value of Graphic State */
		public	static	const	HPDF_DEF_FONT  : String	=	             "Helvetica";
		public	static	const	HPDF_DEF_PAGE_LAYOUT : Number	=	        HPDF_PageLayout.HPDF_PAGE_LAYOUT_SINGLE;
		public	static	const	HPDF_DEF_PAGE_MODE  : Number	=	         HPDF_PageMode.HPDF_PAGE_MODE_USE_NONE;
		public	static	const	HPDF_DEF_WORDSPACE : Number	=	          0;
		public	static	const	HPDF_DEF_CHARSPACE  : Number	=	         0;
		public	static	const	HPDF_DEF_FONTSIZE  : Number	=	          10;
		public	static	const	HPDF_DEF_HSCALING  : Number	=	          100;
		public	static	const	HPDF_DEF_LEADING  : Number	=	           0;
		public	static	const	HPDF_DEF_RENDERING_MODE  : Number	=	    HPDF_TextRenderingMode.HPDF_FILL;
		public	static	const	HPDF_DEF_RISE  : Number	=	              0;
		public	static	const	HPDF_DEF_RAISE  : Number	=	             HPDF_DEF_RISE;
		public	static	const	HPDF_DEF_LINEWIDTH    : Number	=	       1;
		public	static	const	HPDF_DEF_LINECAP  : Number	=	           HPDF_LineCap.HPDF_BUTT_END;
		public	static	const	HPDF_DEF_LINEJOIN  : Number	=	         HPDF_LineJoin.HPDF_MITER_JOIN;
		public	static	const	HPDF_DEF_MITERLIMIT  : Number	=	        10;
		public	static	const	HPDF_DEF_FLATNESS  : Number	=	          1;
		public	static	const	HPDF_DEF_PAGE_NUM   : Number	=	         1;
		
		public	static	const	HPDF_BS_DEF_WIDTH : Number	=	           1;
		
		/* defalt page-size */
		public	static	const	HPDF_DEF_PAGE_WIDTH  : Number	=	        595.276;
		public	static	const	HPDF_DEF_PAGE_HEIGHT   : Number	=	      841.89;
		
		/*---------------------------------------------------------------------------*/
		/*----- compression mode ----------------------------------------------------*/
		
		public	static	const	 HPDF_COMP_NONE  : Number	=	           0x00 ;
		public	static	const	 HPDF_COMP_TEXT   : Number	=	          0x01;
		public	static	const	 HPDF_COMP_IMAGE   : Number	=	         0x02;
		public	static	const	 HPDF_COMP_METADATA   : Number	=	      0x04;
		public	static	const	 HPDF_COMP_ALL     : Number	=	         0x0F;
		/* public	static	const	 HPDF_COMP_BEST_COMPRESS   0x10
		 * public	static	const	 HPDF_COMP_BEST_SPEED      0x20
		 */
		public	static	const	 HPDF_COMP_MASK     : Number	=	     0xFF ;

		
		/*----------------------------------------------------------------------------*/
		/*----- permission flags (only Revision 2 is supported)-----------------------*/
		
		public static const HPDF_ENABLE_READ      : Number =     0;
		public static const HPDF_ENABLE_PRINT     : Number =     4;
		public static const HPDF_ENABLE_EDIT_ALL  : Number =     8;
		public static const HPDF_ENABLE_COPY      : Number =     16;
		public static const HPDF_ENABLE_EDIT      : Number =     32;
		
		
		/*----------------------------------------------------------------------------*/
		/*------ viewer preferences definitions --------------------------------------*/
		
		public static const HPDF_HIDE_TOOLBAR : Number =        1;
		public static const HPDF_HIDE_MENUBAR : Number =        2;
		public static const HPDF_HIDE_WINDOW_UI : Number =      4;
		public static const HPDF_FIT_WINDOW    : Number =       8;
		public static const HPDF_CENTER_WINDOW  : Number =      16 ;
				

		
		
		/*---------------------------------------------------------------------------*/
		/*------ limitation of object implementation (PDF1.4) -----------------------*/
		
		public	static	const	HPDF_LIMIT_MAX_INT : Number			=	            2147483647;
		public	static	const	HPDF_LIMIT_MIN_INT : Number	=             -2147483647;
		
		public	static	const	HPDF_LIMIT_MAX_REAL : Number	=            32767;
		public	static	const	HPDF_LIMIT_MIN_REAL : Number	=            -32767;
		
		public	static	const	HPDF_LIMIT_MAX_STRING_LEN : Number	=      65535;
		public	static	const	HPDF_LIMIT_MAX_NAME_LEN : Number	=       127;
		
		public	static	const	HPDF_LIMIT_MAX_ARRAY : Number	=           8191;
		public	static	const	HPDF_LIMIT_MAX_DICT_ELEMENT : Number	=    4095;
		public	static	const	HPDF_LIMIT_MAX_XREF_ELEMENT : Number	=   8388607;
		public	static	const	HPDF_LIMIT_MAX_GSTATE : Number	=          28;
		public	static	const	HPDF_LIMIT_MAX_DEVICE_N  : Number =       8;
		public	static	const	HPDF_LIMIT_MAX_DEVICE_N_V15 : Number =    32;
		public	static	const	HPDF_LIMIT_MAX_CID : Number =             65535;
		public	static	const	HPDF_MAX_GENERATION_NUM : Number =        65535;
		
		public	static	const	HPDF_MIN_PAGE_HEIGHT : Number =           3;
		public	static	const	HPDF_MIN_PAGE_WIDTH : Number =            3;
		public	static	const	HPDF_MAX_PAGE_HEIGHT : Number =           14400;
		public	static	const	HPDF_MAX_PAGE_WIDTH : Number =            14400;
		public	static	const	HPDF_MIN_MAGNIFICATION_FACTOR : Number =  8;
		public	static	const	HPDF_MAX_MAGNIFICATION_FACTOR : Number =  3200;
		
		/*---------------------------------------------------------------------------*/
		/*------ limitation of various properties -----------------------------------*/
		
		public static const HPDF_MIN_PAGE_SIZE  : Number =          3;
		public static const HPDF_MAX_PAGE_SIZE : Number =           14400;
		public static const HPDF_MIN_HORIZONTALSCALING : Number =   10;
		public static const HPDF_MAX_HORIZONTALSCALING : Number =   300;
		public static const HPDF_MIN_WORDSPACE    : Number =        -30;
		public static const HPDF_MAX_WORDSPACE  : Number =          300;
		public static const HPDF_MIN_CHARSPACE  : Number =          -30;
		public static const HPDF_MAX_CHARSPACE   : Number =         300;
		public static const HPDF_MAX_FONTSIZE    : Number =         300;
		public static const HPDF_MAX_ZOOMSIZE    : Number =         10;
		public static const HPDF_MAX_LEADING     : Number =         300;
		public static const HPDF_MAX_LINEWIDTH   : Number =         100;
		public static const HPDF_MAX_DASH_PATTERN  : Number =       100;
		
		public static const HPDF_MAX_JWW_NUM    : Number =          128 ;
		
		/*----------------------------------------------------------------------------*/
		/*----- country code definition ----------------------------------------------*/
		
		public static const HPDF_COUNTRY_AF : String =  "AF"    ; /* AFGHANISTAN */
		public static const HPDF_COUNTRY_AL : String =  "AL"    ; /* ALBANIA */
		public static const HPDF_COUNTRY_DZ : String =  "DZ"    ; /* ALGERIA */
		public static const HPDF_COUNTRY_AS : String =  "AS"    ; /* AMERICAN SAMOA */
		public static const HPDF_COUNTRY_AD : String =  "AD"    ; /* ANDORRA */
		public static const HPDF_COUNTRY_AO : String =  "AO"    ; /* ANGOLA */
		public static const HPDF_COUNTRY_AI : String =  "AI"    ; /* ANGUILLA */
		public static const HPDF_COUNTRY_AQ : String =  "AQ"    ; /* ANTARCTICA */
		public static const HPDF_COUNTRY_AG : String =  "AG"    ; /* ANTIGUA AND BARBUDA */
		public static const HPDF_COUNTRY_AR : String =  "AR"    ; /* ARGENTINA */
		public static const HPDF_COUNTRY_AM : String = "AM"    ; /* ARMENIA */
		public static const HPDF_COUNTRY_AW : String =  "AW"    ; /* ARUBA */
		public static const HPDF_COUNTRY_AU : String =  "AU"    ; /* AUSTRALIA */
		public static const HPDF_COUNTRY_AT : String =  "AT"    ; /* AUSTRIA */
		public static const HPDF_COUNTRY_AZ : String =  "AZ"    ; /* AZERBAIJAN */
		public static const HPDF_COUNTRY_BS : String =  "BS"    ; /* BAHAMAS */
		public static const HPDF_COUNTRY_BH : String =  "BH"    ; /* BAHRAIN */
		public static const HPDF_COUNTRY_BD : String =  "BD"    ; /* BANGLADESH */
		public static const HPDF_COUNTRY_BB : String =  "BB"    ; /* BARBADOS */
		public static const HPDF_COUNTRY_BY : String =  "BY"    ; /* BELARUS */
		public static const HPDF_COUNTRY_BE : String =  "BE"    ; /* BELGIUM */
		public static const HPDF_COUNTRY_BZ : String =  "BZ"    ; /* BELIZE */
		public static const HPDF_COUNTRY_BJ : String =  "BJ"    ; /* BENIN */
		public static const HPDF_COUNTRY_BM : String =  "BM"    ; /* BERMUDA */
		public static const HPDF_COUNTRY_BT : String =  "BT"    ; /* BHUTAN */
		public static const HPDF_COUNTRY_BO : String =  "BO"    ; /* BOLIVIA */
		public static const HPDF_COUNTRY_BA : String =  "BA"    ; /* BOSNIA AND HERZEGOWINA */
		public static const HPDF_COUNTRY_BW  : String = "BW"    ; /* BOTSWANA */
		public static const HPDF_COUNTRY_BV : String =  "BV"    ; /* BOUVET ISLAND */
		public static const HPDF_COUNTRY_BR : String =  "BR"    ; /* BRAZIL */
		public static const HPDF_COUNTRY_IO : String =  "IO"    ; /* BRITISH INDIAN OCEAN TERRITORY */
		public static const HPDF_COUNTRY_BN : String =  "BN"    ; /* BRUNEI DARUSSALAM */
		public static const HPDF_COUNTRY_BG : String =  "BG"    ; /* BULGARIA */
		public static const HPDF_COUNTRY_BF : String =  "BF"    ; /* BURKINA FASO */
		public static const HPDF_COUNTRY_BI : String =  "BI"    ; /* BURUNDI */
		public static const HPDF_COUNTRY_KH : String =  "KH"    ; /* CAMBODIA */
		public static const HPDF_COUNTRY_CM : String =  "CM"    ; /* CAMEROON */
		public static const HPDF_COUNTRY_CA : String =  "CA"    ; /* CANADA */
		public static const HPDF_COUNTRY_CV : String =  "CV"    ; /* CAPE VERDE */
		public static const HPDF_COUNTRY_KY : String =  "KY"    ; /* CAYMAN ISLANDS */
		public static const HPDF_COUNTRY_CF  : String = "CF"    ; /* CENTRAL AFRICAN REPUBLIC */
		public static const HPDF_COUNTRY_TD : String =  "TD"    ; /* CHAD */
		public static const HPDF_COUNTRY_CL : String =  "CL"    ; /* CHILE */
		public static const HPDF_COUNTRY_CN : String =  "CN"    ; /* CHINA */
		public static const HPDF_COUNTRY_CX : String =  "CX"    ; /* CHRISTMAS ISLAND */
		public static const HPDF_COUNTRY_CC : String =  "CC"    ; /* COCOS (KEELING) ISLANDS */
		public static const HPDF_COUNTRY_CO : String =  "CO"    ; /* COLOMBIA */
		public static const HPDF_COUNTRY_KM  : String = "KM"    ; /* COMOROS */
		public static const HPDF_COUNTRY_CG : String =  "CG"    ; /* CONGO */
		public static const HPDF_COUNTRY_CK : String =  "CK"    ; /* COOK ISLANDS */
		public static const HPDF_COUNTRY_CR : String =  "CR"    ; /* COSTA RICA */
		public static const HPDF_COUNTRY_CI : String =  "CI"    ; /* COTE D'IVOIRE */
		public static const HPDF_COUNTRY_HR : String =  "HR"    ; /* CROATIA (local name: Hrvatska) */
		public static const HPDF_COUNTRY_CU : String =  "CU"    ; /* CUBA */
		public static const HPDF_COUNTRY_CY : String =  "CY"    ; /* CYPRUS */
		public static const HPDF_COUNTRY_CZ : String =  "CZ"    ; /* CZECH REPUBLIC */
		public static const HPDF_COUNTRY_DK : String =  "DK"    ; /* DENMARK */
		public static const HPDF_COUNTRY_DJ : String =  "DJ"    ; /* DJIBOUTI */
		public static const HPDF_COUNTRY_DM : String =  "DM"    ; /* DOMINICA */
		public static const HPDF_COUNTRY_DO : String =  "DO"    ; /* DOMINICAN REPUBLIC */
		public static const HPDF_COUNTRY_TP : String =  "TP"    ; /* EAST TIMOR */
		public static const HPDF_COUNTRY_EC : String =  "EC"    ; /* ECUADOR */
		public static const HPDF_COUNTRY_EG : String =  "EG"    ; /* EGYPT */
		public static const HPDF_COUNTRY_SV : String =  "SV"    ; /* EL SALVADOR */
		public static const HPDF_COUNTRY_GQ : String =  "GQ"    ; /* EQUATORIAL GUINEA */
		public static const HPDF_COUNTRY_ER : String =  "ER"    ; /* ERITREA */
		public static const HPDF_COUNTRY_EE : String =  "EE"    ; /* ESTONIA */
		public static const HPDF_COUNTRY_ET : String =  "ET"    ; /* ETHIOPIA */
		public static const HPDF_COUNTRY_FK : String =  "FK"   ; /* FALKLAND ISLANDS (MALVINAS) */
		public static const HPDF_COUNTRY_FO : String =   "FO"    ; /* FAROE ISLANDS */
		public static const HPDF_COUNTRY_FJ : String =  "FJ"    ; /* FIJI */
		public static const HPDF_COUNTRY_FI : String =  "FI"    ; /* FINLAND */
		public static const HPDF_COUNTRY_FR : String =  "FR"    ; /* FRANCE */
		public static const HPDF_COUNTRY_FX : String =  "FX"    ; /* FRANCE, METROPOLITAN */
		public static const HPDF_COUNTRY_GF : String =  "GF"    ; /* FRENCH GUIANA */
		public static const HPDF_COUNTRY_PF : String =  "PF"    ; /* FRENCH POLYNESIA */
		public static const HPDF_COUNTRY_TF : String =  "TF"    ; /* FRENCH SOUTHERN TERRITORIES */
		public static const HPDF_COUNTRY_GA : String =  "GA"    ; /* GABON */
		public static const HPDF_COUNTRY_GM : String =  "GM"    ; /* GAMBIA */
		public static const HPDF_COUNTRY_GE : String =  "GE"    ; /* GEORGIA */
		public static const HPDF_COUNTRY_DE : String =  "DE"    ; /* GERMANY */
		public static const HPDF_COUNTRY_GH : String =  "GH"    ; /* GHANA */
		public static const HPDF_COUNTRY_GI : String =  "GI"    ; /* GIBRALTAR */
		public static const HPDF_COUNTRY_GR : String =  "GR"    ; /* GREECE */
		public static const HPDF_COUNTRY_GL : String =  "GL"    ; /* GREENLAND */
		public static const HPDF_COUNTRY_GD : String =  "GD"    ; /* GRENADA */
		public static const HPDF_COUNTRY_GP : String =  "GP"    ; /* GUADELOUPE */
		public static const HPDF_COUNTRY_GU : String =  "GU"    ; /* GUAM */
		public static const HPDF_COUNTRY_GT : String =  "GT"    ; /* GUATEMALA */
		public static const HPDF_COUNTRY_GN : String =  "GN"    ; /* GUINEA */
		public static const HPDF_COUNTRY_GW : String =  "GW"    ; /* GUINEA-BISSAU */
		public static const HPDF_COUNTRY_GY : String =  "GY"    ; /* GUYANA */
		public static const HPDF_COUNTRY_HT : String =  "HT"    ; /* HAITI */
		public static const HPDF_COUNTRY_HM : String =  "HM"    ; /* HEARD AND MC DONALD ISLANDS */
		public static const HPDF_COUNTRY_HN : String =  "HN"    ; /* HONDURAS */
		public static const HPDF_COUNTRY_HK : String =  "HK"    ; /* HONG KONG */
		public static const HPDF_COUNTRY_HU : String =  "HU"    ; /* HUNGARY */
		public static const HPDF_COUNTRY_IS : String =  "IS"    ; /* ICELAND */
		public static const HPDF_COUNTRY_IN : String =  "IN"    ; /* INDIA */
		public static const HPDF_COUNTRY_ID : String =  "ID"    ; /* INDONESIA */
		public static const HPDF_COUNTRY_IR : String =  "IR"    ; /* IRAN (ISLAMIC REPUBLIC OF) */
		public static const HPDF_COUNTRY_IQ : String =  "IQ"    ; /* IRAQ */
		public static const HPDF_COUNTRY_IE : String =  "IE"    ; /* IRELAND */
		public static const HPDF_COUNTRY_IL : String =  "IL"    ; /* ISRAEL */
		public static const HPDF_COUNTRY_IT : String =  "IT"    ; /* ITALY */
		public static const HPDF_COUNTRY_JM : String =  "JM"    ; /* JAMAICA */
		public static const HPDF_COUNTRY_JP : String =  "JP"    ; /* JAPAN */
		public static const HPDF_COUNTRY_JO : String =  "JO"    ; /* JORDAN */
		public static const HPDF_COUNTRY_KZ : String =  "KZ"    ; /* KAZAKHSTAN */
		public static const HPDF_COUNTRY_KE : String =  "KE"    ; /* KENYA */
		public static const HPDF_COUNTRY_KI : String =  "KI"    ; /* KIRIBATI */
		public static const HPDF_COUNTRY_KP: String =   "KP"    ; /* KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF */
		public static const HPDF_COUNTRY_KR : String =  "KR"    ; /* KOREA, REPUBLIC OF */
		public static const HPDF_COUNTRY_KW : String =  "KW"    ; /* KUWAIT */
		public static const HPDF_COUNTRY_KG : String =  "KG"    ; /* KYRGYZSTAN */
		public static const HPDF_COUNTRY_LA : String =  "LA"    ; /* LAO PEOPLE'S DEMOCRATIC REPUBLIC */
		public static const HPDF_COUNTRY_LV : String =  "LV"    ; /* LATVIA */
		public static const HPDF_COUNTRY_LB : String =  "LB"    ; /* LEBANON */
		public static const HPDF_COUNTRY_LS : String =  "LS"    ; /* LESOTHO */
		public static const HPDF_COUNTRY_LR : String =  "LR"    ; /* LIBERIA */
		public static const HPDF_COUNTRY_LY : String =  "LY"    ; /* LIBYAN ARAB JAMAHIRIYA */
		public static const HPDF_COUNTRY_LI : String =  "LI"    ; /* LIECHTENSTEIN */
		public static const HPDF_COUNTRY_LT : String =  "LT"    ; /* LITHUANIA */
		public static const HPDF_COUNTRY_LU : String =  "LU"    ; /* LUXEMBOURG */
		public static const HPDF_COUNTRY_MO : String =  "MO"    ; /* MACAU */
		public static const HPDF_COUNTRY_MK : String =  "MK"   ; /* MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF */
		public static const HPDF_COUNTRY_MG : String =  "MG"    ; /* MADAGASCAR */
		public static const HPDF_COUNTRY_MW : String =  "MW"    ; /* MALAWI */
		public static const HPDF_COUNTRY_MY : String =  "MY"    ; /* MALAYSIA */
		public static const HPDF_COUNTRY_MV : String =  "MV"    ; /* MALDIVES */
		public static const HPDF_COUNTRY_ML : String =  "ML"    ; /* MALI */
		public static const HPDF_COUNTRY_MT : String =  "MT"    ; /* MALTA */
		public static const HPDF_COUNTRY_MH: String =   "MH"    ; /* MARSHALL ISLANDS */
		public static const HPDF_COUNTRY_MQ : String =  "MQ"    ; /* MARTINIQUE */
		public static const HPDF_COUNTRY_MR : String =  "MR"    ; /* MAURITANIA */
		public static const HPDF_COUNTRY_MU : String =  "MU"    ; /* MAURITIUS */
		public static const HPDF_COUNTRY_YT : String =  "YT"    ; /* MAYOTTE */
		public static const HPDF_COUNTRY_MX : String =  "MX"    ; /* MEXICO */
		public static const HPDF_COUNTRY_FM  : String = "FM"    ; /* MICRONESIA, FEDERATED STATES OF */
		public static const HPDF_COUNTRY_MD : String =  "MD"    ; /* MOLDOVA, REPUBLIC OF */
		public static const HPDF_COUNTRY_MC : String =  "MC"    ; /* MONACO */
		public static const HPDF_COUNTRY_MN : String =  "MN"    ; /* MONGOLIA */
		public static const HPDF_COUNTRY_MS : String =  "MS"    ; /* MONTSERRAT */
		public static const HPDF_COUNTRY_MA : String =  "MA"    ; /* MOROCCO */
		public static const HPDF_COUNTRY_MZ : String =  "MZ"    ; /* MOZAMBIQUE */
		public static const HPDF_COUNTRY_MM: String =   "MM"    ; /* MYANMAR */
		public static const HPDF_COUNTRY_NA : String =  "NA"    ; /* NAMIBIA */
		public static const HPDF_COUNTRY_NR : String =  "NR"    ; /* NAURU */
		public static const HPDF_COUNTRY_NP : String =  "NP"    ; /* NEPAL */
		public static const HPDF_COUNTRY_NL : String =  "NL"    ; /* NETHERLANDS */
		public static const HPDF_COUNTRY_AN : String =  "AN"    ; /* NETHERLANDS ANTILLES */
		public static const HPDF_COUNTRY_NC : String =  "NC"    ; /* NEW CALEDONIA */
		public static const HPDF_COUNTRY_NZ : String =  "NZ"    ; /* NEW ZEALAND */
		public static const HPDF_COUNTRY_NI : String =  "NI"    ; /* NICARAGUA */
		public static const HPDF_COUNTRY_NE : String =  "NE"    ; /* NIGER */
		public static const HPDF_COUNTRY_NG : String =  "NG"    ; /* NIGERIA */
		public static const HPDF_COUNTRY_NU : String =  "NU"    ; /* NIUE */
		public static const HPDF_COUNTRY_NF : String =  "NF"    ; /* NORFOLK ISLAND */
		public static const HPDF_COUNTRY_MP : String =  "MP"    ; /* NORTHERN MARIANA ISLANDS */
		public static const HPDF_COUNTRY_NO : String =  "NO"    ; /* NORWAY */
		public static const HPDF_COUNTRY_OM : String =  "OM"    ; /* OMAN */
		public static const HPDF_COUNTRY_PK : String =  "PK"    ; /* PAKISTAN */
		public static const HPDF_COUNTRY_PW : String =  "PW"    ; /* PALAU */
		public static const HPDF_COUNTRY_PA : String =  "PA"    ; /* PANAMA */
		public static const HPDF_COUNTRY_PG : String =  "PG"    ; /* PAPUA NEW GUINEA */
		public static const HPDF_COUNTRY_PY : String =  "PY"    ; /* PARAGUAY */
		public static const HPDF_COUNTRY_PE : String =  "PE"    ; /* PERU */
		public static const HPDF_COUNTRY_PH : String =  "PH"    ; /* PHILIPPINES */
		public static const HPDF_COUNTRY_PN : String =  "PN"    ; /* PITCAIRN */
		public static const HPDF_COUNTRY_PL : String =  "PL"    ; /* POLAND */
		public static const HPDF_COUNTRY_PT : String =  "PT"    ; /* PORTUGAL */
		public static const HPDF_COUNTRY_PR : String =  "PR"    ; /* PUERTO RICO */
		public static const HPDF_COUNTRY_QA : String =  "QA"    ; /* QATAR */
		public static const HPDF_COUNTRY_RE : String =  "RE"    ; /* REUNION */
		public static const HPDF_COUNTRY_RO : String =  "RO"    ; /* ROMANIA */
		public static const HPDF_COUNTRY_RU : String =  "RU"    ; /* RUSSIAN FEDERATION */
		public static const HPDF_COUNTRY_RW : String =  "RW"    ; /* RWANDA */
		public static const HPDF_COUNTRY_KN : String =  "KN"    ; /* SAINT KITTS AND NEVIS */
		public static const HPDF_COUNTRY_LC : String =  "LC"    ; /* SAINT LUCIA */
		public static const HPDF_COUNTRY_VC : String =  "VC"    ; /* SAINT VINCENT AND THE GRENADINES */
		public static const HPDF_COUNTRY_WS : String =  "WS"    ; /* SAMOA */
		public static const HPDF_COUNTRY_SM : String =  "SM"    ; /* SAN MARINO */
		public static const HPDF_COUNTRY_ST : String =  "ST"    ; /* SAO TOME AND PRINCIPE */
		public static const HPDF_COUNTRY_SA : String =  "SA"    ; /* SAUDI ARABIA */
		public static const HPDF_COUNTRY_SN : String =  "SN"    ; /* SENEGAL */
		public static const HPDF_COUNTRY_SC : String =  "SC"    ; /* SEYCHELLES */
		public static const HPDF_COUNTRY_SL : String =  "SL"    ; /* SIERRA LEONE */
		public static const HPDF_COUNTRY_SG : String =  "SG"    ; /* SINGAPORE */
		public static const HPDF_COUNTRY_SK : String =  "SK"    ; /* SLOVAKIA (Slovak Republic) */
		public static const HPDF_COUNTRY_SI : String =  "SI"    ; /* SLOVENIA */
		public static const HPDF_COUNTRY_SB : String =  "SB"    ; /* SOLOMON ISLANDS */
		public static const HPDF_COUNTRY_SO : String =  "SO"    ; /* SOMALIA */
		public static const HPDF_COUNTRY_ZA : String =  "ZA"    ; /* SOUTH AFRICA */
		public static const HPDF_COUNTRY_ES : String =  "ES"    ; /* SPAIN */
		public static const HPDF_COUNTRY_LK : String =  "LK"    ; /* SRI LANKA */
		public static const HPDF_COUNTRY_SH : String =  "SH"    ; /* ST. HELENA */
		public static const HPDF_COUNTRY_PM : String =  "PM"    ; /* ST. PIERRE AND MIQUELON */
		public static const HPDF_COUNTRY_SD : String =  "SD"    ; /* SUDAN */
		public static const HPDF_COUNTRY_SR : String =  "SR"    ; /* SURINAME */
		public static const HPDF_COUNTRY_SJ : String =  "SJ"    ; /* SVALBARD AND JAN MAYEN ISLANDS */
		public static const HPDF_COUNTRY_SZ : String =  "SZ"    ; /* SWAZILAND */
		public static const HPDF_COUNTRY_SE : String =  "SE"    ; /* SWEDEN */
		public static const HPDF_COUNTRY_CH : String =  "CH"    ; /* SWITZERLAND */
		public static const HPDF_COUNTRY_SY : String =  "SY"    ; /* SYRIAN ARAB REPUBLIC */
		public static const HPDF_COUNTRY_TW : String =  "TW"    ; /* TAIWAN, PROVINCE OF CHINA */
		public static const HPDF_COUNTRY_TJ : String =  "TJ"    ; /* TAJIKISTAN */
		public static const HPDF_COUNTRY_TZ : String =  "TZ"    ; /* TANZANIA, UNITED REPUBLIC OF */
		public static const HPDF_COUNTRY_TH : String =  "TH"    ; /* THAILAND */
		public static const HPDF_COUNTRY_TG : String =  "TG"    ; /* TOGO */
		public static const HPDF_COUNTRY_TK : String =  "TK"    ; /* TOKELAU */
		public static const HPDF_COUNTRY_TO : String =  "TO"    ; /* TONGA */
		public static const HPDF_COUNTRY_TT : String =  "TT"    ; /* TRINIDAD AND TOBAGO */
		public static const HPDF_COUNTRY_TN  : String = "TN"    ; /* TUNISIA */
		public static const HPDF_COUNTRY_TR: String =   "TR"    ; /* TURKEY */
		public static const HPDF_COUNTRY_TM : String =  "TM"    ; /* TURKMENISTAN */
		public static const HPDF_COUNTRY_TC  : String = "TC"    ; /* TURKS AND CAICOS ISLANDS */
		public static const HPDF_COUNTRY_TV : String =  "TV"    ; /* TUVALU */
		public static const HPDF_COUNTRY_UG : String =  "UG"    ; /* UGANDA */
		public static const HPDF_COUNTRY_UA : String =  "UA"    ; /* UKRAINE */
		public static const HPDF_COUNTRY_AE : String =  "AE"    ; /* UNITED ARAB EMIRATES */
		public static const HPDF_COUNTRY_GB : String =  "GB"    ; /* UNITED KINGDOM */
		public static const HPDF_COUNTRY_US : String =  "US"    ; /* UNITED STATES */
		public static const HPDF_COUNTRY_UM : String =  "UM"    ; /* UNITED STATES MINOR OUTLYING ISLANDS */
		public static const HPDF_COUNTRY_UY : String =  "UY"    ; /* URUGUAY */
		public static const HPDF_COUNTRY_UZ : String =  "UZ"    ; /* UZBEKISTAN */
		public static const HPDF_COUNTRY_VU : String =  "VU"    ; /* VANUATU */
		public static const HPDF_COUNTRY_VA : String =  "VA"    ; /* VATICAN CITY STATE (HOLY SEE) */
		public static const HPDF_COUNTRY_VE  : String = "VE"    ; /* VENEZUELA */
		public static const HPDF_COUNTRY_VN : String =  "VN"    ; /* VIET NAM */
		public static const HPDF_COUNTRY_VG: String =   "VG"    ; /* VIRGIN ISLANDS (BRITISH) */
		public static const HPDF_COUNTRY_VI : String =  "VI"    ; /* VIRGIN ISLANDS (U.S.) */
		public static const HPDF_COUNTRY_WF : String =  "WF"    ; /* WALLIS AND FUTUNA ISLANDS */
		public static const HPDF_COUNTRY_EH : String =  "EH"    ; /* WESTERN SAHARA */
		public static const HPDF_COUNTRY_YE : String =  "YE"    ; /* YEMEN */
		public static const HPDF_COUNTRY_YU : String =  "YU"    ; /* YUGOSLAVIA */
		public static const HPDF_COUNTRY_ZR : String =  "ZR"    ; /* ZAIRE */
		public static const HPDF_COUNTRY_ZM : String =  "ZM"    ; /* ZAMBIA */
		public static const HPDF_COUNTRY_ZW  : String = "ZW"    ; /* ZIMBABWE */
		
		/*----------------------------------------------------------------------------*/
		/*----- lang code definition -------------------------------------------------*/
		
		public static const HPDF_LANG_AA  : String =   "aa"     ; /* Afar */
		public static const HPDF_LANG_AB  : String =   "ab"     ; /* Abkhazian */
		public static const HPDF_LANG_AF  : String =   "af"     ; /* Afrikaans */
		public static const HPDF_LANG_AM  : String =   "am"     ; /* Amharic */
		public static const HPDF_LANG_AR  : String =   "ar"     ; /* Arabic */
		public static const HPDF_LANG_AS  : String =   "as"     ; /* Assamese */
		public static const HPDF_LANG_AY  : String =   "ay"     ; /* Aymara */
		public static const HPDF_LANG_AZ  : String =   "az"     ; /* Azerbaijani */
		public static const HPDF_LANG_BA  : String =   "ba"     ; /* Bashkir */
		public static const HPDF_LANG_BE  : String =   "be"     ; /* Byelorussian */
		public static const HPDF_LANG_BG  : String =   "bg"     ; /* Bulgarian */
		public static const HPDF_LANG_BH  : String =   "bh"     ; /* Bihari */
		public static const HPDF_LANG_BI  : String =   "bi"     ; /* Bislama */
		public static const HPDF_LANG_BN  : String =   "bn"     ; /* Bengali Bangla */
		public static const HPDF_LANG_BO  : String =   "bo"     ; /* Tibetan */
		public static const HPDF_LANG_BR  : String =   "br"     ; /* Breton */
		public static const HPDF_LANG_CA  : String =   "ca"     ; /* Catalan */
		public static const HPDF_LANG_CO  : String =   "co"     ; /* Corsican */
		public static const HPDF_LANG_CS  : String =   "cs"     ; /* Czech */
		public static const HPDF_LANG_CY   : String =  "cy"     ; /* Welsh */
		public static const HPDF_LANG_DA  : String =   "da"     ; /* Danish */
		public static const HPDF_LANG_DE  : String =   "de"     ; /* German */
		public static const HPDF_LANG_DZ  : String =   "dz"     ; /* Bhutani */
		public static const HPDF_LANG_EL  : String =   "el"     ; /* Greek */
		public static const HPDF_LANG_EN  : String =   "en"     ; /* English */
		public static const HPDF_LANG_EO  : String =   "eo"     ; /* Esperanto */
		public static const HPDF_LANG_ES  : String =   "es"     ; /* Spanish */
		public static const HPDF_LANG_ET  : String =   "et"     ; /* Estonian */
		public static const HPDF_LANG_EU  : String =   "eu"     ; /* Basque */
		public static const HPDF_LANG_FA  : String =   "fa"     ; /* Persian */
		public static const HPDF_LANG_FI  : String =   "fi"     ; /* Finnish */
		public static const HPDF_LANG_FJ : String =    "fj"     ; /* Fiji */
		public static const HPDF_LANG_FO  : String =   "fo"     ; /* Faeroese */
		public static const HPDF_LANG_FR  : String =   "fr"     ; /* French */
		public static const HPDF_LANG_FY  : String =   "fy"     ; /* Frisian */
		public static const HPDF_LANG_GA  : String =   "ga"     ; /* Irish */
		public static const HPDF_LANG_GD  : String =   "gd"     ; /* Scots Gaelic */
		public static const HPDF_LANG_GL  : String =   "gl"     ; /* Galician */
		public static const HPDF_LANG_GN  : String =   "gn"     ; /* Guarani */
		public static const HPDF_LANG_GU  : String =   "gu"     ; /* Gujarati */
		public static const HPDF_LANG_HA  : String =   "ha"     ; /* Hausa */
		public static const HPDF_LANG_HI  : String =   "hi"     ; /* Hindi */
		public static const HPDF_LANG_HR  : String =   "hr"     ; /* Croatian */
		public static const HPDF_LANG_HU  : String =   "hu"     ; /* Hungarian */
		public static const HPDF_LANG_HY   : String =  "hy"     ; /* Armenian */
		public static const HPDF_LANG_IA  : String =   "ia"     ; /* Interlingua */
		public static const HPDF_LANG_IE  : String =   "ie"     ; /* Interlingue */
		public static const HPDF_LANG_IK  : String =   "ik"     ; /* Inupiak */
		public static const HPDF_LANG_IN  : String =   "in"     ; /* Indonesian */
		public static const HPDF_LANG_IS  : String =   "is"     ; /* Icelandic */
		public static const HPDF_LANG_IT  : String =   "it"     ; /* Italian */
		public static const HPDF_LANG_IW  : String =   "iw"     ; /* Hebrew */
		public static const HPDF_LANG_JA : String =    "ja"     ; /* Japanese */
		public static const HPDF_LANG_JI  : String =   "ji"     ; /* Yiddish */
		public static const HPDF_LANG_JW  : String =   "jw"     ; /* Javanese */
		public static const HPDF_LANG_KA  : String =   "ka"     ; /* Georgian */
		public static const HPDF_LANG_KK  : String =   "kk"     ; /* Kazakh */
		public static const HPDF_LANG_KL  : String =   "kl"     ; /* Greenlandic */
		public static const HPDF_LANG_KM : String =    "km"     ; /* Cambodian */
		public static const HPDF_LANG_KN  : String =   "kn"     ; /* Kannada */
		public static const HPDF_LANG_KO  : String =   "ko"     ; /* Korean */
		public static const HPDF_LANG_KS  : String =   "ks"     ; /* Kashmiri */
		public static const HPDF_LANG_KU  : String =   "ku"     ; /* Kurdish */
		public static const HPDF_LANG_KY  : String =   "ky"     ; /* Kirghiz */
		public static const HPDF_LANG_LA  : String =   "la"     ; /* Latin */
		public static const HPDF_LANG_LN  : String =   "ln"     ; /* Lingala */
		public static const HPDF_LANG_LO  : String =   "lo"     ; /* Laothian */
		public static const HPDF_LANG_LT  : String =   "lt"     ; /* Lithuanian */
		public static const HPDF_LANG_LV  : String =   "lv"     ; /* Latvian,Lettish */
		public static const HPDF_LANG_MG  : String =   "mg"     ; /* Malagasy */
		public static const HPDF_LANG_MI  : String =   "mi"     ; /* Maori */
		public static const HPDF_LANG_MK  : String =   "mk"     ; /* Macedonian */
		public static const HPDF_LANG_ML  : String =   "ml"     ; /* Malayalam */
		public static const HPDF_LANG_MN  : String =   "mn"     ; /* Mongolian */
		public static const HPDF_LANG_MO  : String =   "mo"     ; /* Moldavian */
		public static const HPDF_LANG_MR   : String =  "mr"     ; /* Marathi */
		public static const HPDF_LANG_MS  : String =   "ms"     ; /* Malay */
		public static const HPDF_LANG_MT  : String =   "mt"     ; /* Maltese */
		public static const HPDF_LANG_MY  : String =   "my"     ; /* Burmese */
		public static const HPDF_LANG_NA  : String =   "na"     ; /* Nauru */
		public static const HPDF_LANG_NE  : String =   "ne"     ; /* Nepali */
		public static const HPDF_LANG_NL  : String =   "nl"     ; /* Dutch */
		public static const HPDF_LANG_NO  : String =   "no"     ; /* Norwegian */
		public static const HPDF_LANG_OC  : String =   "oc"     ; /* Occitan */
		public static const HPDF_LANG_OM  : String =   "om"     ; /* (Afan)Oromo */
		public static const HPDF_LANG_OR   : String =  "or"     ; /* Oriya */
		public static const HPDF_LANG_PA  : String =   "pa"     ; /* Punjabi */
		public static const HPDF_LANG_PL  : String =   "pl"     ; /* Polish */
		public static const HPDF_LANG_PS  : String =   "ps"     ; /* Pashto,Pushto */
		public static const HPDF_LANG_PT  : String =   "pt"     ; /* Portuguese  */
		public static const HPDF_LANG_QU  : String =   "qu"     ; /* Quechua */
		public static const HPDF_LANG_RM  : String =   "rm"     ; /* Rhaeto-Romance */
		public static const HPDF_LANG_RN  : String =   "rn"     ; /* Kirundi */
		public static const HPDF_LANG_RO  : String =   "ro"     ; /* Romanian */
		public static const HPDF_LANG_RU  : String =   "ru"     ; /* Russian */
		public static const HPDF_LANG_RW  : String =   "rw"     ; /* Kinyarwanda */
		public static const HPDF_LANG_SA  : String =   "sa"     ; /* Sanskrit */
		public static const HPDF_LANG_SD  : String =   "sd"     ; /* Sindhi */
		public static const HPDF_LANG_SG  : String =   "sg"     ; /* Sangro */
		public static const HPDF_LANG_SH  : String =   "sh"     ; /* Serbo-Croatian */
		public static const HPDF_LANG_SI   : String =  "si"     ; /* Singhalese */
		public static const HPDF_LANG_SK  : String =   "sk"     ; /* Slovak */
		public static const HPDF_LANG_SL   : String =  "sl"     ; /* Slovenian */
		public static const HPDF_LANG_SM : String =    "sm"     ; /* Samoan */
		public static const HPDF_LANG_SN  : String =   "sn"     ; /* Shona */
		public static const HPDF_LANG_SO  : String =   "so"     ; /* Somali */
		public static const HPDF_LANG_SQ  : String =   "sq"     ; /* Albanian */
		public static const HPDF_LANG_SR  : String =   "sr"     ; /* Serbian */
		public static const HPDF_LANG_SS  : String =   "ss"     ; /* Siswati */
		public static const HPDF_LANG_ST  : String =   "st"     ; /* Sesotho */
		public static const HPDF_LANG_SU  : String =   "su"     ; /* Sundanese */
		public static const HPDF_LANG_SV   : String =  "sv"     ; /* Swedish */
		public static const HPDF_LANG_SW  : String =   "sw"     ; /* Swahili */
		public static const HPDF_LANG_TA   : String =  "ta"     ; /* Tamil */
		public static const HPDF_LANG_TE : String =    "te"     ; /* Tegulu */
		public static const HPDF_LANG_TG  : String =   "tg"     ; /* Tajik */
		public static const HPDF_LANG_TH  : String =   "th"     ; /* Thai */
		public static const HPDF_LANG_TI : String =    "ti"     ; /* Tigrinya */
		public static const HPDF_LANG_TK  : String =   "tk"     ; /* Turkmen */
		public static const HPDF_LANG_TL  : String =   "tl"     ; /* Tagalog */
		public static const HPDF_LANG_TN  : String =   "tn"     ; /* Setswanato Tonga */
		public static const HPDF_LANG_TR  : String =   "tr"     ; /* Turkish */
		public static const HPDF_LANG_TS  : String =   "ts"     ; /* Tsonga */
		public static const HPDF_LANG_TT  : String =   "tt"     ; /* Tatar */
		public static const HPDF_LANG_TW  : String =   "tw"     ; /* Twi */
		public static const HPDF_LANG_UK  : String =   "uk"     ; /* Ukrainian */
		public static const HPDF_LANG_UR  : String =   "ur"     ; /* Urdu */
		public static const HPDF_LANG_UZ  : String =   "uz"     ; /* Uzbek */
		public static const HPDF_LANG_VI  : String =   "vi"     ; /* Vietnamese */
		public static const HPDF_LANG_VO  : String =   "vo"     ; /* Volapuk */
		public static const HPDF_LANG_WO  : String =   "wo"     ; /* Wolof */
		public static const HPDF_LANG_XH  : String =   "xh"     ; /* Xhosa */
		public static const HPDF_LANG_YO  : String =   "yo"     ; /* Yoruba */
		public static const HPDF_LANG_ZH  : String =   "zh"     ; /* Chinese */
		public static const HPDF_LANG_ZU  : String =   "zu"     ; /* Zulu */
 
		/** graphics mode **/
		public	static	const	HPDF_GMODE_PAGE_DESCRIPTION : Number	= 0x0001;	
		public	static	const	HPDF_GMODE_PATH_OBJECT : Number			= 0x0002;	 
		public	static	const	HPDF_GMODE_TEXT_OBJECT : Number			= 0x0004;	
		public	static	const	HPDF_GMODE_CLIPPING_PATH : Number		= 0x0008;	
		public	static	const	HPDF_GMODE_SHADING : Number				= 0x0010;	
		public	static	const	HPDF_GMODE_INLINE_IMAGE : Number		= 0x0020;	
		public	static	const	HPDF_GMODE_EXTERNAL_OBJECT : Number		= 0x0040;	
		
		
	}
}