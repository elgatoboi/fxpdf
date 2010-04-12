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
package com.fxpdf.encoder
{
	public class HPDF_BasicEncoderAttr
	{
	/*	char           base_encoding[HPDF_LIMIT_MAX_NAME_LEN + 1];
      HPDF_BYTE           first_char;
      HPDF_BYTE           last_char;
      HPDF_UNICODE        unicode_map[256];
      HPDF_BOOL           has_differences;
      HPDF_BYTE           differences[256];
      */ 
		
		public	var	baseEncoding	: String ; 
		public	var	firstChar		: uint ; 
		public	var	lastChar		: uint ; 
		public	var	unicodeMap		: Array;
		public	var	hasDifferences : Boolean ; 
		public	var	differences		: Array ; 
		public function HPDF_BasicEncoderAttr()
		{
			unicodeMap	=	new Array(255);
			differences	=	new Array(255);
		}

	}
}