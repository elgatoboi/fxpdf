package com.fxpdf.encoder
{
	public class HPDF_CidRange_Rec
	{
		
		public var from 	:uint;
		public var to_		:uint;
		public var cid		:uint; 
		
		public function HPDF_CidRange_Rec( from:uint = 0 , to_:uint = 0  , cid:uint = 0 )
		{
			this.from 	= from;
			this.to_	= to_;
			this.cid	= cid; 
		}
		
	}
}