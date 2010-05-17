package com.fxpdf.image
{
	import com.fxpdf.types.enum.HPDF_ColorSpace;
	import com.fxpdf.xref.HPDF_Xref;
	
	import flash.utils.ByteArray;
	
	public class HPDF_PngImage extends HPDF_Image
	{
		
		protected var idataBytes			: ByteArray;
		protected var palBytes				: ByteArray;
		protected var type					: int;
		
		public static const HEADER:int = 0x8950;
		public static const PLTE:int = 0x504C5445;
		public static const TRNS:int = 0x74524E53;
		public static const IDAT:int = 0x49444154;
		public static const IEND:int = 0x49454E44;
		
		public static const IO:int = 0;
		public static const I1:int = 1;
		public static const I2:int = 2;
		public static const I3:int = 3;
		public static const I4:int = 4;
		public static const I16:int = 16;
		
		
		public function HPDF_PngImage(xref:HPDF_Xref,imageStream:ByteArray, colorSpace:int )
		{
			super(xref, imageStream, colorSpace );
			LoadPngData();
		}
		
		
		
		
		
		public function LoadPngData( ):void
		{
			
			palBytes = new ByteArray();
			idataBytes = new ByteArray();
			
			imageStream.position = HPDF_PngImage.I16;
			
			width = imageStream.readInt();
			height = imageStream.readInt();
			
			bitsPerComponent = imageStream.readByte();
			
			ct = imageStream.readByte();
			
			if ( ct == HPDF_PngImage.IO ) 
				colorSpace = HPDF_ColorSpace.HPDF_CS_DEVICE_GRAY;
			else if (ct == HPDF_PngImage.I2 ) 
				colorSpace = HPDF_ColorSpace.HPDF_CS_DEVICE_RGB;
			else if ( ct == HPDF_PngImage.I3 ) 
				colorSpace = HPDF_ColorSpace.HPDF_CS_INDEXED;
			
			else throw new Error("Alpha channel not supported for now");
			
			if ( imageStream.readByte() != 0 ) 
				throw new Error ("Unknown compression method");
			if ( imageStream.readByte() != 0 ) 
				throw new Error ("Unknown filter method");
			if ( imageStream.readByte() != 0 ) 
				throw new Error ("Interlacing not supported");
			
			imageStream.position += HPDF_PngImage.I4;
			
			parameters = '/DecodeParms <</Predictor 15 /Colors '+(ct == HPDF_PngImage.I2 ? HPDF_PngImage.I3 : HPDF_PngImage.I1)+' /BitsPerComponent '+bitsPerComponent+' /Columns '+width+'>>';
			
			var trns:String = '';
			
			do 
			{	
				n = imageStream.readInt();
				type = imageStream.readUnsignedInt();
				
				if ( type == HPDF_PngImage.PLTE )
				{
					imageStream.readBytes(palBytes, imageStream.position, n);
					imageStream.readUnsignedInt();
					palBytes.position = HPDF_PngImage.IO;
					pal = palBytes.readUTFBytes(palBytes.bytesAvailable);
					
				} else if ( type == HPDF_PngImage.TRNS )
				{
					
					
				} else if ( type == HPDF_PngImage.IDAT )
				{	
					imageStream.readBytes(idataBytes, idataBytes.length, n);
					imageStream.position += HPDF_PngImage.I4;
					
				} else if ( type == HPDF_PngImage.IEND )
				{	
					break;
					
				} else imageStream.position += n+HPDF_PngImage.I4;
				
			} while ( n > HPDF_PngImage.IO );
			
			imageStream.position = 0 ;
			stream.HPDF_Stream_Write( imageStream );
			if ( colorSpace == HPDF_ColorSpace.HPDF_CS_INDEXED && !pal.length ) 
				throw new Error ("Missing palette in current picture");
		}
	}
}