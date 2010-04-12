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
	public class HPDF_TextWidth
	{

    	public	var	numchars 	: uint ; 
    	public	var	width 		: uint ; 
    	public	var	numspace	: uint ; 
    	public	var	numwords	: uint ;
    	 
		public function HPDF_TextWidth( numchars : uint = 0 , width : uint = 0, numspace : uint = 0 , numwords : uint = 0 )
		{
			this.numchars	=	numchars;
			this.width		=	width;
			this.numspace	=	numspace;
			this.numwords	=	numwords;
		}

	}
}