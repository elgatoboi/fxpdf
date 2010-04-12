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
package com.fxpdf.objects
{
	import mx.messaging.AbstractConsumer;
	
	
	/** represents HPDF_Obj_Header */
	public class HPDF_Obj_Header
	{
	
		public static const  HPDF_OTYPE_NONE   : Number = 0x00000000;
		public static const  HPDF_OTYPE_DIRECT : Number =            0x80000000;
		public static const  HPDF_OTYPE_INDIRECT: Number =           0x40000000;
		public static const  HPDF_OTYPE_ANY   : Number =             (HPDF_OTYPE_DIRECT | HPDF_OTYPE_INDIRECT);
		public static const  HPDF_OTYPE_HIDDEN : Number =            0x10000000 ;
		
		public static const  HPDF_OCLASS_UNKNOWN  : Number =         0x0001;
		public static const  HPDF_OCLASS_NULL   : Number =           0x0002;
		public static const  HPDF_OCLASS_BOOLEAN : Number =          0x0003;
		public static const  HPDF_OCLASS_NUMBER   : Number =         0x0004;
		public static const  HPDF_OCLASS_REAL : Number =             0x0005;
		public static const  HPDF_OCLASS_NAME  : Number =            0x0006;
		public static const  HPDF_OCLASS_STRING  : Number =          0x0007;
		public static const  HPDF_OCLASS_BINARY  : Number =          0x0008;
		public static const  HPDF_OCLASS_ARRAY  : Number =           0x0010;
		public static const  HPDF_OCLASS_DICT   : Number =           0x0011;
		public static const  HPDF_OCLASS_PROXY  : Number =           0x0012;
		public static const  HPDF_OCLASS_ANY   : Number =            0x00FF;
		
		public static const  HPDF_OSUBCLASS_FONT  : Number =         0x0100;
		public static const  HPDF_OSUBCLASS_CATALOG : Number =       0x0200;
		public static const  HPDF_OSUBCLASS_PAGES : Number =         0x0300;
		public static const  HPDF_OSUBCLASS_PAGE   : Number =        0x0400;
		public static const  HPDF_OSUBCLASS_XOBJECT  : Number =      0x0500;
		public static const  HPDF_OSUBCLASS_OUTLINE  : Number =      0x0600;
		public static const  HPDF_OSUBCLASS_DESTINATION : Number =   0x0700;
		public static const  HPDF_OSUBCLASS_ANNOTATION : Number =    0x0800;
		public static const  HPDF_OSUBCLASS_ENCRYPT   : Number =     0x0900;
		public static const  HPDF_OSUBCLASS_EXT_GSTATE  : Number =   0x0A00;
		public static const  HPDF_OSUBCLASS_EXT_GSTATE_R  : Number = 0x0B00; /* read only object */ 


		
	
 
		/*  HPDF_UINT32  obj_id;
    	HPDF_UINT16  gen_no;
    	HPDF_UINT16  obj_class;
    	*/
    	
    	public	var	objId 	: Number; 
		public	var	genNo	:Number;
		public	var	objClass : Number; 
		
		
		public function HPDF_Obj_Header()
		{
		}
		
		public	function	HPDF_Obj_Free() : void
		{
			//if (!(header->obj_id & HPDF_OTYPE_INDIRECT))
        		//HPDF_Obj_ForceFree (mmgr, obj);
        	//if ( ! 
		}
		

	}
}