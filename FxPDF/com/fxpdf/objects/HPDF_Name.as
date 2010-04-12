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
	import com.fxpdf.error.HPDF_Error;
	
	public class HPDF_Name extends HPDF_Object
	{
		
	/*	HPDF_Obj_Header  header;
    HPDF_Error       error;
    char        value[HPDF_LIMIT_MAX_NAME_LEN + 1];
} HPDF_Name_Rec;
*/
		public	var	error	: HPDF_Error; 
		public	var	value : String ; 
		 
		public function HPDF_Name( pValue : String)
		{
			header	=	new HPDF_Obj_Header( ) ; 
			header.objClass	=	HPDF_Obj_Header.HPDF_OCLASS_NAME;
			value	=	pValue ; 
		}

	}
}