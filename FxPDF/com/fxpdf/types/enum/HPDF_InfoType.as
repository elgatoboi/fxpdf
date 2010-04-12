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
	public class HPDF_InfoType
	{
		public	static	const	HPDF_INFO_CREATION_DATE : Number = 0;
	    public	static	const	HPDF_INFO_MOD_DATE : Number = 1;
	
	    /* string type parameters */
	    public	static	const	HPDF_INFO_AUTHOR : Number = 2;
	    public	static	const	HPDF_INFO_CREATOR : Number = 3;
	    public	static	const	HPDF_INFO_PRODUCER : Number = 4;
	    public	static	const	HPDF_INFO_TITLE : Number = 5;
	    public	static	const	HPDF_INFO_SUBJECT : Number = 6;
	    public	static	const	HPDF_INFO_KEYWORDS : Number = 7;
	    public	static	const	HPDF_INFO_EOF : Number =  8;
	    
	    
		public function HPDF_InfoType()
		{
		}

	}
}