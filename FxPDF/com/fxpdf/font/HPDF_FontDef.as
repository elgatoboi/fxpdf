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
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.ttf.HPDF_TTF_LongHorMetric;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.enum.HPDF_FontDefType;
	
	public class HPDF_FontDef
	{
		
		/*------ collection of flags for defining characteristics. ---*/
		
		public static const  HPDF_FONT_FIXED_WIDTH  : int =    1;
		public static const  HPDF_FONT_SERIF 		: int =    2;
		public static const  HPDF_FONT_SYMBOLIC	 	: int =    4;
		public static const  HPDF_FONT_SCRIPT 		: int =    8;
		  /* Reserved                    16 */
		public static const  HPDF_FONT_STD_CHARSET  : int =    32;
		public static const  HPDF_FONT_ITALIC  : int =         64;
		  /* Reserved                    128
		     Reserved                    256
		     Reserved                    512
		     Reserved                    1024
		     Reserved                    2048
		     Reserved                    4096
		     Reserved                    8192
		     Reserved                    16384
		     Reserved                    32768 */
		public static const  HPDF_FONT_ALL_CAP     : int =     65536;
		public static const  HPDF_FONT_SMALL_CAP   : int =     131072;
		public static const  HPDF_FONT_FOURCE_BOLD  : int =    262144;
		
		public static const  HPDF_CID_W_TYPE_FROM_TO   : int =    0;
		public static const  HPDF_CID_W_TYPE_FROM_ARRAY  : int =  1;
		
		public	static	const	HPDF_FONTDEF_SIG_BYTES : Number = 0x464F4E54;  
		
		public	static	const	HPDF_TTF_FONT_TAG_LEN : int =  6;
		public	static	const	HPDF_REQUIRED_TAGS_COUNT : int =  13 
		 public	var	sigBytes	: uint ;
		 public	var	baseFont	: String;
		 
		 public	var	type		: uint ; 
		 
    	public	var	ascent		: int ; 
    	public	var	descent		: int ; 
    	public	var	flags		: uint ; 
    	public	var	fontBBox	: HPDF_Box;
    	public	var	italicAngle	: int ; 

    	public	var	stemv		: uint ; 
    	public	var	avgWidth	: int ; 
    	public	var	maxWidth	: int ; 
    	public	var	missingWidth : int ; 
    	public	var	stemh		: uint ; 
    	public	var	xHeight		: uint ; 
    	public	var	capHeight	: uint ;
    	
    	public	var	descriptor	: HPDF_Dict ; 
    	public	var	data		: HPDF_Stream ; 
    	public	var	valid		: Boolean ; 
    	public	var	attr		: Object ; 
    
    
		public  var initFn		: Function;
    
		public function HPDF_FontDef()
		{
		}
		
		public	function	cleanFn ( ) : void
		{
			
		}
		
		public	function	freeFn( ) : void 
		{
			
		}
		
		
		
		
		public	static	function	HPDF_Base14FontDef_New ( fontName : String ) : HPDF_FontDef
		{
			var	fontdef  : HPDF_FontDef	=	HPDF_Type1FontDef_New ( ); 
			
			var	attr : HPDF_Type1FontDefAttr ; 
		    
		   
		    var data :HPDF_Base14FontDefData  = HPDF_Base14FontDefData.HPDF_Base14FontDef_FindBuiltinData ( fontName );
		
		    if ( !data )
		    {
		   		throw new HPDF_Error ( "HPDF_Base14FontDef_New",HPDF_Error.HPDF_INVALID_FONT_NAME, 0);
		    }
		
		  	fontdef.baseFont = new String ( data.fontName ) ; 
		    
			
		    attr = fontdef.attr as HPDF_Type1FontDefAttr;
		    attr.isBase14Font = true ;
		
			if (data.isFontSpecific)
		    	attr.encodingScheme	=	HPDF_Encoder.HPDF_ENCODING_FONT_SPECIFIC;
		        
		    fontdef.HPDF_Type1FontDef_SetWidths ( data.widthsTable );
		
		    fontdef.fontBBox = data.bbox;
		    fontdef.ascent = data.ascent;
		    fontdef.descent = data.descent;
		    fontdef.xHeight = data.xHeight;
		    fontdef.capHeight = data.capHeight;
		
		    fontdef.valid = true;
		
		    return fontdef;
		    
		}
		
		
		public	static function	HPDF_Type1FontDef_New ( ) : HPDF_FontDef
		{
		
			
		    var	fontdefAttr  : HPDF_Type1FontDefAttr;
		 
		    trace (" HPDF_Type1FontDef_New");
		
		        
		    var fontdef	: HPDF_FontDef	=	new HPDF_FontDef( ) ;
		    
		    fontdef.sigBytes = HPDF_FONTDEF_SIG_BYTES;
		    fontdef.baseFont = "";
		    fontdef.type = HPDF_FontDefType.HPDF_FONTDEF_TYPE_TYPE1;
		    /*fontdef,.clean_fn = NULL;
		    fontdef->free_fn = FreeFunc;
		    fontdef->descriptor = NULL;
		    fontdef->valid = HPDF_FALSE;
		    */
		    fontdefAttr 	=	new HPDF_Type1FontDefAttr( ) ;
			fontdef.attr	=	fontdefAttr ; 
		    fontdef.flags = HPDF_FONT_STD_CHARSET;
		
		    return fontdef;
		}
		
		public	function	HPDF_Type1FontDef_SetWidths( widths : Array ) : void
		{
			
			//const HPDF_CharData* src = widths;
		   /* var	attr : HPDF_Type1FontDefAttr	=	attr as HPDF_Type1FontDefAttr;
		    HPDF_CharData* dst;
		    */
		    var i : uint = 0;
		    var src : Array	= widths;
		    var attr : HPDF_Type1FontDefAttr	=	attr as HPDF_Type1FontDefAttr;
		    FreeWidth( ) ; 
		    trace ( " HPDF_Type1FontDef_SetWidths");
		    
		    
		    while ( src[i].unicode != 0xFFFF) 
		    {
		    	i++;
		    }
		    attr.widthCount	=	i ; 
		    attr.widths = new Vector.<HPDF_CharData> ;
		     
		    for ( i = 0 ; i< attr.widthCount ; i++ ) 
		    {
		    	var cd : HPDF_CharData = new HPDF_CharData;
		    	// var srcCd : HPDF_CharData = src[i] as HPDF_CharData;
		    	var srcCd : Object = src[i] ; 
		    	cd.charCd	=	srcCd.charCd ; 
		    	cd.unicode	=	srcCd.unicode ; 
		    	cd.width	=	srcCd.width;
		    	if (cd.unicode == 0x0020 ) 
		    		missingWidth	=	cd.width ;
		    	attr.widths.push( cd ) ;  
		    } 
		    return ; 
		}
		
		public	function	HPDF_Type1FontDef_GetWidth  (unicode : uint) : uint
		{
		    
		    var	attr  : HPDF_Type1FontDefAttr	=	attr as HPDF_Type1FontDefAttr;
		    
		    /*HPDF_CharData *cdata = attr->widths;
		    HPDF_UINT i;
		*/
		   // trace (" HPDF_Type1FontDef_GetWidth");
		
		    for (var i: int = 0; i < attr.widths.length; i++)
		    {
		    	if ( attr.widths[i].unicode == unicode ) 
		    		return attr.widths[i].width ; 
		    }
		
		    return missingWidth;
		}
		
		public	function	HPDF_TTFontDef_SetTagName( tag : String ) : void
		{
			 
			 var	attr : HPDF_TTFontDefAttr	=	attr as HPDF_TTFontDefAttr;
			 var	buf	 : String ; 
			 
		     trace (" HPDF_TTFontDef_SetTagName");
		
		    
		    if ( tag.length > HPDF_TTF_FONT_TAG_LEN )
		    	return ; 
		
		    attr.tagName	=	new String( tag );
		    attr.tagName 	+=  "+";
		    
		    /*for (var i : int = 0; i < HPDF_TTF_FONT_TAG_LEN + 1; i++)
		    {
		        attr->tag_name2[i * 2] = 0x00;
		        attr->tag_name2[i * 2 + 1] = attr->tag_name[i];
		    }
			*/
			attr.tagName2 = new String( attr.tagName );  // ? 
		    buf	=	"" ;
		    buf	+=	attr.tagName ;
		    buf +=	this.baseFont ;
		    attr.baseFont	=	new String ( buf )  ; 
		    /*HPDF_MemCpy ((HPDF_BYTE *)buf, (HPDF_BYTE *)attr->tag_name, HPDF_TTF_FONT_TAG_LEN + 1);
		    HPDF_MemCpy ((HPDF_BYTE *)buf + HPDF_TTF_FONT_TAG_LEN + 1, (HPDF_BYTE *)fontdef->base_font, HPDF_LIMIT_MAX_NAME_LEN - HPDF_TTF_FONT_TAG_LEN - 1);
		
		    HPDF_MemCpy ((HPDF_BYTE *)attr->base_font, (HPDF_BYTE *)buf, HPDF_LIMIT_MAX_NAME_LEN + 1);
		    */ 
		}
		
		public	function	HPDF_FontDef_Free( ) : void
		{
			
		}
		
		private	function	FreeWidth( ) : void
		{
			
			if ( attr ) 
				attr.widths = null ; 
			this.valid = false ; 
			
		}
		
		
		
		
		/** **/
		public function HPDF_TTFontDef_GetGidWidth( gid :uint ) : int 
		{
			var advanceWidth		: uint;
			var hmetrics			: HPDF_TTF_LongHorMetric;
			var attr				: HPDF_TTFontDefAttr = this.attr as HPDF_TTFontDefAttr;
			
			trace(" HPDF_TTFontDef_GetGidWidth");
			
			if ( gid >= attr.numGlyphs ) { 
				trace(" HPDF_TTFontDef_GetGidWidth WARNING gid > " + 
					"num_glyphs " + gid.toString() + " > " + attr.numGlyphs.toString() + "\n");
				return missingWidth;
			}
			
			hmetrics = attr.hMetric[gid];
			
			advanceWidth = hmetrics.advanceWidth * 1000 / attr.header.unitsPerEm;
			
			trace(" HPDF_TTFontDef_GetGidWidth gid=" + gid.toString()  + ", width=" + advanceWidth.toString() +"\n" );
				
			return advanceWidth;
		}
		
		public function HPDF_FontDef_Cleanup():void
		{
			
		}
	}
		
	   
	   
		

}