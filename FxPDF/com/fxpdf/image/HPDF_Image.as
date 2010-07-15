/*
* Source used from a project PurePDF under the terms of LGPL licence 
*                             ______ _____  _______ 
* .-----..--.--..----..-----.|   __ \     \|    ___|
* |  _  ||  |  ||   _||  -__||    __/  --  |    ___|
* |   __||_____||__|  |_____||___|  |_____/|___|    
* |__|
* $Id: Font.as 249 2010-02-02 06:59:26Z alessandro.crugnola $
* $Author Alessandro Crugnola $
* $Rev: 249 $ $LastChangedDate: 2010-02-02 07:59:26 +0100 (Wt, 02 lut 2010) $
* $URL: http://purepdf.googlecode.com/svn/tags/0.20.20100205/src/org/purepdf/Font.as $
*
* The contents of this file are subject to  LGPL license 
* (the "GNU LIBRARY GENERAL PUBLIC LICENSE"), in which case the
* provisions of LGPL are applicable instead of those above.  If you wish to
* allow use of your version of this file only under the terms of the LGPL
* License and not to allow others to use your version of this file under
* the MPL, indicate your decision by deleting the provisions above and
* replace them with the notice and other provisions required by the LGPL.
* If you do not delete the provisions above, a recipient may use your version
* of this file under either the MPL or the GNU LIBRARY GENERAL PUBLIC LICENSE
*
* Software distributed under the License is distributed on an "AS IS" basis,
* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
* for the specific language governing rights and limitations under the License.
*
* The Original Code is 'iText, a free JAVA-PDF library' ( version 4.2 ) by Bruno Lowagie.
* All the Actionscript ported code and all the modifications to the
* original java library are written by Alessandro Crugnola (alessandro@sephiroth.it)
*
* This library is free software; you can redistribute it and/or modify it
* under the terms of the MPL as stated above or under the terms of the GNU
* Library General Public License as published by the Free Software Foundation;
* either version 2 of the License, or any later version.
*
* This library is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU LIBRARY GENERAL PUBLIC LICENSE for more
* details
*
* If you didn't download this code from the following link, you should check if
* you aren't using an obsolete version:
* http://code.google.com/p/purepdf
*
*/
package com.fxpdf.image
{
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.dict.HPDF_DictStream;
	import com.fxpdf.dict.HPDF_Null;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Boolean;
	import com.fxpdf.objects.HPDF_Name;
	import com.fxpdf.objects.HPDF_Number;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.types.HPDF_Point;
	import com.fxpdf.xref.HPDF_Xref;
	
	import flash.utils.ByteArray;

	public class HPDF_Image extends HPDF_DictStream
	{
		
		public static const COL_CMYK	: String = "DeviceCMYK";
		public static const COL_RGB		: String = "DeviceRGB";
		public static const COL_GRAY	: String = "DeviceGray";

		
		
		public var width:int;
		public var height:int;
		public var resourceId:int;
		public var n:int;
		public var colorSpace 			: int;
		public var bitsPerComponent		: int = 8;
		public var transparency:String;
		public var parameters:String;
		public var pal:String;
		public var masked:Boolean;
		public var ct:Number;
		public var progressive:Boolean;
		public var imageStream:ByteArray;
		
		
		public function HPDF_Image( xref:HPDF_Xref )
		{
			super( xref );
			
			header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_XOBJECT;
			HPDF_Dict_AddName ( "Type", "XObject");
			HPDF_Dict_AddName ( "Subtype", "Image");
			
		}
		
		
		public function HPDF_Image_GetWidth  ():Number
		{
			return HPDF_Image_GetSize().x;
		}
		
		public function HPDF_Image_GetHeight  ():Number
		{
			return HPDF_Image_GetSize().y;
		}
		
		public function HPDF_Image_GetSize(): HPDF_Point
		{
			var width : HPDF_Number;
			var height : HPDF_Number;
			var ret		: HPDF_Point = new HPDF_Point();
			
			trace ((" HPDF_Image_GetSize\n"));
			
			
			width = HPDF_Dict_GetItem ( "Width", HPDF_Obj_Header.HPDF_OCLASS_NUMBER) as HPDF_Number;
			height = HPDF_Dict_GetItem ( "Height",  HPDF_Obj_Header.HPDF_OCLASS_NUMBER) as HPDF_Number;
			
			if (width && height) {
				ret.x = width.value;
				ret.y = height.value;
			}
			
			return ret;
		}
		
		public function HPDF_Image_SetMaskImage  ( maskImage : HPDF_Image ) : void 
		{
			
			maskImage.HPDF_Image_SetMask ( true);
			
			return HPDF_Dict_Add ( "Mask", maskImage);
		}
		
		public function HPDF_Image_SetMask ( mask : Boolean ) : void
		{
			var image_mask : HPDF_Boolean;  
			
			if (mask && HPDF_Image_GetBitsPerComponent () != 1)
				throw new HPDF_Error("HPDF_Image_SetMask", HPDF_Error.HPDF_INVALID_BIT_PER_COMPONENT,				0);
			
			image_mask = HPDF_Dict_GetItem ( "ImageMask", HPDF_Obj_Header.HPDF_OCLASS_BOOLEAN ) as HPDF_Boolean;
			if (!image_mask) {
				image_mask = new HPDF_Boolean ( );
				
				HPDF_Dict_Add ( "ImageMask", image_mask)
			}
			
			image_mask.value = mask;
		}
		
		public function HPDF_Image_GetBitsPerComponent ()  : int 
		{
			return bitsPerComponent;
		}
		
		
		public function HPDF_Image_GetColorSpace(): String
		{
			var n : HPDF_Name;
			
			trace (" HPDF_Image_GetColorSpace");
			
			n = HPDF_Dict_GetItem ( "ColorSpace", HPDF_Obj_Header.HPDF_OCLASS_NAME) as HPDF_Name;
			
			if (!n) {
				return null; 
			}
			
			return n.value;
		}
		public function HPDF_Image_SetColorMask ( rmin  :uint, rmax : uint , gmin : uint , gmax : uint, bmin : uint , bmax : uint ) : void
		{
			var array 			: HPDF_Array;
			var name			: String; 
			
			
			if ( HPDF_Dict_GetItem ("ImageMask", HPDF_Obj_Header.HPDF_OCLASS_BOOLEAN))
				throw new HPDF_Error("HPDF_Image_SetColorMask", HPDF_Error.HPDF_INVALID_OPERATION, 0);
			
			if (  HPDF_Image_GetBitsPerComponent() != 8)
				throw new HPDF_Error("HPDF_Image_SetColorMask", HPDF_Error.HPDF_INVALID_BIT_PER_COMPONENT, 0);
			
			name = HPDF_Image_GetColorSpace ();
			if (!name || COL_RGB != name)
				throw new HPDF_Error("HPDF_Image_SetColorMask", HPDF_Error.HPDF_INVALID_COLOR_SPACE, 0);
				
			/* Each integer must be in the range 0 to 2^BitsPerComponent - 1 */
			if (rmax > 255 || gmax > 255 || bmax > 255)
				throw new HPDF_Error("HPDF_Image_SetColorMask", HPDF_Error.HPDF_INVALID_PARAMETER, 0);
			
			array = new HPDF_Array();
			
			HPDF_Dict_Add ( "Mask", array);
			array.HPDF_Array_AddNumber ( rmin);
			array.HPDF_Array_AddNumber (  rmax);
			array.HPDF_Array_AddNumber (  gmin);
			array.HPDF_Array_AddNumber (  gmax);
			array.HPDF_Array_AddNumber (  bmin);
			array.HPDF_Array_AddNumber (  bmax);
			
		}




		
		
		
	}
}