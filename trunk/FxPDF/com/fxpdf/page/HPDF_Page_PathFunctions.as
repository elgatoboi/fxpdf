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
	import com.fxpdf.types.HPDF_Point;
	
	public class HPDF_Page_PathFunctions
	{
	
		private	var page : HPDF_Page;
		
		public function HPDF_Page_PathFunctions(page : HPDF_Page)
		{
			this.page = page;
		}
		
		public	function	HPDF_Page_MoveTo( x: Number, y : Number) : void
		{
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_PATH_OBJECT);
		    var pbuf : String = ""
		    
		    trace (" HPDF_Page_MoveTo");
		
		    pbuf = HPDF_Utils.HPDF_FToA (  x, 11);
		    pbuf += " " ;
		    pbuf += HPDF_Utils.HPDF_FToA (y, 11);
		    pbuf += HPDF_Utils.ParseString( " m\\012" ) ; 
		
		    page.pageAttr.stream.HPDF_Stream_WriteStr ( pbuf );
		    
		    page.pageAttr.curPos.x = x;
		    page.pageAttr.curPos.y = y;
		    page.pageAttr.strPos = new HPDF_Point( page.pageAttr.curPos.x, page.pageAttr.curPos.y );
		    page.pageAttr.gmode = HPDF_Consts.HPDF_GMODE_PATH_OBJECT;
		}
		
		
		public	function	HPDF_Page_LineTo( x: Number, y : Number ) : void
		{
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT);
		    var pbuf : String = ""
		    
		    trace (" HPDF_Page_LineTo");
		    
		    pbuf = HPDF_Utils.HPDF_FToA (  x, 11);
		    pbuf += " " ;
		    pbuf += HPDF_Utils.HPDF_FToA (y, 11);
		    pbuf += HPDF_Utils.ParseString( " l\\012" ) ; 
		
		    page.pageAttr.stream.HPDF_Stream_WriteStr ( pbuf );
		
		    page.pageAttr.curPos.x = x;
		    page.pageAttr.curPos.y = y;
		}
		
		public function HPDF_Page_CurveTo( x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number):void
		{
			var pbuf : String ; 
			
			trace ("HPDF_Page_CurveTo");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT );
			
			pbuf = HPDF_Utils.HPDF_FToA ( x1 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y1 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( x2 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y2 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( x3 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y3 );
		    pbuf += " c" + HPDF_Utils.NEW_LINE;
		    
		    page.pageAttr.stream.HPDF_Stream_WriteStr( pbuf );
		    page.pageAttr.curPos.x = x3;
		    page.pageAttr.curPos.y = y3;
		    
		} // end HPDF_Page_CurveTo
		
		public function HPDF_Page_CurveTo2( x2:Number, y2:Number, x3:Number, y3:Number):void
		{
			var pbuf : String ; 
			
			trace ("HPDF_Page_CurveTo2");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT );
			
		    pbuf = HPDF_Utils.HPDF_FToA ( x2 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y2 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( x3 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y3 );
		    pbuf += " v" + HPDF_Utils.NEW_LINE;
		    
		    page.pageAttr.stream.HPDF_Stream_WriteStr( pbuf );
		    page.pageAttr.curPos.x = x3;
		    page.pageAttr.curPos.y = y3;
		    
		} // end HPDF_Page_CurveTo2
		
		public function HPDF_Page_CurveTo3( x1:Number, y1:Number, x3:Number, y3:Number):void
		{
			var pbuf : String ; 
			
			trace ("HPDF_Page_CurveTo3");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT );
			
		    pbuf = HPDF_Utils.HPDF_FToA ( x1 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y1 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( x3 );
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y3 );
		    pbuf += " y" + HPDF_Utils.NEW_LINE;
		    
		    page.pageAttr.stream.HPDF_Stream_WriteStr( pbuf );
		    page.pageAttr.curPos.x = x3;
		    page.pageAttr.curPos.y = y3;
		    
		} // end HPDF_Page_CurveTo3
		
		public function HPDF_Page_ClosePath():void
		{
			trace ("HPDF_Page_ClosePath");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT );
			
			page.pageAttr.stream.HPDF_Stream_WriteStr( " h" + HPDF_Utils.NEW_LINE );
			page.pageAttr.curPos = new HPDF_Point( page.pageAttr.strPos.x, page.pageAttr.strPos.y);
			
		} // end HPDF_Page_ClosePath
		
		public	function	HPDF_Page_Rectangle( x : Number, y: Number, width : Number, height: Number ) : void
		{
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_PATH_OBJECT);
			var pbuf : String ; 
		    
		    trace (" HPDF_Page_Rectangle");
		
		    pbuf = HPDF_Utils.HPDF_FToA ( x, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( width, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( height, 11);
		    pbuf += " re" + HPDF_Utils.NEW_LINE;
		
		    page.pageAttr.stream.HPDF_Stream_WriteStr ( pbuf) ;
		    
		    page.pageAttr.curPos.x = x;
		    page.pageAttr.curPos.y = y;
		    page.pageAttr.strPos = new HPDF_Point( page.pageAttr.curPos.x, page.pageAttr.curPos.y);
		    page.pageAttr.gmode = HPDF_Consts.HPDF_GMODE_PATH_OBJECT;
		    
		} // end HPDF_Page_Rectangle
		
		
		/** PATH PAINTING OPERATIONS **/
		public function HPDF_Page_ClosePathStroke():void
		{
			trace ("HPDF_Page_ClosePathStroke");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT | HPDF_Consts.HPDF_GMODE_CLIPPING_PATH );
			
			page.pageAttr.stream.HPDF_Stream_WriteStr( " s" + HPDF_Utils.NEW_LINE );
			
			page.pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
    		page.pageAttr.curPos	= HPDF_Page.INIT_POS;
			
		} // end HPDF_Page_ClosePathStroke
		
		
		public function HPDF_Page_Eofill():void
		{
			trace ("HPDF_Page_Eofill");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT | HPDF_Consts.HPDF_GMODE_CLIPPING_PATH );
			
			page.pageAttr.stream.HPDF_Stream_WriteStr( " f*" + HPDF_Utils.NEW_LINE );
			
			page.pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
    		page.pageAttr.curPos	= HPDF_Page.INIT_POS;
			
		} // end HPDF_Page_Eofill
		
		public function HPDF_Page_FillStroke():void
		{
			trace ("HPDF_Page_FillStroke");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT | HPDF_Consts.HPDF_GMODE_CLIPPING_PATH );
			
			page.pageAttr.stream.HPDF_Stream_WriteStr( " B" + HPDF_Utils.NEW_LINE );
			
			page.pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
    		page.pageAttr.curPos	= HPDF_Page.INIT_POS;
			
		} // end HPDF_Page_FillStroke
		
		public function HPDF_Page_EofillStroke():void
		{
			trace ("HPDF_Page_EofillStroke");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT | HPDF_Consts.HPDF_GMODE_CLIPPING_PATH );
			
			page.pageAttr.stream.HPDF_Stream_WriteStr( " B*" + HPDF_Utils.NEW_LINE );
			
			page.pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
			
		} // end HPDF_Page_EofillStroke
		
		public function HPDF_Page_ClosePathFillStroke():void
		{
			trace ("HPDF_Page_ClosePathFillStroke");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT | HPDF_Consts.HPDF_GMODE_CLIPPING_PATH );
			
			page.pageAttr.stream.HPDF_Stream_WriteStr( " b" + HPDF_Utils.NEW_LINE );
			
			page.pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
			page.pageAttr.curPos	= HPDF_Page.INIT_POS;
			
		} // end HPDF_Page_ClosePathFillStroke
		
		public function HPDF_Page_ClosePathEofillStroke():void
		{
			trace ("HPDF_Page_ClosePathEofillStroke");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT | HPDF_Consts.HPDF_GMODE_CLIPPING_PATH );
			
			page.pageAttr.stream.HPDF_Stream_WriteStr( " b*" + HPDF_Utils.NEW_LINE );
			
			page.pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
			page.pageAttr.curPos	= HPDF_Page.INIT_POS;
			
		} // end HPDF_Page_ClosePathEofillStroke
		
		
		public function HPDF_Page_EndPath() : void
		{
			trace ("HPDF_Page_ClosePathEofillStroke");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT | HPDF_Consts.HPDF_GMODE_CLIPPING_PATH );
			 
			page.pageAttr.stream.HPDF_Stream_WriteStr(" n" + HPDF_Utils.NEW_LINE );
			
			page.pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION;
   			page.pageAttr.curPos	= HPDF_Page.INIT_POS;
			
		} // end HPDF_Page_EndPath
		
		
		/** CLIPPING PATH OPERATORS **/
		public function HPDF_Page_Clip():void
		{
			trace ("HPDF_Page_Clip");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT  );
			 
			page.pageAttr.stream.HPDF_Stream_WriteStr(" W" + HPDF_Utils.NEW_LINE );
			
			page.pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_CLIPPING_PATH;
   			
		} // end HPDF_Page_Clip
		
		public function HPDF_Page_Eoclip():void
		{
			trace ("HPDF_Page_Eoclip");
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PATH_OBJECT  );
			 
			page.pageAttr.stream.HPDF_Stream_WriteStr(" W*" + HPDF_Utils.NEW_LINE );
			
			page.pageAttr.gmode		= HPDF_Consts.HPDF_GMODE_CLIPPING_PATH;
   			
		} // end HPDF_Page_Eoclip

		  
		

	}
}