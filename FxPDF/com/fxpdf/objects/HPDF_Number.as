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
	public class HPDF_Number extends HPDF_Object
	{
		public	var	value : Number ; 
		
		public function HPDF_Number( pValue : Number)
		{
				super( );
				header.objClass	=	HPDF_Obj_Header.HPDF_OCLASS_NUMBER ; 
				value 			=	pValue ; 
		}
		
		public	function	HPDF_Number_SetValue( pValue : Number ) : void
		{
			value	=	pValue ; 
		}

	}
}