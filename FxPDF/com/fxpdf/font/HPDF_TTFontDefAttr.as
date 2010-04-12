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
package com.fxpdf.font
{
	import __AS3__.vec.Vector;
	
	import flash.utils.ByteArray;
	
	import com.fxpdf.font.ttf.*;
	
	public class HPDF_TTFontDefAttr extends HPDF_Type1FontDefAttr
	{
		public	var	baseFont : String ; 
		public	var	firstChar	: uint ; 
	//	public	var	lastChar	: uint ; 
	//	public	var	charSet 	: String ; 
		public	var	tagName		: String ; 
		public	var	tagName2	: String ; 
		
		public	var	header		: HPDF_TTF_FontHeader;
		public	var	glyphTbl	: HPDF_TTF_GryphOffsets;
		
		public	var	numGlyphs	: uint ; 
		public	var	nameTbl		: HPDF_TTF_NamingTable ;
		public	var	hMetric		: Vector.<HPDF_TTF_LongHorMetric> ; 
		public	var	numHMetric	: uint ; 
		public	var	offsetTbl 	: HPDF_TTF_OffsetTbl ; 
		public	var	cmap		: HPDF_TTF_CmapRange ; 
		public	var	fsType		: uint ; 
		public	var	panose		: Vector.<uint> ; 
		public	var	codePageRange1	: uint ; 
		public	var	codePageRange2	: uint ; 
		
	//	public	var	length1		: uint ; 
		public	var	embedding	: Boolean ;
		public	var	isCidFont	: Boolean ; 
		// public	var	stream		: HPDF_Stream;
	//	public	var	fontData	: ByteArray ; 

		public function HPDF_TTFontDefAttr()
		{
		}

	}
}