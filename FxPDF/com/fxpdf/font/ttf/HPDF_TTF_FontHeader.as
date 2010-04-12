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
	import flash.utils.ByteArray;
	
	public class HPDF_TTF_FontHeader
	{
		
		public	var	versionNumber	: ByteArray ; // what type ? length 4
		
		public	var fontRevision : uint ;
	    public	var checkSumAdjustment: uint ;
	    public	var magicNumber: uint ;
	    public	var flags: uint ;
	    public	var unitsPerEm: uint ;
	    public	var created : ByteArray; // what type should we use ?
	    public	var modified : ByteArray ;  // what type should we use ?
	    public	var xMin : int ; 
	    public	var yMin: int ; 
	    public	var xMax: int ; 
	    public	var yMax: int ; 
	    public	var macStyle : uint ; 
	    public	var lowestRecPpem : uint ; 
	    public	var fontDirectionHint: int ; 
	    public	var indexToLocFormat: int ; 
	    public	var glyphDataFormat: int ; 
	
		public function HPDF_TTF_FontHeader()
		{
		}

	}
}