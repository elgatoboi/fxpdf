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
package com.fxpdf.font
{
	import com.fxpdf.font.charData.HPDF_Base14Font_CharData;
	import com.fxpdf.types.HPDF_Box;
	
	public class HPDF_Base14FontDefData
	{
		public	var	fontName : String ; 
		public	var widthsTable : Array;  
		public	var isFontSpecific : Boolean; 
		public	var	ascent : int ; 
		public	var	descent : int ; 
		public	var xHeight : uint ; 
		public	var	capHeight : uint ; 
		public	var	bbox	: HPDF_Box ;
		
		/*----------------------------------------------------------------------------*/
		/*------ base14 fonts --------------------------------------------------------*/
		
		public static const  HPDF_FONT_COURIER                 : String = "Courier";
		public static const  HPDF_FONT_COURIER_BOLD            : String = "Courier-Bold";
		public static const  HPDF_FONT_COURIER_OBLIQUE         : String = "Courier-Oblique";
		public static const  HPDF_FONT_COURIER_BOLD_OBLIQUE    : String = "Courier-BoldOblique";
		public static const  HPDF_FONT_HELVETICA               : String = "Helvetica";
		public static const  HPDF_FONT_HELVETICA_BOLD          : String = "Helvetica-Bold";
		public static const  HPDF_FONT_HELVETICA_OBLIQUE       : String = "Helvetica-Oblique";
		public static const  HPDF_FONT_HELVETICA_BOLD_OBLIQUE  : String = "Helvetica-BoldOblique";
		public static const  HPDF_FONT_TIMES_ROMAN             : String = "Times-Roman";
		public static const  HPDF_FONT_TIMES_BOLD              : String = "Times-Bold";
		public static const  HPDF_FONT_TIMES_ITALIC            : String = "Times-Italic";
		public static const  HPDF_FONT_TIMES_BOLD_ITALIC       : String = "Times-BoldItalic";
		public static const  HPDF_FONT_SYMBOL                  : String = "Symbol";
		public static const  HPDF_FONT_ZAPF_DINGBATS           : String = "ZapfDingbats" ;
		
		
		public	static const HPDF_BUILTIN_FONTS : Array  =  [
	    {
	        fontName : HPDF_FONT_COURIER,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_COURIER,
	        isFontSpecific: false, 
	        ascent : 629,
	        descent: -157,
	        xHeight : 426,
	        capHeight : 562,
	        bbox : new HPDF_Box( -23, -250, 715, 805 ) 
	    },
	    {
	        fontName : HPDF_FONT_COURIER_BOLD,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_COURIER_BOLD,
	        isFontSpecific: false,
	        ascent :629,
	        descent: -157,
	        xHeight :439,
	        capHeight : 562,
	        bbox : new HPDF_Box(-113, -250, 749, 801)
	    },
	    {
	        fontName : HPDF_FONT_COURIER_OBLIQUE,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_COURIER_OBLIQUE,
	        isFontSpecific: false,
	        ascent :629,
	        descent: -157,
	        xHeight :426,
	        capHeight : 562,
	        bbox : new HPDF_Box(-27, -250, 849, 805)
	    },
	    {
	        fontName : HPDF_FONT_COURIER_BOLD_OBLIQUE,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_COURIER_BOLD_OBLIQUE,
	        isFontSpecific: false,
	        ascent :629,
	        descent: -157,
	        xHeight :439,
	        capHeight : 562,
	        
	        bbox : new HPDF_Box(-57, -250, 869, 801)
	    },
	    {
	        fontName : HPDF_FONT_HELVETICA,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_HELVETICA,
	        isFontSpecific: false,
	        ascent :718,
	        descent: -207,
	        xHeight :523,
	        capHeight : 718,
	        bbox : new HPDF_Box(-166, -225, 1000, 931)
	    },
	    {
	        fontName : HPDF_FONT_HELVETICA_BOLD,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_HELVETICA_BOLD,
	        isFontSpecific: false,
	        ascent :718,
	        descent: -207,
	        xHeight :532,
	        capHeight : 718,
	        bbox : new HPDF_Box(-170, -228, 1003, 962)
	    },
	    {
	        fontName : HPDF_FONT_HELVETICA_OBLIQUE,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_HELVETICA_OBLIQUE,
	        isFontSpecific: false,
	        ascent :718,
	        descent: -207,
	        xHeight :532,
	        capHeight : 718,
	        bbox : new HPDF_Box(-170, -225, 1116, 931)
	    },
	    {
	        fontName : HPDF_FONT_HELVETICA_BOLD_OBLIQUE,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_HELVETICA_BOLD_OBLIQUE,
	        isFontSpecific: false,
	        ascent :718,
	        descent: -207,
	        xHeight :532,
	        capHeight : 718,
	        bbox : new HPDF_Box(-174, -228, 1114, 962)
	    },
	    {
	        fontName : HPDF_FONT_TIMES_ROMAN,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_TIMES_ROMAN,
	        isFontSpecific: false,
	        ascent :683,
	        descent: -217,
	        xHeight :450,
	        capHeight : 662,
	        bbox : new HPDF_Box(-168, -218, 1000, 898)
	    },
	    {
	        fontName : HPDF_FONT_TIMES_BOLD,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_TIMES_BOLD,
	        isFontSpecific: false,
	        ascent :683,
	        descent: -217,
	        xHeight :461,
	        capHeight : 676,
	        bbox : new HPDF_Box(-168, -218, 1000, 935)
	    },
	    {
	        fontName : HPDF_FONT_TIMES_ITALIC,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_TIMES_ITALIC,
	        isFontSpecific: false,
	        ascent :683,
	        descent: -217,
	        xHeight :441,
	        capHeight : 653,
	        bbox : new HPDF_Box(-169, -217, 1010, 883)
	    },
	    {
	        fontName : HPDF_FONT_TIMES_BOLD_ITALIC,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_TIMES_BOLD_ITALIC,
	        isFontSpecific: false,
	        ascent :683,
	        descent: -217,
	        xHeight :462,
	        capHeight : 669,
	        bbox : new HPDF_Box(-200, -218, 996, 921)
	    },
	    {
	        fontName : HPDF_FONT_SYMBOL,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_SYMBOL,
	        isFontSpecific: true,
	        ascent :0,
	        descent: 0,
	        xHeight :0,
	        capHeight : 0,
	        bbox : new HPDF_Box(-180, -293, 1090, 1010)
	    },
	    {
	        fontName : HPDF_FONT_ZAPF_DINGBATS,
	        widthsTable : HPDF_Base14Font_CharData.CHAR_DATA_ZAPF_DINGBATS,
	        isFontSpecific: true,
	        ascent :0,
	        descent: 0,
	        xHeight :0,
	        capHeight : 0,
	        bbox : new HPDF_Box(-1, -143, 981, 820)
	    },
	    {
	        fontName : null,
	        widthsTable : null,
	        isFontSpecific: false,
	        ascent :0,
	        descent: 0,
	        xHeight :0,
	        capHeight : 0,
	        bbox : new HPDF_Box(0, 0, 0, 0)
	    },
	]; 
	    	public function HPDF_Base14FontDefData()
			{
			}
			
			public	static	function HPDF_Base14FontDef_FindBuiltinData ( fontName : String ) : HPDF_Base14FontDefData
			{
				for ( var i : int = 0 ; i < HPDF_BUILTIN_FONTS.length ; i++ ) {
					if ( HPDF_BUILTIN_FONTS[i].fontName == fontName )
					{
						var	ret	: HPDF_Base14FontDefData	=	new HPDF_Base14FontDefData; 
						ret.fontName	=	HPDF_BUILTIN_FONTS[i].fontName;
						ret.widthsTable	=	HPDF_BUILTIN_FONTS[i].widthsTable;
						ret.isFontSpecific	=	HPDF_BUILTIN_FONTS[i].isFontSpecific;
						ret.ascent	=	HPDF_BUILTIN_FONTS[i].ascent;
						ret.descent	=	HPDF_BUILTIN_FONTS[i].descent;
						ret.xHeight	=	HPDF_BUILTIN_FONTS[i].xHeight;
						ret.capHeight	=	HPDF_BUILTIN_FONTS[i].capHeight;
						ret.bbox	=	HPDF_BUILTIN_FONTS[i].bbox;
						
						return ret ; 
					}
				}
				return null; 
			}
   

	}
}