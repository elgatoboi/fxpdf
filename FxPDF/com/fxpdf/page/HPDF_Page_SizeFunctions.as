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
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.types.HPDF_Box;
	import com.fxpdf.types.HPDF_Real;
	import com.fxpdf.types.enum.HPDF_PageDirection;
	import com.fxpdf.types.enum.HPDF_PageSizes;
	
	public class HPDF_Page_SizeFunctions
	{
		private	var	page : HPDF_Page	;
		
		private	static const HPDF_PREDEFINED_PAGE_SIZES:Array = [
		    {x:612, y:792},     /* HPDF_PAGE_SIZE_LETTER */
		    {x:612,y: 1008},    /* HPDF_PAGE_SIZE_LEGAL */
		    {x:841.89, y:1199.551},    /* HPDF_PAGE_SIZE_A3 */
		    {x:595.276,y: 841.89},     /* HPDF_PAGE_SIZE_A4 */
		    {x:419.528, y:595.276},     /* HPDF_PAGE_SIZE_A5 */
		    {x:708.661,y: 1000.63},     /* HPDF_PAGE_SIZE_B4 */
		    {x:498.898,y: 708.661},     /* HPDF_PAGE_SIZE_B5 */
		    {x:522,y: 756},     /* HPDF_PAGE_SIZE_EXECUTIVE */
		    {x:288, y:432},     /* HPDF_PAGE_SIZE_US4x6 */
		    {x:288,y: 576},     /* HPDF_PAGE_SIZE_US4x8 */
		    {x:360, y:504},     /* HPDF_PAGE_SIZE_US5x7 */
		    {x:297, y:684}      /* HPDF_PAGE_SIZE_COMM10 */
		] ; 

		public function HPDF_Page_SizeFunctions( page : HPDF_Page)
		{
			this.page = page; 
		}
		
		
		public	function	HPDF_Page_SetSize  ( size : uint , direction : uint ) : void
		{
		    trace("HPDF_Page_SetSize");
		
		    page.HPDF_Page_Validate( ) ; 
		     
		    if (size < 0 || size > HPDF_PageSizes.HPDF_PAGE_SIZE_EOF)
		    {
		    	throw new HPDF_Error("HPDF_Page_SetSize",HPDF_Error.HPDF_PAGE_INVALID_SIZE,direction);
		    } 
		    
		
		    if (direction == HPDF_PageDirection.HPDF_PAGE_LANDSCAPE)
		    {
		        page.HPDF_Page_SetHeight (  HPDF_PREDEFINED_PAGE_SIZES[size].x );
		        page.HPDF_Page_SetWidth (   HPDF_PREDEFINED_PAGE_SIZES[size].y );
		    }
		    else if (direction == HPDF_PageDirection.HPDF_PAGE_PORTRAIT)
		    {
		        page.HPDF_Page_SetHeight ( HPDF_PREDEFINED_PAGE_SIZES[size].y );
		        page.HPDF_Page_SetWidth  ( HPDF_PREDEFINED_PAGE_SIZES[size].x );
		    }
		    else
		    {
		    	throw new HPDF_Error("HPDF_Page_SetSize",HPDF_Error.HPDF_PAGE_INVALID_DIRECTION, direction);
		    }
		}
		public	function HPDF_Page_GetMediaBox( ) : HPDF_Box
		{	
		    var mediaBox : HPDF_Box = new HPDF_Box(0, 0 ,0, 0);
		    trace(" HPDF_Page_GetMediaBox");
		
		    page.HPDF_Page_Validate ();
	        
			var array : HPDF_Array	=	page.HPDF_Page_GetInheritableItem( "MediaBox", HPDF_Obj_Header.HPDF_OCLASS_ARRAY ) as HPDF_Array ;  
	        if (array)
	        {
	            var r : HPDF_Real ; 
	
	            r = array.HPDF_Array_GetItem (0, HPDF_Obj_Header.HPDF_OCLASS_REAL) as HPDF_Real;
	            if (r)
	                mediaBox.left = r.value;
	
	            r = array.HPDF_Array_GetItem (1, HPDF_Obj_Header.HPDF_OCLASS_REAL) as HPDF_Real;
	            if (r)
	                mediaBox.bottom = r.value;
	
	            r = array.HPDF_Array_GetItem (2, HPDF_Obj_Header.HPDF_OCLASS_REAL) as HPDF_Real;
	            if (r)
	                mediaBox.right = r.value;
	
	            r = array.HPDF_Array_GetItem (3, HPDF_Obj_Header.HPDF_OCLASS_REAL) as HPDF_Real;
	            if (r)
	                mediaBox.top = r.value;
	        }
	        else
	        {
	        	throw new HPDF_Error("HPDF_Page_GetMediaBox", HPDF_Error.HPDF_PAGE_CANNOT_FIND_OBJECT, 0);
	    }	
	
		return mediaBox;
		} 
		
		public	function	HPDF_Page_SetBoxValue ( name : String, index : uint , value : Number ): void
		{
         
		    var r: HPDF_Real ; 
		    
		
		    trace(" HPDF_Page_SetBoxValue");
		
		    page.HPDF_Page_Validate ( ) ;
		
			var array : HPDF_Array	=	page.HPDF_Page_GetInheritableItem( name, HPDF_Obj_Header.HPDF_OCLASS_ARRAY ) as HPDF_Array;  
		    if (!array)
		        throw new HPDF_Error("HPDF_Page_SetBoxValue", HPDF_Error.HPDF_PAGE_CANNOT_FIND_OBJECT, 0);
		
		    r = array.HPDF_Array_GetItem (index, HPDF_Obj_Header.HPDF_OCLASS_REAL ) as HPDF_Real;
		    if (!r)
		    {
		    	throw new HPDF_Error("HPDF_Page_SetBoxValue", HPDF_Error.HPDF_PAGE_INVALID_INDEX, 0);
		    }
		
		    r.value = value;
		}
    
	}
}