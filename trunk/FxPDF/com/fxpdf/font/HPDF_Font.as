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
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.encoder.HPDF_BasicEncoderAttr;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.ttf.HPDF_FontDef_TT;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.C_NumberPointer;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.HPDF_TextWidth;
	import com.fxpdf.xref.HPDF_Xref;
	
	public class HPDF_Font extends HPDF_Dict
	{
		public function HPDF_Font(fontdef: HPDF_FontDef = null , encoder : HPDF_Encoder = null, xref : HPDF_Xref = null) 
		{
			super();
			
			header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_FONT; 
			
		
		}
		
		
		public	function	HPDF_Font_Validate( ) : Boolean
		{
			trace(" HPDF_Font_Validate");
		
		    if ( !attr || header.objClass != (HPDF_Obj_Header.HPDF_OSUBCLASS_FONT | HPDF_Obj_Header.HPDF_OCLASS_DICT))
		        return false;
		
		    return true; 
		    
		}
		
		public	function	HPDF_Font_GetBBox  ( ) : HPDF_Box
		{
			var bbox : HPDF_Box = new HPDF_Box( 0,0,0,0);
    		trace(" HPDF_Font_GetBBox");
    		HPDF_Font_Validate( ) ;
    		return (attr as HPDF_FontAttr).fontdef.fontBBox;
		}

		
		public	function	HPDF_Font_TextWidth  ( text : String , len : uint ) : HPDF_TextWidth
		{
            var	tw: HPDF_TextWidth	=	new HPDF_TextWidth ( 0, 0, 0, 0 );
    		

    		trace (" HPDF_Font_TextWidth");

		    if (len > HPDF_Consts.HPDF_LIMIT_MAX_STRING_LEN)
		    {
		        throw new HPDF_Error("HPDF_Font_TextWidth",  HPDF_Error.HPDF_STRING_OUT_OF_RANGE, 0);
		    }
		
		    var fontAttr:HPDF_FontAttr = attr as HPDF_FontAttr;
		
		    if (fontAttr.textWidthFn == null ) 
		    {
		        throw new HPDF_Error("HPDF_Font_TextWidth",  HPDF_Error.HPDF_INVALID_OBJECT, 0);
		    }
		
		    tw = fontAttr.textWidthFn (this,text, len);
		    return tw;
		}
		
		
		
		/** Override HPDF_Dict functions  **/
		/** functions to override **/
		override public	function	freeFn( ) : void
		{
			throw new HPDF_Error("HPDF_Dict.freeFn not implemented" , 0,0);
		}
		
	
		
		override public	function	writeFn( stream : HPDF_Stream ) : void
		{
			var	attr : HPDF_FontAttr	=	this.attr	as HPDF_FontAttr;
			var	encoderAttr : HPDF_BasicEncoderAttr	=	attr.encoder.attr  as  HPDF_BasicEncoderAttr;
			var	pbuf : String  = "";
		    
		    trace (" HPDF_Font_OnWrite");
		
		    /* Widths entry */
		    stream.HPDF_Stream_WriteEscapeName( "Widths");
		    
		    stream.HPDF_Stream_WriteStr( HPDF_Utils.ParseString(" [\\012" ));
		
			for ( var i : int = encoderAttr.firstChar ; i <= encoderAttr.lastChar; i++)
			{
				pbuf += attr.widths[i].toString();
				pbuf += " ";
				if ( ( i+1) % 16 == 0 )
				{
					pbuf += HPDF_Utils.ParseString("\\012");
					stream.HPDF_Stream_WriteStr( pbuf );
					pbuf = "";
				}
				
			}
		   	pbuf += HPDF_Utils.ParseString("]\\012");
		   	stream.HPDF_Stream_WriteStr( pbuf );
		    
		    return attr.encoder.writeFn ( stream ); 
		}
		
		
		
		override public	function	afterWriteFn( stream : HPDF_Stream) : void
		{
			null ; 
		}
		
		public	function	HPDF_Font_MeasureText (text :String, len : uint, width : Number, fontSize : Number, charSpace : Number, wordSpace:Number, wordwrap : Boolean, realWidth : C_NumberPointer) : Number
		{
			var	attr : HPDF_FontAttr	=	attr as HPDF_FontAttr ; 
		    trace (" HPDF_Font_MeasureText");
		
		    HPDF_Font_Validate( ) ;
		        
		
		    if (len > HPDF_Consts.HPDF_LIMIT_MAX_STRING_LEN)
		    {
		        throw new HPDF_Error("HPDF_Font_MeasureText", HPDF_Error.HPDF_STRING_OUT_OF_RANGE, 0);
		    }
			if ( attr.measureTextFn == null ) 
				throw new HPDF_Error("HPDF_Font_MeasureText", HPDF_Error.HPDF_INVALID_OBJECT, 0);
		    
		    return attr.measureTextFn ( this, text, len, width, fontSize,
		                            charSpace, wordSpace, wordwrap, realWidth);
		} 
		
		

	
		

	}
}