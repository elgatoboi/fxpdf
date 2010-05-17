package com.fxpdf.image
{
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.dict.HPDF_DictStream;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.xref.HPDF_Xref;
	
	import flash.utils.ByteArray;

	public class HPDF_Image extends HPDF_DictStream
	{
		
		public var width:int;
		public var height:int;
		public var resourceId:int;
		public var n:int;
		public var colorSpace 			: int;
		public var bitsPerComponent:int = 8;
		public var transparency:String;
		public var parameters:String;
		public var pal:String;
		public var masked:Boolean;
		public var ct:Number;
		public var progressive:Boolean;
		public var imageStream:ByteArray;
		
		
		public function HPDF_Image( xref:HPDF_Xref, imageStream:ByteArray, colorSpace:int )
		{
			super( xref );
			
			header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_XOBJECT;
			HPDF_Dict_AddName ( "Type", "XObject");
			HPDF_Dict_AddName ( "Subtype", "Image");
			
			this.imageStream = imageStream;
			this.colorSpace = colorSpace;
		}
		
		
		
		
		
	}
}