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
package com.fxpdf.types
{
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Array;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.page.HPDF_Page;
	import com.fxpdf.types.enum.HPDF_DestinationType;
	import com.fxpdf.xref.HPDF_Xref;

	public class HPDF_Destination extends HPDF_Array
	{
		
		private	static	const HPDF_DESTINATION_TYPE_NAMES : Array = [
        "XYZ",
        "Fit",
        "FitH",
        "FitV",
        "FitR",
        "FitB",
        "FitBH",
        "FitBV",
        null ] ; 
        
        
		public function HPDF_Destination( target : HPDF_Page, xref : HPDF_Xref)
		{
			super();
			
			trace ("HPDF_Destination_New");
			
			if ( !target.HPDF_Page_Validate( ) ) 
				throw new HPDF_Error("HPDF_Destination_New", HPDF_Error.HPDF_INVALID_PAGE, 0);
			
		    header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_DESTINATION;
		    
		    xref.HPDF_Xref_Add( this );
		    
			/* first item of array must be target page */	    
		    this.HPDF_Array_Add( target );
    
		    /* default type is HPDF_FIT */
    		this.HPDF_Array_AddName ( HPDF_DESTINATION_TYPE_NAMES[HPDF_DestinationType.HPDF_FIT] ) ;
    
		}
		
		public	function	HPDF_Destination_SetXYZ( left : Number, top : Number, zoom : Number ): void
		{
			var target : HPDF_Page ; 
			trace(" HPDF_Destination_SetXYZ");
			
			if (!HPDF_Destination_Validate () )
        		throw new HPDF_Error("HPDF_Destination_SetXYZ  - invalid destination",0,0);
        	
        	if (left < 0 || top < 0 || zoom < 0.08 || zoom > 32)
        		throw new HPDF_Error("HPDF_Destination_SetXYZ", HPDF_Error.HPDF_INVALID_PARAMETER, 0);
        		
        	target = HPDF_Array_GetItem ( 0, HPDF_Obj_Header.HPDF_OCLASS_DICT) as HPDF_Page;
        	
        		 
        	
        	if (list.count > 1)
        	{
        		this.HPDF_Array_Clear() ; 
        		this.HPDF_Array_Add( target );
        	}
		    HPDF_Array_AddName ( HPDF_DESTINATION_TYPE_NAMES[HPDF_DestinationType.HPDF_XYZ]);
		    HPDF_Array_AddReal ( left );
		    HPDF_Array_AddReal ( top );
		    HPDF_Array_AddReal ( zoom);
		}
		
		
		public	function	HPDF_Destination_Validate ( ) : Boolean
		{
			var header : HPDF_Obj_Header	=	this.header ; 
			var target : HPDF_Page ; 
			
			if ( header.objClass != ( HPDF_Obj_Header.HPDF_OCLASS_ARRAY | HPDF_Obj_Header.HPDF_OSUBCLASS_DESTINATION))
				return false;
			
			if ( list.count < 2 ) 
				return false; 
			
			target = this.HPDF_Array_GetItem(0, HPDF_Obj_Header.HPDF_OCLASS_DICT ) as HPDF_Page ; 
			if ( !target.HPDF_Page_Validate()  )
				throw new HPDF_Error( "HPDF_Destination_Validate", HPDF_Error.HPDF_INVALID_PAGE, 0);
			
			return true; 
		}

		
	}
}