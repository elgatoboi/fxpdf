package com.fxpdf.encoder
{
	public class HPDF_UnicodeMap
	{
		public var code		: uint; 
		public var unicode : uint; 
		
		public function    HPDF_UnicodeMap (  code : uint, unicode : uint )
		{
			this.code = code;
			this.unicode = unicode;
		}
	}
}