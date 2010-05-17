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
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.dict.HPDF_DictStream;
	import com.fxpdf.encoder.HPDF_BasicEncoderAttr;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.HPDF_TextWidth;
	import com.fxpdf.types.enum.HPDF_EncoderType;
	import com.fxpdf.types.enum.HPDF_FontDefType;
	import com.fxpdf.types.enum.HPDF_FontType;
	import com.fxpdf.types.enum.HPDF_WritingMode;
	import com.fxpdf.xref.HPDF_Xref;
	
	public class HPDF_Type1Font extends HPDF_Font
	{
		public function HPDF_Type1Font( fontdef: HPDF_FontDef , encoder : HPDF_Encoder, xref : HPDF_Xref)
		{
			super( fontdef, encoder, xref );
			 
			var	attr	: HPDF_FontAttr_Type1	=	new HPDF_FontAttr_Type1( ) ; 
			var	fontdefAttr : HPDF_Type1FontDefAttr	=	new HPDF_Type1FontDefAttr( ) ;
			var	encoderAttr : HPDF_BasicEncoderAttr	=	new HPDF_BasicEncoderAttr( ) ;  
		    
		    trace (" HPDF_Type1Font_New");
		
		    /* check whether the fontdef object and the encoder object is valid. */
		    
		    if (encoder.type != HPDF_EncoderType.HPDF_ENCODER_TYPE_SINGLE_BYTE)
		    {
		        throw new HPDF_Error( "HPDF_Type1Font",HPDF_Error.HPDF_INVALID_ENCODER_TYPE, 0); 
		    }
		
			if (fontdef.type != HPDF_FontDefType.HPDF_FONTDEF_TYPE_TYPE1)
		    {
		        throw new HPDF_Error( "HPDF_Type1Font",HPDF_Error.HPDF_INVALID_FONTDEF_TYPE, 0); 
		    }
			header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_FONT;

		    this.attr = attr;
		    attr.type				= HPDF_FontType.HPDF_FONT_TYPE1;
		    attr.writingMode		= HPDF_WritingMode.HPDF_WMODE_HORIZONTAL;
		    attr.fontdef			= fontdef;
		    attr.encoder			= encoder;
		    attr.xref				= xref;
		    attr.widths				=	new Vector.<uint>; 
		    for ( i = 0 ; i < 256; i++ ) 
		       attr.widths.push ( 0 ) ; 

   
    		encoderAttr = encoder.attr as HPDF_BasicEncoderAttr ;

		    
		    for (var i:int = encoderAttr.firstChar; i <= encoderAttr.lastChar; i++)
		    {
		        // C HPDF_UNICODE u = encoder_attr->unicode_map[i];
		        var	u : uint	=	encoderAttr.unicodeMap[i];
		
		        //C HPDF_UINT16 w = HPDF_Type1FontDef_GetWidth (fontdef, u);
		        var	w : uint	=	fontdef.HPDF_Type1FontDef_GetWidth( u ) ; 
		        attr.widths[i] = w;
		    }
		
		    fontdefAttr = fontdef.attr	as HPDF_Type1FontDefAttr ;
		
		    HPDF_Dict_AddName ("Type", "Font");
		    HPDF_Dict_AddName ("BaseFont", fontdef.baseFont);
		    HPDF_Dict_AddName ("Subtype", "Type1");
		
		    if (!fontdefAttr.isBase14Font)
		    {
		        if (fontdef.missingWidth != 0)
		            HPDF_Dict_AddNumber ("MissingWidth",fontdef.missingWidth);
		
		        Type1Font_CreateDescriptor (xref);
		    }
		
		   
		    xref.HPDF_Xref_Add ( this );
		    
		    
		    /*var	fontdef : HPDF_FontDef	=	new HPDF_FontDef( ) ; 
			var	fontdefAttr	: HPDF_Type1FontDefAttr	=	new HPDF_Type1FontDefAttr( ) ; 
			
			trace (" HPDF_Type1FontDef_New");

			
    	    fontdef.sigBytes	= HPDF_FontDef.HPDF_FONTDEF_SIG_BYTES;
		    fontdef.baseFont	=	"" ; 
		    fontdef.type		= HPDF_FontDefType.HPDF_FONTDEF_TYPE_TYPE1;
		    fontdef.description = null;
		    fontdef.valid		= false;
		
			fontdefAttr	=	new HPDF_Type1FontDefAttr( ) ; 
		    
		    fontdef.attr	= fontdefAttr;
		    fontdef.flags	= HPDF_FontDef.HPDF_FONT_STD_CHARSET;
		    */
		    
		}
		
		override public	function	writeFn ( stream : HPDF_Stream ) : void
		{
			var attr : HPDF_FontAttr = attr as HPDF_FontAttr;
			var fontdefAttr : HPDF_Type1FontDefAttr = attr.fontdef.attr as HPDF_Type1FontDefAttr;
			var encoderAttr : HPDF_BasicEncoderAttr	=	attr.encoder.attr as HPDF_BasicEncoderAttr;
			
			var i : uint ; 
			var buf : String  = new String ;
			
			trace ( "HPDF_Font_Type1Font_OnWrite");
		
		    /* if font is base14-font these entries is not required */
		    if (!fontdefAttr.isBase14Font || encoderAttr.hasDifferences)
		    {
		        buf = "" ;  
		
				buf += "/FirstChar " ;
				buf += HPDF_Utils.HPDF_IToA( encoderAttr.firstChar ) ;
				buf += HPDF_Utils.ParseString("\\012");
		        
		        stream.HPDF_Stream_WriteStr ( buf );
		
				buf = "/LastChar " ;
				buf += HPDF_Utils.HPDF_IToA( encoderAttr.lastChar ) ;
				buf += HPDF_Utils.ParseString("\\012");
		        
		        stream.HPDF_Stream_WriteStr ( buf );
		
		        /* Widths entry */
		        stream.HPDF_Stream_WriteEscapeName ( "Widths");
		
		        stream.HPDF_Stream_WriteStr ( HPDF_Utils.ParseString(" [\\012" ) );
				buf = "" ; 
		        for (i = encoderAttr.firstChar; i <= encoderAttr.lastChar; i++)
		        {
		
		            buf += HPDF_Utils.HPDF_IToA (attr.widths[i]);
		            buf += " ";
		            if ((i + 1) % 16 == 0) {
		            	
		                buf += HPDF_Utils.ParseString("\\012");
		                stream.HPDF_Stream_WriteStr (buf);
		                buf = "";
		            }
		        }
		
		        buf += HPDF_Utils.ParseString("]\\012");
		        stream.HPDF_Stream_WriteStr (buf);
		    }

    		attr.encoder.writeFn ( stream );
		}
		
		
		
		/*override public	function	freeFn ( ) : void
		{
			
		}*/
		
		override public	function	HPDF_Font_TextWidth( text : String, len : uint ) : HPDF_TextWidth
		{
		    /*HPDF_FontAttr attr = (HPDF_FontAttr)font->attr;
		    HPDF_TextWidth ret = {0, 0, 0, 0};
		    HPDF_UINT i;
		    HPDF_BYTE b = 0;
		*/
			var	ret	 : HPDF_TextWidth	=	new HPDF_TextWidth(0,0,0,0);
		    trace ( " HPDF_Type1Font_TextWidth");
		
		    if (attr.widths)
		    {
		        for (var i : int= 0; i < len; i++)
		        {
		            //b = text[i];
		            var	b : uint = text.charCodeAt(i);
		            trace(" char " + text.charAt(i) + " code =" + b.toString() );
		            // fix code
		            b	=	attr.encoder.unicodeToByte( b ) ; 
		            ret.numchars++;
		            ret.width += attr.widths[ b ];
		
		            if (HPDF_Utils.HPDF_IS_WHITE_SPACE(b))
		            {
		                ret.numspace++;
		                ret.numwords++;
		            }
		            
		        }
		    } else
		    {
		       // HPDF_SetError (font->error, HPDF_FONT_INVALID_WIDTHS_TABLE, 0);
		       throw new HPDF_Error( "textWidthFn", HPDF_Error.HPDF_FONT_INVALID_WIDTHS_TABLE, 0);
		    }
		
		    /* 2006.08.19 add. */
		    if (HPDF_Utils.HPDF_IS_WHITE_SPACE(b))
		        trace("do nothing"); /* do nothing. */
		    else
		        ret.numwords++;
		
		    return ret;
		} 
		
		private	function	Type1Font_CreateDescriptor  ( xref : HPDF_Xref) : void
		{
		    var	fontAttr : HPDF_FontAttr	=	attr as HPDF_FontAttr;
		    var	def : HPDF_FontDef	=	fontAttr.fontdef;
		    var	defAttr : HPDF_Type1FontDefAttr	=	def.attr	as HPDF_Type1FontDefAttr;
		    
		     
		    trace (" HPDF_Type1Font_CreateDescriptor");
			
		    if (!fontAttr.fontdef.descriptor)
		    {
		        var	descriptor : HPDF_Dict	=	new HPDF_Dict ( )  ;
		        var array : HPDF_Array
		
		        xref.HPDF_Xref_Add ( descriptor);
		        descriptor.HPDF_Dict_AddName ( "Type", "FontDescriptor");
		        descriptor.HPDF_Dict_AddNumber ( "Ascent", def.ascent);
		        descriptor.HPDF_Dict_AddNumber ( "Descent", def.descent);
		        descriptor.HPDF_Dict_AddNumber ( "Flags", def.flags);
		
		        array = HPDF_Array.HPDF_Box_Array_New( def.fontBBox );
		        descriptor.HPDF_Dict_Add ( "FontBBox", array);
		
		        descriptor.HPDF_Dict_AddName ( "FontName", fontAttr.fontdef.baseFont);
		        descriptor.HPDF_Dict_AddNumber ( "ItalicAngle", def.italicAngle);
		        descriptor.HPDF_Dict_AddNumber ( "StemV", def.stemv);
		        descriptor.HPDF_Dict_AddNumber ( "XHeight", def.xHeight);
		
		        if (defAttr.charSet)
		            descriptor.HPDF_Dict_AddName ("CharSet",defAttr.charSet);
		
		        if (defAttr.fontData)
		        {
		            var	fontData :HPDF_DictStream =	new HPDF_DictStream( xref ) ; 
					//fontData.stream.HPDF_Stream_WriteToStream( defAttr.fontData, HPDF_Stream.HPDF_STREAM_FILTER_NONE, null );
					defAttr.fontData.position = 0 ; 
					fontData.stream.HPDF_Stream_Write(  defAttr.fontData ) ;
		            
		            
		            descriptor.HPDF_Dict_Add ("FontFile", fontData);
		            fontData.HPDF_Dict_AddNumber ("Length1",defAttr.length1);
		            fontData.HPDF_Dict_AddNumber ( "Length2",defAttr.length2);
		            fontData.HPDF_Dict_AddNumber ("Length3", defAttr.length3);
		
		            fontData.filter = filter;
		        }
		
		        fontAttr.fontdef.descriptor = descriptor;
		    }
		
		    this.HPDF_Dict_Add ( "FontDescriptor", fontAttr.fontdef.descriptor);
		} 
		
		
		
				
	}
}