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
package com.fxpdf.dict
{
	import com.fxpdf.encoder.HPDF_Encoder;
	import com.fxpdf.error.HPDF_Error;
	import com.fxpdf.objects.HPDF_Number;
	import com.fxpdf.objects.HPDF_Obj_Header;
	import com.fxpdf.objects.HPDF_String;
	import com.fxpdf.types.HPDF_Destination;
	import com.fxpdf.xref.HPDF_Xref;
	
	public class HPDF_Outline extends HPDF_Dict
	{
		public	static	const HPDF_OUTLINE_CLOSED : uint =  0 ; 
		public	static	const HPDF_OUTLINE_OPENED : uint =  1 ;

		public function HPDF_Outline( root : Boolean = false, parent : HPDF_Outline = null, title : String = "" , encoder : HPDF_Encoder = null, xref : HPDF_Xref = null)
		{
			
			super();
			var s : HPDF_String  ; 
			var openFlg : HPDF_Number ; 
			
		    trace(" HPDF_Outline_New");
		
		    if (( !parent || !xref ) && !root)
		        return ;
		
		   xref.HPDF_Xref_Add ( this );
		   
		   if ( !root )
		   {
		   	 s = new HPDF_String ( title, encoder );   
 		     this.HPDF_Dict_Add( "Title", s );
 		     parent.AddChild ( this );
 		   }
		   
		   openFlg = new HPDF_Number( HPDF_OUTLINE_OPENED ) ;
		   openFlg.header.objId	|= HPDF_Obj_Header.HPDF_OTYPE_HIDDEN; 
		    
		   this.HPDF_Dict_Add( "_OPENED", openFlg );
		   this. HPDF_Dict_AddName ( "Type", "Outline");
		   
		
		   this.header.objClass |= HPDF_Obj_Header.HPDF_OSUBCLASS_OUTLINE;
		}
		
		
	
		    
	
		
		override public	function	beforeWriteFn( ) : void
		{
			var n : HPDF_Number	=	HPDF_Dict_GetItem( "Count",HPDF_Obj_Header.HPDF_OCLASS_NUMBER) as  HPDF_Number;
			
			var count : int = CountChild ( ) ; 
	
    		trace(" BeforeWrite");

		    if (count == 0 && n)
		    {
		       HPDF_Dict_RemoveElement ( "Count");
		       return ; 
		    }

		    if ( !HPDF_Outline_GetOpened ())
		        count = -1;
		
		    if (n)
		        n.value = count;
		    else
		        if (count)
		            HPDF_Dict_AddNumber ( "Count", count);
	   }		
	   
	   private	function CountChild ( ) : uint 
	   {
	   		var child : HPDF_Outline = HPDF_Outline_GetFirst( ); 
	   		var count  :uint = 0; 
	   		
	   		trace(" CountChild");
	   		
	   		while ( child ) {
	   			
	   			count++;
	   			
		   		if ( child.HPDF_Outline_GetOpened() ) 
		   			count += child.CountChild() ; 
		   		
		   		child = child.HPDF_Outline_GetNext( );
		   		 
	   		}
	   		return count; 
	   }
	   
	   public	function	HPDF_Outline_GetNext( ) : HPDF_Outline
	   {
	   		trace(" HPDF_Outline_GetNext");
	   		return HPDF_Dict_GetItem( "Next", HPDF_Obj_Header.HPDF_OCLASS_DICT) as HPDF_Outline;
	   }
	   
	    public	function	HPDF_Outline_GetFirst( ) : HPDF_Outline
	   {
	   		trace(" HPDF_Outline_GetFirst");
	   		return HPDF_Dict_GetItem( "First", HPDF_Obj_Header.HPDF_OCLASS_DICT) as HPDF_Outline;
	   }
	   
	   
	    public	function	HPDF_Outline_GetLast( ) : HPDF_Outline
	   {
	   		trace(" HPDF_Outline_GetLast");
	   		return HPDF_Dict_GetItem( "Last", HPDF_Obj_Header.HPDF_OCLASS_DICT) as HPDF_Outline;
	   }
	   public	function	HPDF_Outline_GetOpened( ) : Boolean
	   {
	   		var n : HPDF_Number	=	HPDF_Dict_GetItem( "_OPENED", HPDF_Obj_Header.HPDF_OCLASS_NUMBER) as HPDF_Number;
	   		if (!n)
	   			return false;
	   		return n.value as Boolean; 
	   }
	   	
	   
	   
	   public	function	AddChild( item : HPDF_Outline ) : void
	   {
	   	
	   		var first : HPDF_Outline = HPDF_Dict_GetItem ( "First", HPDF_Obj_Header.HPDF_OCLASS_DICT) as HPDF_Outline;
	   		var last  : HPDF_Outline = HPDF_Dict_GetItem ( "Last", HPDF_Obj_Header.HPDF_OCLASS_DICT) as HPDF_Outline;
	   		
	   		trace(" AddChild"); 
	   		
	   		if (!first)
		        HPDF_Dict_Add ( "First", item);
		
		    if (last) {
		        last.HPDF_Dict_Add ( "Next", item);
		        item.HPDF_Dict_Add ( "Prev", last);
		    }
		
		    HPDF_Dict_Add ( "Last", item);
		    item.HPDF_Dict_Add ( "Parent", this);
	   }
	   
	   	public	function	HPDF_Outline_Validate( ) : Boolean
	 	{
	 		trace(" HPDF_Outline_Validate");
	 		
	 		if ( header.objClass !=  ( HPDF_Obj_Header.HPDF_OSUBCLASS_OUTLINE | HPDF_Obj_Header.HPDF_OCLASS_DICT ) )
	 			return false;
	 		return true ;
	 		
	 	}	
	 	
	 	public	function	HPDF_Outline_SetDestination( dst : HPDF_Destination ) : void
	 	{
	 		
		    trace(" HPDF_Outline_SetDestination");
		
		    if (!HPDF_Outline_Validate ())
		    	throw new HPDF_Error("HPDF_Outline_SetDestination - invalid");
		
		    if (!dst.HPDF_Destination_Validate ())
				   throw new HPDF_Error("HPDF_Outline_SetDestination", HPDF_Error.HPDF_INVALID_DESTINATION, 0);
		
		    if (dst == null)
		    {
		        HPDF_Dict_RemoveElement ( "Dest");
		        return ; 
		    }
		
		    HPDF_Dict_Add ( "Dest", dst);
		    
		} // end HPDF_Outline_SetDestination
		
		public	function	HPDF_Outline_SetOpened( opened : Boolean ) : void
	 	{
	 		
		    trace(" HPDF_Outline_SetOpened");
		    var n : HPDF_Number ; 
		
		    if (!HPDF_Outline_Validate ())
		    	throw new HPDF_Error("HPDF_Outline_SetOpened - invalid");
		
		   	n = HPDF_Dict_GetItem ( "_OPENED", HPDF_Obj_Header.HPDF_OCLASS_NUMBER ) as HPDF_Number;
		   	
		   	if ( !n ) 
		   	{
		   		n	=	new HPDF_Number( opened ? 1 : 0 ) ;
		   		HPDF_Dict_Add ( "_OPENED", n );  
		   	}
		    else
		    	n.value	=	opened ? 1 : 0;
		    
		} // end HPDF_Outline_SetOpened
		
	
 
	}
}