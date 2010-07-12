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
		
		
		
		
		
	}
}