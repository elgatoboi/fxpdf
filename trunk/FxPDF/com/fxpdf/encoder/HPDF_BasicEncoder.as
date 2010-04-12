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
package com.fxpdf.encoder
{
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.enum.HPDF_BaseEncodings;
	import com.fxpdf.types.enum.HPDF_EncoderType;
	
	public class HPDF_BasicEncoder extends HPDF_Encoder
	{
		
		public	static	const HPDF_BASIC_ENCODER_FIRST_CHAR : uint = 32;
		public	static	const HPDF_BASIC_ENCODER_LAST_CHAR : uint =   255;
		
		public	function	get basicEncoderAttr ( ) : HPDF_BasicEncoderAttr
		{
			return this.attr	as HPDF_BasicEncoderAttr; 
		}
		
		/**
		 * AS3 function to get byte representation ( 0-255 ) of unicode char
		 * */
		override public	function	unicodeToByte( value : uint ) : uint 
		{
			var basicAttr : HPDF_BasicEncoderAttr = basicEncoderAttr;
			
			for ( var i : int = 0 ; i < basicAttr.unicodeMap.length ; i++ ) 
				{
					if ( basicAttr.unicodeMap[i] == value ) 
						return i; 
				}
			throw new Error("cannot find value" + value.toString()+ " in unicode map");
			//return 0 ; 
			
		}
		
		public function HPDF_BasicEncoder(  encodingName : String )
		{
		    var	encoderAttr : HPDF_BasicEncoderAttr ; 
		    var	data	: HPDF_BuiltinEncodingData ;
		    
		    trace( " new HPDF_BasicEncoder");
		
		   
		    data = HPDF_Encoder.HPDF_BasicEncoder_FindBuiltinData ( encodingName );
		    if (!data) {
		    	
		    	throw new HPDF_Error( "HPDF_BasicEncoder_New", HPDF_Error.HPDF_INVALID_ENCODING_NAME, 0);
		    }

		    name	=	new String( data.encodingName ) ;
		    
		    type = HPDF_EncoderType.HPDF_ENCODER_TYPE_SINGLE_BYTE;
		    
		    
		    encoderAttr = new HPDF_BasicEncoderAttr;
		    
		    sigBytes	= HPDF_Encoder.HPDF_ENCODER_SIG_BYTES;
		    attr 		= encoderAttr;
		    
		    encoderAttr.firstChar	= HPDF_BASIC_ENCODER_FIRST_CHAR;
		    encoderAttr.lastChar	= HPDF_BASIC_ENCODER_LAST_CHAR;
		    encoderAttr.hasDifferences = false ;
		
		    //  TODO eptr = encoderAttr.baseEncoding + HPDF_Conf.HPDF_LIMIT_MAX_NAME_LEN;

	    switch (data.baseEncoding)
	    {
	    	
	        case HPDF_BaseEncodings.HPDF_BASE_ENCODING_STANDARD:
	            //HPDF_StrCpy (encoder_attr->base_encoding,
	               //      HPDF_ENCODING_STANDARD,  eptr);
	            encoderAttr.baseEncoding	= 	HPDF_BaseEncodings.HPDF_BASE_ENCODING_STANDARD.toString();
	            HPDF_BasicEncoder_CopyMap (HPDF_Encoding_Maps.HPDF_UNICODE_MAP_STANDARD);
	            break;
	        case HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI:
	            encoderAttr.baseEncoding =	HPDF_Encoder.HPDF_ENCODING_WIN_ANSI ;
	            HPDF_BasicEncoder_CopyMap ( HPDF_Encoding_Maps.HPDF_UNICODE_MAP_WIN_ANSI);
	            break;
	        case HPDF_BaseEncodings.HPDF_BASE_ENCODING_MAC_ROMAN:
	            encoderAttr.baseEncoding	=	HPDF_Encoder.HPDF_ENCODING_MAC_ROMAN ;
	            HPDF_BasicEncoder_CopyMap (  HPDF_Encoding_Maps.HPDF_UNICODE_MAP_MAC_ROMAN);
	            break;
	        default:
	            encoderAttr.baseEncoding = HPDF_Encoder.HPDF_ENCODING_FONT_SPECIFIC ; 
	            HPDF_BasicEncoder_CopyMap (HPDF_Encoding_Maps.HPDF_UNICODE_MAP_FONT_SPECIFIC);
	    }

   		 if (data.ovewrrideMap)
        		HPDF_BasicEncoder_OverrideMap  (data.ovewrrideMap);

		}
		
		override public	function	writeFn ( stream : HPDF_Stream) : void
		{
			var	attr : HPDF_BasicEncoderAttr	=	attr as HPDF_BasicEncoderAttr;
		
		    trace (" HPDF_BasicEncoder_Write");
		
		    /*  if HPDF_ENCODING_FONT_SPECIFIC is selected, no Encoding object will be "
		     *  written.
		     */
		    if ( attr.baseEncoding	==	HPDF_ENCODING_FONT_SPECIFIC ) 
		    	return ; 
		
		    /* if encoder has differences-data, encoding object is written as
		       dictionary-object, otherwise it is written as name-object. */
		    if ( attr.hasDifferences )
		    {
		        stream.HPDF_Stream_WriteStr ( HPDF_Utils.ParseString(
		                "/Encoding <<\\012" +
		                "/Type /Encoding\\012" +
		                "/BaseEncoding "));
		        
		    }
		    else
		    {
		        stream.HPDF_Stream_WriteStr ( "/Encoding ");
		    }
		
		    
		    stream.HPDF_Stream_WriteEscapeName(attr.baseEncoding );
		    
		
		    stream.HPDF_Stream_WriteStr ( HPDF_Utils.ParseString("\\012") );
		    		
		    /* write differences data */
		    if (attr.hasDifferences )
		    {
		        stream.HPDF_Stream_WriteStr ( "/Differences [");
		        
		
		        for (var i:int = attr.firstChar; i <= attr.lastChar; i++)
		        {
		            if (attr.differences[i] == 1)
		            {
		                /*char tmp[HPDF_TEXT_DEFAULT_LEN];
		                char* ptmp = tmp;
		                const char* char_name =
		                */
		                var ptmp : String = "";
		                var charName : String =   HPDF_UnicodeToGryphName (attr.unicodeMap[i]);
		
		                // C ptmp = HPDF_IToA (ptmp, i, tmp + HPDF_TMP_BUF_SIZ - 1);
		                ptmp += i.toString();
		                
		                //*ptmp++ = ' ';
		                //*ptmp++ = '/';
		                ptmp += " /";
		                /*ptmp = (char *)HPDF_StrCpy (ptmp, char_name, tmp +
		                        HPDF_TMP_BUF_SIZ - 1);
		                        
		                *ptmp++ = ' ';
		                *ptmp = 0; */
		              
		                ptmp += charName+" ";
		
		                stream.HPDF_Stream_WriteStr (ptmp);
		            }
		        }
		
		        stream.HPDF_Stream_WriteStr (HPDF_Utils.ParseString( "]\\012>>\\012"));
    	}
  }
  
		
		override public	function	ReadFn ( ) : void
		{
			
		}
		
		private	function HPDF_BasicEncoder_CopyMap  ( map: Array) : void
		{
		
		    // HPDF_UINT i;
		    
		    /* C ((HPDF_BasicEncoderAttr)encoder.attr).unicode_map +
		        HPDF_BASIC_ENCODER_FIRST_CHAR; */
		   /*  var	dst : uint = basicEncoderAttr.unicodeMap	+ HPDF_BASIC_ENCODER_FIRST_CHAR;
		    
				*/
		    //var dst : Array	=	basicEncoderAttr.
		    trace(" HPDF_BasicEncoder_CopyMap");
		
		    for (var i : int = 0; i <= HPDF_BASIC_ENCODER_LAST_CHAR - HPDF_BASIC_ENCODER_FIRST_CHAR; i++)
		    {
		        basicEncoderAttr.unicodeMap[ HPDF_BASIC_ENCODER_FIRST_CHAR + i ] = map[i];
		        /**dst++ = *map++;
		        dst*/
		    }
		   
		   // basicEncoderAttr.unicodeMap	=	map ;
		}
		
		private	function	HPDF_BasicEncoder_OverrideMap  (  map :Array ) : void 
		{
		   /* HPDF_UINT i;
		    HPDF_BasicEncoderAttr data = (HPDF_BasicEncoderAttr)encoder.attr;
		    HPDF_UNICODE* dst;
		    HPDF_BYTE* flgs;
		    */
		    //var	attr : HPDF_BasicEncoderAttr	=	this.attr as HPDF_BasicEncoderAttr;
		
		    trace (" HPDF_BasicEncoder_OverrideMap");
			// basicEncoderAttr.unicodeMap	=	map ;
			this.attr.hasDifferences = true ;
			basicEncoderAttr.differences = new Array(HPDF_BASIC_ENCODER_LAST_CHAR - HPDF_BASIC_ENCODER_FIRST_CHAR);
			
			for ( var i : int = 0 ; i <= HPDF_BASIC_ENCODER_LAST_CHAR - HPDF_BASIC_ENCODER_FIRST_CHAR ; i++)
			{
				if ( map[i] != basicEncoderAttr.unicodeMap[i +HPDF_BASIC_ENCODER_FIRST_CHAR ])
				{
					basicEncoderAttr.unicodeMap[i +HPDF_BASIC_ENCODER_FIRST_CHAR ]	=	map[i];
					basicEncoderAttr.differences[i+HPDF_BASIC_ENCODER_FIRST_CHAR ] = 1;
				}
				else
					basicEncoderAttr.differences[i + HPDF_BASIC_ENCODER_FIRST_CHAR] = 0;
			}
			
		    /*if (data.has_differences)
		        return HPDF_SetError (encoder.error, HPDF_INVALID_OPERATION, 0);
		
		    dst = data.unicode_map + HPDF_BASIC_ENCODER_FIRST_CHAR;
		    flgs = data.differences + HPDF_BASIC_ENCODER_FIRST_CHAR;
		
		    for (i = 0; i <= HPDF_BASIC_ENCODER_LAST_CHAR -
		            HPDF_BASIC_ENCODER_FIRST_CHAR; i++) {
		        if (*map != *dst) {
		            *dst = *map;
		            *flgs = 1;
		        }
		        map++;
		        dst++;
		        flgs++;
		    }
		    data.has_differences = HPDF_TRUE;
		
		    return HPDF_OK;*/
		}
		override public	function	HPDF_Encoder_ToUnicode( code : uint ) : uint
		{
			 var	attr : HPDF_BasicEncoderAttr	=	attr as HPDF_BasicEncoderAttr;
			 if  ( code > 255 ) 
			 	return 0; 
			 return attr.unicodeMap[code];
		}

	}
}