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
	import com.fxpdf.types.HPDF_Point;
	
	public class HPDF_Page_CombinedFunctions
	{
		
		private	var	page : HPDF_Page	;
		private	static	const KAPPA : Number = 0.552 ; 

		
		
		public function HPDF_Page_CombinedFunctions( page :HPDF_Page)
		{
			this.page = page; 
		}
		
		private function QuarterEllipseA  ( x: Number, y:Number, xray: Number, yray:Number ) : String
		{
			
			var pbuf : String ; 
			pbuf = HPDF_Utils.HPDF_FToA( x -xray);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y + yray * KAPPA);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x -xray * KAPPA);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y + yray);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y + yray);
		    pbuf += " c" + HPDF_Utils.NEW_LINE ;
		    return pbuf; 
		}

		private function QuarterEllipseB  ( x: Number, y:Number, xray: Number, yray:Number ) : String
		{
			var pbuf : String ; 
		    pbuf = HPDF_Utils.HPDF_FToA( x + xray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y + yray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x + xray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y + yray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x + xray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y, 11);
		    pbuf += " c" + HPDF_Utils.NEW_LINE ;
		    return pbuf; 
		}

		private function QuarterEllipseC  ( x: Number, y:Number, xray: Number, yray:Number ) : String
		{
			var pbuf : String ; 
		    pbuf = HPDF_Utils.HPDF_FToA( x + xray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y - yray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x + xray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y - yray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y - yray ); 
		    pbuf += " c" + HPDF_Utils.NEW_LINE ;
		    return pbuf;
		}

		private function QuarterEllipseD  ( x: Number, y:Number, xray: Number, yray:Number ) : String
		{
			var pbuf : String ; 
		    pbuf = HPDF_Utils.HPDF_FToA( x - xray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y - yray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x - xray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y - yray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x - xray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y, 11);
		    pbuf += " ";
		    pbuf += " c" + HPDF_Utils.NEW_LINE ;
		    return pbuf;
		}
		
		public	function	HPDF_Page_Ellipse  ( x : Number, y : Number, xray : Number, yray:Number ) : void
		{
			page.HPDF_Page_CheckState (HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_PATH_OBJECT);
			var pbuf : String = ""; 
			
		    trace (" HPDF_Page_Ellipse");
		
		    pbuf = HPDF_Utils.HPDF_FToA (x - xray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y, 11);
		    pbuf += " m" + HPDF_Utils.NEW_LINE ;
		
		    pbuf += QuarterEllipseA ( x, y, xray, yray);
		    pbuf += QuarterEllipseB ( x, y, xray, yray);
		    pbuf += QuarterEllipseC ( x, y, xray, yray);
		    pbuf += QuarterEllipseD ( x, y, xray, yray);
			
			page.pageAttr.stream.HPDF_Stream_WriteStr ( pbuf) ;

		    page.pageAttr.curPos.x = x - xray;
		    page.pageAttr.curPos.y = y;
		    page.pageAttr.strPos = page.pageAttr.curPos;
		    page.pageAttr.gmode = HPDF_Consts.HPDF_GMODE_PATH_OBJECT;
		}
		
		
		/** Circle function (s)     **/
		
		private function QuarterCircleA  ( x: Number, y:Number, ray: Number ) : String
		{
			
			var pbuf : String ; 
			pbuf = HPDF_Utils.HPDF_FToA( x -ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y + ray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x -ray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y + ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y + ray, 11);
		    pbuf += HPDF_Utils.ParseString( " c\\012");
		    return pbuf; 
		}

		private function QuarterCircleB  ( x: Number, y:Number, ray: Number ) : String
		{
			var pbuf : String ; 
		    pbuf = HPDF_Utils.HPDF_FToA( x + ray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y + ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x + ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y + ray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x + ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y, 11);
		    pbuf += HPDF_Utils.ParseString( " c\\012");
		    return pbuf; 
		}

		private function QuarterCircleC  ( x: Number, y:Number, ray: Number ) : String
		{
			var pbuf : String ; 
		    pbuf = HPDF_Utils.HPDF_FToA( x + ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y - ray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x + ray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y - ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y - ray,11 ); 
		    pbuf += HPDF_Utils.ParseString( " c\\012");
		    return pbuf;
		}

		private function QuarterCircleD  ( x: Number, y:Number, ray: Number ) : String
		{
			var pbuf : String ; 
		    pbuf = HPDF_Utils.HPDF_FToA( x - ray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y - ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x - ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y - ray * KAPPA, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( x - ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA( y, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.ParseString( " c\\012");
		    return pbuf;
		}
		
		public	function	HPDF_Page_Circle  ( x : Number, y : Number, ray : Number ) : void
		{
			page.HPDF_Page_CheckState (HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_PATH_OBJECT);
			var pbuf : String = ""; 
			
		    trace (" HPDF_Page_Circle");
		
		    pbuf = HPDF_Utils.HPDF_FToA (x - ray, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y, 11);
		    pbuf += HPDF_Utils.ParseString( " m\\012") ; 
		
		    pbuf += QuarterCircleA ( x, y, ray);
		    pbuf += QuarterCircleB ( x, y, ray);
		    pbuf += QuarterCircleC ( x, y, ray);
		    pbuf += QuarterCircleD ( x, y, ray);
			
			page.pageAttr.stream.HPDF_Stream_WriteStr ( pbuf) ;

		    page.pageAttr.curPos.x = x - ray;
		    page.pageAttr.curPos.y = y;
		    page.pageAttr.strPos = page.pageAttr.curPos;
		    page.pageAttr.gmode = HPDF_Consts.HPDF_GMODE_PATH_OBJECT;
		}
		
		public	function	HPDF_Page_Arc( x : Number, y : Number, ray : Number, ang1 : Number, ang2 : Number ) : void
		{
			var contFlg : Boolean = false;
			page.HPDF_Page_CheckState (HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_PATH_OBJECT);

		    // trace (" HPDF_Page_Arc");
		
		    if (ang1 >= ang2 || (ang2 - ang1) >= 360)
		        throw new HPDF_Error("HPDF_Page_Arc", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, 0);

		    while (ang1 < 0 || ang2 < 0) {
		        ang1 = ang1 + 360;
		        ang2 = ang2 + 360;
		    }


		    for (;;) {
		        if (ang2 - ang1 <= 90){
		            InternalArc ( x, y, ray, ang1, ang2, contFlg);
		            return ; 
		        }
		        else {
		            var tmpAng : Number = ang1 + 90 ;
		
		            InternalArc (  x, y, ray, ang1, tmpAng, contFlg) ; 
		            ang1 = tmpAng;
		        }
		
		        if (ang1 >= ang2)
		            break;
		
		        contFlg = true;
		    }
		}
		
		public	function	InternalArc  ( x : Number, y : Number, ray : Number, ang1 : Number, ang2 : Number, contFlg : Boolean ) : void
		{
		   const PIE : Number = 3.14159;
		   var pbuf : String = ""; 
		   var rx0 : Number ;
		   var ry0 : Number ; 
		   var rx1 : Number ;
		   var ry1 : Number ;
		   var rx2 : Number ;
		   var ry2 : Number ;
		   var rx3 : Number ;
		   var ry3 : Number ;
		   var x0  : Number ; 
		   var y0  : Number ; 
		   var x1  : Number ; 
		   var y1  : Number ;
		   var x2  : Number ; 
		   var y2  : Number ;
		   var x3  : Number ; 
		   var y3  : Number ;
		   var deltaAngle : Number; 
		   var newAngle   : Number ; 
		   
		   trace (" HPDF_Page_InternalArc");
		
		   
		   deltaAngle = (90 - (ang1 + ang2) / 2) / 180 * PIE;
		   newAngle = (ang2 - ang1) / 2 / 180 * PIE;
		
		   rx0 = ray * Math.cos( newAngle);
		   ry0 = ray * Math.sin (newAngle);
		   rx2 = (ray * 4.0 - rx0) / 3.0;
		   ry2 = ((ray * 1.0 - rx0) * (rx0 - ray * 3.0)) / (3.0 * ry0);
		   rx1 = rx2;
		   ry1 = -ry2;
		   rx3 = rx0;
		   ry3 = -ry0;

		    x0 = rx0 * Math.cos (deltaAngle) - ry0 * Math.sin (deltaAngle) + x;
		    y0 = rx0 * Math.sin (deltaAngle) + ry0 * Math.cos (deltaAngle) + y;
		    x1 = rx1 * Math.cos (deltaAngle) - ry1 * Math.sin (deltaAngle) + x;
		    y1 = rx1 * Math.sin (deltaAngle) + ry1 * Math.cos (deltaAngle) + y;
		    x2 = rx2 * Math.cos (deltaAngle) - ry2 * Math.sin (deltaAngle) + x;
		    y2 = rx2 * Math.sin (deltaAngle) + ry2 * Math.cos (deltaAngle) + y;
		    x3 = rx3 * Math.cos (deltaAngle) - ry3 * Math.sin (deltaAngle) + x;
		    y3 = rx3 * Math.sin (deltaAngle) + ry3 * Math.cos (deltaAngle) + y;

		    if (!contFlg) {
		        pbuf = HPDF_Utils.HPDF_FToA ( x0 ,11 );
		        pbuf += " ";
		        pbuf += HPDF_Utils.HPDF_FToA ( y0,11);
		        pbuf += HPDF_Utils.ParseString(  " m\\012");
		    }

		    pbuf += HPDF_Utils.HPDF_FToA (x1, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA (y1, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA (x2, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA (y2, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA (x3, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA (y3, 11);
		    pbuf += HPDF_Utils.ParseString(  " c\\012");

    		page.pageAttr.stream.HPDF_Stream_WriteStr ( pbuf );
		    page.pageAttr.curPos.x = x3;
		    page.pageAttr.curPos.y =y3;
		    page.pageAttr.strPos = new HPDF_Point(page.pageAttr.curPos.x,page.pageAttr.curPos.y);
		    page.pageAttr.gmode = HPDF_Consts.HPDF_GMODE_PATH_OBJECT;
		    
    
		}
		

	}
}