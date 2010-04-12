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
package com.fxpdf.streams
{
	import flash.utils.ByteArray;
	
	public class HPDF_MemStreamAttr
	{
		
	/* C	HPDF_List  buf;
    HPDF_UINT  buf_siz;
    HPDF_UINT  w_pos;
    HPDF_BYTE  *w_ptr;
    HPDF_UINT  r_ptr_idx;
    HPDF_UINT  r_pos;
    HPDF_BYTE  *r_ptr;*/
     
    
    	/*public	var	buf : HPDF_List ; 
    	public	var	bufSiz : uint ; 
    	public	var	wPos	: uint ; 
    	public	var	wPtr : Object ; 
    	public	var	rPtrIdx	 : uint ; 
    	public	var	rPos	: uint ; 
    	public	var	rPtr	: *;
    	
    	*/
    	
    	public	var	buf : ByteArray ;  
    	
    	
		public function HPDF_MemStreamAttr()
		{
			buf = new ByteArray( ); 
		}

	}
}