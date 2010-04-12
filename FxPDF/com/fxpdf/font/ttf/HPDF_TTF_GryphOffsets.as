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
package com.fxpdf.font.ttf
{
	import __AS3__.vec.Vector;
	
	public class HPDF_TTF_GryphOffsets
	{
			 /* C HPDF_UINT32   base_offset;
		        HPDF_UINT32  *offsets;
		        HPDF_BYTE    *flgs;   /* 0: unused, 1: used */
		        
		        
		public	var	baseOffset : uint ; 
		public	var	offsets : Vector.<uint> ;
		public	var	flgs	: Vector.<uint>; // ??
		
		
		public function HPDF_TTF_GryphOffsets()
		{
		 
		}

	}
}