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
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_List;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.HPDF_LineCap;
	import com.fxpdf.types.HPDF_ParseText;
	import com.fxpdf.types.enum.HPDF_BaseEncodings;
	import com.fxpdf.types.enum.HPDF_ByteType;
	
	public class HPDF_Encoder
	{
		
		public static const  HPDF_ENCODING_FONT_SPECIFIC 	: String =   	"FontSpecific";
		public static const  HPDF_ENCODING_STANDARD 		: String =       "StandardEncoding";
		public static const  HPDF_ENCODING_MAC_ROMAN		: String =       "MacRomanEncoding";
		public static const  HPDF_ENCODING_WIN_ANSI			: String =        "WinAnsiEncoding";
		public static const  HPDF_ENCODING_ISO8859_2		: String =       "ISO8859-2";
		public static const  HPDF_ENCODING_ISO8859_3		: String =       "ISO8859-3";
		public static const  HPDF_ENCODING_ISO8859_4		: String =       "ISO8859-4";
		public static const  HPDF_ENCODING_ISO8859_5		: String =       "ISO8859-5";
		public static const  HPDF_ENCODING_ISO8859_6		: String =       "ISO8859-6";
		public static const  HPDF_ENCODING_ISO8859_7		: String =       "ISO8859-7";
		public static const  HPDF_ENCODING_ISO8859_8		: String =       "ISO8859-8";
		public static const  HPDF_ENCODING_ISO8859_9		: String =       "ISO8859-9";
		public static const  HPDF_ENCODING_ISO8859_10		: String =      "ISO8859-10";
		public static const  HPDF_ENCODING_ISO8859_11		: String =      "ISO8859-11";
		public static const  HPDF_ENCODING_ISO8859_13		: String =      "ISO8859-13";
		public static const  HPDF_ENCODING_ISO8859_14		: String =      "ISO8859-14";
		public static const  HPDF_ENCODING_ISO8859_15		: String =      "ISO8859-15";
		public static const  HPDF_ENCODING_ISO8859_16		: String =      "ISO8859-16";
		public static const  HPDF_ENCODING_CP1250			: String =          "CP1250";
		public static const  HPDF_ENCODING_CP1251			: String =          "CP1251";
		public static const  HPDF_ENCODING_CP1252			: String =          "CP1252";
		public static const  HPDF_ENCODING_CP1253			: String =          "CP1253";
		public static const  HPDF_ENCODING_CP1254			: String =          "CP1254";
		public static const  HPDF_ENCODING_CP1255			: String =          "CP1255";
		public static const  HPDF_ENCODING_CP1256			: String =          "CP1256";
		public static const  HPDF_ENCODING_CP1257			: String =          "CP1257";
		public static const  HPDF_ENCODING_CP1258			: String =          "CP1258";
		public static const  HPDF_ENCODING_KOI8_R			: String =          "KOI8-R";
		
		public	static	const	HPDF_ENCODER_SIG_BYTES : Number	=	 0x454E4344 ;  
		
    	public	var	name : String ;  
    	public	var	type : uint  ; 
    	public	var	langCode : String ; 
    	public	var countryCode : String ; 
    	public	var	attr	: Object ; 
    	
    	public	var	sigBytes : Number ; 
		public var initFn		: Function;
    	
		public	static const HPDF_BUILTIN_ENCODINGS :Array = [
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_FONT_SPECIFIC,HPDF_BaseEncodings.HPDF_BASE_ENCODING_FONT_SPECIFIC,null ), 
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_STANDARD,HPDF_BaseEncodings.HPDF_BASE_ENCODING_STANDARD,null),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_MAC_ROMAN,HPDF_BaseEncodings.HPDF_BASE_ENCODING_MAC_ROMAN,null),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_WIN_ANSI,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,null ),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_2,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_2),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_3,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_3),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_4,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_4),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_5,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_5),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_6,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_6),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_7,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_7),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_8,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_8),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_9,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_9),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_10,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_10),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_11,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_11),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_13,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_13),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_14,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_14),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_ISO8859_15,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_15),
		    new HPDF_BuiltinEncodingData( HPDF_ENCODING_ISO8859_16,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_ISO8859_16),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_CP1250,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_CP1250),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_CP1251,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_CP1251),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_CP1252,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_CP1252),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_CP1253,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_CP1253),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_CP1254,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_CP1254),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_CP1255,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_CP1255),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_CP1256,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_CP1256),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_CP1257,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_CP1257),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_CP1258,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_CP1258),
		    new HPDF_BuiltinEncodingData(HPDF_ENCODING_KOI8_R,HPDF_BaseEncodings.HPDF_BASE_ENCODING_WIN_ANSI,HPDF_Encoding_Maps.HPDF_UNICODE_MAP_KOI8_R),
		    new HPDF_BuiltinEncodingData(null,HPDF_BaseEncodings.HPDF_BASE_ENCODING_EOF,null)		   
		];
		
 
 		
		public function HPDF_Encoder()
		{
		}
		
		public	static	function HPDF_BasicEncoder_New ( encodingName : String ) : HPDF_Encoder
		{	
			var  encoder : HPDF_Encoder	=	new HPDF_Encoder();
		    return encoder;
		}
 		public	function	unicodeToByte( value : uint ) : uint 
 		{
 			throw new Error("unicodeToByte not implemented");
 		}
		 public	static	function HPDF_BasicEncoder_FindBuiltinData  ( encodingName : String) :  HPDF_BuiltinEncodingData
		 {
			    
			    var	i	: uint  = 0; 
			
			    trace( " HPDF_BasicEncoder_FindBuiltinData");
			
			    while (HPDF_BUILTIN_ENCODINGS[i].encodingName)
			    {
			        if (  HPDF_BUILTIN_ENCODINGS[i].encodingName ==	encodingName)
			            break;
			        i++;
			    }
				var	ret	: HPDF_BuiltinEncodingData =	HPDF_BUILTIN_ENCODINGS[i] as HPDF_BuiltinEncodingData;
			    return HPDF_BUILTIN_ENCODINGS[i] as HPDF_BuiltinEncodingData;
		 }
		
		
		
		public	function	writeFn (stream : HPDF_Stream) : void
		{
			throw new HPDF_Error("HPDF_Encoder.writeFn not implemented" , 0,0);
		}
		
		public	function	ReadFn ( ) : void
		{
			
		}
		
		public	function	ByteTypeFn( state : HPDF_ParseText ) : uint
		{
			//trace("ByteTypeFn default" );
			return HPDF_ByteType.HPDF_BYTE_TYPE_SINGLE;
		}
		
		
		public	function	HPDF_UnicodeToGryphName  ( unicode : uint) : String
		{
    		var map : Array = HPDF_UnicodeToGryphMap.HPDF_UNICODE_GRYPH_NAME_MAP;
    		for ( var i :int = 0; i< map.length; i++) {
    			if ( map[i].unicode == unicode )
    				return map[i].gryphName;
    		}
    		return map[0].gryphName;
	    } 
	    public	static function	HPDF_GryphNameToUnicode( gryphName : String ) : uint
	    {
	    	var map : Array = HPDF_UnicodeToGryphMap.HPDF_UNICODE_GRYPH_NAME_MAP;
    		for ( var i :int = 0; i< map.length; i++) {
    			if ( map[i].gryphName == gryphName )
    				return map[i].unicode;
    		}
    		return 0;
	    }
    		

 	  public	function HPDF_Encoder_SetParseText  ( state :HPDF_ParseText, text : String, len : uint ) : void
 	  {
       
		    trace (" HPDF_CMapEncoder_SetParseText");
		
		    state.text = text;
		    state.index = 0;
		    state.len = len;
		    state.byteType = HPDF_ByteType.HPDF_BYTE_TYPE_SINGLE;
		}
		public	function	HPDF_Encoder_ByteType  ( state : HPDF_ParseText ) : uint
		{
         
		    //trace (" HPDF_Encoder_ByteType");
			return ByteTypeFn ( state ) ;
		    
		}
		
		
		public	function	HPDF_CMapEncoder_ByteType( state : HPDF_ParseText ) : uint
		{
			trace (" HPDF_CMapEncoder_ByteType");
			
			if (state.index >= state.len)
				return HPDF_ByteType.HPDF_BYTE_TYPE_UNKNOWN;
			
			
			var attr : HPDF_CMapEncoderAttr =  this.attr as HPDF_CMapEncoderAttr;
			
			if (state.byteType == HPDF_ByteType.HPDF_BYTE_TYPE_LEAD) {
				if (attr.isTrialByteFn (this, state.text[state.index]))
					state.byteType = HPDF_ByteType.HPDF_BYTE_TYPE_TRIAL;
				else
					state.byteType = HPDF_ByteType.HPDF_BYTE_TYPE_UNKNOWN;
			} 
			else {
				if (attr.isLeadByteFn (this, state.text[state.index]))
					state.byteType = HPDF_ByteType.HPDF_BYTE_TYPE_LEAD;
				else
					state.byteType = HPDF_ByteType.HPDF_BYTE_TYPE_SINGLE;
			}
			
			state.index++;
			
			return state.byteType;
			
		}
		
		
		
		public function HPDF_CMapEncoder_ToCID  ( code : uint) : uint
		{
			var l : uint = code & 0x00FF;
			var h : uint = code >> 8;
			
			var attr:HPDF_CMapEncoderAttr = this.attr as HPDF_CMapEncoderAttr;
			
			return attr.cidMap[l][h];
		}
		
		
		public function	GBK_EUC_AddCodeSpaceRange () : void 
		{
			var code_space_range1:HPDF_CidRange_Rec  = new HPDF_CidRange_Rec(0x00, 0x80, 0);
			var code_space_range2:HPDF_CidRange_Rec  = new HPDF_CidRange_Rec(0x8140, 0xFEFE, 0);
			
			this.HPDF_CMapEncoder_AddCodeSpaceRange ( code_space_range1);
			this.HPDF_CMapEncoder_AddCodeSpaceRange ( code_space_range2);
		}
		
		
		public function	HPDF_CMapEncoder_AddCodeSpaceRange  (range : HPDF_CidRange_Rec ) : void 
		{
			var attr : HPDF_CMapEncoderAttr = this.attr as HPDF_CMapEncoderAttr;
			
			AddCidRainge ( range, attr.codeSpaceRange);
		}

			
		public function HPDF_CMapEncoder_AddNotDefRange( range : HPDF_CidRange_Rec ) : void
		{
			
			var attr : HPDF_CMapEncoderAttr = this.attr as HPDF_CMapEncoderAttr;
			
			AddCidRainge ( range, attr.notdefRange); 
		}
		
		public function AddCidRainge( range : HPDF_CidRange_Rec, target  : HPDF_List ) :void
		{
			var prange		: HPDF_CidRange_Rec = new HPDF_CidRange_Rec( range.from, range.to_, range.cid );	
			
			target.HPDF_List_Add ( prange) ;
		}

		public function HPDF_CMapEncoder_SetUnicodeArray  ( array : Array ) : void
		{
			
			var attr : HPDF_CMapEncoderAttr = this.attr as HPDF_CMapEncoderAttr;
			var i : int = 0; 
			var ar : HPDF_UnicodeMap;
			ar =array[0] as HPDF_UnicodeMap;
			if (array != null) {
				while (ar.unicode != 0xffff && i < array.length) {
					var l : uint = ar.code & 0x00FF;
					var h : uint = ar.code >> 8;
					
					attr.unicodeMap[l][h] = ar.unicode;
					i++;
					if ( i < array.length )
						ar =array[i] as HPDF_UnicodeMap;
				}
			}
		}

		
		/** overridable functions **/
		public	function	HPDF_Encoder_ToUnicode( code : uint ) : uint
		{
			return null; 	
		}
		
		
		public function HPDF_Encoder_Free():void
		{
			
		}
	}

}