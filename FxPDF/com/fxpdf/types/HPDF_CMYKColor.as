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
	public class HPDF_CMYKColor
	{
		public	var	c : Number;
		public	var	m : Number;
		public	var	y : Number;
		public	var	k : Number;
		
		public function HPDF_CMYKColor( c : Number = 0, m : Number = 0, y : Number = 0, k : Number = 0)
		{
			this.c =	c;
			this.m =	m;
			this.y =	y;
			this.k =	k;
		}

	}
}