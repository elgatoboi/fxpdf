package com.fxpdf.encoder
{
	import com.fxpdf.objects.HPDF_List;
	import com.fxpdf.types.HPDF_LineCap;

	public class HPDF_CMapEncoderAttr
	{
		
		public var unicodeMap			: Vector.<Vector.<uint>>;
		public var cidMap				: Vector.<Vector.<uint>>;
		public var jwwLineHead			: Vector.<uint>;
		public var cmapRange			: HPDF_List;
		public var notdefRange			: HPDF_List;
		public var codeSpaceRange		: HPDF_List;
		public var writingMode			: uint; 
		public var registry				: String;
		public var ordering				: String; 
		public var suppliment			: int ; 
		public var isLeadByteFn			: Function; 
		public var isTrialByteFn		: Function; 
		public var uidOffset			: int ; 
		public var xuid					: Vector.<uint>;
		
		
		public function HPDF_CMapEncoderAttr()
		{
			unicodeMap	= new Vector.<Vector.<uint>>(256);
			cidMap		= new Vector.<Vector.<uint>>(256);
			xuid		= new Vector.<uint>(3);
			
			for ( var i : int = 0; i < 256 ; i++ ) { 
				cidMap[i] 	= new Vector.<uint>(256);
				unicodeMap[i] = new Vector.<uint>(256);
				for ( var j:int = 0; j< 256 ; j++ ) 
				{
					unicodeMap[i][j] = 0x25A1; 
				}
				
			}
		}
	 
	}
}