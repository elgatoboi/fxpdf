/*
Copyright 2010 FxPDF.com

FxPDF is based on libHaru code originally developed & maintained by Takeshi Kanno (libHaru.org). 

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package com.fxpdf.page
{
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.font.HPDF_Font;
	import com.fxpdf.font.HPDF_FontAttr;
	import com.fxpdf.image.HPDF_Image;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.objects.HPDF_PageAttr;
	import com.fxpdf.types.C_NumberPointer;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.HPDF_ParseText;
	import com.fxpdf.types.HPDF_Point;
	import com.fxpdf.types.HPDF_Real;
	import com.fxpdf.types.HPDF_TextWidth;
	import com.fxpdf.types.HPDF_TransMatrix;
	import com.fxpdf.types.enum.HPDF_ByteType;
	import com.fxpdf.types.enum.HPDF_FontType;
	import com.fxpdf.types.enum.HPDF_TextAlignment;
	import com.fxpdf.types.enum.HPDF_TextRenderingMode;
	import com.fxpdf.types.enum.HPDF_WritingMode;
	
	public class HPDF_Page_ImageFunctions
	{
		private	var	page : HPDF_Page	;
		
		
		private	static const INIT_POS : HPDF_Point	=	new HPDF_Point(0, 0);
		
		public function HPDF_Page_ImageFunctions( page : HPDF_Page)
		{
			this.page	=	page; 
		}
		
		public	function	get	pageAttr ( ) : HPDF_PageAttr
		{
			return page.attr as HPDF_PageAttr;
		}
		
		/** Text object operators **/
		
		public	function	HPDF_Page_DrawImage( image:HPDF_Image, x:Number, y:Number, width:Number, height:Number ) : void
		{
			
			page.HPDF_Page_GSave ( );
				
			page.HPDF_Page_Concat (width, 0, 0, height, x, y);
			
			page.HPDF_Page_ExecuteXObject ( image );
			
			page.HPDF_Page_GRestore (); 
		        
		} //  end HPDF_Page_DrawImage
		
		
		
		public function HPDF_Page_ExecuteXObject( obj:HPDF_Dict ):void
		{
			page.HPDF_Page_CheckState( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION );
			var localName		:String;
			
			
			trace (" HPDF_Page_ExecuteXObject");
			
			
			if (!obj || obj.header.objClass != ( HPDF_Obj_Header.HPDF_OSUBCLASS_XOBJECT | HPDF_Obj_Header.HPDF_OCLASS_DICT))
				throw new HPDF_Error("HPDF_Page_ExecuteXObject", HPDF_Error.HPDF_INVALID_OBJECT );
			
			localName = HPDF_Page_GetXObjectName ( obj );
			
			if (!localName)
				throw new HPDF_Error("HPDF_Page_ExecuteXObject", HPDF_Error.HPDF_INVALID_OBJECT );
			
			pageAttr.stream.HPDF_Stream_WriteEscapeName ( localName );
			
			pageAttr.stream.HPDF_Stream_WriteStr (" Do"+ HPDF_Utils.NEW_LINE );
			
		}
		
		public function HPDF_Page_GetXObjectName( xobj:HPDF_Dict ):String
		{
			var key	:String;
			
			trace(" HPDF_Page_GetXObjectName");
			
			if (!pageAttr.xobjects) {
				var resources	:HPDF_Dict;
				var xobjects	:HPDF_Dict;
				
				resources =  page.HPDF_Page_GetInheritableItem ( "Resources", HPDF_Obj_Header.HPDF_OCLASS_DICT) as HPDF_Dict;
				if (!resources)
					return null;
				
				xobjects = new HPDF_Dict();
				if (!xobjects)
					return null;
				
				resources.HPDF_Dict_Add ("XObject", xobjects);
				
				pageAttr.xobjects = xobjects;
			}
			
			/* search xobject-object from xobject-resource */
			key = pageAttr.xobjects.HPDF_Dict_GetKeyByObj ( xobj );
			if (!key) {
				/* if the xobject is not resisterd in xobject-resource, register
				* xobject to xobject-resource.
				*/
				var xobjName		:String = "X";
				/*char xobj_name[HPDF_LIMIT_MAX_NAME_LEN + 1];
				char *ptr;
				char *end_ptr = xobj_name + HPDF_LIMIT_MAX_NAME_LEN;
				*/
				//ptr = HPDF_StrCpy (xobj_name, "X", end_ptr);
				
				//HPDF_IToA (ptr, attr->xobjects->list->count + 1, end_ptr);
				xobjName += HPDF_Utils.HPDF_IToA( pageAttr.xobjects.list.length +1 );
				
				pageAttr.xobjects.HPDF_Dict_Add (xobjName, xobj);
				
				key = pageAttr.xobjects.HPDF_Dict_GetKeyByObj ( xobj);
			}
			
			return key;
		}
	}
  

	
}