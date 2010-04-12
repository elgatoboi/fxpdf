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
package com.fxpdf.page
{
	import com.fxpdf.HPDF_Consts;
	import com.fxpdf.HPDF_Utils;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.types.enum.HPDF_ColorSpace;
	
	
	public class HPDF_PageColorFunctions
	{
		private	var	page : HPDF_Page	;
		
		public function HPDF_PageColorFunctions( page:HPDF_Page )
		{
			this.page = page; 
		}
		
		
		public	function	HPDF_Page_SetGrayFill( gray : Number ) : void
		{
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION |  HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
			
    		trace (" HPDF_Page_SetGrayFill");

		    
		    if (gray < 0 || gray > 1)
		        throw new HPDF_Error("HPDF_Page_SetGrayFill", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, 0);
		
		    page.pageAttr.stream.HPDF_Stream_WriteReal(gray);
		    page.pageAttr.stream.HPDF_Stream_WriteStr ( " g" + HPDF_Utils.NEW_LINE ) ;
		
		    page.pageAttr.gstate.grayFill	= gray;
		    page.pageAttr.gstate.csFill		= HPDF_ColorSpace.HPDF_CS_DEVICE_GRAY;
		    
		}
		
		public	function	HPDF_Page_SetGrayStroke( gray : Number ) : void
		{
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION |  HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
			
    		trace (" HPDF_Page_SetGrayStroke");

		    if (gray < 0 || gray > 1)
		        throw new HPDF_Error("HPDF_Page_SetGrayStroke", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, 0);
		
		    page.pageAttr.stream.HPDF_Stream_WriteReal (gray);
		    page.pageAttr.stream.HPDF_Stream_WriteStr (  " G" + HPDF_Utils.NEW_LINE ) ;
		
		    page.pageAttr.gstate.grayStroke	=	gray;
		    page.pageAttr.gstate.csStroke	=	HPDF_ColorSpace.HPDF_CS_DEVICE_GRAY;
		}
		
		public	function	HPDF_Page_SetRGBStroke( r : Number, g: Number, b : Number) : void
		{
			var pbuf : String ; 
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION |  HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
			
    		trace (" HPDF_Page_SetRGBStroke");

		    if ( r < 0 || r > 1 || g < 0 || g > 1 || b < 0 || b > 1 )
		        throw new HPDF_Error("HPDF_Page_SetRGBStroke", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, 0);
		
			pbuf = HPDF_Utils.HPDF_FToA ( r );
			pbuf += " ";
			pbuf += HPDF_Utils.HPDF_FToA ( g );
			pbuf += " ";
			pbuf += HPDF_Utils.HPDF_FToA ( b );
			pbuf += " RG" + HPDF_Utils.NEW_LINE; 
		    
		    page.pageAttr.stream.HPDF_Stream_WriteStr ( pbuf );
		    
		    page.pageAttr.gstate.rgbStroke.r	=	r;
    		page.pageAttr.gstate.rgbStroke.g	=	g;
    		page.pageAttr.gstate.rgbStroke.b	=	b;
    	    page.pageAttr.gstate.csStroke		=	HPDF_ColorSpace.HPDF_CS_DEVICE_RGB;
		    
		} // end HPDF_Page_SetRGBStroke
		
		public	function	HPDF_Page_SetCMYKFill( c : Number, m: Number, y:Number, k:Number) : void
		{
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION |  HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
			var pbuf : String ; 
    		trace (" HPDF_Page_SetCMYKFill");

		    if ( c < 0 || c > 1 || m < 0 || m > 1 || y < 0 || y > 1 || k < 0 || k > 1 )
		        throw new HPDF_Error("HPDF_Page_SetCMYKFill", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, 0);
		
			pbuf = HPDF_Utils.HPDF_FToA ( c );
			pbuf += " ";
			pbuf += HPDF_Utils.HPDF_FToA ( m );
			pbuf += " ";
			pbuf += HPDF_Utils.HPDF_FToA ( y );
			pbuf += " ";
			pbuf += HPDF_Utils.HPDF_FToA ( k );
			pbuf += " k" + HPDF_Utils.NEW_LINE; 
		    
		    page.pageAttr.stream.HPDF_Stream_WriteStr ( pbuf );
		    
		    page.pageAttr.gstate.cmykFill.c	=	c;
    		page.pageAttr.gstate.cmykFill.m	=	m;
    		page.pageAttr.gstate.cmykFill.y	=	y;
    		page.pageAttr.gstate.cmykFill.k	=	k;
    	    page.pageAttr.gstate.csFill		=	HPDF_ColorSpace.HPDF_CS_DEVICE_CMYK;
		    
		} // end HPDF_Page_SetCMYKFill
		
		public	function	HPDF_Page_SetCMYKStroke( c : Number, m: Number, y:Number, k:Number) : void
		{
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION |  HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
			var pbuf : String ; 
    		trace (" HPDF_Page_SetCMYKStroke");

		    if ( c < 0 || c > 1 || m < 0 || m > 1 || y < 0 || y > 1 || k < 0 || k > 1 )
		        throw new HPDF_Error("HPDF_Page_SetCMYKStroke", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, 0);
		
			pbuf = HPDF_Utils.HPDF_FToA ( c );
			pbuf += " ";
			pbuf += HPDF_Utils.HPDF_FToA ( m );
			pbuf += " ";
			pbuf += HPDF_Utils.HPDF_FToA ( y );
			pbuf += " ";
			pbuf += HPDF_Utils.HPDF_FToA ( k );
			pbuf += " K" + HPDF_Utils.NEW_LINE; 
		    
		    page.pageAttr.stream.HPDF_Stream_WriteStr ( pbuf );
		    
		    page.pageAttr.gstate.cmykStroke.c	=	c;
    		page.pageAttr.gstate.cmykStroke.m	=	m;
    		page.pageAttr.gstate.cmykStroke.y	=	y;
    		page.pageAttr.gstate.cmykStroke.k	=	k;
    	    page.pageAttr.gstate.csStroke		=	HPDF_ColorSpace.HPDF_CS_DEVICE_CMYK;
		    
		} // end HPDF_Page_SetCMYKStroke
		
		

	}
}