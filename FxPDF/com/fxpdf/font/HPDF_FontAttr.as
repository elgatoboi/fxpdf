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
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.types.C_NumberPointer;
	import com.fxpdf.types.HPDF_TextWidth;
	import com.fxpdf.xref.HPDF_Xref;
	
	public class HPDF_FontAttr
	{
		
		public	var	type 		: uint ; 
    	public	var	writingMode	: uint ; 
    	public	var	fontdef		: HPDF_FontDef 
    	public	var	encoder		: HPDF_Encoder; 
    	
    	public	var	widths		: Vector.<uint>;
    	public	var	used		: Vector.<uint>;
    	
    	public	var	xref		: HPDF_Xref ; 
    	public	var	descendantFont	: HPDF_Dict ; 
    	public	var	mapStream	: HPDF_Dict; 
    	public	var	cmapStream	: HPDF_Dict; 
    	
		public function HPDF_FontAttr()
		{
			
		}
		
		public	function	textWidthFn( font:HPDF_Font, text : String, len : uint ) : HPDF_TextWidth
		{
			throw new Error("Function textWidthFn  not implemented by HPDF_FontAttr !  " ) ; 
		}
		
		
		public	function	measureTextFn( font : HPDF_Font , text :String, len : uint, 
		width : Number, fontSize : Number, charSpace : Number, wordSpace:Number, wordwrap : Boolean, realWidth : C_NumberPointer ) : Number
		{
			throw new Error("Function measure text not implemented by HPDF_FontAttr !  " ) ; 
		}

	}
}