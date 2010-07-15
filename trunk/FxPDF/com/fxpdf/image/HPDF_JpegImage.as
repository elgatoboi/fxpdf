package com.fxpdf.image
{
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Name;
	import com.fxpdf.objects.HPDF_Number;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.xref.HPDF_Xref;
	
	import flash.utils.ByteArray;
	
	public class HPDF_JpegImage extends HPDF_Image
	{
		
		public static const FORMAT:int = 0;
		public static const HEADER:int = 0xFFD8;
		
		private var ins : ByteArray;
		
		
		
		public function HPDF_JpegImage(xref:HPDF_Xref,data:ByteArray)
		{
			super(xref);
			
			header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_XOBJECT;
			this.ins = data; 
		}
		
		
		/**
		 * Loads an image from input stream - ins
		 * */
		public function loadImage():void
		{
			trace("loadImage");
			
			/* add requiered elements */
			filter = HPDF_Stream.HPDF_STREAM_FILTER_DCT_DECODE;
			HPDF_Dict_AddName ( "Type", "XObject");
			HPDF_Dict_AddName ( "Subtype", "Image");
			
			LoadJpegHeader (  );
			
			//if (HPDF_Stream_Seek (jpeg_data, 0, HPDF_SEEK_SET) != HPDF_OK)
				//return NULL;
			ins.position = 0; 
			
			//for (;;) {
				/*HPDF_BYTE buf[HPDF_STREAM_BUF_SIZ];
				HPDF_UINT len = HPDF_STREAM_BUF_SIZ;
				HPDF_STATUS ret = HPDF_Stream_Read (jpeg_data, buf,
					&len);
				
				if (ret != HPDF_OK) {
					if (ret == HPDF_STREAM_EOF) {
						if (len > 0) {
							ret = HPDF_Stream_Write (image->stream, buf, len);
							if (ret != HPDF_OK)
								return NULL;
						}
						break;
					} else
						return NULL;
				}
				
				if (HPDF_Stream_Write (image->stream, buf, len) != HPDF_OK)
					return NULL;
				*/
				this.stream.HPDF_Stream_Write( ins ); 
			//}
			
		}


		/**
		 * Loads new jpg image from byte array
		 * */
		public static function HPDF_LoadJpegImageFromFile( xref:HPDF_Xref, source:ByteArray ) : HPDF_JpegImage
		{
			trace("HPDF_LoadJpegImageFromFile");
			
			var image:HPDF_JpegImage = new HPDF_JpegImage( xref, source);
			image.loadImage( );
			return image;
		}
		
		
		private function LoadJpegHeader ():void
		{
			var tag 			: Number;
			
			var precision		: Number; 
			var numComponents	: Number; 
			var colorSpaceName	: String;
			var len				: uint;
			var array			: HPDF_Array;
			
			trace (" HPDF_Image_LoadJpegHeader");
			
			len = 2;
			
			tag = ins.readUnsignedShort(); 
			/*if (HPDF_Stream_Read (stream, (HPDF_BYTE *)&tag, &len) != HPDF_OK)
				return HPDF_Error_GetCode (stream->error);*/
			
			//HPDF_UInt16Swap (&tag);
			if (tag != 0xFFD8)
				throw new HPDF_Error("",HPDF_Error.HPDF_INVALID_JPEG_DATA,0);
			
			/* find SOF record */
			for (;;) 
			{
				var size 	: uint; 
				
				len = 2;
				tag = ins.readUnsignedShort(); ; 
				/*if (HPDF_Stream_Read (stream, (HPDF_BYTE *)&tag,  &len) != HPDF_OK)
					return HPDF_Error_GetCode (stream->error);
				
				HPDF_UInt16Swap (&tag);
				
				len = 2;
				*/
				size = ins.readUnsignedShort(); 
				/*if (HPDF_Stream_Read (stream, (HPDF_BYTE *)&size,  &len) != HPDF_OK)
					return HPDF_Error_GetCode (stream->error);
				
				HPDF_UInt16Swap (&size);
				*/
				trace ( "tag= + " +  tag.toString() + " size=" + size.toString() );
				
				if (tag == 0xFFC0 || tag == 0xFFC1 ||
					tag == 0xFFC2 || tag == 0xFFC9) {
					
					/*len = 1;
					if (HPDF_Stream_Read (stream, (HPDF_BYTE *)&precision, &len) !=
						HPDF_OK)
						return HPDF_Error_GetCode (stream->error);
					*/
					precision = ins.readByte();
					/*len = 2;
					if (HPDF_Stream_Read (stream, (HPDF_BYTE *)&height, &len) !=
						HPDF_OK)
						return HPDF_Error_GetCode (stream->error);
					
					HPDF_UInt16Swap (&height);
					*/
					height = ins.readUnsignedShort();
					/*len = 2;
					if (HPDF_Stream_Read (stream, (HPDF_BYTE *)&width, &len) != HPDF_OK)
						return HPDF_Error_GetCode (stream->error);
					
					HPDF_UInt16Swap (&width);
					*/
					width = ins.readUnsignedShort();
					
					/*len = 1;
					if (HPDF_Stream_Read (stream, (HPDF_BYTE *)&num_components, &len) !=
						HPDF_OK)
						return HPDF_Error_GetCode (stream->error);
					*/
					numComponents = ins.readByte();
					
					break;
				} 
				else if ((tag | 0x00FF) != 0xFFFF)
					/* lost marker */
					throw new HPDF_Error("LoadJpegHeader",HPDF_Error.HPDF_UNSUPPORTED_JPEG_FORMAT,0);
				
				//if (HPDF_Stream_Seek (stream, size - 2, HPDF_SEEK_CUR) != HPDF_OK)
					//return HPDF_Error_GetCode (stream->error);
				ins.position += size -2; 
			}
			
			HPDF_Dict_AddNumber ( "Height", height);
			
			HPDF_Dict_AddNumber ( "Width", width);
			
			/* classification of RGB and CMYK is less than perfect
			* YCbCr and YCCK are classified into RGB or CMYK.
			*
			* It is necessary to read APP14 data to distinguish colorspace perfectly.
			
			*/
			switch (numComponents) {
				case 1:
					colorSpaceName = COL_GRAY;
					break;
				case 3:
					colorSpaceName = COL_RGB;
					break;
				case 4:
					array =  new HPDF_Array();
					
					HPDF_Dict_Add ( "Decode", array);
					
					array.HPDF_Array_Add ( new HPDF_Number( 1));
					array.HPDF_Array_Add ( new HPDF_Number( 0));
					array.HPDF_Array_Add ( new HPDF_Number( 1));
					array.HPDF_Array_Add ( new HPDF_Number( 0));
					array.HPDF_Array_Add ( new HPDF_Number( 1));
					array.HPDF_Array_Add ( new HPDF_Number( 0));
					array.HPDF_Array_Add ( new HPDF_Number( 1));
					array.HPDF_Array_Add ( new HPDF_Number( 0));
					
					colorSpaceName = COL_CMYK;
					
					break;
				default:
					throw new HPDF_Error("LoadJpegHeader",HPDF_Error.HPDF_UNSUPPORTED_JPEG_FORMAT,0);
			}
			
			HPDF_Dict_Add ("ColorSpace",new HPDF_Name( colorSpaceName));
			HPDF_Dict_Add ("BitsPerComponent",new HPDF_Number( precision));
			
		}
		
	
	}
}