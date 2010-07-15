package  com.fxpdf.encoder
{
	import com.fxpdf.HPDF_Conf;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.HPDF_CID_Width;
	import com.fxpdf.objects.HPDF_List;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.HPDF_ParseText;
	import com.fxpdf.types.enum.HPDF_ByteType;
	import com.fxpdf.types.enum.HPDF_EncoderType;
	import com.fxpdf.types.enum.HPDF_WritingMode;
	
	
	public class HPDF_CMapEncoder extends HPDF_Encoder
	{
		public function HPDF_CMapEncoder( name : String, initFn : Function)
		{
			super();
			
			trace (" HPDF_CMapEncoder_New");
			
			this.name = name; 
			
			this.type 		= HPDF_EncoderType.HPDF_ENCODER_TYPE_UNINITIALIZED;
			this.sigBytes	= HPDF_Encoder.HPDF_ENCODER_SIG_BYTES;
			this.initFn		= initFn;
			
		}
		
		
		
		override public	function	writeFn (stream : HPDF_Stream ) : void
		{
			throw new HPDF_Error("HPDF_Encoder.writeFn not implemented" , 0,0);
			
		}
		
		override public	function	ReadFn ( ) : void
		{
			throw new HPDF_Error("HPDF_Encoder.ReadFn not implemented" , 0,0);
		}
		
		
		
		
		
		
		
		override public function HPDF_Encoder_ToUnicode( code : uint ):uint
		{
			/* C HPDF_BYTE l = code;
			HPDF_BYTE h = code >> 8;
			HPDF_CMapEncoderAttr attr = (HPDF_CMapEncoderAttr)encoder->attr;
			
			return attr->unicode_map[l][h]; */
			
			var l : uint = code & 0x00FF; // todo  ?
			var h : uint = code >> 8; 
			var attr:HPDF_CMapEncoderAttr = this.attr as HPDF_CMapEncoderAttr;
			return attr.unicodeMap[l][h];
		}
		
		
		/** INIT FN **/
		public static function GBK_EUC_H_Init( encoder : HPDF_CMapEncoder ) : void
		{
			encoder.HPDF_CMapEncoder_InitAttr ();
			
			var attr : HPDF_CMapEncoderAttr	 = encoder.attr as HPDF_CMapEncoderAttr;
			
			encoder.HPDF_CMapEncoder_AddCMap( HPDF_Encoder_Cns.CMAP_ARRAY_GBK_EUC_H ) ;
			
			encoder.GBK_EUC_AddCodeSpaceRange();
			
			encoder.HPDF_CMapEncoder_AddNotDefRange( HPDF_Encoder_Cns.GBK_EUC_NOTDEF_RANGE );
			
			encoder.HPDF_CMapEncoder_SetUnicodeArray ( HPDF_Encoder_Cns.CP936_UNICODE_ARRAY) ;
			
			/*attr.isLeadByteFn		= GBK_EUC_IsLeadByte;
			attr.isTrialByteFn		= GBK_EUC_IsTrialByte;*/
	
			attr.registry			= "Adobe" ;
			attr.ordering			= "GB1";
			
			attr.suppliment 		= 2;
			attr.uidOffset 		= -1;
			attr.xuid	
			attr.xuid[0] 			= 1;
			attr.xuid[1] 			= 10;
			attr.xuid[2] 			= 25377;
			
			encoder.type			 = HPDF_EncoderType.HPDF_ENCODER_TYPE_DOUBLE_BYTE;
			
			
		}
		
		
		public function HPDF_CMapEncoder_InitAttr():void
		{
			
			var i : uint ; 
			var j : uint ; 
			
			trace (" HPDF_CMapEncoder_InitAttr");
			
			if (attr)
				throw new HPDF_Error("HPDF_CMapEncoder_InitAttr HPDF_INVALID_ENCODER", 0);
			
			this.attr = new HPDF_CMapEncoderAttr();
			var attr : HPDF_CMapEncoderAttr = attr as HPDF_CMapEncoderAttr;
			
			attr.writingMode			= HPDF_WritingMode.HPDF_WMODE_HORIZONTAL;
			
			/*for ( i = 0; i<= 255; i++ ) {
			attr.unicodeMap[i] = new Vector.<uint>[255]; 
			for ( j = 0 ; j <= 255 ; j++) {
			/* undefined charactors are replaced to square */
			//	attr.unicodeMap[i][j] = 0x25A1;
			// }
			//}
			
			/* create cmap range */
			
			attr.cmapRange 		= 		new HPDF_List ( HPDF_Conf.HPDF_DEF_RANGE_TBL_NUM );
			attr.notdefRange	=		new HPDF_List(  HPDF_Conf.HPDF_DEF_ITEMS_PER_BLOCK) ;
			attr.codeSpaceRange	=		new HPDF_List(  HPDF_Conf.HPDF_DEF_ITEMS_PER_BLOCK) ; 
	}
	
	
	public function HPDF_CMapEncoder_AddCMap  ( trange:Array ):void
	{
		var attr:HPDF_CMapEncoderAttr = this.attr as HPDF_CMapEncoderAttr;
		
		trace (" HPDF_CMapEncoder_AddCMap");
		var i : int = 0; 
		var range : HPDF_CidRange_Rec = trange[i];
		/* Copy specified pdf_cid_range array to fRangeArray. */
		while ( range.from != 0xffff && range.to_ != 0xffff) {
			
				var code 	: uint = range.from;
				var cid		: uint = range.cid;
				var prange	: HPDF_CidRange_Rec;
				
				while (code <= range.to_) {
					
					var l 	: int = code & 0x00FF;
					var h	: int = code >> 8 ; 
					
					attr.cidMap[l][h] = cid;
					code++;
					cid++;
					
				}
				
				prange = new HPDF_CidRange_Rec();
				prange.from	= range.from;
				prange.to_ 	= range.to_;
				prange.cid	= range.cid;
				
				attr.cmapRange.HPDF_List_Add( prange );
				i++;
				range = trange[i];
		}
	}
	
	override public function unicodeToByte(value:uint):uint
	{
		var attr:HPDF_CMapEncoderAttr = this.attr as HPDF_CMapEncoderAttr;
		
		for ( var i : int = 0; i < 256; i++ ) { 
			for( var j : int = 0; j < 256; j++ ) { 
				if ( attr.unicodeMap[i][j] == value )  {
					var ret:uint = j << 8;
					ret += i ; 
					return  ret; 
				}
			}
		}
		return 0; 
	}
		
	
	
	
}
	
	
}