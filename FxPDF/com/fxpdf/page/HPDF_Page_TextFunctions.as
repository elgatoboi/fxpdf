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
package com.fxpdf.page
{
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.font.HPDF_FontAttr;
	import com.fxpdf.objects.HPDF_PageAttr;
	import com.fxpdf.types.C_NumberPointer;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.HPDF_ParseText;
	import com.fxpdf.types.HPDF_Point;
	import com.fxpdf.types.HPDF_Real;
	import com.fxpdf.types.HPDF_TextWidth;
	import com.fxpdf.types.HPDF_TransMatrix;
	import com.fxpdf.types.enum.HPDF_ByteType;
	import com.fxpdf.types.enum.HPDF_FontType;
	import com.fxpdf.types.enum.HPDF_TextAlignment;
	import com.fxpdf.types.enum.HPDF_TextRenderingMode;
	import com.fxpdf.types.enum.HPDF_WritingMode;
	
	public class HPDF_Page_TextFunctions
	{
		private	var	page : HPDF_Page	;
		
		
		private	static const INIT_POS : HPDF_Point	=	new HPDF_Point(0, 0);
		
		public function HPDF_Page_TextFunctions( page : HPDF_Page)
		{
			this.page	=	page; 
		}
		
		public	function	get	pageAttr ( ) : HPDF_PageAttr
		{
			return page.attr as HPDF_PageAttr;
		}
		
		/** Text object operators **/
		
		public	function	HPDF_Page_BeginText( ) : void
		{
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION);
			var INIT_MATRIX : HPDF_TransMatrix	=	new HPDF_TransMatrix( 1,0,0,1,0,0);
			trace (" HPDF_Page_BeginText");
		
		    pageAttr.stream.HPDF_Stream_WriteStr ( "BT" + HPDF_Utils.NEW_LINE );
		    
		    pageAttr.gmode		=	HPDF_Consts.HPDF_GMODE_TEXT_OBJECT;
		    pageAttr.textPos	=	INIT_POS;
		    pageAttr.textMatrix	=	INIT_MATRIX;
		        
		} //  end HPDF_Page_BeginText
		
		public	function	HPDF_Page_EndText( ) : void
		{
			trace (" HPDF_Page_EndText");
			page.HPDF_Page_CheckState (HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
		
		    pageAttr.stream.HPDF_Stream_WriteStr (  "ET" + HPDF_Utils.NEW_LINE ); 
		        
		    pageAttr.textPos	= INIT_POS;
		    pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
		}
		
		    
		/** TEXT STATE **/
		
		/* Tc */
		public	function	HPDF_Page_SetCharSpace  ( value : Number ) : void
		{
		    trace (" HPDF_Page_SetCharSpace");
		    
		    page.HPDF_Page_CheckState (HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION |  HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
		    
		    
		    if (value < HPDF_Consts.HPDF_MIN_CHARSPACE || value > HPDF_Consts.HPDF_MAX_CHARSPACE)
		    	throw new HPDF_Error( "HPDF_Page_SetCharSpace" , HPDF_Error.HPDF_PAGE_OUT_OF_RANGE,0);
		    
		    pageAttr.stream.HPDF_Stream_WriteReal (value);
		    pageAttr.stream.HPDF_Stream_WriteStr (  " Tc" + HPDF_Utils.NEW_LINE )
		
		    pageAttr.gstate.charSpace = value;
		}
		
		/* Tw */
		public	function	HPDF_Page_SetWordSpace  ( value : Number ) : void
		{
		    page.HPDF_Page_CheckState (HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION |HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
		    
		    trace (" HPDF_Page_SetWordSpace");
		
		    if ( value < HPDF_Consts.HPDF_MIN_WORDSPACE || value > HPDF_Consts.HPDF_MAX_WORDSPACE)
		        throw new HPDF_Error( "HPDF_Page_SetWordSpace" , HPDF_Error.HPDF_PAGE_OUT_OF_RANGE,0);
		    
		    pageAttr.stream.HPDF_Stream_WriteReal ( value );
		    pageAttr.stream.HPDF_Stream_WriteStr ( " Tw" + HPDF_Utils.NEW_LINE );
		        
		    pageAttr.gstate.wordSpace = value;
		}
		
		/* Tz */
		public	function	HPDF_Page_SetHorizontalScalling  ( value : Number ) : void
		{
		    page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
		    trace ( " HPDF_Page_SetHorizontalScalling");
		    
		    if (value < HPDF_Consts.HPDF_MIN_HORIZONTALSCALING || value > HPDF_Consts.HPDF_MAX_HORIZONTALSCALING)
		        throw new HPDF_Error( "HPDF_Page_SetHorizontalScalling" , HPDF_Error.HPDF_PAGE_OUT_OF_RANGE,0);
		    
		    pageAttr.stream.HPDF_Stream_WriteReal ( value );
		      
		    pageAttr.stream.HPDF_Stream_WriteStr ( " Tz" + HPDF_Utils.NEW_LINE ) ;
		    pageAttr.gstate.hScalling = value;
		
		}
		
		/* TL */
		public	function	HPDF_Page_SetTextLeading  ( value : Number ) : void
		{
		    page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
		    
		    trace (" HPDF_Page_SetTextLeading");
		
		    pageAttr.stream.HPDF_Stream_WriteReal ( value ) ;
		    pageAttr.stream.HPDF_Stream_WriteStr (  " TL" + HPDF_Utils.NEW_LINE );
		
		    pageAttr.gstate.textLeading = value;
		    
		} // HPDF_Page_SetTextLeading
		
		/* Tf */
		
		public	function	HPDF_Page_SetFontAndSize  ( font : HPDF_Font, size : Number ) : void
		{
		    trace (" HPDF_Page_SetFontAndSize");
		    page.HPDF_Page_CheckState (HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
		    
		    var pbuf : String	=	 new String ( ) ; 
		    
		    
		    if (!font.HPDF_Font_Validate ())
		        throw new HPDF_Error( "HPDF_Page_SetFontAndSize" , HPDF_Error.HPDF_PAGE_INVALID_FONT,0);
		    
		    if (size <= 0 || size > HPDF_Consts.HPDF_MAX_FONTSIZE)
		        throw new HPDF_Error( "HPDF_Page_SetFontAndSize" , HPDF_Error.HPDF_PAGE_INVALID_FONT_SIZE,0);
		    
		    var localName : String	= page.HPDF_Page_GetLocalFontName ( font );
		
		    if (!localName)
		       throw new HPDF_Error( "HPDF_Page_SetFontAndSize" , HPDF_Error.HPDF_PAGE_INVALID_FONT,0);
		    
		    pageAttr.stream.HPDF_Stream_WriteEscapeName ( localName );
		
		    pbuf = " " + HPDF_Utils.HPDF_FToA(size);
		    pbuf += " Tf" + HPDF_Utils.NEW_LINE 
		
		    pageAttr.stream.HPDF_Stream_WriteStr ( pbuf) ;
		        
		    pageAttr.gstate.font		= font;
		    pageAttr.gstate.fontSize	= size;
		    pageAttr.gstate.writingMode = font.attr.writingMode ;
		     
		}
		
		/* Tr */
		public	function	HPDF_Page_SetTextRenderingMode  ( mode : int ) : void
		{
		    page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
		    
		    trace (" HPDF_Page_SetTextRenderingMode");
		
		   
		    if ( mode < 0 || mode >= HPDF_TextRenderingMode.HPDF_RENDERING_MODE_EOF)
		        throw new HPDF_Error( "HPDF_Page_SetTextRenderingMode" , HPDF_Error.HPDF_PAGE_OUT_OF_RANGE,mode);
		    
		    pageAttr.stream.HPDF_Stream_WriteInt (  mode );
		    pageAttr.stream.HPDF_Stream_WriteStr ( " Tr" + HPDF_Utils.NEW_LINE );
		
		    pageAttr.gstate.renderingMode = mode;
 		}
		
		/* Ts */
		public	function	HPDF_Page_SetTextRaise  ( value : Number ) : void
		{
		    return page.HPDF_Page_SetTextRise ( value );
		}
		
		public	function	HPDF_Page_SetTextRise  ( value : Number ) : void
		{
		    page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
		  
		    trace (" HPDF_Page_SetTextRaise");
		    
		    pageAttr.stream.HPDF_Stream_WriteReal ( value );
		    pageAttr.stream.HPDF_Stream_WriteStr ( " Ts" + HPDF_Utils.NEW_LINE );
		
		    pageAttr.gstate.textRise = value;
		}
		
		/** TEXT POSITIONING **/
		
		/* Td */
		
		public	function	HPDF_Page_MoveTextPos  ( x: Number, y : Number ) : void 
		{
		    page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_TEXT_OBJECT );
		    
		    var	pbuf : String	 = new String ( );  
		
		    trace (" HPDF_Page_MoveTextPos");
		
		    pbuf	= HPDF_Utils.HPDF_FToA( x ) ;
		    pbuf	+=	" ";
		    pbuf	+=	HPDF_Utils.HPDF_FToA( y ) ;
		    pbuf	+= 	" Td" + HPDF_Utils.NEW_LINE
		
		    pageAttr.stream.HPDF_Stream_WriteStr ( pbuf );
		
		    pageAttr.textMatrix.x += x * pageAttr.textMatrix.a + y * pageAttr.textMatrix.c;
		    pageAttr.textMatrix.y += y * pageAttr.textMatrix.d + x * pageAttr.textMatrix.b;
		    pageAttr.textPos.x = pageAttr.textMatrix.x;
		    pageAttr.textPos.y = pageAttr.textMatrix.y;
		
		}
		
		/* TD */
		public	function	HPDF_Page_MoveTextPos2  ( x: Number, y : Number ) : void 
		{
			var pbuf : String ;
			
			trace (" HPDF_Page_MoveTextPos2");
			page.HPDF_Page_CheckState (  HPDF_Consts.HPDF_GMODE_TEXT_OBJECT );
		    
		    pbuf	= HPDF_Utils.HPDF_FToA( x );
		    pbuf	+=	" ";
		    pbuf	+=	HPDF_Utils.HPDF_FToA( y );
		    pbuf	+= 	" TD" + HPDF_Utils.NEW_LINE
		
		    pageAttr.stream.HPDF_Stream_WriteStr ( pbuf );
		
		    pageAttr.textMatrix.x += x * pageAttr.textMatrix.a + y * pageAttr.textMatrix.c;
		    pageAttr.textMatrix.y += y * pageAttr.textMatrix.d + x * pageAttr.textMatrix.b;
		    pageAttr.textPos.x = pageAttr.textMatrix.x;
		    pageAttr.textPos.y = pageAttr.textMatrix.y;
		    pageAttr.gstate.textLeading = -y;
		
		}
		
		/* Tm */
		public	function	HPDF_Page_SetTextMatrix  ( a : Number, b : Number, c : Number, d : Number, x : Number, y : Number ):void
		{
		    page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_TEXT_OBJECT );
		    var pbuf : String	 = new String ( ) ; 
		
		    trace (" HPDF_Page_SetTextMatrix");
		
		    if ((a == 0 || d == 0) && (b == 0 || c == 0))
		    {
		        throw new HPDF_Error ( "HPDF_Page_SetTextMatrix", HPDF_Error.HPDF_INVALID_PARAMETER, 0);
		    }
		
		    pbuf += HPDF_Utils.HPDF_FToA(a,11)+ " " ;
		    pbuf += HPDF_Utils.HPDF_FToA(b,11)+ " " ;
		    pbuf += HPDF_Utils.HPDF_FToA(c,11)+ " " ;
		    pbuf += HPDF_Utils.HPDF_FToA(d,11)+ " " ;
		    pbuf += HPDF_Utils.HPDF_FToA(x,11)+ " " ;
		    pbuf += HPDF_Utils.HPDF_FToA(y,11);
		    pbuf += " Tm" + HPDF_Utils.NEW_LINE;
		    
		    pageAttr.stream.HPDF_Stream_WriteStr (pbuf) ;
		    
		    pageAttr.textMatrix.a = a;
		    pageAttr.textMatrix.b = b;
		    pageAttr.textMatrix.c = c;
		    pageAttr.textMatrix.d = d;
		    pageAttr.textMatrix.x = x;
		    pageAttr.textMatrix.y = y;
		    pageAttr.textPos.x = pageAttr.textMatrix.x;
		    pageAttr.textPos.y = pageAttr.textMatrix.y;
		     
		}
		
		/* T* */
		public	function	HPDF_Page_MoveToNextLine  ( ) : void 
		{
		    page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_TEXT_OBJECT ) ;
		    trace (" HPDF_Page_MoveToNextLine");
		
		    pageAttr.stream.HPDF_Stream_WriteStr ( "T*" + HPDF_Utils.NEW_LINE );
		
		    /* calculate the reference point of text */
		    pageAttr.textMatrix.x -= pageAttr.gstate.textLeading * pageAttr.textMatrix.c;
		    pageAttr.textMatrix.y -= pageAttr.gstate.textLeading * pageAttr.textMatrix.d;
		
		    pageAttr.textPos.x = pageAttr.textMatrix.x;
		    pageAttr.textPos.y = pageAttr.textMatrix.y;
		}
		
		/** TEXT SHOWING **/
		
		/* Tj */
		public	function	HPDF_Page_ShowText  ( text : String ) : void
		{
			var tw : Number ;
			
			trace (" HPDF_Page_ShowText");
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_TEXT_OBJECT );
		    
		        if ( text == null )
		        return ;
		    if ( text.length == 0 ) 
		    	return ; 
		
		    /* no font exists */
		    if (!pageAttr.gstate.font)
		       throw new HPDF_Error( "HPDF_Page_ShowText", HPDF_Error.HPDF_PAGE_FONT_NOT_FOUND, 0);
		    
		    tw = page.HPDF_Page_TextWidth ( text );
		    if (!tw)
		        return ;
			
		    pageAttr.InternalWriteText (text);
		        
		    pageAttr.stream.HPDF_Stream_WriteStr ( " Tj" + HPDF_Utils.NEW_LINE);
		    
		
		    /* calculate the reference point of text */
		    if (pageAttr.gstate.writingMode == HPDF_WritingMode.HPDF_WMODE_HORIZONTAL)
		    {
		        pageAttr.textPos.x += tw * pageAttr.textMatrix.a;
		        pageAttr.textPos.y += tw * pageAttr.textMatrix.b;
		    } else {
		        pageAttr.textPos.x -= tw * pageAttr.textMatrix.b;
		        pageAttr.textPos.y -= tw * pageAttr.textMatrix.a;
		    }
		
		}
		/* TJ */
		/* ' */
		public	function	HPDF_Page_ShowTextNextLine  ( text : String ) : void
		{
		    page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_TEXT_OBJECT );
		    var tw : Number ; 
		    
		    trace (" HPDF_Page_ShowTextNextLine");
		    
		    /* no font exists */
		    if (!pageAttr.gstate.font)
		       throw new HPDF_Error( "HPDF_Page_ShowTextNextLine", HPDF_Error.HPDF_PAGE_FONT_NOT_FOUND, 0);
		    
		    if (text == null || text.length == 0)
		    {
		        page.HPDF_Page_MoveToNextLine();
		        return; 
		    }
		
		    pageAttr.InternalWriteText ( text );
		        
		    pageAttr.stream.HPDF_Stream_WriteStr (" \'" + HPDF_Utils.NEW_LINE );
		
		    tw = page.HPDF_Page_TextWidth ( text);
		
		    /* calculate the reference point of text */
		    pageAttr.textMatrix.x -= pageAttr.gstate.textLeading * pageAttr.textMatrix.c;
		    pageAttr.textMatrix.y -= pageAttr.gstate.textLeading * pageAttr.textMatrix.d;
		
		    pageAttr.textPos.x = pageAttr.textMatrix.x;
		    pageAttr.textPos.y = pageAttr.textMatrix.y;
		
		    if (pageAttr.gstate.writingMode == HPDF_WritingMode.HPDF_WMODE_HORIZONTAL)
		    {
		        pageAttr.textPos.x += tw * pageAttr.textMatrix.a;
		        pageAttr.textPos.y += tw * pageAttr.textMatrix.b;
		    } else {
		        pageAttr.textPos.x -= tw * pageAttr.textMatrix.b;
		        pageAttr.textPos.y -= tw * pageAttr.textMatrix.a;
		    }
		}
		
		/* " */
		public	function	HPDF_Page_ShowTextNextLineEx  ( wordSpace : Number, charSpace : Number, text : String ) : void
		{ 
		    page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_TEXT_OBJECT );
		    var	tw : Number ;
		    var	pbuf : String	=	new String () 
		    

		
		    trace (" HPDF_Page_ShowTextNextLineEX");
		
		    if ( wordSpace < HPDF_Consts.HPDF_MIN_WORDSPACE || wordSpace > HPDF_Consts.HPDF_MAX_WORDSPACE)
		        throw new HPDF_Error( "HPDF_Page_ShowTextNextLineEx", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, 0);
		     
		    if (charSpace < HPDF_Consts.HPDF_MIN_CHARSPACE || charSpace > HPDF_Consts.HPDF_MAX_CHARSPACE)
		        throw new HPDF_Error( "HPDF_Page_ShowTextNextLineEx", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, 0);
		    
		    if (!pageAttr.gstate.font)
		       throw new HPDF_Error( "HPDF_Page_ShowTextNextLineEx", HPDF_Error.HPDF_PAGE_FONT_NOT_FOUND, 0);
		    
		    if (text == null || text.length == 0 )
		    {
		      page.HPDF_Page_MoveToNextLine( ) ;
		      return ; 
		    }
		
		   
		    pbuf	=	HPDF_Utils.HPDF_FToA( wordSpace );
		    pbuf	+= " ";
		    pbuf	+=	HPDF_Utils.HPDF_FToA( charSpace );
		    pbuf	+= " ";
		
		    pageAttr.InternalWriteText ( pbuf ) ;
		
		    pageAttr.InternalWriteText (text ) ;
		
		    pageAttr.stream.HPDF_Stream_WriteStr ( "\"" + HPDF_Utils.NEW_LINE );
		
		    pageAttr.gstate.wordSpace = wordSpace;
		    pageAttr.gstate.charSpace = charSpace;
		
		    tw = page.HPDF_Page_TextWidth ( text);
		
		    /* calculate the reference point of text */
		    pageAttr.textMatrix.x += pageAttr.gstate.textLeading * pageAttr.textMatrix.b;
		    pageAttr.textMatrix.y -= pageAttr.gstate.textLeading * pageAttr.textMatrix.a;
		
		    pageAttr.textPos.x = pageAttr.textMatrix.x;
		    pageAttr.textPos.y = pageAttr.textMatrix.y;
		
		    if (pageAttr.gstate.writingMode == HPDF_WritingMode.HPDF_WMODE_HORIZONTAL) {
		        pageAttr.textPos.x += tw * pageAttr.textMatrix.a;
		        pageAttr.textPos.y += tw * pageAttr.textMatrix.b;
		    } else {
		        pageAttr.textPos.x -= tw * pageAttr.textMatrix.b;
		        pageAttr.textPos.y -= tw * pageAttr.textMatrix.a;
		    }
		}
		
		
		/*** END OF TEXT FUNCTIONS **/
		
		
		
		
		
		
		
		
		public	function	HPDF_Page_TextWidth  ( text : String ) : Number
		{
                     
		    var ret : Number	=	0	;
		    
		    var	len : uint	=	Math.min ( text.length, HPDF_Consts.HPDF_LIMIT_MAX_STRING_LEN + 1 ) ;
		
		    trace (" HPDF_Page_TextWidth" );
		
		    if ( len == 0 )
		    	return 0 ; 
		
		    
		    /* no font exists */
		    if (!pageAttr.gstate.font)
		    {
		        throw new HPDF_Error ( "HPDF_Page_TextWidth", HPDF_Error.HPDF_PAGE_FONT_NOT_FOUND, 0) ;
		    }
		
		    var tw : HPDF_TextWidth = pageAttr.gstate.font.HPDF_Font_TextWidth ( text, len);
		
		    ret += pageAttr.gstate.wordSpace * tw.numspace;
		    ret += tw.width * pageAttr.gstate.fontSize  / 1000;
		    ret += pageAttr.gstate.charSpace * tw.numchars;
		
		    return ret;
		}

		public	function	HPDF_Page_MeasureText  ( text : String, width : Number , wordwrap : Boolean, realWidth : C_NumberPointer ) : Number
		{
		    var	ret : Number;  
		    var	len : uint	=	Math.min ( text.length,HPDF_Consts.HPDF_LIMIT_MAX_STRING_LEN + 1);
		    
		    if ( len == 0 )
		    	return 0 ; 
		    
		    trace(" HPDF_Page_MeasureText");
		
		    /* no font exists */
		    if (!pageAttr.gstate.font)
		    {
		        throw new HPDF_Error("HPDF_Page_MeasureText", HPDF_Error.HPDF_PAGE_FONT_NOT_FOUND, 0);
		    }
		
		    ret = pageAttr.gstate.font.HPDF_Font_MeasureText (text, len, width,
		        pageAttr.gstate.fontSize, pageAttr.gstate.charSpace,
		        pageAttr.gstate.wordSpace, wordwrap, realWidth);
		
		    return ret;
		}  
		
		/**
		 * HPDF_Page_TextRect
		 * */
		public	function	HPDF_Page_TextRect( left : Number, top : Number, right : Number, bottom : Number, text : String, align : Number, len : uint ) : uint
		{
		    
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
			var x : Number ; 
			var y : Number ;
			var attr : HPDF_PageAttr	=	page.attr as  HPDF_PageAttr;
		    var saveCharSpace : Number = 0; 
		    var isInsufficientSpace : Boolean = false ; 
		    var numRest : uint ; 
		    var bbox : HPDF_Box ; 
		    var charSpaceChanged : Boolean = false; 
		    
		    trace (" HPDF_Page_TextOutEx");
			
			if ( text.indexOf("Ubezpieczający oświadcza") == 0 )
			{
				var o :Object  = 1; 
			}
		    /* no font exists */
		    if (!attr.gstate.font) {
		    	throw new HPDF_Error("HPDF_Page_TextRect",HPDF_Error.HPDF_PAGE_FONT_NOT_FOUND, 0);
		    }
		
		    bbox = attr.gstate.font.HPDF_Font_GetBBox ();
		
		    if (len)
		        len = 0;
		        
		    numRest = text.length;
		
		    if ( numRest > HPDF_Consts.HPDF_LIMIT_MAX_STRING_LEN)
		    {
		        throw new HPDF_Error("HPDF_Page_TextRect",HPDF_Error.HPDF_STRING_OUT_OF_RANGE, 0);
		    }
		    if ( numRest <= 0 ) 
		    	return HPDF_Consts.HPDF_OK;  
		
		    if (attr.gstate.textLeading == 0)
		        page.HPDF_Page_SetTextLeading ( (bbox.top - bbox.bottom) / 1000 * attr.gstate.fontSize);
		
		    top = top - bbox.top / 1000 * attr.gstate.fontSize +  attr.gstate.textLeading;
		    bottom = bottom - bbox.bottom / 1000 * attr.gstate.fontSize;
		
		    if (attr.textMatrix.a == 0) {
		        y = (left - attr.textMatrix.x) / attr.textMatrix.c;
		        x = (top - attr.textMatrix.y - (left - attr.textMatrix.x) * attr.textMatrix.d / attr.textMatrix.c) / attr.textMatrix.b;
		    } else {
		        y = (top - attr.textMatrix.y - (left - attr.textMatrix.x) *
		                attr.textMatrix.b / attr.textMatrix.a) / (attr.textMatrix.d -
		                attr.textMatrix.c * attr.textMatrix.b / attr.textMatrix.a);
		        x = (left - attr.textMatrix.x - y * attr.textMatrix.c) /
		                attr.textMatrix.a;
		    }
		
		    page.HPDF_Page_MoveTextPos (x, y);
		
		
		    if (align == HPDF_TextAlignment.HPDF_TALIGN_JUSTIFY) {
		        saveCharSpace = attr.gstate.charSpace;
		        attr.gstate.charSpace = 0;
		    }
		    
		    for (;;) {
		        var tmpLen : uint ; 
		        var rw : C_NumberPointer  = new C_NumberPointer; 
		        var xAdjust : Number ; 
		        var numChar : uint ; 
		        var state : HPDF_ParseText = new HPDF_ParseText();  
		        var encoder : HPDF_Encoder; 
		        var i : uint ; 
		        
		        tmpLen = page.HPDF_Page_MeasureText ( text, right - left, true, rw);
		        if (tmpLen == 0) {
		            isInsufficientSpace = true;
		            break;
		        }
		
		        if (len)
		            len += tmpLen;
		
		        switch (align)
		        {
		            case HPDF_TextAlignment.HPDF_TALIGN_RIGHT:
		                xAdjust = right - left - rw.value;
		                page.HPDF_Page_MoveTextPos (xAdjust, 0);
		
		                page.InternalShowTextNextLine (text, tmpLen);
		
		                page.HPDF_Page_MoveTextPos ( -xAdjust, 0);
		                break;
		                
		            case HPDF_TextAlignment.HPDF_TALIGN_CENTER:
		                xAdjust = (right - left - rw.value) / 2;
		                page.HPDF_Page_MoveTextPos ( xAdjust, 0);
		                page.InternalShowTextNextLine ( text, tmpLen);
		                page.HPDF_Page_MoveTextPos ( -xAdjust, 0);
		                    return HPDF_Consts.HPDF_OK;
		                break;
		            case HPDF_TextAlignment.HPDF_TALIGN_JUSTIFY:
		                numChar = 0;
		                encoder = (attr.gstate.font.attr as HPDF_FontAttr).encoder;
		                encoder.HPDF_Encoder_SetParseText ( state, text, tmpLen);
		                i = 0;
		                while (i < text.length)
		                {
		                	var tmpPtr : uint = text.charCodeAt(i);
		                    var btype:uint = encoder.HPDF_Encoder_ByteType ( state);
		                    if (btype != HPDF_ByteType.HPDF_BYTE_TYPE_TRIAL)
		                        numChar++;
		
		                    i++;
		                    if (i >= tmpLen)
		                        break;
		                  
		                }
		
		                if (HPDF_Utils.HPDF_IS_WHITE_SPACE( text.charCodeAt(i) ))
		                    numChar--;
		
		                if (numChar > 1)
		                    xAdjust = (right - left - rw.value) / (numChar - 1);
		                else
		                    xAdjust = 0;
		
		                if (numRest == tmpLen)
		                {
		                    page.HPDF_Page_SetCharSpace (saveCharSpace);
		                    charSpaceChanged = false;
		                } else
		                {
		                    page.HPDF_Page_SetCharSpace ( xAdjust);
		                    charSpaceChanged = true;
		                }
		
		                page.InternalShowTextNextLine ( text, tmpLen);
		
		                attr.gstate.charSpace = 0;
		                break;
		            default:
		                page.InternalShowTextNextLine ( text, tmpLen);
		        }
		
		        numRest -= tmpLen;
		        if (numRest <= 0)
		            break;
		
		        if (attr.textPos.y - attr.gstate.textLeading < bottom)
		        {
		            isInsufficientSpace = true;
		            break;
		        }
		
		        // TODO ptr += tmpLen;
		        text = text.substr( tmpLen , text.length - tmpLen );
		    }
		
		    if (charSpaceChanged) {
		        page.HPDF_Page_SetCharSpace (saveCharSpace);
		    }
		
		    if (isInsufficientSpace)
		        return HPDF_Error.HPDF_PAGE_INSUFFICIENT_SPACE;
		    else
		        return HPDF_Error.HPDF_OK;
		} 
		
		
		public	function	InternalShowTextNextLine ( text : String, len : uint ): void
		{
		    var	attr : HPDF_PageAttr	=	page.attr as HPDF_PageAttr;
		    var	tw : HPDF_Real  = new HPDF_Real() ; 
		    var fontAttr : HPDF_FontAttr	=	attr.gstate.font.attr;
		    
		    trace (" ShowTextNextLine");
		
		    if (fontAttr.type == HPDF_FontType.HPDF_FONT_TYPE0_TT ||
		       fontAttr.type == HPDF_FontType.HPDF_FONT_TYPE0_CID)
		       {
		        attr.stream.HPDF_Stream_WriteStr ( "<" );
		        attr.stream.HPDF_Stream_WriteBinaryString (text, null);
		        attr.stream.HPDF_Stream_WriteStr ( ">" );
		            
		    } else 
		    { 
		    	attr.stream.HPDF_Stream_WriteEscapeText2 (text,fontAttr.encoder, len);
		    }
		
		
		    attr.stream.HPDF_Stream_WriteStr ( HPDF_Utils.ParseString(" \'\\012") );
		
		    tw.value = page.HPDF_Page_TextWidth ( text);
		
		    /* calculate the reference point of text */
		    attr.textMatrix.x -= attr.gstate.textLeading * attr.textMatrix.c;
		    attr.textMatrix.y -= attr.gstate.textLeading * attr.textMatrix.d;
		
		    attr.textPos.x = attr.textMatrix.x;
		    attr.textPos.y = attr.textMatrix.y;
		
		    if (attr.gstate.writingMode == HPDF_WritingMode.HPDF_WMODE_HORIZONTAL) {
		        attr.textPos.x += tw.value * attr.textMatrix.a;
		        attr.textPos.y += tw.value * attr.textMatrix.b;
		    } else {
		        attr.textPos.x -= tw.value * attr.textMatrix.b;
		        attr.textPos.y -= tw.value * attr.textMatrix.a;
		    }
		}
		
		
		public	function	HPDF_Page_GetCurrentTextPos ( ) : HPDF_Point
		{
			var pos : HPDF_Point = new HPDF_Point( 0, 0 );
			
    	    trace(" HPDF_Page_GetCurrentTextPos");

		    page.HPDF_Page_Validate ();
		    var attr : HPDF_PageAttr = page.attr as HPDF_PageAttr; 
		
	        if (attr.gmode & HPDF_Consts.HPDF_GMODE_TEXT_OBJECT)
	        	pos = attr.textPos;
		    
		  return pos;
		}
		
		public	function	HPDF_Page_TextOut  ( xpos : Number, ypos : Number, text : String ) : void
		{
        
        	page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
        	 
        	var x : Number ; 
        	var y : Number ; 
        	var attr : HPDF_PageAttr = page.attr as HPDF_PageAttr; 
        	
    
    		trace (" HPDF_Page_TextOut");
		
		    if (attr.textMatrix.a == 0) {
		        y = (xpos - attr.textMatrix.x) / attr.textMatrix.c;
		        x = (ypos - attr.textMatrix.y - (xpos - attr.textMatrix.x) * attr.textMatrix.d / attr.textMatrix.c) / attr.textMatrix.b;
		    } else {
		        y = (ypos - attr.textMatrix.y - (xpos - attr.textMatrix.x) *
		                attr.textMatrix.b / attr.textMatrix.a) / (attr.textMatrix.d -
		                attr.textMatrix.c * attr.textMatrix.b / attr.textMatrix.a);
		        x = (xpos - attr.textMatrix.x - y * attr.textMatrix.c) /
		                attr.textMatrix.a;
		    }
		
		   page.HPDF_Page_MoveTextPos ( x, y) ;
		   page.HPDF_Page_ShowText ( text);
		} // end HPDF_Page_TextOut
	}

  

	
}