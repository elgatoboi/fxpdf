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
package com.fxpdf.types.enum
{
	public class HPDF_ColorSpace
	{
		
		public	static	const	HPDF_CS_DEVICE_GRAY : Number = 0;
	    public	static	const	HPDF_CS_DEVICE_RGB : Number = 1;
	    public	static	const	HPDF_CS_DEVICE_CMYK : Number = 2;
	    public	static	const	HPDF_CS_CAL_GRAY : Number = 3;
	    public	static	const	HPDF_CS_CAL_RGB : Number = 4;
	    public	static	const	HPDF_CS_LAB : Number = 5;
	    public	static	const	HPDF_CS_ICC_BASED : Number = 6;
	    public	static	const	HPDF_CS_SEPARATION : Number = 7;
	    public	static	const	HPDF_CS_DEVICE_N : Number = 8;
	    public	static	const	HPDF_CS_INDEXED : Number = 9;
	    public	static	const	HPDF_CS_PATTERN : Number = 10;
	    public	static	const	HPDF_CS_EOF  : Number = 11;
	    
		public function HPDF_ColorSpace()
		{
		}

	}
}