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
package com.fxpdf.objects
{
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.encrypt.HPDF_Encrypt;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.types.HPDF_Point;
	import com.fxpdf.types.enum.HPDF_FontType;
	import com.fxpdf.xref.HPDF_Xref;
	
	public class HPDF_PageAttr
	{
		
		/* C 
		 HPDF_Pages         parent;
	    HPDF_Dict          fonts;
	    HPDF_Dict          xobjects;
	    HPDF_Dict          ext_gstates;
	    HPDF_GState        gstate;
	    HPDF_Point         str_pos;
	    HPDF_Point         cur_pos;
	    HPDF_Point         text_pos;
	    HPDF_TransMatrix   text_matrix;
	    HPDF_UINT16        gmode;
	    HPDF_Dict          contents;
	    HPDF_Stream        stream;
	    HPDF_Xref          xref;
	    HPDF_UINT          compression_mode;
		HPDF_PDFVer       *ver;  
		 */
		 
		 
		 
		public	var	parent : HPDF_Pages	; 
		public	var	fonts	: HPDF_Dict ; 
		public	var	xobjects : HPDF_Dict ; 
		public	var	extGStates	: HPDF_Dict ; 
		public	var	gstate	: * ; // TODO 
		
		public	var	strPos : *; 
		public	var	curPos : HPDF_Point ; 
		public	var	textPos: HPDF_Point ;  
		public	var textMatrix : Object ; 
		
		public	var	gmode : Number ; 
		public var	contents : HPDF_Dict ; 
		public	var	stream : HPDF_Stream ; 
		public	var	xref : HPDF_Xref ; 
		public	var	compressionMode : Number ; 
		public	var	ver : Object; 
		
		
		public function HPDF_PageAttr()
		{
		}
		
		public	function	InternalWriteText  ( text : String) : void
		{
		    
		    var	fontAttr : Object	=	gstate.font.attr;
		    trace (" InternalWriteText");

			stream.HPDF_Stream_WriteStr ("<");
			
		    if ( fontAttr.type == HPDF_FontType.HPDF_FONT_TYPE0_TT ) 
		    {
		        stream.HPDF_Stream_WriteBinary ( HPDF_Utils.StringToByteArray(text), null as HPDF_Encrypt);
				stream.HPDF_Stream_WriteStr ( ">");		
				return; 
			}
			if ( fontAttr.type == HPDF_FontType.HPDF_FONT_TYPE0_CID) 
			{
				stream.HPDF_Stream_WriteBinary ( HPDF_Utils.StringToByteArray(text,true,"cn-gb"), null as HPDF_Encrypt);
				stream.HPDF_Stream_WriteStr ( ">");
				return ; 
			}
		    stream.HPDF_Stream_WriteEscapeText ( text,fontAttr.encoder );
			stream.HPDF_Stream_WriteStr ( ">");
			return; 
						

		}


	}
}