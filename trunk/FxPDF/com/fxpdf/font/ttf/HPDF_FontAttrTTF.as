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
package com.fxpdf.font.ttf
{
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.font.HPDF_FontAttr;
	import com.fxpdf.font.HPDF_TTFont;
	import com.fxpdf.types.C_NumberPointer;
	import com.fxpdf.types.HPDF_TextWidth;

	public class HPDF_FontAttrTTF extends HPDF_FontAttr
	{
		public function HPDF_FontAttrTTF()
		{
			super();
		}
		
		override public function textWidthFn( font:HPDF_Font, text:String,len:uint):HPDF_TextWidth
		{
			var	ret : HPDF_TextWidth	=	new HPDF_TextWidth(0,0,0,0);
			var	b : uint ; 
			trace ("HPDF_TTFont_TextWidth");
			
			if (this.widths ) 
			{
				for ( var i : int = 0 ; i < len ; i ++ ) {
					b = text.charCodeAt(i);
					// transform unicode to byte
					if ( encoder ) 
					 b = encoder.unicodeToByte( b );
					ret.numchars ++ ; 
					ret.width	+= (font as HPDF_TTFont).CharWidth( b );
					if ( HPDF_Utils.HPDF_IS_WHITE_SPACE(b)) {
						ret.numspace ++ ;
						ret.numwords ++ ;  
					}
				}
			}
			
			if  ( HPDF_Utils.HPDF_IS_WHITE_SPACE(b))
				null;
			else
				ret.numwords ++ ;
				
			return ret;
		} 
		
		private	function	CharWidth( font : HPDF_Font, code : uint ) : int
		{
			
			if ( this.used[code] == 0 )
			{
				var unicode : uint	=	this.encoder.HPDF_Encoder_ToUnicode( code ) ; 
				
				used[code] = 1 ;
				widths[code] = (fontdef as HPDF_FontDef_TT).HPDF_TTFontDef_GetCharWidth( unicode );  
			} 
			return widths[code];
		}
		
		
		override public function measureTextFn(font : HPDF_Font , text :String, len : uint, 
		width : Number, fontSize : Number, charSpace : Number, wordSpace:Number, wordwrap : Boolean, realWidth : C_NumberPointer ) :Number
		{
		
			var w  :Number= 0  ; 
			var tmpLen : uint 
		   	var i : uint ; 
		
		    trace (" HPDF_TTFont_MeasureText");
		
		    for (i = 0; i < len; i++)
		    {
		        var b: uint = text.charCodeAt( i ); 
		        // use encoder
		        if ( encoder ) 
		         b = encoder.unicodeToByte( b ); 
		
		        if (HPDF_Utils.HPDF_IS_WHITE_SPACE(b))
		        {
		            tmpLen = i + 1;
		
		            if (realWidth)
		                realWidth.value = w; 
		
		            w += wordSpace;
		        } else if (!wordwrap){
		            tmpLen = i;
		
		            if (realWidth)
		                realWidth.value = w; 
		        }
		
		        w += (font as HPDF_TTFont).CharWidth ( b) * fontSize / 1000;
		
		        /* 2006.08.04 break when it encountered  line feed */
		        if (w > width || b == 0x0A)
		            return tmpLen;
		
		        if (i > 0)
		            w += charSpace;
		    }
		
		    /* all of text can be put in the specified width */
		    if (realWidth)
		      realWidth.value = w; 
		    return len;
		}
				
	

	}
}