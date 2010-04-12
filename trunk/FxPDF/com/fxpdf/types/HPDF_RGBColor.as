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
	public class HPDF_RGBColor
	{
		public	var	r : Number;
		public	var	g : Number;
		public	var	b : Number;
		
		
		public function HPDF_RGBColor( r:Number=0, g:Number=0, b:Number=0)
		{
			this.r	=	r;
			this.g	=	g;
			this.b	=	b;
		}
		// generuje kolor ze stringu w postaci #RRGGBB
		public	function	fromString( pString:String):void
		{
				var cr:String = pString.substr(1,2);
				var cg:String = pString.substr(3,2); 
				var cb:String = pString.substr(5,2);
				
				r = Number(  "0x" + cr );
				g = Number(  "0x" + cg ); 
				b = Number(  "0x" + cb );  
		}
		
		
		
		public	static 	const	COLOR_BLACK:HPDF_RGBColor	=	new HPDF_RGBColor( 0,0,0 ) ;


	}
}