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
package com.fxpdf.types
{
	public class HPDF_Box
	{
		public	var	bottom : Number;
		public	var	top : Number ;
		public	var left : Number; 
		public	var	right : Number  ; 
		
		public function HPDF_Box( left : Number = 0, bottom : Number = 0, right : Number = 0, top : Number = 0)
		{
			this.left	=	left;
			this.bottom	=	bottom ; 
			this.right	=	right; 
			this.top	=   top ; 
			
		}

	}
}