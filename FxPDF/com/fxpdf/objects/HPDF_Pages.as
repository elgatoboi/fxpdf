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
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.xref.HPDF_Xref;

	public class HPDF_Pages extends HPDF_Dict
	{
		// C exuals HPDF_Pages_New
		
		public function HPDF_Pages( parent : HPDF_Pages, xref : HPDF_Xref)
		{
			super();
			
			trace((" HPDF_Pages_New"));
		    
		    //C pages->header.obj_class |= HPDF_OSUBCLASS_PAGES;
		    //C pages->before_write_fn = Pages_BeforeWrite;
		    this.header.objClass	|=	HPDF_Obj_Header.HPDF_OSUBCLASS_PAGES;

		    /* C if (HPDF_Xref_Add (xref, pages) != HPDF_OK)
		        return NULL; */
		    xref.HPDF_Xref_Add( this ); 

		    /* add requiered elements */
		    /*C ret += HPDF_Dict_AddName (pages, "Type", "Pages");
		    ret += HPDF_Dict_Add (pages, "Kids", HPDF_Array_New (pages->mmgr));
		    ret += HPDF_Dict_Add (pages, "Count", HPDF_Number_New (pages->mmgr, 0)); */
		    this.HPDF_Dict_AddName( "Type", "Pages");
		    this.HPDF_Dict_Add( "Kids", new HPDF_Array( ) ) ;
		    this.HPDF_Dict_Add( "Count" , new HPDF_Number( 0 ) );

    		/* C if (ret == HPDF_OK && parent)
        		ret += HPDF_Pages_AddKids (parent, pages); */
        	if ( parent ) 
        		parent.HPDF_Pages_AddKids ( this );
    			
		}
		
		public	function	HPDF_Pages_AddKids ( kid : HPDF_Dict ) :void
		{
		
			//HPDF_Array kids;
			var kids 		 	: HPDF_Array;
			var	pageAttr 		: HPDF_PageAttr;
		
		    trace((" HPDF_Pages_AddKids\n"));
		
		    /* C if (HPDF_Dict_GetItem (kid, "Parent", HPDF_OCLASS_DICT))
		        return HPDF_SetError (parent->error, HPDF_PAGE_CANNOT_SET_PARENT, 0); */
		        
		    if ( kid.HPDF_Dict_GetItem ( "Parent" , HPDF_Obj_Header.HPDF_OCLASS_DICT ) )  
		    {
		    	throw new HPDF_Error ("HPDF_Pages_AddKids",HPDF_Error.HPDF_PAGE_CANNOT_SET_PARENT, 0 ) ; 
		    }
		
		    kid.HPDF_Dict_Add ( "Parent", this);
		       
		
		    // C kids = (HPDF_Array )HPDF_Dict_GetItem (parent, "Kids", HPDF_OCLASS_ARRAY);
		    kids	=	this.HPDF_Dict_GetItem( "Kids" , HPDF_Obj_Header.HPDF_OCLASS_ARRAY )  as HPDF_Array;
		    
		    if (!kids)
		    {
		       // return HPDF_SetError (parent->error, HPDF_PAGES_MISSING_KIDS_ENTRY, 0);
		        throw new HPDF_Error( "HPDF_Pages_AddKids", HPDF_Error.HPDF_PAGES_MISSING_KIDS_ENTRY, 0);
		    }
		    
		    if ( kid.header.objClass == (HPDF_Obj_Header.HPDF_OCLASS_DICT | HPDF_Obj_Header.HPDF_OSUBCLASS_PAGE))
		    {
		        pageAttr  = kid.attr as HPDF_PageAttr;
		        pageAttr.parent = this;
		    }
		    
		    if  ( kid.header.objClass	== ( HPDF_Obj_Header.HPDF_OCLASS_DICT | HPDF_Obj_Header.HPDF_OSUBCLASS_PAGE ) )
		    {
		    	// TODO var	attr : HPDF_PageAttr = kid.attr ; 
		    	pageAttr  = kid.attr as HPDF_PageAttr;
		    }
		
		    kids.HPDF_Array_Add( kid ) ; //(kids, kid); 
			
		}
		
		public	function	HPDF_Pages_Validate( ) : Boolean
		{
			
			//HPDF_Obj_Header *header = (HPDF_Obj_Header *)pages;

		    trace(" HPDF_Pages_Validate");
		
		    if (header.objClass != (HPDF_Obj_Header.HPDF_OCLASS_DICT | HPDF_Obj_Header.HPDF_OSUBCLASS_PAGES) )
		        return false;
		
		    return true; 
		}
		public	function	GetPageCount  ( ) : uint
		{
			var count : uint = 0 ; 
		    var	kids : HPDF_Array	=	HPDF_Dict_GetItem("Kids",HPDF_Obj_Header.HPDF_OCLASS_ARRAY )  as HPDF_Array ;
		
		    trace(" GetPageCount");
		
		    if (!kids)
		        return 0;
		
		    for (var i : uint = 0; i < kids.list.count; i++)
		    {
		         
		        var obj : Object = kids.HPDF_Array_GetItem ( i, HPDF_Obj_Header.HPDF_OCLASS_DICT);
		        var header : HPDF_Obj_Header	=	obj.header ; 
		
		        if (header.objClass == (HPDF_Obj_Header.HPDF_OCLASS_DICT | HPDF_Obj_Header.HPDF_OSUBCLASS_PAGES))
		            count += obj.GetPageCount ( );
		        else if (header.objClass == (HPDF_Obj_Header.HPDF_OCLASS_DICT | HPDF_Obj_Header.HPDF_OSUBCLASS_PAGE))
		            count += 1;
		    }
		
		    return count;
		} 
		
		/** overrided functions **/
		override public	function	beforeWriteFn( ) : void
		{
			
            var	kids : HPDF_Array	=	HPDF_Dict_GetItem("Kids",HPDF_Obj_Header.HPDF_OCLASS_ARRAY )  as HPDF_Array ;
            var	count : HPDF_Number	=	HPDF_Dict_GetItem("Count",HPDF_Obj_Header.HPDF_OCLASS_NUMBER ) as HPDF_Number;
		    
		    trace(" HPDF_Pages_BeforeWrite");
		
		    if (!kids)
		    {
		        throw new HPDF_Error("HPDF_Pages.beforeWriteFn", HPDF_Error.HPDF_PAGES_MISSING_KIDS_ENTRY, 0);
		    }
		
		    if (count)
		        count.value = GetPageCount ();
		    else {
		        count = new HPDF_Number( GetPageCount () );
		        HPDF_Dict_Add ( "Count", count) ;
		    }
		}
		override public	function	afterWriteFn( stream : HPDF_Stream ) : void
		{
			null ;
		}
		override public	function	writeFn( stream : HPDF_Stream) : void
		{
			null ; 
		}
		
	}
}