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
package com.fxpdf.font.type1
{
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.HPDF_CharData;
	import com.fxpdf.font.HPDF_FontDef;
	import com.fxpdf.font.HPDF_Type1FontDefAttr;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.enum.HPDF_FontDefType;
	//import flash.utils.ByteArray;

	public class HPDF_FontDef_Type1 extends HPDF_FontDef
	{
		import flash.utils.ByteArray;

		public function HPDF_FontDef_Type1()
		{
			var fontdefAttr : HPDF_Type1FontDefAttr	
			
			trace ( " HPDF_Type1FontDef_New" ) ;
			
			
		    this.sigBytes = HPDF_FONTDEF_SIG_BYTES;
		    this.baseFont = ""; 
		    this.type = HPDF_FontDefType.HPDF_FONTDEF_TYPE_TYPE1;
		    this.descriptor = null;
		    this.valid = false; 
			
			fontdefAttr	=	new HPDF_Type1FontDefAttr( ) ; 
			this.attr = fontdefAttr ;
			this.flags =  HPDF_FONT_STD_CHARSET
    	}
		
		public	static	function	HPDF_Type1FontDef_Load( afm : ByteArray, fontData : ByteArray ) : HPDF_FontDef_Type1 
		{
			var fontdef : HPDF_FontDef_Type1	=	new HPDF_FontDef_Type1( );
			fontdef.LoadAfm( afm ) ;
			if ( fontData ) 
				fontdef.LoadFontData( fontData ) ;
				
			return fontdef ;  
		}
		
		
		public	function	LoadAfm( fontData : ByteArray ) : void
		{
			var attr 		: HPDF_Type1FontDefAttr	=	 attr as HPDF_Type1FontDefAttr;
			var buf 		: String ; 
			var cdata	 	: Vector.<HPDF_CharData>;
			var len 		: uint ; 
			var keyword 	: String ; 
			var i 			: uint ; 
			
		    trace (" LoadAfm");

		    /* chaeck AFM header */
		    var h:HPDF_Utils;
		    buf = HPDF_Utils.ByteArrayReadLn(fontData);  
		    if ( !buf || buf.length == 0 )
		         return ;

    		keyword = GetKeyword ( buf );

	    	if ( keyword != "StartFontMetrics"  )
	    		throw new HPDF_Error("LoadAmf - HPDF_INVALID_AFM_HEADER");
	       		 
		
		    /* Global Font Information */
		    for (;;) {
		        var s : String ; 
				buf = HPDF_Utils.ByteArrayReadLn (fontData);   
				if ( !buf || buf.length == 0 )
					return ; 
		
		        keyword = GetKeyword ( buf );
		        s = buf.substr( keyword.length + 1, buf.length - keyword.length - 1) ;
		
		        if ( keyword == "FontName" ) {
		            this.baseFont = s ;
		        } 
		
		        else if ( keyword ==  "Weight") {
		            if ( s == "Bold" )
		                flags |= HPDF_FONT_FOURCE_BOLD;
		        } 
		        
		        else if ( keyword ==  "IsFixedPitch" ) {
		            if ( s == "true")
		               flags |= HPDF_FONT_FIXED_WIDTH;
		        } 
		
		        else if ( keyword ==  "ItalicAngle" ) {
		            italicAngle = new Number(s);
		            if ( italicAngle != 0 )
		               flags |= HPDF_FONT_ITALIC;
		        } 
		
		        else if ( keyword == "CharacterSet" ) {
		            
		            len  = s.length ; 
		
		            if (len > 0) {
		                attr.charSet = s ; 
		             }
		        } 
		        
		        else if ( keyword == "FontBBox" ) {
							            
					fontBBox = new HPDF_Box( ) ; 
					
		            buf = GetKeyword ( s );
		            fontBBox.left = new Number(buf);

					s = s.substr ( buf.length + 1, s.length - buf.length );
		
		            buf = GetKeyword ( s );
		            fontBBox.bottom = new Number(buf);
		            s = s.substr ( buf.length + 1, s.length - buf.length );
		
		            buf = GetKeyword ( s );
		            fontBBox.right = new Number(buf);
		            
		            s = s.substr ( buf.length + 1, s.length - buf.length );
		
		            buf = GetKeyword ( s );
		            fontBBox.top = new Number(buf);
		            
		        } 
		        
		        else if ( keyword == "EncodingScheme" )       {
		            attr.encodingScheme = s; 
		        } 
		        
		        else if ( keyword ==  "CapHeight" ) {
		            capHeight = new Number( s ) ;
		        } 
		        
		        else  if ( keyword ==  "Ascender" ) {
		            ascent = new Number( s ) ;
		        } 
		        else if ( keyword ==  "Descender" ) {
		            descent =  new Number( s ) ;
		        } 
		        
		        else if ( keyword ==  "STDHW" ) {
		            stemh =  new Number( s ) ;
		        } 
		        
		        else if ( keyword ==  "STDHV" ) {
		            stemv =  new Number( s ) ;
		        } 
		        else if ( keyword ==  "StartCharMetrics" ) {
		            attr.widthCount =  new Number( s ) ;
		            break;
		        }
		    }

		    cdata = new Vector.<HPDF_CharData>;
		    attr.widths = cdata; 
		
		    /* load CharMetrics */
		    for (i = 0; i < attr.widthCount; i++)
		    {
		    	var cd : HPDF_CharData	=	new HPDF_CharData();
		        
		        var buf2 : String ; 
		
		        buf = HPDF_Utils.ByteArrayReadLn( fontData );   
		        if ( !buf || buf.length == 0 )
		        	return ; 
		        	
		        /* C default character code. */
		        buf2 = GetKeyword (buf);
		        s = buf.substr( buf2.length + 1, buf.length - keyword.length - 1) ;
		        if ( buf2 ==  "CX" ) {
		            /* not suppoted yet. */
		            throw new HPDF_Error("LoadAfm",HPDF_Error.HPDF_INVALID_CHAR_MATRICS_DATA, 0);
		        } 
		        
		        else if ( buf2 ==  "C") {
		            // ??? s += 2;
					buf2	=	GetKeyword( s ) ;
					
					s = s.substr( buf2.length + 1, s.length - buf2.length -1 );
		            //s = GetKeyword (s, buf2, HPDF_LIMIT_MAX_NAME_LEN + 1);
		            // HPDF_AToI (buf2);
					
		            cd.charCd =new Number( buf2 ) ; // HPDF_AToI (buf2);
		
		        } else
		            throw new HPDF_Error("LoadAfm", HPDF_Error.HPDF_INVALID_CHAR_MATRICS_DATA, 0);
		
		        /* WX Character width */
		        /// s = HPDF_StrStr (s, "WX ", 0);
		        // s = s.substr( 3, s.length - 3 ) ; 
		        s = s.substr ( s.indexOf("WX") + 3, 100 ); 
		        
		        //s += 3;
		
		        /*s = GetKeyword (s, buf2, HPDF_LIMIT_MAX_NAME_LEN + 1);
		        if (buf2[0] == 0)
		            return HPDF_SetError (fontdef->error, HPDF_INVALID_WX_DATA, 0);
		            */
		        buf2 = GetKeyword ( s) ; 
		
		        cd.width = new Number(buf2) ; //HPDF_AToI (buf2);
		
		        /* N PostScript language character name */
		        s = s.substr ( s.indexOf("N") + 2, 100 );
		        buf2 = GetKeyword ( s) ; 
		        cd.unicode = HPDF_Encoder.HPDF_GryphNameToUnicode (buf2);
		        // s = HPDF_StrStr (s, "N ", 0);
		        /* TODO s = s.substr( 
		        if (!s)
		            return HPDF_SetError (fontdef->error, HPDF_INVALID_N_DATA, 0);
		
		        s += 2;
		
		        GetKeyword (s, buf2, HPDF_LIMIT_MAX_NAME_LEN + 1);
		
		        cdata->unicode = HPDF_GryphNameToUnicode (buf2);
		        */
		        cdata.push( cd ) ;
		
		    }
  			
		}
		
		
		
		public	function	LoadFontData( data : ByteArray ) : void
		{
			var attr : HPDF_Type1FontDefAttr	=	 attr as HPDF_Type1FontDefAttr; 
			var buf : String ;
			var bbuf : ByteArray = new ByteArray; 
			var len : uint = 0; 
			var endFlg : Boolean = false ; 
			
    	

		    trace (" LoadFontData");
		
		    attr.fontData	= data ; 
		
		    len = 11;
		    
		    // C ret = HPDF_Stream_Read (stream, pbuf, &len);
		    data.readBytes(bbuf, 0 , 11) ;
		    
		    //pbuf += 11;
		
		    //for (;;) {
		        //len = HPDF_STREAM_BUF_SIZ - 11;
		        //ret = HPDF_Stream_Read (stream, pbuf, &len);
		        var str : String = data.toString() ;
		        // locate "eexec" string 
		        var eepos : uint = str.indexOf( "eexec" ) ;
		        if ( eepos < 0 )
		        	throw new HPDF_Error("Bad Font data file " ); 
		        
		        attr.length1 = eepos ; 
		        
		        // locate "cleartomark" string
		        
		        var endpos : uint = str.indexOf( "cleartomark" ) ;
		        attr.length2	=	endpos - eepos ; 
		      /*  i 
		        if (ret == HPDF_STREAM_EOF) {
		            end_flg = HPDF_TRUE;
		        } else if (ret != HPDF_OK)
		            return ret;
		
		        if (len > 0) {
		            if (attr->length1 == 0) {
		               const char *s1 = HPDF_StrStr (buf, "eexec", len + 11);
		
		               /* length1 indicate the size of ascii-data of font-file. */
		             /*  if (s1)
		                  attr->length1 = attr->font_data->size + (s1 - buf) + 6;
		            }*/
		
		           /* if (attr->length1 > 0 && attr->length2 == 0) {
		                const char *s2 = HPDF_StrStr (buf, "cleartomark",
		                        len + 11);
		
		                if (s2)
		                    attr->length2 = attr->font_data->size + - 520 -
		                        attr->length1 + (s2 - buf);
		                /*  length1 indicate the size of binary-data.
		                 *  in most fonts, it is all right at 520 bytes . but it need
		                 *  to modify because it does not fully satisfy the
		                 *  specification of type-1 font.
		                 */
		          //  }
		       // }

       /* if (end_flg) {
            if ((ret = HPDF_Stream_Write (attr->font_data, buf, len + 11)) !=
                        HPDF_OK)
                return ret;

            break;
        } else {
            if ((ret = HPDF_Stream_Write (attr->font_data, buf, len)) !=
                        HPDF_OK)
                return ret;
            HPDF_MemCpy (buf, buf + len, 11);
            pbuf = buf + 11;
        }
    }*/

  /*  if (attr->length1 == 0 || attr->length2 == 0)
        return HPDF_SetError (fontdef->error, HPDF_UNSUPPORTED_TYPE1_FONT, 0);
*/
    		attr.length3 = attr.fontData.length - attr.length1 - attr.length2;
				
			
		}
		
		
		private	function	GetKeyword( src : String ) : String
		{
			var srcLen : uint = src.length ;
			var ret : String = "";  
			var i : int  = 0; 
			
		   // trace (" GetKeyword");

		    if (srcLen == 0)
		        return null;
			
			i = src.indexOf(" ");
			if ( i>=0 )
				return src.substr(0, i);
		
			return null;
		} // end GetKeyword

 
		
		
		
	}
}