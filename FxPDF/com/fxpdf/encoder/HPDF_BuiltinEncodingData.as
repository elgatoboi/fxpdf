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
	public class HPDF_BuiltinEncodingData
	{
		/* C  const char     *encoding_name;
    HPDF_BaseEncodings  base_encoding;
    const HPDF_UNICODE  *ovewrride_map;
    */
    	public	var	encodingName : String ; 
    	public	var	baseEncoding	: int ; 
    	public	var	ovewrrideMap : Array ;  
    	
		public function HPDF_BuiltinEncodingData( encodingName : String = "" , baseEncoding : int = 0 , overrideMap  : Array	=	null)
		{
			this.encodingName	=	encodingName; 
			this.baseEncoding	=	baseEncoding;
			this.ovewrrideMap	=	overrideMap ; 
		}

	}
}