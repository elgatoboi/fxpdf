package com.fxpdf.encrypt
{
	import com.fxpdf.HPDF_Utils;
	
	import flash.utils.ByteArray;

	public class HPDF_MD5_CTX
	{
		
		public var buf			:Vector.<uint> = new Vector.<uint>(4);
		public var bits			:Vector.<uint> = new Vector.<uint>(2);
		
		public var inbytes		:ByteArray = HPDF_Utils.createByteArray(64);

		public function HPDF_MD5_CTX()
		{
		}
		
		
		public function HPDF_MD5Init  ():void
		{
			buf[0] = 0x67452301;
			buf[1] = 0xefcdab89;
			buf[2] = 0x98badcfe;
			buf[3] = 0x10325476;
			
			bits[0] = 0;
			bits[1] = 0;
		} 
	}
}