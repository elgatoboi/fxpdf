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
	import flash.utils.ByteArray;
	
	public class HPDF_Type1FontDefAttr
	{
	/* C 	HPDF_BYTE       first_char;                               /* Required */
    /* C HPDF_BYTE       last_char;                                /* Required */
    /* C HPDF_CharData  *widths;                                   /* Required */
    /* C HPDF_UINT       widths_count;

    HPDF_INT16      leading;
    char      *char_set;
    char       encoding_scheme[HPDF_LIMIT_MAX_NAME_LEN + 1];
    HPDF_UINT       length1;
    HPDF_UINT       length2;
    HPDF_UINT       length3;
    HPDF_BOOL       is_base14font;
    HPDF_BOOL       is_fixed_pitch;

    HPDF_Stream     font_data; */
    
    	
    
    	public	var	fistChar : uint; 
    	public	var	lastChar : uint; 
    	public	var	widths	: Vector.<HPDF_CharData>;
    	public	var	widthCount	: uint ; 
    	
    	public	var	leading	: int ; 
    	public	var	charSet	: String ; 
    	public	var	encodingScheme : String ; 
    	public	var	length1 : uint ;
    	public	var	length2 : uint ;
    	public	var	length3 : uint ;
    	public	var	isBase14Font	: Boolean; 
    	public	var	isFixedPitch	: Boolean ; 
    	public	var	fontData		: ByteArray ; 
    	
		public function HPDF_Type1FontDefAttr()
		{
		}

	}
}