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
package com.fxpdf.catalog
{
	import com.fxpdf.dict.HPDF_Dict;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.objects.HPDF_Pages;
	import com.fxpdf.streams.HPDF_Stream;
	import com.fxpdf.xref.HPDF_Xref;
	
	public class HPDF_Catalog extends HPDF_Dict
	{
		
		private	static const HPDF_PAGE_MODE_NAMES:Array = [
                        "UseNone",
                        "UseOutlines",
                        "UseThumbs",
                        "FullScreen",
                        "UseOC",
                        "UseAttachments",
                        null ] ;

		/** = HPDF_Catalog_NEW */
		public function HPDF_Catalog( xref : HPDF_Xref)  :void
		{
			var ret  :Number	=	0;
		   // HPDF_STATUS ret = 0;
		
			    
		    //catalog->header.obj_class |= HPDF_OSUBCLASS_CATALOG;
		    this.header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_CATALOG;
		   
			
		   /* if (HPDF_Xref_Add (xref, catalog) != HPDF_OK)
		        return null;
		        */
		    // C if ( xref.HPDF_Xref_Add( this ) != HPDF_Consts.HPDF_OK ) 
		    	// return null ;
		    xref.HPDF_Xref_Add( this );  
		
		    /* add requiered elements */
		    ret += HPDF_Dict_AddName ( "Type", "Catalog");
		    ret += HPDF_Dict_Add ( "Pages", new HPDF_Pages ( null, xref ) );
		}
		public	function	HPDF_Catalog_GetRoot( ) : HPDF_Pages
		{	
			var	pages : Object; 
		    
		    pages = HPDF_Dict_GetItem ( "Pages", HPDF_Obj_Header.HPDF_OCLASS_DICT) ;
		    if (!pages || pages.header.objClass != (HPDF_Obj_Header.HPDF_OSUBCLASS_PAGES |   HPDF_Obj_Header.HPDF_OCLASS_DICT))
		    {
		        throw new HPDF_Error ( "HPDF_Catalog_GetRoot", HPDF_Error.HPDF_PAGE_CANNOT_GET_ROOT_PAGES, 0);
		    }
		    return pages as HPDF_Pages; 
		}
		
		
		public	function	HPDF_Catalog_SetPageMode  ( mode  :uint ) : void
		{
        	HPDF_Dict_AddName( "PageMode",  HPDF_PAGE_MODE_NAMES[mode] ); 	
		}
    
     
		
		override	public	function	beforeWriteFn( ) : void
		{
			null ; 
		}
		override public	function	writeFn( stream : HPDF_Stream ) : void
		{
			null;
		}
		override public	function	afterWriteFn( stream : HPDF_Stream) : void
		{
			null; 
		}


	}
}