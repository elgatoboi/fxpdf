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
	import com.fxpdf.encoder.HPDF_BasicEncoder;
	import com.fxpdf.encoder.HPDF_BasicEncoderAttr;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.types.C_NumberPointer;
	import com.fxpdf.types.HPDF_TextWidth;
	
	public class HPDF_FontAttr_Type1 extends HPDF_FontAttr
	{
		public function HPDF_FontAttr_Type1()
		{
			super();
		}
		
		override	public	function	textWidthFn( font:HPDF_Font, text : String, len : uint ) : HPDF_TextWidth
		{
			var	ret : HPDF_TextWidth	=	new HPDF_TextWidth(0, 0, 0, 0);
		    var i : uint ; 
		    var b : uint = 0; 
		    
		    trace (" HPDF_Type1Font_TextWidth");
		
		    if (widths)
		    {
		        for (i = 0; i < len; i++) {
		            b = text.charCodeAt( i ) ;
		            if ( encoder ) 
		            	b = encoder.unicodeToByte( b ) ; 
		            ret.numchars++;
		            ret.width += widths[b];
		
		            if ( HPDF_Utils.HPDF_IS_WHITE_SPACE(b) )
		            {
		                ret.numspace++;
		                ret.numwords++;
		            }
		        }
		    } else
		    {
		    	throw new HPDF_Error( "textWidthFn", HPDF_Error.HPDF_FONT_INVALID_WIDTHS_TABLE, 0);
		    }
		        
		    /* 2006.08.19 add. */
		    if ( HPDF_Utils.HPDF_IS_WHITE_SPACE(b))
		        trace("do nothing"); /* do nothing. */
		    else
		        ret.numwords++;
		
		    return ret; 
		}
		
		
		
		override	public	function	measureTextFn( font : HPDF_Font , text :String, len : uint, 
		width : Number, fontSize : Number, charSpace : Number, wordSpace:Number, wordwrap : Boolean, realWidth : C_NumberPointer ) : Number
		{
			var w : Number = 0; 
			var tmpLen : uint = 0 ; 
			var i : uint = 0; 
			

    		trace (" HPDF_Type1Font_MeasureText");

		    for (i = 0; i < len; i++)
		    {
		        var b : uint = text.charCodeAt( i ) ; 
		        trace(" char is " + text.charAt(i) + " code is  " + b.toString() ) ;
		        // UNICODE SUPPORT
		        // here we need to fix one byte char code
		        // we find it in differences
		        b = this.encoder.unicodeToByte( b ) ; 
		         
		
		        if (HPDF_Utils.HPDF_IS_WHITE_SPACE( b ))
		        {
		            tmpLen = i + 1;
		
		            if (realWidth)
		               realWidth.value = w;
		               
		            w += wordSpace;
		        } else if (!wordwrap)
		        {
		            tmpLen = i;
		
		            if (realWidth)
		               realWidth.value = w;
		        }
		
		        w += widths[b] * fontSize / 1000;
		
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