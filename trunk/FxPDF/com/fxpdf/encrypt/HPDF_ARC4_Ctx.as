package com.fxpdf.encrypt
{
	import flash.utils.ByteArray;

	public class HPDF_ARC4_Ctx
	{
		public static const HPDF_ARC4_BUF_SIZE      :int = 256;  
		
		public var 	idx1	:uint;
		public var 	idx2	:uint;
		public var 	state	:Vector.<int> = new Vector.<int>(HPDF_ARC4_BUF_SIZE);
		
		public function HPDF_ARC4_Ctx()
		{
		}
		
		
		public function	ARC4CryptBuf ( inbytes:ByteArray, out:ByteArray, len:uint ):void
		{
			var i		:uint;
			var t		:uint;
			var k		:uint;
			
			for (i = 0; i < len; i++) {
				
				var tmp		:uint; 
				
				this.idx1 = (this.idx1 + 1) % 256;
				this.idx2 = (this.idx2 +  this.state[this.idx1] ) % 256;
				
				tmp = this.state[this.idx1];
				this.state[this.idx1] = this.state[this.idx2];
				this.state[this.idx2] = tmp;
				
				t = (this.state[this.idx1] + this.state[this.idx2]) % 256;
				k = this.state[t];
				
				out[i] = inbytes[i] ^ k;
			}
		}

	}
}