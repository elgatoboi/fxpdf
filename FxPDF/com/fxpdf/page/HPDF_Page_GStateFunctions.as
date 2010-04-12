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
	import com.fxpdf.gstate.HPDF_ExtGState;
	import com.fxpdf.gstate.HPDF_GState;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.types.HPDF_LineCap;
	import com.fxpdf.types.HPDF_TransMatrix;
	import com.fxpdf.types.enum.HPDF_LineJoin;
	
	public class HPDF_Page_GStateFunctions
	{
		private	 var	page : HPDF_Page ; 
		
		public function HPDF_Page_GStateFunctions( page : HPDF_Page)
		{
			this.page = page; 
		}
		
		public	function	HPDF_Page_SetLineWidth( lineWidth : Number ) : void
		{
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION |  HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
		    
		    // trace (" HPDF_Page_SetLineWidth");
		
		
		    if (lineWidth < 0)
		       throw new HPDF_Error("HPDF_Page_SetLineWidth", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, 0);
		
		    page.pageAttr.stream.HPDF_Stream_WriteReal ( lineWidth ) ;
		    page.pageAttr.stream.HPDF_Stream_WriteStr ( " w" + HPDF_Utils.NEW_LINE ) ;
		    
		    page.pageAttr.gstate.lineWidth = lineWidth;
		}
		
		
		/* J */
		/**
		 * Description
		HPDF_Page_SetLineCap() sets the shape to be used at the ends of lines.
		
		Parameters
		
		page - The handle of a page object.
		line_cap - The line cap style (one of the following).
		Value 		Description
		HPDF_BUTT_END 	figure10.png 	Line is squared off at path endpoint.
		HPDF_ROUND_END 	figure11.png 	End of line becomes a semicircle whose center is at path endpoint.
		HPDF_PROJECTING_SCUARE_END 	figure12.png 	Line continues beyond endpoint, goes on half the endpoint stroke width.
		
		Graphics Mode
		
		Before and after - HPDF_GMODE_PAGE_DESCRIPTION or HPDF_GMODE_TEXT_OBJECT.
		
		Return Value
		
		Returns HPDF_OK on success. Otherwise, returns error code and error-handler is invoked. 
 		* */
		public function HPDF_Page_SetLineCap( lineCap : int ):void
		{
			
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
    	    trace (" HPDF_Page_SetLineCap");

		     if (lineCap < 0 || lineCap >= HPDF_LineCap.HPDF_LINECAP_EOF)
		     	throw new HPDF_Error("HPDF_Page_SetLineCap", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, lineCap);

		    page.pageAttr.stream.HPDF_Stream_WriteInt ( lineCap );
		    page.pageAttr.stream.HPDF_Stream_WriteStr( " J" + HPDF_Utils.NEW_LINE ) ;
		    
		    page.pageAttr.gstate.lineCap = lineCap;
   		} 
   		
   		
   		public function HPDF_Page_SetLineJoin( lineJoin : int ):void
   		{
   			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
    	    trace (" HPDF_Page_SetLineJoin");

		     if (lineJoin < 0 || lineJoin >= HPDF_LineJoin.HPDF_LINEJOIN_EOF )
		     	throw new HPDF_Error("HPDF_Page_SetLineJoin", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, lineJoin);

		    page.pageAttr.stream.HPDF_Stream_WriteInt ( lineJoin );
		    page.pageAttr.stream.HPDF_Stream_WriteStr( " j" + HPDF_Utils.NEW_LINE ) ;
		    
		    page.pageAttr.gstate.lineJoin = lineJoin;
   		}
   		
   		
   		
   		public function HPDF_Page_SetMiterLimit( miterLimit:Number ):void
   		{
   			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
    	    trace (" HPDF_Page_SetMiterLimit");

		     if ( miterLimit < 1 )
		     	throw new HPDF_Error("HPDF_Page_SetMiterLimit", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, miterLimit);

		    page.pageAttr.stream.HPDF_Stream_WriteReal ( miterLimit );
		    page.pageAttr.stream.HPDF_Stream_WriteStr( " M" + HPDF_Utils.NEW_LINE ) ;
		    
		    page.pageAttr.gstate.miterLimit = miterLimit;
   		}
   		
   		
   		public function HPDF_Page_SetDash( dashPtn:Vector.<uint>, numParam:uint, phase:uint ):void
   		{
   			throw new HPDF_Error("HPDF_Page_SetDash is not yet implemented in LibHaruAS3");
   		}
   		
   		public function HPDF_Page_SetFlat( flatness:Number ):void
   		{
   			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION | HPDF_Consts.HPDF_GMODE_TEXT_OBJECT);
    	    trace (" HPDF_Page_SetFlat");

		     if ( flatness < 0 || flatness > 100 )
		     	throw new HPDF_Error("HPDF_Page_SetFlat", HPDF_Error.HPDF_PAGE_OUT_OF_RANGE, flatness);

		    page.pageAttr.stream.HPDF_Stream_WriteReal ( flatness );
		    page.pageAttr.stream.HPDF_Stream_WriteStr( " i" + HPDF_Utils.NEW_LINE ) ;
		    
		    page.pageAttr.gstate.flatness = flatness;
   		}
   		
   		
   		public function HPDF_Page_SetExtGState( extGState:HPDF_ExtGState ):void
   		{
   			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION );
   			var localName : String ; 
   			
   			trace (" HPDF_Page_SetExtGState");
   			if (!extGState || !extGState.HPDF_ExtGState_Validate())
   				throw new HPDF_Error("HPDF_Page_SetExtGState", HPDF_Error.HPDF_INVALID_OBJECT, 0);
   				
   			localName = page.HPDF_Page_GetExtGStateName ( extGState );
   			if (!localName)
   				throw new HPDF_Error("HPDF_Page_SetExtGState", HPDF_Error.HPDF_INVALID_OBJECT, 0);
   			
   			page.pageAttr.stream.HPDF_Stream_WriteEscapeName( localName );
		    page.pageAttr.stream.HPDF_Stream_WriteStr( " gs" + HPDF_Utils.NEW_LINE ) ;
		    
		    /* change objct class to read only. */
		    extGState.header.objClass = ( HPDF_Obj_Header.HPDF_OSUBCLASS_EXT_GSTATE_R | HPDF_Obj_Header.HPDF_OCLASS_DICT);
		       			
   		}
   		
   		
   		public function HPDF_Page_GSave():void
		{
			var	newGState :HPDF_GState
			page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION );
		
		    trace (" HPDF_Page_GSave");
		
		    newGState = new HPDF_GState( page.pageAttr.gstate );
		    
		    page.pageAttr.stream.HPDF_Stream_WriteStr ( "q" + HPDF_Utils.NEW_LINE );
		    page.pageAttr.gstate = newGState;
		}
		
		public	function	HPDF_Page_GRestore( ) :void
		{
			var newGState : HPDF_GState;
			
		    trace (" HPDF_Page_GRestore");

    	    if (!page.pageAttr.gstate.prev)
    	    {
    	    	throw new HPDF_Error("HPDF_Page_GRestore", HPDF_Error.HPDF_PAGE_CANNOT_RESTORE_GSTATE,0);
    	    }
        
    		newGState = page.pageAttr.gstate.HPDF_GState_Free ();

		    page.pageAttr.gstate = newGState;

		    page.pageAttr.stream.HPDF_Stream_WriteStr ( "Q" + HPDF_Utils.NEW_LINE );
		}
		
		public	function	HPDF_Page_Concat( a : Number, b : Number, c : Number, d : Number, x : Number, y : Number ) : void
    	{
    		page.HPDF_Page_CheckState ( HPDF_Consts.HPDF_GMODE_PAGE_DESCRIPTION );
    		var pbuf : String ;
    		var tm : HPDF_TransMatrix;
    		
		    trace (" HPDF_Page_Concat");
		
		    pbuf = HPDF_Utils.HPDF_FToA ( a, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( b, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( c, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( d, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( x, 11);
		    pbuf += " ";
		    pbuf += HPDF_Utils.HPDF_FToA ( y, 1);
		    pbuf += " cm"+ HPDF_Utils.NEW_LINE ;
		
		    page.pageAttr.stream.HPDF_Stream_WriteStr ( pbuf );
		    tm = page.pageAttr.gstate.transMatrix;
		
		    page.pageAttr.gstate.transMatrix.a = tm.a * a + tm.b * c;
		    page.pageAttr.gstate.transMatrix.b = tm.a * b + tm.b * d;
		    page.pageAttr.gstate.transMatrix.c = tm.c * a + tm.d * c;
		    page.pageAttr.gstate.transMatrix.d = tm.c * b + tm.d * d;
		    page.pageAttr.gstate.transMatrix.x = tm.x + x * tm.a + y * tm.c;
		    page.pageAttr.gstate.transMatrix.y = tm.y + x * tm.b + y * tm.d;	
    	}


	}
}