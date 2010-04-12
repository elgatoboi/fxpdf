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
package com.fxpdf
{
	public class HPDF_Conf
	{
		
		/* default buffer size of memory-stream-object */
		public static const  HPDF_STREAM_BUF_SIZ  : Number	=       4096;
		
		/* default array size of list-object */
		public static const  HPDF_DEF_ITEMS_PER_BLOCK   : Number	= 20;
		
		/* default array size of cross-reference-table */
		public static const  HPDF_DEFALUT_XREF_ENTRY_NUM : Number	=1024;
		
		/* default array size of widths-table of cid-fontdef */
		public static const  HPDF_DEF_CHAR_WIDTHS_NUM : Number	=   128;
		
		/* default array size of page-list-tablef */
		public static const  HPDF_DEF_PAGE_LIST_NUM : Number	=     256;
		
		/* default array size of range-table of cid-fontdef */
		public static const  HPDF_DEF_RANGE_TBL_NUM : Number	=     128;
		
		/* default buffer size of memory-pool-object */
		public static const  HPDF_MPOOL_BUF_SIZ: Number	=          8192;
		public static const  HPDF_MIN_MPOOL_BUF_SIZ  : Number	=    256;
		public static const  HPDF_MAX_MPOOL_BUF_SIZ : Number	=     1048576;
		
		
		public function HPDF_Conf()
		{
		}

	}
}